# Trainer content for the 401-500 folder, round 2 (2026-10-04), family:
# situp. Six sit-ups and V-ups from the builder's 415-444 exports: 426 Sit-Up
# (Abs/SitUp), 427 Weighted Sit-Up (Abs/WeightedSitUp), 428 Decline Sit-Up
# (Abs/DeclineSitUp), 429 Weighted Decline Sit-Up (Abs/WeightedDeclineSitUp),
# 443 V-Up (Abs/VUp) and 444 Alternating V-Up (Abs/AlternatingVUp). Same
# format as spec.py on top of common_1_50.py; spec_500.py imports this module
# and gen.py reads SPEC / SETUP. notes_500_situp.md maps the copy's claims to
# the sources below and records the model facts.
#
# What the models show, measured on the rigs with Blender's Python + pxr
# (SCRATCH/situp/: rig.py reader, measure.py angles every 1/24 s, detail.py
# spine bends and hands against the head, plate.py the plate against the
# chest, bench.py the decline bench, vup.py hands against the feet; the app's
# Y-up space, the lifter facing +z, their left +x, lying with the head toward
# -z), the trunk stills at 0/1/2/3/5 s, tiers2.json and joints.json. "Trunk"
# is the pelvis-to-neck line, its angle measured above the floor. All six
# clips are 7.96 s with two identical 4 s reps: still to ~0.3 s, up by
# ~1.2 s (~0.9 s), held at the top ~1.2-2.1 s (~0.9 s), lowered by ~3.3 s
# (~1.1 s), resting flat ~3.3-4.3 s (~1 s). Paint on all six: rectus
# abdominis and the Sartorius mesh (the rig's hip flexors) bright, external
# and internal obliques dim.
# - Sit-Up (yaw -1.35, seen from the left): on a mat, knees bent 84-85°,
#   feet flat ~0.30 m apart and free (nothing holds them; they stay put all
#   rep). The hands rest beside the head, wrists ~14 cm out from it and the
#   fingertips ~3-6 cm behind it, elbows bent 39-41° and pointing forward
#   and out; they do not move against the head all rep. Lying, the trunk is
#   5° below level (hips 150°); it rises to 81° (9° short of upright, hips
#   62°, trunk-to-thigh 59°). The rise starts as a curl: at 0.5 s the
#   shoulder blades are ~12 cm off the mat while the trunk is only 11° up,
#   the upper back rounds ~15° more than lying and the head nods ~7°; the
#   hips then flex. The pelvis rolls back ~4 cm at the top.
# - Weighted Sit-Up (yaw -1.35): the same mat, legs and timing, holding a
#   30 cm plate (4.8 cm thick) flat against the upper chest, the left hand
#   over its top edge and the right hand under its bottom edge (elbows
#   77° / 83°); the plate stays on the chest all rep (fixed in the chest
#   joint's frame). The trunk rises to 76° (14° short of upright, hips 68°).
# - Decline Sit-Up (yaw -1.35): a decline bench, its pad sloping 17° (~1.6 m
#   long, 42 cm wide, 0.31 m up at the head end, 0.78 m at the high end), the
#   fronts of the ankles hooked under a 10 cm ankle roller at the high end,
#   knees bent 73-74°, the seat on the pad. Lying along the pad the trunk is
#   22° below level (head below the hips); it rises to 86° (4° short of
#   upright, 103° from the bench), hips 35°, the chest over the thighs
#   (trunk-to-thigh 30°): 108° of trunk travel against 86° on the floor.
#   Hands as the Sit-Up.
# - Weighted Decline Sit-Up (yaw -1.35): the same bench and legs, a 25 cm
#   plate held flat on the upper chest as the Weighted Sit-Up (elbows
#   76° / 80°). The trunk rises to 65° (82° from the bench; hips 57°), well
#   short of upright.
# - V-Up (yaw -1.35): flat on a mat, legs straight (knees 180°) about
#   hip-width, arms straight (elbows 174°) overhead on the mat, hands ~0.6 m
#   apart. Trunk and legs rise together to a V: both 62° above the floor at
#   the top (hips 57°), the arms swinging forward so each hand's fingertips
#   reach ~4 cm from its own ankle; balanced on the seat (the pelvis 3 cm
#   lower). Held ~1 s, lowered ~1 s, then arms and legs rest on the mat for
#   ~1 s between reps.
# - Alternating V-Up (yaw -0.8, three-quarter from the front-left): the same
#   start and trunk path (62°), one leg at a time: rep 1 (0-4 s) the LEFT leg
#   rises to 62° and both hands reach the left ankle (fingertips ~6 cm from
#   it), the shoulders turned ~10° toward it; the right leg stays straight on
#   the mat. Rep 2 (4-8 s) mirrors it with the right leg. Knees 180°.
#
# How they differ from the library: the Crunch stops when the shoulder blades
# clear the floor and the Decline Crunch curls only the upper back; these four
# sit-ups come up to 65-86°, the hips flexing as well as the spine, so the hip
# flexors are painted bright and are primary rows. The Reverse Crunch and
# Hanging Leg Raise move the legs with the trunk still; the V-ups raise both.
# The floor sit-ups leave the feet free, the decline pair hook the ankles.
#
# Sources (abstracts read on Europe PMC 2026-10-04, full text where noted;
# ExRx on the Wayback Machine; web pages as dated; details in the notes):
# - ExRx.net (Wayback Machine; the live site returns 403): Sit-up
#   (RectusAbdominis/BWSitUp, snapshot 2026-02-12), Weighted Sit-up
#   (WtSitUp, 2026-02-06), Incline Sit-up (BWInclineSitUp, 2026-02-12,
#   ExRx's name for the head-down board), Weighted Decline Sit-up
#   (HipFlexors/WtDeclineSitup, 2023-12-13), Roman Chair Sit-up
#   (HipFlexors/BWRomanChairSitup, 2025-06-16), Arm Position During Waist
#   Exercises (WeightTraining/Tips, 2025-10-29) and the Dangerous Exercise
#   essay (Questions/DangerousExercises, 2025-06-07):
#   target rectus abdominis, synergists iliopsoas, tensor fasciae latae,
#   rectus femoris, sartorius and obliques, tibialis anterior a stabiliser
#   with the feet hooked; the abs only shorten if the waist actually bends,
#   otherwise they hold the pelvis and waist while the hip flexors lift;
#   if the upper back does not come all the way down the abs may only work
#   isometrically; keep space between chin and sternum if needed; a load
#   higher up the body (further from the fulcrum, the joint the body turns
#   about: arms or a plate higher up) is harder, a plate on
#   the upper chest just below the neck suits those protecting the neck,
#   jerking the head forward with the hands behind it may hurt the neck;
#   the slope (and added weight) makes the board version harder; strong
#   abs and flexible hip flexors matter before decline sit-ups.
# - Juker D, McGill S, Kropf P, Steffen T 1998, Med Sci Sports Exerc
#   30(2):301-310, doi:10.1097/00005768-199802000-00020, PMID 9502361 -
#   intramuscular EMG: every sit-up form activated psoas 15-35% MVC, the
#   curl-up under 10%.
# - Andersson EA, Nilsson J, Ma Z, Thorstensson A 1997, Eur J Appl Physiol
#   Occup Physiol 75(2):115-123, doi:10.1007/s004210050135, PMID 9118976 -
#   6 men, 38 exercises: abdominals active in both trunk and hip flexion
#   sit-ups; in hip flexion sit-ups flexed and supported legs raised hip
#   flexor activation and did not generally change the abdominals';
#   bilateral, not unilateral, leg lifts needed the abdominals.
# - Sullivan W, Gardin FA, Bellon CR, Leigh S 2015, J Strength Cond Res
#   29(12):3472-3479, doi:10.1519/JSC.0000000000001006, PMID 25970493 - 18
#   trained men: a sit-up done as trunk flexion drew more mean rectus
#   abdominis and external oblique EMG and less rectus femoris than the
#   Army sit-up, which emphasised hip flexion and may arch the lower back.
# - Parfrey KC, Docherty D, Workman RC, Behm DG 2008, Appl Physiol Nutr
#   Metab 33(5):888-895, doi:10.1139/H08-061, PMID 18923563 - 14
#   subjects, isometric sit- and curl-up positions: fixing the feet
#   lowered activation at every abdominal site and raised rectus femoris
#   activation.
# - Burden AM, Redmond CG 2013, J Strength Cond Res 27(8):2119-2128,
#   doi:10.1519/JSC.0b013e318278f0ac, PMID 23207881 - 23 British Army
#   personnel: feet-restrained sit-ups and curl-ups worked the rectus
#   femoris harder than unrestrained curl-ups (but curl-ups with the feet
#   restrained drew the highest abdominal EMG, so the copy cites only
#   Parfrey for feet fixing lowering the abdominals).
# - Cordo PJ, Gurfinkel VS, Smith TC, Hodges PW, Verschueren SM, Brumagne S
#   2003, J Electromyogr Kinesiol 13(3):239-252,
#   doi:10.1016/S1050-6411(03)00023-3, PMID 12706604 - the sit-up is trunk
#   curling (neck and upper trunk, then lumbar lifting) and then pelvic
#   rotation; the lumbar lift is the point of peak muscle contraction and
#   greatest instability.
# - Kim K, Lee T 2016, J Phys Ther Sci 28(2):491-494,
#   doi:10.1589/jpts.28.491, PMID 27065536 (PMC4792997, full text) - 20
#   students, 3 s up and 3 s down sit-ups: lower rectus abdominis 34.1% MVIC
#   lowering against 27.9% raising (significant).
# - Escamilla RF, McTaggart MS, Fricklas EJ, et al. 2006, J Orthop Sports
#   Phys Ther 36(2):45-57, doi:10.2519/jospt.2006.36.2.45, PMID 16494072 -
#   rectus abdominis among the highest in the crunch (not the bent-knee
#   sit-up), obliques among the highest in both the crunch and the bent-knee
#   sit-up, rectus femoris among the highest in the bent-knee sit-up.
# - Escamilla RF, Babb E, DeWitt R, et al. 2006, Phys Ther 86(5):656-671,
#   doi:10.1093/ptj/86.5.656, PMID 16649890 - rectus femoris among the
#   highest in the bent-knee sit-up.
# - Monfort-Panego M, Vera-Garcia FJ, Sanchez-Zuriaga D, Sarti-Martinez MA
#   2009, J Manipulative Physiol Ther 32(3):232-244,
#   doi:10.1016/j.jmpt.2009.02.007, PMID 19362234 - review of 87 studies:
#   inclined planes or added loads raise contraction intensity; for safety
#   avoid active hip flexion and fixed feet and do not pull with the hands
#   behind the head.
# - McGill SM 1995, Clin Biomech 10(4):184-192,
#   doi:10.1016/0268-0033(95)91396-V, PMID 11415551 - lumbar compression
#   over 3000 N predicted for straight-leg and bent-knee sit-ups.
# - Szasz A, Zimmerman A, Frey E, Brady D, Spalletta R 2002, Mil Med
#   167(11):950-953, doi:10.1093/milmed/167.11.950, PMID 12448625 - over a
#   2-minute sit-up test the hip flexors' share rose against the
#   abdominals'.
# - StrengthLog, Sit-Up (strengthlog.com/sit-up, Wayback 2026-02-21): knees
#   about 90°, bend as far forward as possible, a weight held against the
#   chest to add load.
# - Catalyst Athletics, V-Up (catalystathletics.com/exercise/313, read
#   2026-10-04): legs straight, arms overhead, sit up and lift the legs
#   together, hands to the toes, pause balanced; bent knees with the hands
#   on the head (knees to elbows) make it a jack knife.
# - Rogue Fitness, Movement Demo: V-Ups (Wayback 2025-10-18): lift legs and
#   torso together, legs straight, reach toward the toes, balance on the
#   glutes, lower under control without arching or slamming; the single-leg
#   V-up (one leg at a time, the other on the ground) and the tuck-up as
#   easier versions.
# No EMG study of these six exact lifts was found, so every fraction below
# is a judgement call anchored on the library's Crunch (rectus abdominis
# 0.80, obliques 0.45), Decline Crunch (0.84) and Hanging Leg Raise (hip
# flexors 0.86), ordered by the studies above (see the notes).
from common_1_50 import *


