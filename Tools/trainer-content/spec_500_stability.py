# Trainer content for the 401-500 folder, second round (415-444, 2026-10-05),
# family: stability. Four floor core exercises from the builder's exports:
# 441 Hollow Body Hold (Abs/HollowBodyHold), 442 Hollow Body Rock
# (Abs/HollowBodyRock), 439 Dead Bug (Abs/DeadBug) and 440 Bird Dog
# (Abs/BirdDog). Same format as spec.py on top of common_1_50.py; spec_500.py
# imports this module and gen.py reads SPEC / SETUP. notes_500_stability.md
# maps the copy's claims to the sources below and records the model facts.
#
# What the models show, measured from the rigs with Blender's Python + pxr
# (SCRATCH/stability/rig.py dumps the joints every frame, measure.py adds the
# skinned muscle meshes' lowest points above the mat every 0.125 s; the app's
# Y-up space, the lifter facing +z, their left +x, the mat's top at y 0), the
# trainer stills at 0/1/2/3/5 s, joints.json and tiers2.json. Every clip is
# 7.96 s on one body (torso, neck to pelvis in a straight line, 0.59 m with
# the spine straight on all fours, 0.53-0.57 m in the curled face-up poses)
# on a mat (HG_Mat), no other equipment. Heights are the lowest point of the skinned muscle meshes
# (the shoes for the heels, the fleshed hands for the hands) above the mat.
# For reference, lying flat (the Dead Bug's trunk) the shoulder-blade muscles
# and the buttocks touch the mat (0.1-0.3 cm), the lumbar part of the erector
# spinae sits 3.0 cm above it and the head rests on it.
# - Hollow Body Hold: lying face up, head toward -z. Arms straight overhead
#   (shoulders flexed ~166 deg, elbows 180), hands ~50 cm apart (a little
#   wider than the shoulders), 36-39 cm off the mat. Legs straight (knees
#   180), ankles 24 cm apart (hip-width), toes pointed (ankle ~145 deg), the
#   hip-to-ankle line ~13 deg above the floor, heels 26 cm off the mat; hip
#   angle ~157 deg. The head (lowest point 22 cm up) and shoulder blades are
#   off the mat (the scapula joints 10 cm higher than lying flat; the back's
#   muscle surface lifts away from the mid-back up, 4-5 cm at the lower
#   thoracic region); the buttocks touch it and the lumbar region sits
#   2.5 cm above it, no higher than lying flat. Static: only a slow sway on a
#   4 s cycle (the neck +-0.6 cm, the hands +-1.4 cm); the legs never move.
# - Hollow Body Rock: the same shape (hip ~157, knees 180, arms overhead,
#   spine curve fixed) rocking end to end, six rocks in the clip (one every
#   ~1.33 s). The trunk line (pelvis to neck) tips from 24 deg above level
#   (head end up: heels 3.5-3.9 cm off the mat, shoulder blades ~11 cm up,
#   at 0.33, 1.67, 3.0 s ...) to 6 deg below level (legs end up: the
#   shoulder-blade muscles touch the mat, the head's lowest point ~10 cm up,
#   heels ~51 cm, at 1.0, 2.33, 3.67 s ...), a 30 deg rock rolling on the
#   curved back from the buttocks to the shoulder blades. Starts at the mid
#   pose, which is the Hollow Body Hold's pose.
# - Dead Bug: lying face up, head and shoulder blades resting on the mat
#   throughout (the trunk never moves). Start: arms straight up over the
#   shoulders (shoulders flexed ~86 deg), hips ~95 and knees 90 deg (knees over
#   the hips, shins level). Rep 1: the RIGHT arm goes back overhead (to ~170
#   deg, the upper arm 4 deg above level, the hand ~10 cm off the mat) while
#   the LEFT leg straightens out (hip 174, knee 174 deg, the thigh 4 deg above
#   level, the heel ~9 cm off the mat), together, 0.12-1.25 s; held
#   1.25-1.95 s; back 2.0-3.2 s; rest 3.2-4.1 s. Rep 2: the LEFT arm and RIGHT
#   leg the same way, 4.1-7.2 s. Elbows straight all clip.
# - Bird Dog: on hands and knees, head toward +z. Hands ~7 cm behind the
#   shoulders (about under them), elbows ~165 deg; knees under the hips,
#   ~20 cm apart; the trunk ~9 deg above level (the shoulders a little higher
#   than the hips) and still all clip. Rep 1: the RIGHT arm reaches forward
#   while the LEFT leg goes straight back, 0.2-1.25 s; held 1.25-2.1 s; back
#   2.2-3.35 s; rest to 4.1 s; rep 2 the LEFT arm and RIGHT leg, 4.1-7.35 s.
#   Extended leg: hip 172, knee 169 deg, the thigh 6 deg below level, the
#   ankle at hip height. Extended arm: the upper arm 16 deg above level, but
#   the elbow bends to ~116 deg with the elbow out to the side, so the hand
#   ends ~46 cm in front of the shoulder at shoulder height (ExRx and NASM
#   reach with a straight arm). Both hips stay at the same height; the pelvis
#   slides ~2 cm toward the supporting knee.
# Paint (tiers2.json): hollow hold and rock, rectus abdominis bright, external
# and internal oblique and sartorius dim; dead bug, rectus abdominis bright,
# obliques, sartorius and posterior deltoid dim; bird dog, erector spinae and
# gluteus maximus, medius and minimus bright, anterior and lateral deltoid,
# obliques and rectus abdominis dim. The rig paints the hip flexors on the
# sartorius, so that row is "Hip Flexors" (legend-only, as in spec_abs.py).
#
# How they differ from the library: the Plank and Side Plank hold the body
# face down or on its side on the elbows; the Ab Wheel Rollout rolls the arms
# out from the knees; the Back Extension curls the spine over a pad; the
# Glute Bridge lifts the hips. None holds the curved face-up hollow, rocks
# on it, or moves one arm and the opposite leg while the trunk stays still,
# which the dead bug does face up and the bird dog on hands and knees.
#
# Sources (abstracts read on Europe PMC 2026-10-05, full text where noted;
# ExRx through the Wayback Machine; details and what each supports in the
# notes):
# - Souza GM, Baker LL, Powers CM 2001, Arch Phys Med Rehabil
#   82(11):1551-1557, doi:10.1053/apmr.2001.26082, PMID 11689975 - 12
#   healthy subjects, the Dying Bug and Quadruped exercises at increasing
#   levels: the dying bug worked mostly the abdominals, rectus abdominis and
#   obliques equally, rising with the level; in the quadruped the obliques
#   worked more than the rectus abdominis, and the erector spinae and
#   gluteus maximus were most active when the leg on their side was raised;
#   no muscle went above 41% MVIC in either.
# - Stevens VK, Vleeming A, Bouche KG, Mahieu NN, Vanderstraeten GG,
#   Danneels LA 2007, Eur Spine J 16(5):711-718,
#   doi:10.1007/s00586-006-0181-1, PMID 16896840 (PMC2213547, full text) -
#   30 healthy volunteers, four-point kneeling; exercise 2 raised one leg and
#   the opposite arm to the horizontal (2 s up, 5 s held, 2 s down, neutral
#   spine): the lumbar multifidus and gluteus maximus of the leg's side above
#   20% MVIC, as were the internal oblique of the other side and the external
#   oblique of the leg's side; the rectus abdominis among the lowest, below
#   10% (with the leg side's internal oblique and, in exercises 1 and 2, the
#   other side's gluteus maximus).
#   Its introduction cites Callaghan 1998 for the single-leg extension in
#   four-point kneeling (low joint load, limited muscle activity).
# - Garcia-Vaquero MP, Moreside JM, Brontons-Gil E, Peco-Gonzalez N,
#   Vera-Garcia FJ 2012, J Electromyogr Kinesiol 22(3):398-406,
#   doi:10.1016/j.jelekin.2012.02.017, PMID 22436839 - 29 volunteers: the
#   bird-dog's highest activity was in the internal oblique on the side of
#   the raised arm and the erector spinae on the other side.
# - Callaghan JP, Gunning JL, McGill SM 1998, Phys Ther 78(1):8-18,
#   doi:10.1093/ptj/78.1.8, PMID 9442191 - 13 men: single-leg extension had
#   low spine load and mild extensor demand; adding the opposite arm increased
#   the challenge (abstract; that the leg extension was done on hands and
#   knees is from Stevens 2007's account of it, the full text is paywalled).
# - Ekstrom RA, Donatelli RA, Carp KC 2007, J Orthop Sports Phys Ther
#   37(12):754-762, doi:10.2519/jospt.2007.2471, PMID 18560185 - 30 adults,
#   nine exercises: the quadruped arm/lower-extremity lift was one of the few
#   that may help strengthen a muscle (the abstract names the gluteus
#   maximus); the other exercises stayed below 45% MVIC (abstract only; the
#   per-muscle values are not used).
# - Shields RK, Heiss DG 1997, Spine 22(16):1873-1879,
#   doi:10.1097/00007632-199708150-00012, PMID 9280023 - 15 men: lowering
#   both straight legs with the pelvis held in posterior tilt worked the
#   abdominal muscles harder than a bent-knee curl.
# - ExRx.net (Wayback Machine; the live site returns 403): Bird Dog and
#   Alternating Bird Dog (ErectorSpinae/BWBirdDog, snapshot 2026-06-09, and
#   BWAlternatingBirdDog, 2025-11-04: all fours, the arm out beside the head,
#   the opposite leg back, deliberately with no jerking; target erector
#   spinae, synergists gluteus maximus, lower and middle trapezius, anterior
#   and lateral deltoid; hamstrings dynamic stabilisers; gluteus medius and
#   minimus, pectoralis major, serratus anterior, triceps stabilisers; rectus
#   abdominis and obliques antagonist stabilisers); Lying Straight Leg Raise
#   (HipFlexors/BWStraightLegRaise, 2023-05-31) and Lying Leg Raise on the
#   floor (BWLyingLegRaiseFloor, 2022-09-30): target iliopsoas; with no waist
#   flexion the rectus abdominis and external oblique only stabilise the
#   pelvis and waist; bending the knees makes it easier; quadriceps
#   stabilisers; the Iliopsoas (2024-01-05: the psoas from the T12-L5
#   vertebrae), Rectus Abdominis (2026-05-28: controls the tilt of the pelvis
#   and the lower spine's curve), Gluteus Medius (2026-06-24: steadies the
#   pelvis so it does not sag when the other side has no leg under it),
#   Posterior and Anterior Deltoid muscle pages.
# - NASM Exercise Library, Dead Bug and Bird Dog (nasm.org, read 2026-10-05):
#   set-ups (arms up, hips and knees at 90; hands under the shoulders, knees
#   under the hips), the right arm with the left leg, stopping just short of
#   the floor, the lower back pressed down, slow and deliberate reps, the
#   listed mistakes.
# - StrengthLog, Hollow Hold and Dead Bugs (strengthlog.com, read
#   2026-10-05): the hollow's legs 15-30 deg off the ground and straight,
#   shoulder blades just off it, arms overhead in line with the body, only the
#   lower back and buttocks down, steady breathing, bent knees as the easier
#   version; muscles abs (primary), obliques and hip flexors (secondary).
# - CrossFit, The Hollow Rock (crossfit.com/essentials, read 2026-10-05):
#   rocking like a rocking chair with the arms overhead and the legs
#   straight; a flat spot that clunks from weak lower-ab contraction; the
#   rock's smoothness as the sign of lower-ab strength.
# No EMG study of the hollow hold or rock was found, and the dead bug and bird
# dog studies report %MVIC, which the app's fractions are not; every fraction
# below is a judgement call anchored on the library's nearest lifts (Crunch,
# Reverse Crunch, Plank, Back Extension, Glute Bridge) and the order the
# studies give.
from common_1_50 import *


