# Trainer content for the 401-500 folder, third round (445-474, 2026-10-05),
# family: legraise. Five leg raises and kicks from the builder's exports: 445
# Toe-to-Bar (Abs/ToeToBar), 446 Hanging Oblique Knee Raise
# (Abs/HangingObliqueKneeRaise), 447 Lying Leg Raise (Abs/LyingLegRaise),
# 448 Flutter Kick (Abs/FlutterKick) and 449 Scissor Kick (Abs/ScissorKick).
# Same format as spec.py on top of common_1_50.py; spec_500.py imports this
# module and gen.py reads SPEC / SETUP. notes_500_legraise.md maps the copy's
# claims to the sources below and records the model facts.
#
# What the models show, measured on the rigs with Blender's Python + pxr
# (SCRATCH/lab/r3/legraise/: rig.py dumps every joint every frame, m2.py /
# m3.py / m4.py / hok.py read angles, heights and sides from it, skin.py
# skins the shoe, hand and muscle meshes for heights above the mat and the
# shoes' gap to the bar; the app's Y-up space, the lifter facing +z, their
# left +x; the mat's top at y 0, the pull-up bar's axis at y 2.40 m, z 0,
# 3.5 cm thick), the briefs (written for upright lifts, so the lying angles
# are measured instead), tiers.txt and the trainer stills. One body
# (neck-to-pelvis 0.57-0.59 m), every clip 7.96 s.
# - Toe-to-Bar (yaw -1.3, seen from the front-left side): an overhand grip on
#   the bar, wrist joints 53 cm apart against shoulder joints 39 cm (a little
#   wider than the shoulders). Two identical 4 s strict reps, no kip: a still
#   hang on straight arms (elbows 177 degrees, legs straight down, the
#   ankle joints 27 cm apart, not together) to ~0.1 s and again ~3.5-4.1 s
#   (~0.6 s); the legs rise ~0.1-1.5 s (~1.4 s), held
#   ~1.5-2.0 s (~0.5 s), lowered ~2.0-3.5 s (~1.5 s). At the top the shoes'
#   toes are level with the bar (their top 2.40 m against the bar's axis at
#   2.40) and 2.3 cm in front of its surface, between the hands (x -0.10 m
#   against the hands at +-0.27); they do not quite touch it. The knees stay
#   nearly straight: 176 hanging, 173 at the top, never under 158 (mid
#   swing). The hips fold from 172 to 44 degrees (trunk-to-thigh), the body
#   tips back 37 degrees under the bar (neck behind the pelvis), the pelvis
#   rises 17 cm, the spine rounds ~22 degrees more than in the hang (the
#   pelvis bone turns 36 degrees against the chest, 14 hanging), the arms
#   press down (the upper arm closes on the trunk from 171 to 132 degrees,
#   the elbows soften to 159-160, the shoulder joints rise ~5 cm).
#   Paint: rectus abdominis and the Sartorius mesh (the rig's hip flexors)
#   bright; dim: the forearm flexors and extensors and brachioradialis, the
#   latissimus dorsi, posterior deltoid, rotator cuff (infraspinatus,
#   supraspinatus, subscapularis, teres minor), the three trapezius parts,
#   rhomboid major and the external and internal obliques.
# - Hanging Oblique Knee Raise (yaw -0.5, three-quarter from the
#   front-left): the same bar and grip, the arms straight (177 degrees) all
#   clip, the shoulder line never turning. Rep 1 (0-4 s) the knees bend and
#   rise toward the lifter's LEFT; rep 2 (4-8 s) toward the RIGHT. Still hang
#   to ~0.1 s, up ~0.1-1.5 s, held ~1.5-2.0 s, down ~2.0-3.5 s, still
#   ~3.5-4.1 s. At the top: knees 80 degrees, hips 84, the thighs 18 degrees
#   above level, the knees pointing 20 degrees off to the side, the pelvis
#   turned 20 degrees toward that side under square shoulders, its hip on
#   that side 7 degrees higher, shifted 5 cm toward it, the spine rounded
#   ~13 degrees more than hanging. Paint: external and internal obliques,
#   rectus abdominis and the Sartorius mesh bright; the arms and back
#   (biceps, forearms, posterior deltoid, rotator cuff, latissimus dorsi,
#   trapezius, rhomboid major) only faint.
# - Lying Leg Raise (yaw -1.35, side-on from the left): face up on a mat,
#   head toward -z, arms by the sides, palms down, the head, shoulders,
#   buttocks and hands on the mat; the trunk and pelvis never move (the
#   lumbar muscle surface 3.3 cm above the mat all clip). Legs straight
#   (180), ankles 27 cm apart (hip joints 18 cm), toes pointed (ankle ~140).
#   Two 4 s reps: the legs rise from just above the mat (the hip-to-ankle
#   line 1.5 degrees below the hip, the shoes 4.6 cm off the mat) ~0.1-1.45
#   s to 86 degrees (4 short of vertical, hips 97), hold ~1.45-1.95 s,
#   lower ~2.0-3.6 s (~1.6 s), then hover ~3.6-4.1 s with the heels ~5 cm
#   up; they never touch down. Paint: rectus abdominis and the Sartorius
#   mesh bright, the obliques dim.
# - Flutter Kick (yaw -0.8, three-quarter from the front-left): the same
#   lying set-up, trunk, arms and head as the lying leg raise. Legs straight,
#   toes pointed, kicking alternately in the lifter's own front-back plane
#   (no sideways move): each leg between 5 and 27 degrees above the floor
#   (the shoes' lowest point 14-47 cm off the mat), opposite to the other,
#   crossing level at 16 degrees; one kick of each leg every 1.33 s (left
#   highest at 0.33, 1.67, 3.0 ... s, right at 1.0, 2.33 ... s), six per leg
#   in the clip, no pause. The heels never touch. Paint as the lying leg
#   raise.
# - Scissor Kick (yaw -0.8): the same lying set-up. The over-under scissor:
#   the straight legs open sideways (ankles 67 cm apart, each leg ~18
#   degrees out from straight ahead, both 15 degrees up) and sweep in until
#   they cross, LEFT over RIGHT at 0.67 s (the feet overlapping ~4 cm
#   sideways, the top ankle 17 cm higher: the top leg 21 degrees up, the
#   under leg 9; each leg 4 degrees past straight ahead, so the ankle joints
#   meet at the midline, 3.3 cm either side of it, without passing it), open again at 1.33 s, cross RIGHT over LEFT at 2.0 s, and
#   so on: one cross every 1.33 s, six in the clip, the top leg swapping each
#   time. The legs stay 9-21 degrees above the floor (the shoes' lowest
#   point ~20-38 cm up); the heels never touch. Paint: rectus abdominis and
#   the Sartorius mesh bright; dim: the obliques and adductor longus,
#   adductor magnus and gracilis.
#
# How they differ from the library: the Hanging Leg Raise lifts straight legs
# to about level and the Hanging Knee Raise bent knees straight up the
# middle; the Toe-to-Bar takes straight legs all the way to the bar with the
# pelvis curling and the body tipping back, and the oblique knee raise takes
# the knees to alternate sides. The Captain's Chair Leg Raise is supported on
# the forearms against a back pad. The Reverse Crunch curls the hips off the
# floor with bent knees; the Lying Leg Raise keeps the pelvis still and lifts
# straight legs from the hips. The round-2 Hollow Body Hold holds the legs
# still and the Dead Bug moves one leg with the opposite arm; the kicks move
# both legs nonstop.
#
# Sources (abstracts read on Europe PMC 2026-10-05, full text where noted;
# ExRx through the Wayback Machine, the live site returns 403; web pages read
# 2026-10-05; what each supports is in the notes):
# - ExRx.net: Hanging Straight Leg-Hip Raise
#   (RectusAbdominis/BWHangingStraightLegHipRaise, snapshot 2023-06-07: also
#   known as Toes-to-Bar or Strict Toes-to-Bar; raise the legs by flexing the
#   hips, then raise the feet toward the bar by flexing the waist; attempt to
#   decrease shoulder flexion during the movement; the abs only shorten if the
#   waist flexes, otherwise they hold the pelvis and waist; easier with bent
#   knees; target rectus abdominis, synergists iliopsoas, tensor fasciae
#   latae, sartorius, pectineus, adductor longus and brevis, rectus femoris,
#   obliques, quadriceps); Hanging Straight Leg Raise
#   (HipFlexors/BWHangingStraightLegRaise, 2026-06-25: slightly wider than
#   shoulder-width overhand grip; knees flex to make it easier); Hanging
#   Twisting Leg Raise (Obliques/BWHangingTwistingLegRaise, 2025-01-22: also
#   known as the hanging twisting knee raise; shoulder-width or slightly
#   wider overhand grip; raise the legs to one side, hips and knees flexing,
#   until the hips are fully flexed or the knees well above the hips, then
#   the other side, alternating; target obliques, largely worked
#   isometrically); Hanging Twisting Leg Hip Raise
#   (Obliques/BWHangingTwistingLegHipRaise, 2024-01-05: easier with the
#   knees only just above the hips and little spinal flexion); Lying
#   Straight Leg Raise (HipFlexors/BWStraightLegRaise, 2023-05-31: knees
#   straight, raise the legs until the hips are fully flexed; easier with
#   the knees bent or the heels touching each rep; said of a lying
#   leg-hip raise, beyond vertical the legs no longer load the waist and
#   hip flexors; target iliopsoas, rectus abdominis and obliques
#   stabilisers, quadriceps stabilisers); Lying Leg
#   Raise on the floor (HipFlexors/BWLyingLegRaiseFloor, 2022-09-30, a
#   bent-knee raise: easier letting the heels touch the floor each rep,
#   harder not letting them); Lying Scissor Kick (HipFlexors/BWScissorKick,
#   2023-05-31, the up-and-down kind, one leg lowered as the other rises: a
#   very short range, so isometric-like endurance; slightly easier letting
#   alternate heels touch the floor; harder with ankle weights; also see
#   the over/under variation; target iliopsoas, synergists tensor fasciae
#   latae, sartorius, pectineus, rectus femoris, adductor longus and adductor brevis,
#   stabilisers rectus abdominis, obliques, quadriceps); Lying Simultaneous
#   Alternating Straight Leg Raise (HipFlexors/BWSimAltStraightLegRaise,
#   2021-04-20: easier with the knees bent); the muscle pages Obliques
#   (Muscles/Obliques, 2026-02-02: lumbar flexion, rotation and lateral
#   flexion), Adductors (Muscles/Adductors, 2026-05-20: inner thigh; hip
#   adduction), Iliopsoas (Muscles/Iliopsoas, 2024-01-05: hip flexion).
# - CrossFit Games, Workout 15.1 movement standards
#   (games.crossfit.com/workouts/open/2015): the toes-to-bar goes from a
#   full hang to the toes touching the bar, both feet at once, inside the
#   hands; the hanging knee raise ends when the knees are above hip height.
# - Catalyst Athletics exercise library (catalystathletics.com, read
#   2026-10-05): Hanging Leg Raise (exercise 45: straight legs up until the
#   toes reach the bar without swinging, the abs curling the pelvis up as in
#   a crunch so it is not simply hip flexion; return under control; on a
#   pull-up bar control the speed to minimise swinging; scale by bending the
#   knees), Knees to Elbows (490: the more accessible variation), Flutter
#   Kick (567: lower back pressed into the floor, straight legs, both heels
#   off the floor, a short range; a low-intensity hip flexor exercise that
#   trains the abs to hold the pelvis and back still; 20-100 reps or 20-60
#   s), Alternating Lying Leg Raise (563: lower back pressed into the floor,
#   the heel not touching the floor at the bottom).
# - Weiss B, Vieux M, Ewart T, What Are Toes-to-Bar?, Invictus blog,
#   2023-02-06 (invictusfitness.com/blog/what-are-toes-to-bar): the strict
#   toes-to-bar keeps the lats engaged pressing down on the bar, tucks the
#   pelvis and uses the lower abs; always keep an active hang, space between
#   the ears and shoulders.
# - McGill S, Andersen J, Cannon J 2015, J Sports Sci 33(4):419-426,
#   doi:10.1080/02640414.2014.946437, PMID 25111163 - 14 men: the hanging
#   straight leg raise gave the highest abdominal challenge of the three
#   whole-body exercises tested (rectus abdominis over 130% MVC, external
#   oblique 88%) with ~3000 N of spine compression.
# - Escamilla RF, Babb E, DeWitt R, et al. 2006, Phys Ther 86(5):656-671,
#   doi:10.1093/ptj/86.5.656, PMID 16649890 - 21 adults: the hanging knee-up
#   with straps among the highest for the rectus abdominis, both obliques
#   and the latissimus dorsi.
# - Andersson EA, Nilsson J, Ma Z, Thorstensson A 1997, Eur J Appl Physiol
#   Occup Physiol 75(2):115-123, doi:10.1007/s004210050135, PMID 9118976 - 6
#   men: the hip flexors highly active only when the hips flex; bilateral,
#   not unilateral, leg lifts needed the abdominals; bilateral leg lifts drew
#   more iliacus and sartorius activity than hip-flexion sit-ups.
# - Mandroukas A, Michailidis Y, Kyranoudis AE, Christoulas K, Metaxas T
#   2022, J Funct Morphol Kinesiol 7(3):67, doi:10.3390/jfmk7030067, PMID
#   36135425 (PMC9505236, full text) - 35 male students lying flat: during
#   straight legs moved alternately up and down (the authors' scissors) the
#   lower rectus abdominis was more active than the upper and the external
#   oblique; leg movements from long lying drew more rectus abdominis than
#   external oblique; the authors: the hip flexors (iliopsoas, rectus
#   femoris, sartorius) move the legs, their pull increases the lumbar
#   lordosis while the abs act statically to hold the pelvis.
# - Juan J, Leff G, Kevorken K, Jeanfavre M 2024, J Clin Med 13(21):6617,
#   doi:10.3390/jcm13216617, PMID 39518756 - review of 9 EMG studies: the
#   iliopsoas over 60% MVIC in the active straight leg raise around 60
#   degrees of hip flexion and in supine hip flexion and leg lifts.
# - Lindberg S (medically reviewed by Bubnis D), How to do scissor kicks,
#   Healthline, 2019-05-01 (healthline.com/health/scissor-kicks): keep the
#   motion rhythmic and controlled, not fast (used for one tempo sentence).
# No EMG study of these five exact lifts was found, so every fraction below
# is a judgement call anchored on the library's Hanging Leg Raise (hip
# flexors 0.86, rectus abdominis 0.84, obliques 0.62, forearms 0.40,
# latissimus dorsi 0.25), Hanging Knee Raise (0.80 / 0.76 / 0.64) and
# Reverse Crunch (rectus abdominis 0.82, obliques 0.58, hip flexors 0.42)
# and round 2's Hollow Body Hold, ordered by the studies above (see notes).
from common_1_50 import *