def ov(final):
    """Pre-squeeze override row for an on-screen row (spec_500.row() maps
    0.14-0.86 to 0.16-0.80)."""
    return round(0.14 + (final - 0.16) * (0.86 - 0.14) / (0.80 - 0.16), 4)


def core(name, abs_dx=0.0, abs_dy=0.0, hip_dx=0.0, hip_dy=0.0):
    """The abdominals between the lower back and chest (bright), the front
    of the hip down the near thigh (the hip flexors, bright) and a soft
    halo for the dim obliques."""
    return [glow(name, ["spine", "chest"], A, 0.55, 0.07, 0.05, abs_dx, abs_dy),
            glow(name, ["thigh_L", "patella_L"], A, 0.40, 0.05, 0.035, hip_dx, hip_dy),
            glow(name, ["spine", "pelvis"], SOFT, 0.25, 0.09, 0.05, abs_dx, abs_dy)]


# ---------------------------------------------------------------- Sit-Up

N = "Sit-Up"
ex(name=N, var="sitUp",
   overrides={"top": (ov(0.20), "leading"), "neck": (ov(0.28), "trailing"), "bottom": (ov(0.70), "trailing"), "feet": (ov(0.72), "leading"), "curl": (ov(0.80), "trailing")},
   annotations=[
       ("neck", "Hands at the ears", "hand_L"),
       ("curl", "Curl up first", "spine"),
       ("feet", "Feet stay down", "foot_L"),
       ("top", "Sit up tall, pause", "head"),
       ("bottom", "Shoulders down", "scapula_L"),
   ],
   cues={
       "neck": ("Hand Position",
                "Your hands rest beside your ears, fingertips behind your head, and stay there all rep.",
                "Pulling on the head bends the neck rather than the trunk. ExRx warns that throwing the body up with the hands behind the head can jerk the head forward harder than the neck is used to, and a review of abdominal exercise studies lists not pulling with the hands behind the head among its safety rules.",
                "Hauling on the back of the head to get up, the chin jammed into the chest.",
                "Keep the elbows out, the hands light against your head and a gap between chin and chest, and let the trunk do the lifting."),
       "curl": ("Curl First",
                "Lift the head and shoulders first, then the rest of the back.",
                "A sit-up begins as a trunk curl, the neck and upper back bending before the lower back lifts and the hips take over. In one EMG study a sit-up done as a trunk curl drew more rectus abdominis and external oblique activity on average, and less from the rectus femoris, a hip flexor, than the Army's hip-led sit-up, which the authors said may arch the lower back.",
                "The lower back arching off the mat as you heave up stiffly from the hips.",
                "Tuck the chin slightly, peel the shoulder blades off the mat and keep rounding up until you are sitting."),
       "feet": ("Free Feet",
                "The feet stay flat on the mat with nothing holding them down.",
                "Hooking the feet gives the hip flexors something to pull against. In one EMG study, fixing the feet lowered abdominal activity and raised it in the rectus femoris, a hip flexor, and in another, restrained feet also raised rectus femoris activity.",
                "The feet lifting off the mat as you jerk the trunk up.",
                "Press the heels lightly into the mat and rise at a pace that keeps both feet down; if they lift, curl up more slowly."),
       "top": ("Top of the Rep",
               "Sit up until your trunk is close to upright, then pause.",
               "Coming all the way up adds hip flexion to the curl, which is what makes this a sit-up rather than a crunch: in one study every form of sit-up worked the psoas, a deep hip flexor, at 15 to 35 percent of its maximum, against under 10 percent for the curl-up.",
               "Turning back down with the trunk only halfway up.",
               "Keep curling and sitting up until your trunk is nearly upright, hold for about a second, then lower."),
       "bottom": ("Bottom of the Rep",
                  "Lower until your shoulder blades rest on the mat each rep.",
                  "ExRx notes that if the upper back never comes all the way down, the abs may only hold a position instead of working through their range. Resting the shoulders for a moment also starts each rep from a stop instead of a bounce.",
                  "Stopping with the shoulders hovering above the mat before the next rep.",
                  "Roll back down under control until your shoulder blades rest on the mat, pause, then curl up again."),
   },
   # Paint: rectus abdominis and hip flexors bright (PRIMARY), obliques dim
   # (SECONDARY). Judgement calls: Rectus Abdominis 0.76, a little under the
   # library Crunch's 0.80 (Escamilla 2006 JOSPT: rectus abdominis among the
   # highest in the crunch, not the bent-knee sit-up); Hip Flexors 0.72
   # (Juker 1998: psoas 15-35% MVC in sit-ups vs under 10% in curl-ups;
   # Escamilla 2006: rectus femoris among the highest in the bent-knee
   # sit-up), below the Hanging Leg Raise's 0.86 because the feet are free
   # (Parfrey 2008, Burden 2013: fixed feet raise the rectus femoris);
   # Obliques 0.50, a judgement a little above the Crunch's 0.45 (Escamilla
   # 2006 JOSPT puts the crunch and the bent-knee sit-up both among the
   # highest for the obliques, so it does not rank them).
   activation=[("Rectus Abdominis", P, HI, 0.76), ("Hip Flexors", P, HI, 0.72), ("Obliques", S, MOD, 0.50)],
   stabilisers=["transverse abdominis", "neck flexors", "rectus femoris"],
   comparison=("HEAVING FROM THE HIPS", "Curl up from the shoulders", "Back arches, hips heave",
               "Curling up from the head and shoulders makes the rectus abdominis bend the spine before the hips finish the lift.",
               "Heaving up stiff from the hips can arch the lower back and hands more of the lift to the hip flexors."),
   glows=core(N))