def ov(final):
    """Pre-squeeze override row for an on-screen row (spec_500.row() maps
    0.14-0.86 to 0.16-0.80)."""
    return round(0.14 + (final - 0.16) * (0.86 - 0.14) / (0.80 - 0.16), 4)


# Hollow hold and rock: rectus abdominis bright (PRIMARY), obliques and the
# sartorius (Hip Flexors) dim. No EMG of the hollow exists; Shields 1997's
# straight-leg lowering with the pelvis tucked worked the abdominals harder
# than a curl, so the rectus sits at the Reverse Crunch's 0.82, a touch over
# the Crunch's 0.80. Obliques a little over the Crunch's 0.45 (both ends of
# the trunk held), under the Reverse Crunch's 0.58; the hip flexors hold the
# straight legs off the floor the whole time (ExRx: iliopsoas the target of
# a lying straight-leg raise), so a touch over the Reverse Crunch's 0.42.
# All judgement calls.
HOLLOW = [("Rectus Abdominis", P, HI, 0.82), ("Obliques", S, MOD, 0.52), ("Hip Flexors", S, MOD, 0.48)]
HOLLOW_STAB = ["transverse abdominis", "quadriceps", "neck flexors"]

# ---------------------------------------------------------------- Hollow Body Hold

N = "Hollow Body Hold"
ex(name=N, var="hollowBodyHold",
   # Side-on (yaw -1.35), head on the right: the body is a thin band across
   # v ~0.45-0.58 with the mat under it, nothing moves. Two pills above
   # (legs left, arms right) and three below the mat (lower back and
   # breathing left, shoulder blades right), so every leader meets the body
   # from the open side; the breathing leader to the chest stays right of
   # the lower-back leader. The top pills sit at 0.20: in the mistake view
   # (the model lifted) the legs and arms ghosts reach v ~0.29, onto pills
   # at 0.30 (round 1).
   overrides={"legs": (ov(0.20), "leading"), "arms": (ov(0.20), "trailing"),
              "back": (ov(0.70), "leading"), "breath": (ov(0.80), "leading"),
              "shoulders": (ov(0.70), "trailing")},
   annotations=[
       ("back", "Low back on the mat", "spine"),
       ("shoulders", "Shoulder blades up", "scapula_L"),
       ("legs", "Legs long and low", "patella_L"),
       ("arms", "Arms long overhead", "forearm_L"),
       ("breath", "Breathe, keep the shape", "chest"),
   ],
   cues={
       "back": ("Lower Back Down",
                "Your lower back stays pressed into the mat for the whole hold.",
                "Your hip flexors hold the legs up, and one of them, the psoas, is attached to the lower spine. With the trunk held still, the abs are what hold the pelvis and lower back in place against that pull. In an EMG study that kept the pelvis tucked under while both straight legs were lowered, the abdominals worked harder than in a bent-knee curl.",
                "The lower back peeling up off the mat into an arch as the legs sink.",
                "Tuck your pelvis under so the lower back stays flat on the mat, and raise the legs a little if it starts to lift."),
       "shoulders": ("Upper Back",
                     "Your head and shoulder blades come up off the mat with your arms.",
                     "Lifting the shoulder blades is a small curl of the upper trunk, the rectus abdominis's own movement, held still, and it is what turns lying with the legs up into a hollow. StrengthLog's guide sets the shoulder blades just above the ground, with only the lower back and buttocks touching.",
                     "Resting the head and shoulders on the mat while only the legs are held up.",
                     "Lift your head and shoulder blades until only your lower back and buttocks touch the mat, and keep them there."),
       "legs": ("Leg Height",
                "The legs stay straight and low, the heels about 25 cm off the mat here.",
                "The lower and straighter the legs, the further their weight sits out from the hips and the harder it levers on the trunk, so long, low legs make the hold hard and raising them makes it easier. StrengthLog's guide puts them 15 to 30° off the ground, and ExRx eases a straight-leg raise by bending the knees.",
                "Letting the legs drift up toward the ceiling as the hold gets hard.",
                "Keep the knees straight, toes pointed, and the heels as low as you can hold with your lower back still down."),
       "arms": ("Arm Position",
                "The arms reach straight overhead, in line with your body.",
                "Reaching overhead lengthens the top end of the body the way straight legs lengthen the bottom, so the abs hold a longer shape. StrengthLog's guide keeps the arms extended overhead in line with the body.",
                "Arms drifting forward over the face toward the ceiling.",
                "Reach your arms long behind your head, hands a little wider than your shoulders, and keep them there for the whole hold."),
       "breath": ("Breathing",
                  "Breathe steadily while you hold the shape.",
                  "The hold is logged in seconds, not reps, and StrengthLog's guide asks you to breathe steadily while you hold the position. If you can only keep the shape while holding your breath, use StrengthLog's easier version, knees bent and drawn in, until you can breathe through it.",
                  "Holding your breath until the shape collapses.",
                  "Take short, steady breaths and keep the abs tight and the lower back down as you breathe in and out."),
   },
   activation=HOLLOW,
   stabilisers=HOLLOW_STAB,
   comparison=("BACK ARCHED", "Lower back pressed down", "Lower back lifts off the mat",
               "With the pelvis tucked and the lower back on the mat, the abs hold the curve while the hip flexors hold the legs.",
               "Once the lower back lifts into an arch, the abs have let the pelvis go and the shape is no longer hollow; raise the legs until the back comes down."),
   glows=[glow(N, ["spine", "chest"], A, 0.55, 0.10, 0.045, 0.0, -0.01),
          glow(N, ["pelvis", "thigh_L"], SOFT, 0.28, 0.06, 0.035, -0.02, -0.01)])