def ov(final):
    """Pre-squeeze override row for an on-screen row (spec_500.row() maps
    0.14-0.86 to 0.16-0.80)."""
    return round(0.14 + (final - 0.16) * (0.86 - 0.14) / (0.80 - 0.16), 4)


def hanging(name, abs_dx=0.0, abs_dy=0.0):
    """The abdominals between the pelvis and chest (bright), a soft halo
    at the front of the hip for the hip flexors."""
    return [glow(name, ["spine", "chest"], A, 0.55, 0.05, 0.06, abs_dx, abs_dy),
            glow(name, ["pelvis", "thigh_L"], SOFT, 0.30, 0.05, 0.05, abs_dx, abs_dy + 0.02)]


def lying(name, abs_dx=0.0, hip_dx=0.0):
    """Face up: the abdominals over the trunk (bright) and the front of the
    hips (the hip flexors, bright), as the stability family draws them."""
    return [glow(name, ["spine", "chest"], A, 0.55, 0.08, 0.04, abs_dx, -0.015),
            glow(name, ["pelvis", "thigh_L"], A, 0.40, 0.05, 0.035, hip_dx, -0.01)]


# ---------------------------------------------------------------- Toe-to-Bar

N = "Toe-to-Bar"
ex(name=N, var="toeToBar",
   overrides={"hang": (ov(0.12), "leading"), "lower": (ov(0.18), "leading"), "pelvis": (ov(0.62), "trailing"),
              "legs": (ov(0.78), "trailing"), "toes": (ov(0.80), "leading")},
   annotations=[
       ("hang", "Press the bar down", "hand_R"),
       ("toes", "Toes to bar", "toe_R"),
       ("legs", "Legs long", "shin_R"),
       ("pelvis", "Curl hips up", "spine"),
       ("lower", "Lower slowly", "foot_R"),
   ],
   cues={
       "hang": ("Active Hang",
                "Start from a still hang on straight arms, then press the bar down toward your hips as the legs rise.",
                "ExRx's note for this lift, which it also calls the strict toes-to-bar, is to try to decrease shoulder flexion as you go, that is, to bring the arms down toward the body, and Invictus coaches the strict version with the lats engaged, pressing down on the bar. Here the arms close on the trunk by about 40 degrees and the body tips back under the bar as the legs come up.",
                "Hanging loose from the shoulders, the body sinking between them with the shoulders up by the ears.",
                "Pull the shoulders down away from the ears before the first rep and keep pressing the bar toward your hips as you lift."),
       "toes": ("Toes to the Bar",
                "Lift both feet at once until your toes reach the bar between your hands.",
                "That is the finish of the rep: CrossFit's standard has both feet meet the bar at the same time, inside the hands, from a full hang, and Catalyst Athletics lifts the straight legs until the toes reach the bar. Here the toes come level with the bar, about 2 cm in front of it, and pause there for about half a second.",
                "Stopping with the feet around head height, well short of the bar.",
                "Keep lifting until your toes are at the bar between your hands, pause for a moment, then lower."),
       "legs": ("Straight Legs",
                "Keep your legs long, knees close to straight, from the hang to the bar.",
                "Long legs make this the harder version: ExRx and Catalyst Athletics both make it easier by bending the knees, and Catalyst calls the bent-knee version, knees to elbows, the more accessible one. Here the knees stay within about 20 degrees of straight all the way up.",
                "Bending the knees and tucking them toward the chest, so the feet stay well short of the bar.",
                "Lift with the legs nearly straight and side by side, and let the hips fold rather than the knees."),
       "pelvis": ("Pelvic Curl",
                  "Curl the pelvis up toward your ribs as the legs rise, so the lower back rounds and carries the feet to the bar.",
                  "ExRx describes the lift as a hip raise that finishes with the waist flexing to bring the feet to the bar, and notes the abs only shorten if the waist actually flexes; Catalyst Athletics curls the pelvis up as in a crunch so the lift is not just hip flexion. Here the lower back rounds steadily as the legs rise. In an EMG study of 14 men the hanging straight-leg raise was the hardest of the three exercises tested for the abdominal wall.",
                  "Raising the legs with the lower back still arched, so they stall short of the bar.",
                  "Keep rolling the pelvis up and rounding the lower back as the legs rise, until the toes reach the bar."),
       "lower": ("Lowering",
                 "Lower the legs over about a second and a half and come to a still hang before the next rep.",
                 "Catalyst Athletics returns the legs under control and, on a pull-up bar, controls the speed to keep swinging to a minimum. Dropping the legs sends them swinging back past the bar, and that swing can throw the next rep up for you, which the kipping version does on purpose. This strict version starts every rep from a still hang, here about half a second long.",
                 "Dropping the legs so they swing back behind you and bounce into the next rep.",
                 "Lower at about the speed you lifted, stop the legs under the bar and start each rep from a still hang."),
   },
   # Paint: rectus abdominis and hip flexors bright (PRIMARY); obliques,
   # forearms, latissimus dorsi, posterior deltoid, rotator cuff, trapezius
   # and rhomboids dim. Judgement calls on the library's Hanging Leg Raise
   # (hip flexors 0.86, rectus abdominis 0.84, obliques 0.62, forearms 0.40,
   # latissimus dorsi 0.25), which lifts straight legs to about level:
   # Rectus Abdominis 0.88, above it, because the feet go on to the bar with
   # the waist flexing (ExRx: the abs only shorten if the waist flexes;
   # McGill 2015: the hanging straight leg raise drew over 130% MVC from the
   # rectus abdominis); Hip Flexors 0.86 as there (ExRx's synergists:
   # iliopsoas, rectus femoris, sartorius); Obliques 0.62 as there (dim;
   # McGill 2015: external oblique 88% MVC, but the paint keeps them
   # secondary); Forearms 0.42 (the whole body hangs from the grip, as
   # there); Latissimus Dorsi 0.35, above the library's 0.25 because the
   # arms press the bar down here (the upper arm closes on the trunk from 171
   # to 132 degrees; Invictus: lats engaged pressing down; Escamilla 2006:
   # lat EMG among the highest in the hanging knee-up). The posterior
   # deltoid, rotator cuff, trapezius and rhomboids go to the stabilisers
   # (legend width, as the library's hanging raises do).
   activation=[("Rectus Abdominis", P, HI, 0.88), ("Hip Flexors", P, HI, 0.86), ("Obliques", S, MOD, 0.62),
               ("Forearms", S, MOD, 0.42), ("Latissimus Dorsi", S, LOW, 0.35)],
   stabilisers=["posterior deltoid", "rotator cuff", "trapezius", "rhomboids", "quadriceps"],
   comparison=("FEET SHORT OF THE BAR", "Toes reach the bar", "Feet stop at head height",
               "Curling the pelvis as the legs rise carries the straight legs up to the bar, and ExRx says the abs only shorten when the waist flexes like this.",
               "Stopping at head height cuts the rep off before the waist has finished flexing, the part of the lift that shortens the abs."),
   glows=hanging(N))