SETUP[N] = [
    "Lie on your back on a mat, knees bent to about 90 degrees, feet flat and hip-width apart.",
    "Leave your feet free; do not hook them under anything.",
    "Rest your fingertips behind your head with your hands beside your ears, elbows out.",
    "Start with your head and shoulders resting on the mat.",
]

# ---------------------------------------------------------------- Weighted Sit-Up

N = "Weighted Sit-Up"
ex(name=N, var="weightedSitUp",
   overrides={"chin": (ov(0.24), "trailing"), "plate": (ov(0.28), "leading"), "bottom": (ov(0.70), "trailing"), "feet": (ov(0.72), "leading"), "curl": (ov(0.80), "trailing")},
   annotations=[
       ("plate", "Plate on the chest", "hand_L"),
       ("chin", "Chin off the plate", "head"),
       ("curl", "Round up first", "spine"),
       ("feet", "Heels stay down", "foot_L"),
       ("bottom", "Back to the mat", "scapula_L"),
   ],
   cues={
       "plate": ("Plate Position",
                 "Hug the plate flat to your upper chest from start to finish.",
                 "Where the weight sits sets how hard the rep is. ExRx explains that a load higher up the body is harder to lift, so a plate held high behind the head is harder than the same plate on the lower chest. Pushing the plate out toward the knees shortens its leverage on the hips and swings it up for you.",
                 "Pushing the plate off the chest toward the knees to throw yourself up.",
                 "Keep one hand over the top edge and one under the bottom edge, elbows bent, and the plate against your upper chest as you go up and down."),
       "chin": ("Head Position",
                "Keep a gap between your chin and the plate.",
                "ExRx suggests a neutral neck with space between chin and breastbone for anyone who needs to protect the neck, with the plate on the upper chest just below it. ExRx also warns not to mistake moving the neck for moving the waist: tucking the chin onto the plate only bends the neck.",
                "Dropping the chin onto the plate and leading the rep with the head.",
                "Look slightly up past the plate, chin about a fist from the chest, and let the head move with the trunk."),
       "curl": ("Round Up",
                "Round the upper back off the mat before the hips bend.",
                "In a motion study the sit-up started with the neck and upper back curling, then the lower back lifting, and that lift was the moment of peak muscle activity and least stability. Rounding through it keeps the abs bending the spine; ExRx notes they only shorten if the waist actually bends.",
                "The lower back arching off the mat as you heave the trunk and plate up in one piece.",
                "Nod the chin slightly, curl the shoulders off the mat with the plate on your chest, then keep rounding up."),
       "feet": ("Feet Down",
                "Both feet stay flat on the mat, with nothing holding them.",
                "With a plate on the chest you may want to hook your feet. In one EMG study, fixed feet lowered the abdominals' activity and raised that of the rectus femoris, a hip flexor, so free feet leave more of the lift to the abs.",
                "Both feet lifting off the mat as you jerk the plate up.",
                "Plant your heels and pick a plate you can curl up with while they stay down, then rise smoothly."),
       "bottom": ("Full Return",
                  "Lower all the way until your shoulder blades rest on the mat.",
                  "ExRx's weighted sit-up carries the same note as its plain one: if the upper back stops short of the mat, the abs may only hold a position. Pausing on the mat also takes any bounce out of the next rep.",
                  "Bouncing back up with the shoulders still off the mat.",
                  "Lower the plate and shoulders under control until your upper back rests on the mat, pause, then curl up."),
   },
   # Paint as the Sit-Up. Judgement calls: each row a little above the
   # Sit-Up's for the plate (Monfort-Panego 2009: added loads raise
   # contraction intensity): Rectus Abdominis 0.82, Hip Flexors 0.76,
   # Obliques 0.54.
   activation=[("Rectus Abdominis", P, HI, 0.82), ("Hip Flexors", P, HI, 0.76), ("Obliques", S, MOD, 0.54)],
   stabilisers=["transverse abdominis", "neck flexors", "rectus femoris", "forearm flexors"],
   comparison=("PLATE PUSHED OUT", "Plate hugged to the chest", "Plate pushed toward the knees",
               "With the plate held on the upper chest, its weight keeps its full leverage and the trunk has to lift it.",
               "Pushing the plate toward the knees shortens its leverage on the hips and turns it into a swing."),
   glows=core(N))