SETUP[N] = [
    "Lie on your back on a mat, legs straight and about hip-width apart, arms straight overhead.",
    "Press your lower back into the mat and brace your abs before anything lifts.",
    "Lift your arms, head and shoulder blades off the mat together.",
    "Lift your straight legs until the heels are about 25 cm off the mat, then hold.",
]

# ---------------------------------------------------------------- Hollow Body Rock

N = "Hollow Body Rock"
ex(name=N, var="hollowBodyRock",
   # As the hold, rocking: the feet rise to v ~0.43 at the left and the
   # hands to v ~0.45 at the right. Two pills above at 0.20 (the arms ghost
   # reaches v ~0.29 in the mistake view, onto a pill at 0.30 in round 1)
   # and three below the mat: hips (the far hip) and back (the lumbar spine)
   # on the left, stacked so their leaders do not cross, rhythm (the chest)
   # on the right.
   overrides={"knees": (ov(0.20), "leading"), "arms": (ov(0.20), "trailing"),
              "hips": (ov(0.70), "leading"), "back": (ov(0.80), "leading"),
              "tempo": (ov(0.70), "trailing")},
   annotations=[
       ("back", "Back stays curved", "spine"),
       ("hips", "Rock as one piece", "thigh_R"),
       ("arms", "Arms stay overhead", "forearm_L"),
       ("knees", "Knees straight", "patella_L"),
       ("tempo", "Smooth, even rock", "chest"),
   ],
   cues={
       "back": ("Curved Back",
                "The back stays curved, lower back down, so the body rolls like a rocker.",
                "CrossFit's coaching for the hollow rock describes a flat spot where the body lands with a clunk instead of rolling, which it puts down to weak contraction of the lower abs, and asks you to take the clunk out. Here the body rolls on its curved back from the buttocks to the shoulder blades.",
                "The lower back arching up off the mat, leaving a flat spot the rock lands on.",
                "Keep your lower back pressed down as in the hold and let the body roll on its curved back from hips to shoulder blades."),
       "hips": ("One Piece",
                "The angle at your hips stays the same from one end of the rock to the other.",
                "CrossFit's coaching likens the hollow rock to a rocking chair, which tips without changing shape; here the hips hold the same angle through every rock. Swinging the legs up at the hips throws the body over with momentum instead of the abs.",
                "Kicking the legs up toward the head at one end of the rock.",
                "Hold the legs and trunk at a fixed angle and start each rock by tipping the whole body, not by kicking the legs."),
       "arms": ("Arms Overhead",
                "The arms stay overhead beside your head through every rock.",
                "Swinging the arms forward throws the body toward the feet, so momentum does what the abs should. Held overhead, as CrossFit describes the rock, they keep the shape long.",
                "Throwing the arms forward over the chest to rock back up.",
                "Keep your arms straight and reaching behind your head while the body tips back and forth."),
       "knees": ("Straight Legs",
                 "The knees stay straight and the legs stay long.",
                 "Bent knees bring the feet in toward the hips, which shortens the lever the abs hold up; ExRx eases a straight-leg raise the same way, by bending the knees.",
                 "Bending the knees and tucking them in as the legs come up.",
                 "Squeeze the legs straight, toes pointed, with the heels just off the mat at the low end of the rock."),
       "tempo": ("Rhythm",
                 "Rock back and forth at an even pace, here about one rock every 1.3 seconds.",
                 "A smooth, even rock is the sign that the shape is holding; CrossFit's coaching reads the smoothness of the rock as a measure of lower-ab strength.",
                 "Speeding up and jerking the body to keep the rock going.",
                 "Rock at a steady pace, about six rocks every eight seconds, and end the set when the rock stops being smooth."),
   },
   activation=HOLLOW,
   stabilisers=HOLLOW_STAB,
   comparison=("FLAT SPOT", "Back curved, rock smooth", "Lower back arches, rock clunks",
               "With the shape locked and the back curved, the body rolls smoothly from the hips to the shoulder blades while the abs hold it.",
               "When the lower back gives, the body lands on a flat spot instead of rolling, the sign CrossFit's coaching reads as weak lower abs."),
   glows=[glow(N, ["spine", "chest"], A, 0.55, 0.10, 0.045, 0.0, -0.01),
          glow(N, ["pelvis", "thigh_L"], SOFT, 0.28, 0.06, 0.035, -0.02, -0.01)])