SETUP[N] = [
    "Take an overhand grip on the bar, hands a little wider than your shoulders.",
    "Hang with straight arms, your feet off the floor and your legs straight below you.",
    "Pull your shoulders down away from your ears and wait until your body hangs still.",
]

# ---------------------------------------------------------------- Hanging Oblique Knee Raise

N = "Hanging Oblique Knee Raise"
ex(name=N, var="hangingObliqueKneeRaise",
   overrides={"hang": (ov(0.22), "trailing"), "side": (ov(0.44), "trailing"), "height": (ov(0.30), "leading"),
              "swing": (ov(0.66), "trailing"), "switch": (ov(0.84), "leading")},
   annotations=[
       ("hang", "Shoulders down", "upper_arm_L"),
       ("side", "Knees to one side", "patella_L"),
       ("height", "Knees up high", "patella_R"),
       ("swing", "No swinging", "foot_L"),
       ("switch", "Left, then right", "foot_R"),
   ],
   cues={
       "hang": ("Active Hang",
                "Hang on straight arms with the shoulders pulled down, and keep the arms straight all set.",
                "The arms only hold you here: the elbows stay straight, at about 177 degrees, through every rep and the shoulders stay square to the bar. Invictus's toes-to-bar guide asks for an active hang from the moment you take the bar, space between the ears and shoulders, which it says gives you tension through the body and control over your swing.",
                "Hanging loose from the shoulders, the body sinking with the shoulders up by the ears.",
                "Grip a little wider than your shoulders, draw the shoulders down and keep the arms long while the knees move."),
       "side": ("Knees to the Side",
                "Draw the knees up and across toward one side: the left on the first rep, the right on the next.",
                "ExRx files the hanging twisting knee raise under the obliques, the muscles that turn and side-bend the waist, and lifting the knees to one side turns and tilts the pelvis under the ribs. Here the knees point about 20 degrees off to the side at the top, the pelvis turned about 20 degrees toward it and that hip about 7 degrees higher, while the shoulders stay square.",
                "Lifting the knees straight up the middle, which turns it into a plain hanging knee raise.",
                "Aim the knees toward the outside of one hip as they rise, keep the chest facing forward, then lower and switch sides."),
       "height": ("Height",
                  "Lift until your knees are above your hips, the thighs a little past level.",
                  "ExRx raises the knees until the hips are fully flexed or the knees well above the hips, and CrossFit's hanging knee raise is not finished until the knees pass hip height. Here the thighs finish about 18 degrees above level with the knees bent a little past a right angle.",
                  "Stopping with the thighs still below level.",
                  "Keep the knees bent and lift them past hip height on every rep before you lower."),
       "swing": ("Control",
                 "Lower the knees under control and let the body settle between reps.",
                 "Catalyst Athletics raises the knees without swinging and, on a pull-up bar, controls the speed to keep swinging to a minimum. Kicking the legs back at the bottom builds a swing that throws the next rep up for you. Here each rep takes about a second and a half to lower and pauses for about half a second.",
                 "Letting the legs swing back behind you at the bottom and riding the swing into the next rep.",
                 "Lower over about a second and a half, stop the legs under you and start the next side from a still hang."),
       "switch": ("Alternate Sides",
                  "Work the sides in turn: left, then right.",
                  "ExRx alternates the sides rep by rep, and equal reps each way give both sides of the waist the same work. The model alternates too: the knees go to the left from 0 to 4 seconds, then to the right.",
                  "Doing every rep to the same side, or drifting toward one side as you tire.",
                  "Alternate every rep and finish each set with the same number of reps to each side."),
   },
   # Paint: external and internal obliques, rectus abdominis and hip flexors
   # bright (PRIMARY); the arms and back only faint (the calfstand family's
   # rule for faint paint: LOW rows for the forearms and latissimus dorsi,
   # the rest with the stabilisers). Judgement calls on the library's Hanging
   # Knee Raise (rectus abdominis 0.80, hip flexors 0.76, obliques 0.64),
   # which raises the knees straight up: Obliques 0.76, now primary (ExRx's
   # target for the twisting knee raise; Escamilla 2006: both obliques among
   # the highest in the hanging knee-up), Rectus Abdominis 0.74 and Hip
   # Flexors 0.72, a little under the straight knee raise because the knees
   # rise only to about 18 degrees above level and to one side (ExRx lists
   # the rectus abdominis as a stabiliser of the twisting knee raise);
   # Forearms 0.30 and Latissimus Dorsi 0.18, under the library's 0.40 and
   # 0.25 because they are only faint here and the arms barely press (the
   # upper arm closes on the trunk ~10 degrees, the Toe-to-Bar's ~40).
   activation=[("Obliques", P, HI, 0.76), ("Rectus Abdominis", P, HI, 0.74), ("Hip Flexors", P, HI, 0.72),
               ("Forearms", S, LOW, 0.30), ("Latissimus Dorsi", S, LOW, 0.18)],
   stabilisers=["posterior deltoid", "rotator cuff", "trapezius", "rhomboids", "biceps"],
   comparison=("KNEES UP THE MIDDLE", "Knees rise to one side", "Knees rise straight up",
               "Taking the knees to one side turns and tilts the pelvis under square shoulders; ExRx makes the obliques this raise's target.",
               "Straight up the middle it becomes a plain hanging knee raise and the twist at the waist is lost."),
   glows=[glow(N, ["spine", "chest"], A, 0.55, 0.07, 0.06, 0.0, 0.0),
          glow(N, ["pelvis", "thigh_L"], SOFT, 0.30, 0.06, 0.05, 0.0, 0.02)])