SETUP[N] = [
    "Lie on your back on a mat, knees bent and feet flat, with nothing holding the feet.",
    "Hold a light plate flat against your upper chest, one hand over its top edge and one under its bottom edge.",
    "Rest your head and shoulders on the mat with the plate held close.",
]

# ---------------------------------------------------------------- Decline Sit-Up

N = "Decline Sit-Up"
ex(name=N, var="declineSitUp",
   overrides={"curl": (ov(0.20), "trailing"), "bottom": (ov(0.28), "leading"), "tempo": (ov(0.27), "trailing"), "roller": (ov(0.36), "leading"), "neck": (ov(0.34), "trailing")},
   annotations=[
       ("roller", "Ankles hooked", "toe_L"),
       ("neck", "No pulling", "hand_L"),
       ("curl", "Curl up first", "neck"),
       ("bottom", "Shoulders down", "scapula_R"),
       ("tempo", "Lower slowly", "neck"),
   ],
   cues={
       "roller": ("Ankle Roller",
                  "Hook your ankles under the roller and let the legs relax.",
                  "On a decline the roller stops you sliding down the bench, but it also gives the hip flexors something to pull against. With the legs supported, hip-led sit-ups raised hip flexor activity while the abdominals' stayed about the same, and fixing the feet raised rectus femoris activity in other studies.",
                  "Pulling the shins hard into the roller to drag yourself up.",
                  "Hook the fronts of your ankles under the roller with the knees bent and use it only as an anchor."),
       "neck": ("Hand Position",
                "Fingertips rest behind the head, hands by the ears, for the whole set.",
                "With the head starting below the hips it is tempting to pull on it to get moving. Pulling bends the neck, not the trunk, and a review of abdominal EMG studies lists not pulling with the hands behind the head among its safety rules.",
                "Yanking the head forward with the hands to start each rep.",
                "Keep the elbows out, the hands light and the chin off the chest as you curl up."),
       "curl": ("Curl Off the Bench",
                "Peel your shoulders off the bench before the hips start to bend.",
                "ExRx files its decline sit-up under the hip flexors and notes that unless the waist actually bends, the abs only hold the pelvis and waist still. Curling first keeps them doing the bending.",
                "The lower back arching off the bench as you heave up in one stiff piece.",
                "Nod the chin, round the upper back off the bench and keep curling until you are sitting up."),
       "bottom": ("Back to the Bench",
                  "Lower until your shoulders touch the bench again.",
                  "On ExRx's head-down board you return until the backs of the shoulders touch it, and ExRx notes that if the upper back stops short, the abs may only hold a position. Here that return takes the trunk below level, the lowest point of the rep.",
                  "Turning around with the shoulders still above the bench.",
                  "Lower until your shoulder blades rest on the bench, pause briefly, then curl up again."),
       "tempo": ("Lowering Speed",
                 "Take about a second to lower; never drop back.",
                 "With the head below the hips, gravity pulls the trunk down the slope, so letting go means falling. In a small EMG study of slow sit-ups the lower rectus abdominis worked harder while the trunk was lowered than while it was raised, so the way down is part of the work.",
                 "Dropping back down the slope and landing on the bench with a thud.",
                 "Lower at about the speed you rose, uncurling as you go, until the shoulders touch."),
   },
   # Paint as the Sit-Up. Judgement calls: Rectus Abdominis 0.82 (the
   # library's Decline Crunch has 0.84; Monfort-Panego 2009: inclined planes
   # raise contraction intensity); Hip Flexors 0.84, higher than on the
   # floor because the ankles are hooked (Andersson 1997: supported legs
   # raised hip flexor activation; Parfrey 2008, Burden 2013: fixed feet
   # raised the rectus femoris); Obliques 0.52.
   activation=[("Rectus Abdominis", P, HI, 0.82), ("Hip Flexors", P, HI, 0.84), ("Obliques", S, MOD, 0.52)],
   stabilisers=["transverse abdominis", "neck flexors", "tibialis anterior", "rectus femoris"],
   comparison=("PULLING ON THE ROLLER", "Ankles hooked, legs relaxed", "Shins drag the body up",
               "With the legs relaxed under the roller, the curl starts with the abs and the hips follow.",
               "Dragging on the roller makes the lift a hip flexor pull."),
   glows=core(N))