SETUP[N] = [
    "Lie face up on a mat with your legs straight, hip-width apart, and your arms reaching overhead.",
    "Press your lower back down, then lift your arms, head, shoulder blades and legs into the hollow hold.",
    "Lock the shape: knees straight, toes pointed, arms beside your head.",
    "Tip a little toward your feet to start, then let the whole body rock back and forth without changing shape.",
]

# ---------------------------------------------------------------- Dead Bug

N = "Dead Bug"
ex(name=N, var="deadBug",
   # Three-quarter from the front-left (yaw -0.8), head on the right: the
   # trunk lies across v ~0.52-0.62, the raised arms and shins reach up to
   # v ~0.42, and the reaching limbs sweep out to both sides at v ~0.52-0.57.
   # Three pills above the raised limbs, two below the mat. The reach pill
   # points at the left foot (it reaches in the first half, rests over the
   # hip in the second) from the open top left; the two arm pills stack
   # top right, the same-side pill above so its leader to the right hand
   # passes left of the short arms pill. Every leader meets its joint from
   # the open side in both halves of the clip (checked at 0-5 s).
   # The arms pill moved up from 0.32 (round 1: the raised hand in the
   # lifted mistake view came within ~2 pt of it).
   overrides={"reach": (ov(0.30), "leading"), "pair": (ov(0.16), "trailing"),
              "arms": (ov(0.27), "trailing"),
              "back": (ov(0.72), "leading"), "tempo": (ov(0.72), "trailing")},
   annotations=[
       ("back", "Low back stays down", "spine"),
       ("pair", "Opposite arm and leg", "hand_R"),
       ("reach", "Reach low, no touch", "foot_L"),
       ("arms", "Arms straight", "hand_L"),
       ("tempo", "Slow and steady", "head"),
   ],
   cues={
       "back": ("Lower Back Down",
                "Your lower back stays on the mat while an arm and a leg reach away.",
                "As the leg reaches out, its weight levers on the pelvis and tries to tip it into an arch, and holding it still is the abs' job; in an EMG study the dead bug worked mostly the abdominal muscles. NASM's guide lists the lower back arching away from the floor first among its common mistakes.",
                "The lower back arching off the mat as the leg straightens out.",
                "Keep your lower back pressed gently into the mat, and reach only as far as you can without it lifting."),
       "pair": ("Opposite Limbs",
                "The right arm and the left leg reach together, then the left arm and the right leg.",
                "Reaching with the opposite arm and leg at the same moment makes the trunk hold still against both, and it is how NASM's and StrengthLog's guides set the exercise up.",
                "Moving the arm and leg of the same side, or one limb after the other.",
                "Take your right arm overhead as your left leg straightens, bring both back together, then switch to the left arm and right leg."),
       "reach": ("Range",
                 "The heel and the hand stop about a hand's width above the floor.",
                 "Lowered that far, the straight arm and leg are long levers on the trunk, and NASM's guide stops them just short of touching the floor.",
                 "Stopping halfway, the knee still bent and the arm still high.",
                 "Straighten the leg until the heel hovers just above the mat, and take the arm back until the hand hovers over the floor behind your head."),
       "arms": ("Straight Arms",
                "Both arms stay straight, one pointing at the ceiling, the other reaching back overhead.",
                "A straight arm keeps the hand far from the shoulder, so the reaching arm is a long lever overhead as the straight leg is at the other end. NASM's and StrengthLog's guides start with both arms straight up toward the ceiling.",
                "Bending the elbows, so the reaching hand stays high and the other folds toward the face.",
                "Keep your elbows straight, the resting arm pointing at the ceiling over its shoulder and the reaching arm long behind your head."),
       "tempo": ("Tempo",
                 "Each reach takes about a second, with a short hold at full stretch.",
                 "NASM's guide asks for slow, deliberate reps and lists moving too fast or jerkily among the common mistakes; at a pace you could stop at any point, the lower back stays under control.",
                 "Kicking the leg out and swinging the arm back fast.",
                 "Reach out over about a second, hold briefly, take about a second to come back, then pause before switching sides."),
   },
   # Rectus abdominis bright (PRIMARY); obliques, sartorius (Hip Flexors) and
   # posterior deltoid dim. Souza 2001: the dying bug worked mostly the
   # abdominals, the rectus and obliques about equally, all below 41% MVIC,
   # so the rectus is moderate, under the Plank's 0.78, and the obliques below
   # it as the dim secondary. The hip flexors lower and lift the
   # reaching leg (a little under the Reverse Crunch's 0.42). The posterior
   # deltoid, a shoulder extensor (ExRx), brings the arm back up from
   # overhead, a minor role; as a third secondary row it truncated the
   # one-line legend on the lab shot (POSTERIOR DELTO...), so it is named with
   # the stabilisers, as the calfstand family did with the rhomboids. All
   # judgement calls.
   activation=[("Rectus Abdominis", P, MOD, 0.68), ("Obliques", S, MOD, 0.55),
               ("Hip Flexors", S, MOD, 0.40)],
   stabilisers=["transverse abdominis", "posterior deltoid", "quadriceps"],
   comparison=("BACK ARCHING", "Lower back stays down", "Lower back lifts as the leg lowers",
               "With the lower back on the mat, the abs hold the trunk still while the opposite arm and leg reach away.",
               "When the back arches off the mat, NASM reads it as the core letting go; shorten the reach until the back stays down."),
   glows=[glow(N, ["spine", "chest"], A, 0.55, 0.09, 0.045, 0.0, -0.01),
          glow(N, ["pelvis", "thigh_L"], SOFT, 0.25, 0.05, 0.035, 0.0, 0.0)])