SETUP[N] = [
    "Grip the bar overhand, hands a little wider than shoulder-width.",
    "Hang with straight arms and your legs straight below you, shoulders drawn down.",
    "Let your body hang still, then lift the knees toward your left side first.",
]

# ---------------------------------------------------------------- Lying Leg Raise

N = "Lying Leg Raise"
ex(name=N, var="lyingLegRaise",
   overrides={"top": (ov(0.18), "leading"), "lower": (ov(0.30), "trailing"), "legs": (ov(0.40), "trailing"),
              "back": (ov(0.72), "leading"), "head": (ov(0.72), "trailing")},
   annotations=[
       ("back", "Low back stays down", "spine"),
       ("legs", "Knees straight", "patella_L"),
       ("top", "Legs to vertical", "toe_L"),
       ("head", "Head stays down", "head"),
       ("lower", "Lower slowly", "foot_L"),
   ],
   cues={
       "back": ("Lower Back",
                "Keep your lower back on the mat the whole time; only the legs move.",
                "Lifting the legs is hip flexion. ExRx notes that without waist flexion the rectus abdominis and external oblique only hold the pelvis and waist steady, and the authors of one EMG study describe the hip flexors' pull tending to arch the lower back while the abs hold the pelvis. Here the pelvis and lower back do not move at all.",
                "The lower back arching off the mat as the legs come down low.",
                "Brace before each rep, keep the lower back down on the mat and lower the legs only as far as you can keep it there."),
       "legs": ("Straight Legs",
                "The knees stay straight from the bottom to the top.",
                "Straight legs make a long lever for the hip flexors to lift and for the abs to steady the pelvis against. ExRx's easier version of this raise bends the knees along with the hips.",
                "Bending the knees as the legs rise to make the lift easier.",
                "Keep the knees straight, the legs about hip-width apart and the toes pointed as you raise and lower."),
       "top": ("Top Position",
               "Raise the legs until they point almost straight up.",
               "ExRx raises the straight legs until the hips are fully flexed, and notes that lying down, legs taken past vertical stop loading the waist and hip flexors. Here they stop about 4 degrees short of vertical and pause for about half a second.",
               "Turning back down with the legs only halfway up.",
               "Lift until your feet are over your hips, hold for a moment, then lower."),
       "head": ("Head and Shoulders",
                "Rest your head and shoulders on the mat for the whole set.",
                "The legs rise at the hips, so lifting the head does not help them up; it only bends the neck and upper back. Here the head, shoulders and arms stay down from the first rep to the last.",
                "Lifting the head and shoulders and straining the neck as the legs go up.",
                "Keep the back of your head on the mat, the chin slightly tucked and the arms resting beside you."),
       "lower": ("Lowering",
                 "Lower the legs a little slower than you raised them and stop with the heels just above the mat.",
                 "ExRx makes its lying leg raises easier by letting the heels touch the floor each rep and harder by not letting them. Here the heels hover about 5 cm off the mat between reps, and the legs take about 1.6 seconds to come down against about 1.4 to go up.",
                 "Dropping the legs so the heels thump into the mat.",
                 "Lower under control and hold the heels just off the mat before the next rep."),
   },
   # Paint: rectus abdominis and hip flexors bright (PRIMARY), obliques dim.
   # Judgement calls: Hip Flexors 0.84, the movers (ExRx's target, the
   # iliopsoas; Andersson 1997: bilateral leg lifts drew more iliacus and
   # sartorius activity than hip-flexion sit-ups; Juan 2024: iliopsoas over
   # 60% MVIC in leg lifts), close to the library's Hanging Leg Raise (0.86);
   # Rectus Abdominis 0.72, holding the pelvis (ExRx: a stabiliser with no
   # waist flexion; Andersson 1997: bilateral leg lifts need the abdominals;
   # Mandroukas 2022: the rectus more active than the external oblique),
   # under the Crunch's 0.80 and the Reverse Crunch's 0.82, which curl the
   # spine; Obliques 0.45 (dim; Mandroukas 2022), a little under the Reverse
   # Crunch's 0.58.
   activation=[("Hip Flexors", P, HI, 0.84), ("Rectus Abdominis", P, HI, 0.72), ("Obliques", S, MOD, 0.45)],
   stabilisers=["transverse abdominis", "quadriceps"],
   comparison=("BACK ARCHING", "Lower back stays down", "Back arches as legs lower",
               "With the lower back held on the mat, the abs keep the pelvis still while the hip flexors move the legs.",
               "When the lower back arches, the abs have stopped holding the pelvis against the hip flexors' pull."),
   glows=lying(N))