SETUP[N] = [
    "Set the bench to a shallow decline, about 15 to 20 degrees, head end low.",
    "Sit on the bench and hook your ankles under the roller at the high end, knees bent.",
    "Lie back along the bench until your shoulders rest on it.",
    "Rest your fingertips behind your head with your hands by your ears.",
]

# ---------------------------------------------------------------- Weighted Decline Sit-Up

N = "Weighted Decline Sit-Up"
ex(name=N, var="weightedDeclineSitUp",
   overrides={"bottom": (ov(0.20), "leading"), "curl": (ov(0.24), "trailing"), "plate": (ov(0.30), "leading"), "chin": (ov(0.34), "trailing"), "roller": (ov(0.40), "leading")},
   annotations=[
       ("plate", "Plate close", "chest"),
       ("chin", "Chin up", "head"),
       ("roller", "Ankles hooked", "toe_L"),
       ("curl", "Curl up first", "neck"),
       ("bottom", "Shoulders down", "scapula_R"),
   ],
   cues={
       "plate": ("Plate Position",
                 "The plate stays flat on your upper chest all rep.",
                 "ExRx shows the weight held in front of the chest for this lift and explains that the higher up the body a load sits, the harder it is. Letting the plate drift toward the knees shortens its leverage on the hips as you rise and turns the start of the rep into a swing.",
                 "Pushing the plate out toward the knees to get up off the bench.",
                 "Grip the plate's top and bottom edges with the elbows bent and keep it pressed to your upper chest from the bench to the top."),
       "chin": ("Head Position",
                "Keep the chin up off the plate.",
                "On a head-down bench you may find yourself leading with the chin. ExRx advises keeping space between chin and breastbone where the neck needs protecting, with the plate on the upper chest just below the neck; tucking hard bends the neck, not the waist.",
                "Pressing the chin into the plate and craning the head forward.",
                "Keep the head in line with the upper back, a fist of space under the chin, as you curl and lower."),
       "roller": ("Ankle Roller",
                  "The roller holds your ankles; the legs stay relaxed.",
                  "A plate on the chest makes it more tempting to drag yourself up with the legs. Supported or fixed feet raised hip flexor activity in EMG studies, and in one of them lowered abdominal activity; ExRx adds that strong abs and flexible hip flexors matter before decline sit-ups.",
                  "Hauling on the roller with the shins to get the plate moving.",
                  "Hook the fronts of the ankles under the roller, knees bent, and start each rep from the trunk."),
       "curl": ("Curl Up",
                "Curl the shoulders off the bench, then sit up.",
                "ExRx notes the abs only shorten if the waist bends; kept straight, they just hold the trunk while the hip flexors lift it. Curling first, with the plate on your chest, makes them bend the spine under the load.",
                "The lower back arching off the bench as you lift the plate and trunk in one piece.",
                "Nod the chin, round the upper back off the bench with the plate held close, and keep curling up."),
       "bottom": ("Back to the Bench",
                  "Lower until your upper back rests on the bench.",
                  "ExRx's sit-up on a head-down board returns until the backs of the shoulders touch the board; if the upper back stops short, the abs may only hold a position instead of working through their range.",
                  "Turning around with the shoulders and plate still above the bench.",
                  "Lower the plate and shoulders under control until your shoulder blades rest on the bench, pause, then curl up."),
   },
   # Paint as the Sit-Up. Judgement calls, the highest sit-up values: the
   # Decline Sit-Up's plus the plate (Monfort-Panego 2009: added loads raise
   # contraction intensity): Rectus Abdominis 0.86, Hip Flexors 0.86,
   # Obliques 0.56.
   activation=[("Rectus Abdominis", P, HI, 0.86), ("Hip Flexors", P, HI, 0.86), ("Obliques", S, MOD, 0.56)],
   stabilisers=["transverse abdominis", "tibialis anterior", "rectus femoris", "forearm flexors"],
   comparison=("PLATE DRIFTING", "Plate pressed to the chest", "Plate drifts toward the knees",
               "Held on the upper chest, the plate keeps its full leverage on the hips as you rise.",
               "As the plate drifts toward the knees its leverage on the hips shortens and the rep gets easier."),
   glows=core(N))