SETUP[N] = [
    "Lie on your back on a mat with your head and shoulders resting down.",
    "Raise your arms straight up over your shoulders, fingers pointing at the ceiling.",
    "Lift your legs so the knees are over your hips, bent to 90°, shins level.",
    "Press your lower back gently into the mat and brace your abs.",
]

# ---------------------------------------------------------------- Bird Dog

N = "Bird Dog"
ex(name=N, var="birdDog",
   # Three-quarter from the front-left (yaw -0.8), head on the left: the
   # back runs across v ~0.42-0.47, the reaching arm sweeps out to the left
   # at v ~0.43-0.46 and the lifted leg to the right at v ~0.47-0.50, the
   # support arm and knees down to the mat at v ~0.59. Three pills above the
   # back, two below the mat. The arm pill points at the right hand from
   # below: on the mat it meets it across the mat, reaching (first half) it
   # passes left of the body to the hand out in front. The base pill points
   # at the near shoulder, which stays put while either arm moves, from
   # above (a leader to a support hand would cross the other arm when it
   # becomes the reaching one).
   overrides={"base": (ov(0.24), "leading"), "tempo": (ov(0.18), "trailing"),
              "hips": (ov(0.30), "trailing"),
              "arm": (ov(0.80), "leading"), "leg": (ov(0.72), "trailing")},
   annotations=[
       ("hips", "Hips level", "pelvis"),
       ("leg", "Heel back, hip height", "foot_L"),
       ("arm", "Hand at shoulder height", "hand_R"),
       ("base", "Hands under shoulders", "upper_arm_L"),
       ("tempo", "Slow, hold the top", "chest"),
   ],
   cues={
       "hips": ("Level Hips",
                "Your hips stay level and square to the floor while one leg is up.",
                "With a leg up, the pelvis rests on one knee and the trunk muscles have to stop it turning. In EMG studies of this exercise the obliques and back muscles on opposite sides of the trunk worked together to hold it still, and NASM's guide lists the spine rotating or the hips shifting first among its common mistakes.",
                "The hip of the lifted leg rolling up and out as the leg rises.",
                "Keep both hip bones pointing at the floor and lift the leg only as high as you can without the pelvis turning."),
       "leg": ("Leg Height",
               "The leg reaches straight back to about hip height, knee nearly straight.",
               "Raising the leg to the horizontal is how one EMG study set this exercise up, and there the gluteus maximus of that leg was among the most active muscles. NASM's guide extends the arm and leg into one straight line while the spine stays neutral, so the heel stops at about the height of your back.",
               "Kicking the heel up above hip height and sagging the lower back.",
               "Push the heel straight back until the leg is about level with your back, then stop there."),
       "arm": ("Arm Reach",
               "The hand reaches forward to about shoulder height, in front of your head.",
               "With the arm forward and the opposite leg back, the trunk holds against both at once. One EMG study raised the arm to the horizontal, and in a spine-loading study adding the opposite arm to a leg lift made the exercise harder.",
               "Swinging the arm up high above the head.",
               "Reach the hand forward to shoulder height in front of your head, the elbow allowed to bend as here, and keep the shoulder away from your ear."),
       "base": ("Base",
                "Hands under the shoulders, knees under the hips.",
                "Stacked like this, the arms and thighs carry your weight straight down, so the trunk can stay level while one arm and the opposite leg lift. NASM's guide sets the hands directly under the shoulders and the knees under the hips.",
                "Placing the support hand well out in front of the shoulder.",
                "Set each hand under its shoulder and each knee under its hip before the first rep, and keep the support hand there while the other arm reaches."),
       "tempo": ("Tempo",
                 "Lift slowly, hold the top briefly, lower under control.",
                 "ExRx asks for the arm and leg to be lifted deliberately with no jerking, and one EMG study took 2 seconds to lift, held for 5 and took 2 to lower. Here each way takes about a second, with a short hold at the top.",
                 "Flinging the arm and leg up and dropping them back down.",
                 "Take about a second to lift, hold for a moment at the top, take a second to lower, then switch sides."),
   },
   # Erector spinae and gluteus maximus, medius and minimus bright (PRIMARY);
   # anterior and lateral deltoid, obliques and rectus abdominis dim. In the
   # studies the back extensors and gluteus maximus of the lifted leg's side
   # are the most active (Stevens 2007: multifidus and gluteus maximus >20%
   # MVIC, not significantly different; Souza 2001: erectors and gluteus
   # maximus most active on the lifted leg's side, all <41%; Ekstrom 2007's
   # abstract: this lift may help strengthen the gluteus maximus), so both
   # sit level, moderate (0.64), well under the Glute Bridge's 0.82 and the
   # Back Extension's 0.85; ExRx makes the erector spinae the target, the
   # library row's muscle, so it is listed first. Gluteus medius bright
   # but an ExRx stabiliser here (its muscle page: it steadies the pelvis
   # when the other side has no leg under it, as on one knee here) and not
   # reported in the abstracts, so the lowest moderate (0.42); the gluteus
   # minimus, painted with it, is named with the stabilisers (the hip
   # family's rule for an unmeasured painted minimus). Obliques moderate
   # (0.48), under the erector spinae and gluteus maximus since they are
   # painted dim, though above the unmeasured gluteus medius: in all
   # three studies they are among the most active muscles (Stevens >20% for
   # the other side's internal and the leg side's external oblique, the same
   # class as the multifidus and gluteus maximus; Garcia-Vaquero's highest,
   # with the other side's erector spinae; Souza above the rectus abdominis). Review 2026-10-05: raised from
   # a LOW 0.38, which read as a minor role. The anterior deltoid holds the
   # reaching arm forward (ExRx synergist). The
   # rectus abdominis was among the lowest muscles measured (Stevens <10% MVIC) and
   # the lateral deltoid is a minor synergist, so both are named with the
   # stabilisers; four secondary rows would also overrun the one-line
   # legend. All fractions are judgement calls.
   activation=[("Erector Spinae", P, MOD, 0.64), ("Gluteus Maximus", P, MOD, 0.64),
               ("Gluteus Medius", P, MOD, 0.42), ("Obliques", S, MOD, 0.48),
               ("Anterior Deltoid", S, LOW, 0.28)],
   stabilisers=["rectus abdominis", "lateral deltoid", "gluteus minimus", "hamstrings"],
   comparison=("HIP ROLLING UP", "Hips level, trunk still", "Lifted hip rolls up and out",
               "With the hips square and the trunk still, the glutes lift the leg and the back and side muscles hold the trunk against the twist.",
               "When the hip rolls open, the pelvis turns to make room for the leg and the trunk gives in to the twist it is meant to resist."),
   glows=[glow(N, ["spine", "chest"], A, 0.55, 0.09, 0.03, 0.0, -0.015),
          glow(N, ["pelvis", "thigh_L", "thigh_R"], A, 0.45, 0.05, 0.035, 0.02, 0.0)])

SETUP[N] = [
    "Kneel on a mat on all fours, hands under your shoulders and knees under your hips, about hip-width apart.",
    "Straighten your arms without locking the elbows and spread your weight over both hands and knees.",
    "Set your back long and about level with the floor, your head in line with it.",
    "Brace your abs, then reach one arm forward and the opposite leg back.",
]