SETUP[N] = [
    "Lie on your back on a mat, legs straight and about hip-width apart.",
    "Rest your arms beside you, palms down, and your head on the mat.",
    "Brace your abs and lift your heels just off the mat.",
]

# ---------------------------------------------------------------- Flutter Kick

N = "Flutter Kick"
ex(name=N, var="flutterKick",
   overrides={"range": (ov(0.26), "leading"), "knees": (ov(0.26), "trailing"), "tempo": (ov(0.36), "trailing"),
              "heels": (ov(0.70), "leading"), "back": (ov(0.70), "trailing")},
   annotations=[
       ("back", "Low back stays down", "spine"),
       ("knees", "Knees straight", "patella_L"),
       ("range", "Small kicks", "toe_R"),
       ("heels", "Heels never touch", "foot_L"),
       ("tempo", "Steady rhythm", "thigh_L"),
   ],
   cues={
       "back": ("Lower Back",
                "Keep your lower back pressed into the mat while the legs kick.",
                "Catalyst Athletics calls flutter kicks a hip flexor exercise that trains the abs to hold the pelvis and back still, the lower back pressed into the floor. In an EMG study of 35 male students moving straight legs alternately up and down while lying flat, the lower part of the rectus abdominis showed more activity than its upper part and the external oblique.",
                "The lower back arching up off the mat as the legs flutter.",
                "Brace before you start, keep the back flat and kick a little higher if it starts to lift."),
       "knees": ("Straight Legs",
                 "Kick from the hips with the knees straight.",
                 "Catalyst Athletics lifts straight legs for this, and ExRx's easier version of its alternating straight-leg raises bends the knees. Here both knees stay straight and the toes pointed through every kick.",
                 "Bending the knees and pedalling the feet instead of kicking from the hips.",
                 "Keep the knees straight and the toes pointed, and let each leg move as one piece at the hip."),
       "range": ("Kick Size",
                 "Keep the kicks small and low: each heel travels only about 30 cm between its low and high points.",
                 "Catalyst Athletics keeps the range short, and ExRx notes that its scissor kick's very short range calls for more isometric-like endurance. Here each leg moves between about 5 and 27 degrees above the floor, the heels between about 14 and 47 cm up.",
                 "Swinging the top leg up high toward vertical on each kick.",
                 "Keep both legs low and move them only a short way up and down, one up as the other goes down."),
       "heels": ("Heels Up",
                 "Neither heel touches the mat until the set is over.",
                 "Catalyst Athletics keeps both heels off the floor, and ExRx makes its scissor kick slightly easier by letting alternate heels touch down each rep. Here the lower heel never comes closer than about 14 cm to the mat.",
                 "Letting the lower heel tap the mat between kicks.",
                 "Keep the lower leg just off the mat on every kick; if you cannot, kick a little higher."),
       "tempo": ("Rhythm",
                 "Kick at an even pace you can keep for the whole set.",
                 "Catalyst Athletics programs flutter kicks as sets of 20 to 100 reps or 20 to 60 seconds of work. Here the legs swap about every 0.7 seconds without a pause, each leg kicking up once every 1.3 seconds.",
                 "Racing the kicks until the legs drift up and the back lifts.",
                 "Pick a pace you can hold, breathe steadily and end the set when the back starts to arch."),
   },
   # Paint as the Lying Leg Raise. Judgement calls: Hip Flexors 0.78, holding
   # both legs off the floor nonstop with short kicks (Catalyst: a
   # low-intensity hip flexor exercise; ExRx: the iliopsoas the target of
   # its alternating straight-leg raises), under the Lying Leg Raise's 0.84,
   # which lifts the legs through a full range; Rectus Abdominis 0.74
   # (Mandroukas 2022: in alternate up-and-down leg movements the lower
   # rectus was more active than the upper and the external oblique;
   # Andersson 1997: lifts with both legs off the floor need the
   # abdominals); Obliques 0.45 as the Lying Leg Raise (dim).
   activation=[("Hip Flexors", P, HI, 0.78), ("Rectus Abdominis", P, HI, 0.74), ("Obliques", S, MOD, 0.45)],
   stabilisers=["transverse abdominis", "quadriceps"],
   comparison=("BACK ARCHING", "Back flat, legs low", "Back arches off the mat",
               "With the lower back pressed down, the abs hold the pelvis still while the hip flexors keep the legs moving.",
               "Once the back arches, the abs have let the hip flexors tip the pelvis and arch the lower back."),
   glows=lying(N))