SETUP[N] = [
    "Set the bench to a shallow decline and hook your ankles under the roller, knees bent.",
    "Hold a light plate flat against your upper chest, gripping its top and bottom edges.",
    "Lie back until your shoulder blades rest on the bench, the plate held close.",
]

# ---------------------------------------------------------------- V-Up

N = "V-Up"
ex(name=N, var="vUp",
   overrides={"together": (ov(0.28), "leading"), "reach": (ov(0.32), "trailing"), "back": (ov(0.68), "trailing"), "legs": (ov(0.72), "leading"), "balance": (ov(0.80), "leading")},
   annotations=[
       ("legs", "Knees straight", "shin_L"),
       ("reach", "Hands to the ankles", "hand_L"),
       ("together", "Lift legs and trunk", "toe_L"),
       ("balance", "Balance on the seat", "pelvis"),
       ("back", "No arch coming down", "spine"),
   ],
   cues={
       "legs": ("Straight Legs",
                "The legs stay straight from the floor to the top.",
                "Straight legs make the long lever that sets the V-up apart. Catalyst Athletics describes the bent-knee version, knees and elbows meeting, as another exercise, the jack knife, and Rogue lists the bent-knee tuck-up as an easier version.",
                "Bending the knees to pull the feet in toward the hands.",
                "Keep the knees straight, point the toes and lift the legs as one piece."),
       "reach": ("Reach",
                 "Swing the arms from overhead to reach your hands toward your ankles.",
                 "The reach brings the trunk up to meet the legs; both Catalyst Athletics and Rogue have the hands go to the feet. Here each hand finishes at its own ankle.",
                 "Stopping with the arms pointing at the ceiling, short of the ankles.",
                 "Keep the arms straight and reach past your knees until your hands are at your ankles."),
       "together": ("Rise Together",
                    "The trunk and legs leave the mat at the same time.",
                    "The V-up is a sit-up and a leg raise done together; Rogue and Catalyst Athletics both lift the trunk and the legs at once. Sitting up first and adding the legs later turns it into two smaller movements.",
                    "Sitting up first while the legs stay on the mat, then lifting them.",
                    "Lift the shoulders and heels together so the two halves of the V rise at the same speed."),
       "balance": ("Top Position",
                   "Balance on your seat at the top and hold for a moment.",
                   "At the top your weight rests on the seat between the two halves of the V; Rogue cues balancing on the glutes and Catalyst Athletics a pause where the hands and feet meet. Rolling back onto the lower back means the trunk did not come up as far as the legs.",
                   "Rolling back onto the lower back, the legs tipping back toward the head.",
                   "Rise until you balance on your seat, hold for about a second, then lower."),
       "back": ("Lowering",
                "Lower the legs and trunk together with the lower back down.",
                "Rogue warns against arching the lower back or slamming down on the way back. Lowering the trunk and legs together, under control, keeps the lower back on the mat.",
                "The lower back arching off the mat as the legs come down.",
                "Lower both halves slowly, keep the lower back pressed gently into the mat and let the arms and legs touch down together."),
   },
   # Paint as the Sit-Up. Judgement calls on the library's Hanging Leg Raise
   # (rectus abdominis 0.84, hip flexors 0.86), which lifts straight legs as
   # this does: Hip Flexors 0.88 (both legs lifted straight, plus the trunk);
   # Rectus Abdominis 0.84 (Andersson 1997: lifting both legs needs the
   # abdominals, and they work in sit-ups too); Obliques 0.55.
   activation=[("Rectus Abdominis", P, HI, 0.84), ("Hip Flexors", P, HI, 0.88), ("Obliques", S, MOD, 0.55)],
   stabilisers=["transverse abdominis", "quadriceps", "anterior deltoid"],
   comparison=("BENT KNEES", "Straight legs rise to the hands", "Knees bend to meet the hands",
               "Straight legs make the long lever the hip flexors and abs have to lift and hold.",
               "Bending the knees shortens the legs and turns the V-up into the easier tuck-up."),
   glows=core(N))

SETUP[N] = [
    "Lie flat on your back on a mat, legs straight and about hip-width apart.",
    "Stretch your arms overhead along the mat, hands a little wider than your shoulders.",
    "Brace your abs and press your lower back gently into the mat.",
]

# ---------------------------------------------------------------- Alternating V-Up

N = "Alternating V-Up"
ex(name=N, var="alternatingVUp",
   overrides={"reach": (ov(0.16), "trailing"), "down": (ov(0.30), "leading"), "knees": (ov(0.72), "leading"), "trunk": (ov(0.72), "trailing"), "back": (ov(0.80), "leading")},
   annotations=[
       ("knees", "Knees straight", "patella_L"),
       ("down", "One leg at a time", "foot_R"),
       ("reach", "Hands to that ankle", "hand_L"),
       ("trunk", "Chest comes up too", "chest"),
       ("back", "Lower back stays down", "spine"),
   ],
   cues={
       "knees": ("Straight Legs",
                 "Both knees stay straight: the lifted leg and the one on the mat.",
                 "A straight lifted leg keeps the lever long, and Rogue counts the bent-knee tuck-up as an easier version. The leg on the mat stays straight too, so it cannot brace you up.",
                 "Bending the lifted knee to bring the foot in to the hands.",
                 "Keep both knees straight, point the toes of the lifted foot and raise it as one piece."),
       "down": ("One Leg at a Time",
                "One leg rises each rep: the left first, then the right. The other stays on the mat.",
                "Rogue lists this single-leg V-up, the other leg kept on the ground, as an easier step toward the full V-up. One leg is lighter work for the abs than two: in an EMG study of leg lifts, lifting both legs needed the abdominals and lifting one did not.",
                "The resting leg drifting up off the mat with the working one.",
                "Keep the resting leg straight with the heel on the mat while the other leg rises, and switch legs every rep."),
       "reach": ("Reach",
                 "Both hands reach for the ankle of the leg that rises.",
                 "Reaching for the lifted foot brings the trunk up and turns it slightly toward that leg. The hands reach that ankle, as in the full V-up, which Rogue and Catalyst Athletics both finish with the hands at the feet.",
                 "Stopping with the arms pointing at the ceiling, short of the foot.",
                 "Swing the straight arms up from overhead and reach both hands to the lifted ankle."),
       "trunk": ("Trunk Lift",
                 "The trunk rises as far as the leg does.",
                 "This is still a V-up, the trunk and the leg rising at the same time. Lifting only the leg while the shoulders stay low turns it into a one-leg raise, and in an EMG study of leg lifts, raising one leg alone did not need the abdominals.",
                 "Raising the leg while the chest lags well behind it.",
                 "Curl the chest up as the leg rises until both reach about the same angle off the mat."),
       "back": ("Lowering",
                "Lower the leg and trunk together with the lower back down.",
                "Rogue warns against arching the lower back or slamming down. Bringing the leg and the trunk down together, slowly, keeps the lower back on the mat.",
                "The lower back arching up as the leg comes down.",
                "Lower the leg and the trunk slowly together, lower back pressed gently down, until both rest on the mat."),
   },
   # Paint as the Sit-Up. Judgement calls, below the V-Up because only one
   # leg rises (Andersson 1997: unilateral leg lifts did not need the
   # abdominals, bilateral ones did; Rogue: the single-leg V-up is the easier
   # version): Rectus Abdominis 0.78, Hip Flexors 0.76, Obliques 0.50 (the
   # trunk turns ~10° toward the lifted leg).
   activation=[("Rectus Abdominis", P, HI, 0.78), ("Hip Flexors", P, HI, 0.76), ("Obliques", S, MOD, 0.50)],
   stabilisers=["transverse abdominis", "quadriceps", "anterior deltoid"],
   comparison=("RESTING LEG LIFTING", "Other leg stays on the mat", "Both legs drift up",
               "Keeping the resting leg down makes each rep a single-leg V-up, one leg lifted at a time.",
               "When the resting leg drifts up as well, both legs end up lifting and the rep is no longer the easier single-leg version."),
   glows=core(N))

SETUP[N] = [
    "Lie on your back on a mat, legs straight, arms stretched overhead.",
    "Tighten your abs so your lower back rests lightly on the mat.",
    "Start with your left leg and switch legs every rep.",
]