SETUP[N] = [
    "Lie on your back on a mat with your legs straight, about hip-width apart.",
    "Rest your arms by your sides, palms down, with your head on the mat.",
    "Press your lower back into the mat and lift both heels off it.",
    "Point your toes and start kicking, one leg up as the other goes down.",
]

# ---------------------------------------------------------------- Scissor Kick

N = "Scissor Kick"
ex(name=N, var="scissorKick",
   overrides={"cross": (ov(0.26), "leading"), "knees": (ov(0.26), "trailing"), "tempo": (ov(0.36), "trailing"),
              "heels": (ov(0.70), "leading"), "back": (ov(0.70), "trailing")},
   annotations=[
       ("cross", "Cross, swap the top leg", "toe_L"),
       ("back", "Low back stays down", "spine"),
       ("knees", "Knees straight", "patella_L"),
       ("heels", "Heels off the mat", "foot_R"),
       ("tempo", "Steady rhythm", "thigh_L"),
   ],
   cues={
       "cross": ("Cross Over",
                 "Sweep the legs in until one foot passes just over the other, then open them and bring them in with the other leg on top.",
                 "This is the over-under version that ExRx points to from its own scissor kick. Drawing the legs in toward the midline is hip adduction, which ExRx gives as the movement of the adductors, the inner-thigh muscles. Here the feet meet at the middle and overlap by a few centimetres, the left leg on top, then the right, one cross every 1.3 seconds.",
                 "Turning back with the feet still apart instead of bringing one over the other.",
                 "Bring the legs in until the feet overlap, the top leg a little higher, and swap the top leg every time."),
       "back": ("Lower Back",
                "Your lower back stays flat on the mat while the legs open and cross.",
                "ExRx notes that without waist flexion the abs only hold the pelvis and waist steady while the hip flexors keep the legs up, and that its own scissor kick's very short range calls for isometric-like endurance. The model's pelvis and lower back stay still all set.",
                "The lower back arching off the mat as the legs sweep in and out.",
                "Brace before you lift the legs, keep the back flat and raise the legs a little if it starts to arch."),
       "knees": ("Straight Legs",
                 "Move each leg as one long piece from the hip.",
                 "Straight knees keep the legs a long lever for the hip flexors and abs to hold up, and ExRx's easier versions of its lying leg raises bend the knees. Here the knees stay straight and the toes pointed all set.",
                 "Bending the knees so the feet pedal rather than the legs sweeping.",
                 "Keep the knees straight and the toes pointed as the legs open and cross."),
       "heels": ("Legs Low, Heels Up",
                 "Keep the legs low but never let a heel touch the mat.",
                 "ExRx makes its own up-and-down scissor kick slightly easier by letting alternate heels touch the floor each rep. Here the legs stay between about 9 and 21 degrees above the floor, the lower heel at least about 20 cm up.",
                 "Letting the lower leg drop to the mat as the legs cross.",
                 "Keep both heels off the mat as they cross, the under leg just below the top one."),
       "tempo": ("Rhythm",
                 "Open and cross at an even pace you can hold for the whole set.",
                 "Healthline's scissor kick guide, written for the up-and-down kind, asks for a rhythmic, controlled motion rather than a fast one. The model crosses every 1.3 seconds without stopping, the legs never resting in between.",
                 "Rushing the crosses until the legs flail and the back lifts.",
                 "Pick a steady pace, breathe and keep every cross as wide and as low as the first."),
   },
   # Paint: rectus abdominis and hip flexors bright (PRIMARY); obliques and
   # adductor longus, adductor magnus and gracilis dim (SECONDARY). Judgement
   # calls: Hip Flexors 0.78 and Rectus Abdominis 0.72, as the Flutter Kick
   # less a little for the rectus, since the legs move mostly sideways and
   # stay at about the same height (ExRx's own scissor kick: target
   # iliopsoas, rectus abdominis and obliques stabilisers); Obliques 0.45 as
   # the other floor raises; Adductors 0.45, the dim adductors that draw the
   # legs in to the midline (ExRx Adductors: hip adduction). ExRx also lists
   # adductor longus and brevis as synergists of its up-and-down scissor
   # kick, but it lists them for its other lying hip flexor raises too (its
   # Adductors page gives them initial hip flexion), so that list says
   # nothing about the sideways sweep.
   activation=[("Hip Flexors", P, HI, 0.78), ("Rectus Abdominis", P, HI, 0.72), ("Obliques", S, MOD, 0.45),
               ("Adductors", S, MOD, 0.45)],
   stabilisers=["transverse abdominis", "gluteus medius", "quadriceps"],
   comparison=("FEET NOT CROSSING", "Legs cross over", "Feet turn back apart",
               "Bringing one foot over the other draws the legs in to the midline, the adductors' work in this kick.",
               "Turning back with the feet apart cuts each sweep short of the over-under that sets this version apart."),
   glows=lying(N))

SETUP[N] = [
    "Lie face up on a mat with your arms beside you, palms down.",
    "Lift both straight legs a little off the mat and point your toes.",
    "Open the legs wider than your shoulders, then sweep them in until one foot passes over the other.",
]
