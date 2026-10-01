# Trainer content for the 351-400 folder (2026-09-30), family: legcurl. Six
# knee-flexion curls from the builder's 356-400 set: 369 Standing Leg Curl
# (Legs/StandingLegCurl), 370 Kneeling Leg Curl (Legs/KneelingLegCurl), 371
# Cable Standing Leg Curl (Legs/CableStandingLegCurl), 373 Swiss Ball Leg
# Curl (Legs/SwissBallLegCurl), 374 Sliding Leg Curl (Legs/SlidingLegCurl)
# and 375 Single-Leg Sliding Curl (Legs/SingleLegSlidingCurl). Same format as
# spec.py on top of common_1_50.py; spec_400.py imports this module and
# gen.py reads SPEC / SETUP. notes_400_legcurl.md maps the copy's claims to
# the sources below and records the model facts.
#
# What the models show, from the briefs (SCRATCH/briefs and
# SCRATCH/briefs_legs), the trainer stills at 0/1/2/3/5 s
# (SCRATCH/shots/view/<slug>_t*.png), tiers27.json, joints.json and the rigs,
# equipment and skinned bodies read from the USD with Blender's Python + pxr
# (SCRATCH/legcurl/eq.py, skin.py; the app's Y-up space, the lifter facing
# +z, their left +x). Every clip is 7.96 s: still to 0.38 s, the curl
# ~1.1-1.2 s (to ~1.55 s), the top held ~0.65 s (to 2.25 s), the return
# ~1.25 s (2.29-3.54 s), still at the start position to 4.38 s, then again.
# - Standing Leg Curl: the LEFT leg curls, the lifter standing on the RIGHT
#   foot on a foot platform (right knee 165°), chest on a chest pad
#   (y 1.16-1.42 m), forearms on two arm pads, hands on the handles (elbows
#   86°), trunk 8° forward and still. The left thigh hangs straight down
#   (hip 172°) and never moves; the left knee goes 173° -> 73° (the lower leg
#   ends 17° above level, the ankle 12 cm above the knee). The left knee
#   joint sits on the lever's pivot: knee 0.511 m up, z 0.000; the hinge axle
#   (outside the left leg, x 0.23-0.51) centred 0.51 m up, z 0.00. The ankle
#   roller rides behind the lower leg ~7 cm above the ankle joint and
#   ~9 cm behind it. No thigh pad is modelled (ExRx's machine has an upper
#   pad in front of the lower thigh). The plate stack rises 14 cm. With the
#   knee on the pivot, the knee torque equals the lever's torque wherever
#   the roller sits, so roller placement is about where it presses, not the
#   load.
# - Kneeling Leg Curl: the LEFT leg curls; the RIGHT knee and shin rest on a
#   horizontal kneeling pad (right knee 90°, the right foot off its back
#   end). The trunk leans 50° forward (hips 130°) with the forearms on two
#   arm pads (elbows 89°) and the hands on the handles; no chest pad. The
#   left thigh hangs straight down beside the pad; knee 173° -> 73°. The left
#   knee joint is on the pivot (knee 0.596 m, axle centre 0.595 m, both
#   z 0.00); the roller sits ~7 cm above and ~9 cm behind the ankle joint.
# - Cable Standing Leg Curl: facing a cable tower ~1 m ahead, the low pulley
#   in line with the left leg; a cuff round the LEFT ankle; the lifter
#   stands on the RIGHT foot on the floor (knee 172°), hands on the handles
#   of a support frame in front (elbows 78°), trunk 8° forward. The left
#   thigh hangs straight down; knee 155° -> 73°: every rep starts with the
#   knee ~25° short of straight (ExRx returns to a straight knee; the copy
#   follows the model), the left toes just touching the floor there. The
#   ankle stays near neutral (99°). The cable runs from the cuff forward and
#   down to the pulley: at the start it is level, ~65° to the shin and
#   ~0.34 m from the knee joint; at the top it passes ~5 cm from the knee,
#   so the cable's pull bends the knee hardest early in the curl and very
#   little at the top. The stack rises 16 cm.
# - Swiss Ball Leg Curl: supine on a mat, arms out ~35-40° from the sides on
#   the floor, palms down; both heels on top of a ~68 cm ball, ankles 26 cm
#   apart. The hips are held up the whole clip: at the start the knees are
#   164° and the hips 162°, the pelvis joint 0.35 m up and the seat of the
#   shorts 0.19 m off the floor (~11 cm above the mat); the knees curl to
#   90° as the ball rolls 40 cm toward the hips, the hips rise to 0.62 m and
#   straighten to 176°, a straight line from shoulders to knees at the top.
#   The ankles stay pointed (154° -> 142°).
# - Sliding Leg Curl: supine on a mat, arms out to the sides (~70°) with the
#   elbows bent ~75° and the palms down; both heels on sliders on the floor
#   beyond the mat. At the start the knees are 164° and the seat rests on
#   the mat (skinned shorts 5 cm up, the mat top 7 cm); as the heels slide
#   60 cm in, the knees bend to 70° and the hips lift into a bridge (pelvis
#   0.21 -> 0.47 m, the seat 0.31 m off the floor), then lower back to the
#   mat as the legs slide out. The hip bends as the pelvis lifts (176° ->
#   148° at the top): the hamstrings hold the hips up while they bend the
#   knee. The ankles go from pointed (119°) to flexed (79°) at the top.
# - Single-Leg Sliding Curl: the same with one slider under the LEFT heel;
#   the RIGHT leg is held up off the floor, knee bent 81°, the thigh pointing
#   up at 68° to the floor all clip; the left knee and hips move as in the
#   Sliding Leg Curl, the seat back on the mat at the bottom (pelvis
#   0.21 m, left knee 164°).
# - Highlight tiers: the hamstrings (biceps femoris, semitendinosus,
#   semimembranosus) bright on all six; dim: the calves (gastrocnemius, soleus)
#   on the Standing and Kneeling curls; the calves and the glutes (maximus,
#   medius, minimus) on the Swiss ball and both sliding curls; the calves and
#   glutes only faint (0.11) on the Cable Standing Leg Curl.
#
# How they differ from the library: the Lying Leg Curl (prone, both legs),
# Seated Leg Curl (hips flexed ~90°) and Single-Leg Curl (prone, left leg)
# are the other machine curls. Here the standing machine and the cable curl
# are upright with the hip almost straight, the kneeling machine holds the
# hip bent ~50°, and the three floor curls pair the knee bend with a bridge.
# Each cue set is its own: the chest pad, range, roller, knee on the pivot
# and the standing foot (standing); the forward lean, level hips, range,
# pivot and roller (kneeling); the soft start, the still trunk, the cuff,
# the hips and the thigh (cable); the heels, ribs, the held bridge, tempo
# and arms (ball); the hip drive, the soft bottom, ribs, tempo and arms
# (sliding); the held free leg, the level pelvis, tempo, arms and the full
# slide (single-leg sliding).
#
# Sources (abstracts read on Europe PMC / PubMed records 2026-09-30, full
# texts where noted; revised 2026-10-01 after review: Youdas 2015 added,
# Gulgosteren's Fig. 1B checked; details and quotes in notes_400_legcurl.md):
# - ExRx.net (read on the Wayback Machine; the live site returns 403):
#   Lever Standing Leg Curl (snapshot 2023-05-31), Lever Kneeling Leg Curl
#   (2023-12-27), Cable Standing Leg Curl (2023-03-11), Leg Curl (on ball)
#   BWBallLegCurl (2022-10-06): set-up, execution and muscle lists (target
#   hamstrings; gastrocnemius a synergist; glutes and others stabilisers;
#   dorsiflexion lets the gastrocnemius assist; standing: body weight on
#   the resting foot, pull the lever up to the back of the thigh; cable:
#   keep the hip from sagging or being pulled forward, return to a straight
#   knee; ball: keep the hips straight throughout).
# - StrengthLog, Standing Leg Curl and Lying Leg Curl (strengthlog.com,
#   fetched 2026-09-30): pad just above the heel of the working leg, grip the
#   handles, maintain an upright posture, upper body still, pause at the
#   top, lower slowly, avoid swinging; the machine's joint in line with the
#   knee.
# - Muscle & Strength, Valslide Leg Curl and Single Leg Valslide Leg Curl
#   (Wayback snapshots 2026-04-22 and 2024-07-20; the builder's references):
#   hands by the sides, bridge the hips up with the glutes first and keep
#   them up as the legs go out almost straight and the heels come back in,
#   no locked knees at the bottom (to keep tension, which assumes the hips
#   stay up), feel it in the glutes and hamstrings, a lower-back pump means
#   a core/pelvis stability problem; single-leg: hold the other hip flexed with
#   the knee bent; if the one-leg curl is too hard, lower on one leg and pull
#   back in with both.
# - PureGym, Swiss Ball Hamstring Curls (puregym.com, fetched 2026-09-30):
#   heels and lower calves on the ball, hips lifted into a glute bridge with
#   a straight line from knees to shoulders, shoulders and palms pressed into
#   the floor, head down, return slowly.
# - Monajati A, Larumbe-Zabala E, Goss-Sampson M, Naclerio F 2017, J Hum
#   Kinet 60:29-37, doi:10.1515/hukin-2017-0105, PMID 29339983 (full text
#   PMC5765783) - ten female athletes, Nordic curl vs ball leg curl: the ball
#   curl done supine, heels on the ball, palms down, the pelvis lifted as the
#   knees bend and lowered as they straighten (each rep); in the lowering
#   phase biceps femoris 50.3% vs 74.8% MVIC (ball vs Nordic) at 60-40° of
#   knee flexion, similar and below 45% over the last 40°.
# - Youdas JW, Hartman JP, Murphy BA, Rundle AM, Ugorowski JM, Hollman JH
#   2015, Physiother Theory Pract 31(6):418-427,
#   doi:10.3109/09593985.2015.1010672, PMID 25671354 - 26 adults, supine
#   bridges: hamstrings 51.9-59.6% MVIC in the double-leg hamstring curls;
#   gluteus maximus 10.9% MVIC in the bridge with the feet on a Swiss ball
#   plus a hamstring curl, 16.4% in the double-leg bridge, 32.6% in the
#   single-leg bridge (per-exercise values as tabulated in Macadam P,
#   Feser EH 2019, Int J Sports Phys Ther 14(1):14-31, PMID 30746289,
#   PMC6350668, read).
# - Guruhan S, Kafa N, Ecemis ZB, Guzel NA 2021, Sports Health 13(2):181-186,
#   doi:10.1177/1941738120938649, PMID 32857686 - 31 adults: the Nordic
#   exercise activated the hamstrings more than the stiff-leg deadlifts and
#   the ball leg curl.
# - Hegyi A, Csala D, Peter A, Finni T, Cronin NJ 2019, Scand J Med Sci
#   Sports 29(1):34-43, doi:10.1111/sms.13303, PMID 30230042 - 19 amateur
#   athletes, 9 exercises at 12RM loads with 2 s phases, HD-EMG: the prone
#   and slide leg curls, with the straight-knee bridge and upright hip
#   extension, had the highest hamstring activity of the nine (the group
#   spanning 40-54% MVIC lowering, 69-85% lifting).
# - Tsaklis P et al. 2015, Open Access J Sports Med 6:209-217,
#   doi:10.2147/OAJSM.S79189, PMID 26170726 (full text PMC4492645) - 20 elite
#   female track and field athletes, ten exercises: the slide leg (from bent
#   knees, one heel on a slider bearing weight, the pelvis held off the
#   ground throughout, the other leg off the floor, unloaded; the leg
#   straightened slowly, then curled back) was high intensity (>= 80% MVIC),
#   the highest of the ten, with no medial-lateral bias; EMG normalised to
#   80% of the MVIC value, which inflates the percentages.
# - Gulgosteren E et al. 2025, BMC Sports Sci Med Rehabil 18:6,
#   doi:10.1186/s13102-025-01435-5, PMID 41318473 (full text PMC12772044) -
#   42 male football players; the supine sliding leg curl (both heels down
#   in Fig. 1B, hips low with the legs straight and bridged with the knees
#   bent; the abstract once expands SSLC as Sliding Single-Leg Curl) in the
#   21 healthy players: biceps femoris 70.5 +- 10.3% MVIC, gluteus maximus
#   55.1 +- 9.3% MVIC.
# - Maeo S et al. 2021, Med Sci Sports Exerc 53(4):825-837,
#   doi:10.1249/MSS.0000000000002523, PMID 33009197 (PMC7969179) - 20 adults,
#   12 weeks, one leg seated and the other prone leg curls: whole hamstrings
#   volume +14% vs +9%, the gain in the two-joint hamstrings.
# - Li L, Landin D, Grodesky J, Myers J 2002, J Electromyogr Kinesiol
#   12(5):385-390, doi:10.1016/S1050-6411(02)00049-4, PMID 12223171 - the
#   gastrocnemius' knee-flexion moment was greatest with the knee straight,
#   little at 90° and 75° of knee angle. Background only: it gives no basis
#   for ranking these exercises against each other, so no value rests on it.
# - Lisboa F et al. 2026, J Strength Cond Res 40(4):400-405,
#   doi:10.1519/JSC.0000000000005344, PMID 41609763 - seated leg curls: less
#   lateral gastrocnemius swelling with the toes pointed than with the ankle
#   neutral (the abstract gives no angle); the hamstrings swelled in both.
# - Schoenfeld BJ, Ogborn DI, Vigotsky AD, Franchi MV, Krieger JW 2017,
#   J Strength Cond Res 31(9):2599-2608, doi:10.1519/JSC.0000000000001983,
#   PMID 28486337 - 15 studies: eccentric-only training grew muscle a little
#   more than concentric-only (10.0% vs 6.8%, not significant). Used only
#   for the one-leg lowering being worth doing, not for lowering slowly.
# - Schoenfeld BJ, Ogborn DI, Krieger JW 2015, Sports Med 45(4):577-585,
#   doi:10.1007/s40279-015-0304-0, PMID 25601394 - in sets to failure,
#   repetition durations of 0.5-8 s built similar muscle (so the tempo cues
#   are for control, not a growth claim).
# No gastrocnemius EMG exists for these six exercises: its values follow
# the library (Lying Leg Curl 0.46, Seated 0.40) and the paint, and the
# split between them is a judgement call (see the notes).
from common_1_50 import *


def ov(final):
    """Pre-squeeze override row for an on-screen row (spec_400.row() maps
    0.14-0.86 to 0.16-0.80)."""
    return round(0.14 + (final - 0.16) * (0.86 - 0.14) / (0.80 - 0.16), 4)


# ---------------------------------------------------------------- Standing Leg Curl

N = "Standing Leg Curl"
ex(name=N, var="standingLegCurl",
   # Side-on from the front-left (yaw -1.3, ~15° short of a true left side
   # view): the head at the top middle, the handles and the machine's front
   # posts down the left, the stack, lever, roller and cable rods down the
   # right. The chest label sits top right
   # above the pulley (clear of the eye button, whose bottom is at 0.128).
   # The heel and pad labels sit right of the seat (u >= 0.6) above the
   # lever's sweep; the knee and standing-foot labels sit left over the
   # static frame posts, short enough to end before the standing calf
   # (u ~0.40) and shoe (u ~0.28 at the 0.80 row). The stance label sits at
   # 0.70, not 0.72: the stance fault view frames the body higher, and at
   # 0.72 the ghost's raised heel line clipped the pill's right end.
   overrides={"chest": (ov(0.16), "trailing"), "range": (ov(0.36), "trailing"),
              "pad": (ov(0.48), "trailing"), "pivot": (ov(0.64), "leading"),
              "stance": (ov(0.70), "leading")},
   annotations=[
       ("chest", "Chest on the pad", "chest"),
       ("range", "Heel up past level", "shin_L"),
       ("pad", "Roller at the heel", "foot_L"),
       ("pivot", "Knee on the pivot", "patella_L"),
       ("stance", "Right foot flat", "foot_R"),
   ],
   cues={
       "chest": ("Upper Body",
                 "Chest and forearms stay on the pads.",
                 "With the trunk still, the left knee is the only joint moving, so the hamstrings lift the weight rather than a lean or a swing.",
                 "Rocking the upper body back off the chest pad to swing the heel up.",
                 "Keep your chest against the pad and your forearms on the arm pads, hold the handles lightly and move only the lower leg."),
       "range": ("Range of Motion",
                 "Curl from almost straight to past level.",
                 "Taking the knee from almost straight to past 90° works the hamstrings through most of their range at the knee. With the hip straight they are short at the top, which is one reason the end of the curl can feel hardest.",
                 "Stopping each rep with the lower leg still pointing down, well short of level.",
                 "Curl until your left heel rises above knee height, pause for a moment, then lower until the knee is almost straight."),
       "pad": ("Roller Position",
               "The roller goes just above the left heel.",
               "Just above the heel, the roller sits on the firm lower leg instead of digging into the calf muscle, so you can push into it comfortably through the whole curl.",
               "Setting the roller up on the calf, pressing into the muscle instead of the lower leg.",
               "Adjust the roller so it sits against the back of your left leg, just above the heel."),
       "pivot": ("Knee Alignment",
                 "The left knee lines up with the lever's pivot.",
                 "The lever turns about that pivot. With the knee on the same axis, the roller travels the same arc as the ankle and stays put above the heel; with the knee off it, the roller slides along the leg as it turns.",
                 "The left knee drifting forward off the pivot as the heel comes up, the thigh swinging with it.",
                 "Stand so your left knee is level with the round pivot beside it, and keep the thigh hanging straight down while only the lower leg moves."),
       "stance": ("Standing Leg",
                  "The right foot carries you, flat on the platform.",
                  "With your weight on the whole right foot and the knee soft, the pelvis stays still and only the left knee moves, so the hamstrings do the curling.",
                  "Bobbing the body up off the right heel with each curl instead of standing still.",
                  "Keep your weight on the whole right foot, the knee slightly bent, from the first rep to the last."),
   },
   # Activation follows the paint: hamstrings bright (PRIMARY), calves dim
   # (SECONDARY). Hamstrings 0.90 as the library's lying and single-leg
   # machine curls (ExRx names them the target). Gastrocnemius 0.40, the
   # library's seated value: ExRx lists it as a synergist; no gastrocnemius
   # EMG exists for this exercise, and with the toes pointed (the model's
   # ankle stays at 114°) Lisboa 2026 saw less gastrocnemius swelling than
   # with the ankle neutral, so no higher than the lying curl's 0.46. A
   # judgement call, not a measurement.
   activation=[("Hamstrings", P, HI, 0.90), ("Gastrocnemius", S, MOD, 0.40)],
   stabilisers=["gluteus medius", "gluteus minimus", "core"],
   comparison=("BODY SWINGING", "Chest on the pad, leg curls alone", "Trunk rocks back to swing the heel",
               "With the chest on the pad and the thigh hanging still, the knee is the only joint moving, so the left hamstrings do the whole lift.",
               "Rocking back swings the heel up with momentum, so the hamstrings skip part of the work, most of all near the top."),
   # The working (left) hamstrings bright; softer, the calf, which swings
   # from under the knee to behind it.
   glows=[glow(N, ["thigh_L", "shin_L"], A, 0.55, 0.05, 0.09),
          glow(N, ["shin_L", "foot_L"], SOFT, 0.30, 0.07, 0.07)])

SETUP[N] = [
    "Set the roller so it sits just above your left heel.",
    "Stand on the platform on your right foot, left knee level with the pivot.",
    "Rest your chest on the pad and your forearms on the arm pads.",
    "Hold the handles and let the left leg hang almost straight.",
]

# ---------------------------------------------------------------- Kneeling Leg Curl

N = "Kneeling Leg Curl"
ex(name=N, var="kneelingLegCurl",
   # Side-on from the front-left (yaw -1.3, ~15° short of a true left side
   # view): the head top left, the trunk
   # sloping down to the hips at the middle, the kneeling pad and pivot cam
   # below them, the stack and rods at the right. The head fills the top
   # left, so the top labels go right: the lean label above the back, the
   # hips label below the top bar and above the roller's highest point
   # (v ~0.48), short enough to start right of the seat (u ~0.68). The knee,
   # heel and pad labels sit left over the static handle posts, the pivot
   # label above the heel label: the patella dot sits just up and left of
   # the knee-joint dot, so the other order crossed the two leaders.
   overrides={"lean": (ov(0.16), "trailing"), "hips": (ov(0.42), "trailing"),
              "pivot": (ov(0.52), "leading"), "range": (ov(0.64), "leading"),
              "pad": (ov(0.80), "leading")},
   annotations=[
       ("lean", "Lean on the arm pads", "chest"),
       ("hips", "Hips level", "pelvis"),
       ("range", "Heel above the knee", "shin_L"),
       ("pivot", "Left knee on the pivot", "patella_L"),
       ("pad", "Roller low on the leg", "foot_L"),
   ],
   cues={
       "lean": ("Trunk Position",
                "Stay leaning forward over the arm pads.",
                "Leaning forward keeps the hip bent, so the two-joint hamstrings work from a longer length than in a standing curl. In a 12-week study, leg curls with the hips bent grew the hamstrings more than curls lying flat.",
                "Pushing up off the arm pads as the heel rises, the trunk lifting and the hip opening.",
                "Keep your forearms on the pads and your trunk leaning well forward over them from the first rep to the last."),
       "hips": ("Hip Position",
                "The pelvis stays level over the kneeling pad.",
                "A level pelvis keeps the curl at the knee. When the working hip hitches up, the lower back joins in and the hamstrings do less of each rep.",
                "The left hip hitching up as the heel comes toward the glute.",
                "Keep both hips at the same height, the right knee settled on the pad, and let only the left lower leg move."),
       "range": ("Range of Motion",
                 "Curl from a nearly straight leg until the heel is above the knee.",
                 "Bringing the heel from a nearly straight leg to above the knee works the hamstrings through most of their range at the knee, from the stretched bottom to a well-bent top.",
                 "Short reps that stop with the lower leg still pointing down.",
                 "Raise your left heel until it passes knee height, hold it there briefly, then let the leg down until the knee is almost straight."),
       "pivot": ("Knee Alignment",
                 "Where you kneel puts the left knee on the pivot.",
                 "With the knee on the lever's axis, knee and lever turn together, so the roller moves with the heel instead of sliding up or down the leg.",
                 "Kneeling too far back, so the left knee sits behind the pivot.",
                 "Shuffle along the kneeling pad until your left knee is level with the round pivot, the thigh hanging straight down beside the pad."),
       "pad": ("Roller Position",
               "The roller rests low on the left leg, above the heel.",
               "Low on the leg, the roller rests on the back of the lower leg, below the bulk of the calf, and rides with the heel through the whole curl.",
               "Leaving the roller up on the calf, where it digs into the muscle as the heel comes up.",
               "Before kneeling, move the roller down so it rests on the back of your left lower leg, just above the heel."),
   },
   # Paint: hamstrings bright, calves dim. Values as the Standing Leg Curl
   # (same lever, roller and ankle angle, 114°); ExRx names the hamstrings
   # the target and the gastrocnemius a synergist, the glutes stabilisers.
   activation=[("Hamstrings", P, HI, 0.90), ("Gastrocnemius", S, MOD, 0.40)],
   stabilisers=["gluteus maximus", "gluteus medius", "core"],
   comparison=("TRUNK RISING", "Forearms down, hips bent", "Trunk pushes up, hip opens",
               "Staying down on the arm pads keeps the hip bent, so the hamstrings curl from a longer length through the whole rep.",
               "Pushing up straightens the hip and shortens the hamstrings at the top, and turns the end of each rep into a heave."),
   glows=[glow(N, ["thigh_L", "shin_L"], A, 0.55, 0.05, 0.09),
          glow(N, ["shin_L", "foot_L"], SOFT, 0.30, 0.07, 0.07)])

SETUP[N] = [
    "Set the roller low on the left leg, just above the heel.",
    "Kneel with your right knee on the pad and your left knee level with the pivot.",
    "Rest your forearms on the arm pads and hold the handles.",
    "Lean well forward over the pads; the left leg starts almost straight.",
]

# ---------------------------------------------------------------- Cable Standing Leg Curl

N = "Cable Standing Leg Curl"
ex(name=N, var="cableStandingLegCurl",
   # Same view and body as the Standing Leg Curl, the frame posts down the
   # left and the right side open (the tower is off screen to the left).
   # The start label sits top right with a long leader to the knee; the cuff
   # label right of the back; the hips and knee labels left over the static
   # posts, short enough to end before the belly (u ~0.36); the trunk label
   # left of the neck and upper chest at 0.24, clear of the face: at 0.16 the
   # trunk fault's ghost head and neck, tipped forward, ran through its pill.
   overrides={"range": (ov(0.16), "trailing"), "trunk": (ov(0.24), "leading"),
              "cuff": (ov(0.36), "trailing"), "hips": (ov(0.48), "leading"),
              "thigh": (ov(0.64), "leading")},
   annotations=[
       ("range", "Stop short of straight", "shin_L"),
       ("trunk", "Trunk upright", "chest"),
       ("cuff", "Cuff on the ankle", "foot_L"),
       ("hips", "Hips stay put", "pelvis"),
       ("thigh", "Knee points down", "patella_L"),
   ],
   cues={
       "range": ("Start of the Rep",
                 "Each rep starts with the left knee a little short of straight.",
                 "On this setup the cable pulls almost square to the lower leg while the knee is nearly straight and runs almost through the knee at the top, so the start is the hardest part of the curl. Stopping just short of straight keeps the hamstrings loaded there.",
                 "Letting the leg swing all the way straight between reps and resting there.",
                 "Lower until the knee is just short of straight with the cable still pulling, then curl the heel up until the lower leg passes level."),
       "trunk": ("Upper Body",
                 "Stand tall, the hands only steadying you.",
                 "A still, upright trunk keeps the curl at the knee, with the frame only there for balance. Tipping forward mid-rep turns part of the lift into a swing at the hip.",
                 "Bending forward over the frame as the heel comes up.",
                 "Stand upright with the chest lifted and rest your hands on the frame handles, arms relaxed."),
       "cuff": ("Cuff Position",
                "The cuff goes round the ankle, the cable straight to the pulley.",
                "A cuff at the ankle pulls on the end of the lower leg, the longest lever for the hamstrings, and a snug fit stops it sliding up the calf mid-rep.",
                "A loose cuff that slides up the calf as the heel rises.",
                "Strap the cuff snugly round your left ankle, just above the heel, and face the pulley so the cable runs straight forward."),
       "hips": ("Hip Position",
                "The hips stay put, not pulled toward the stack.",
                "Holding the hips still keeps the cable's pull on the knee, where the hamstrings meet it. Letting it drag the hips forward arches the lower back.",
                "The cable pulling the hips forward and the lower back arching as the leg lowers.",
                "Brace your midsection and keep your hips square and still, directly over the right foot, from the first rep to the last."),
       "thigh": ("Thigh Position",
                 "The left thigh hangs straight down, the knee pointing at the floor.",
                 "With the thigh still, the knee is the only joint moving and the cable's pull goes into bending it. When the knee drifts forward, the hip bends too and the thigh starts swinging the heel up.",
                 "The left knee drifting forward toward the stack as the heel comes up.",
                 "Keep the left knee pointing at the floor beside the right knee, and move only the lower leg."),
   },
   # Paint: hamstrings bright; calves and glutes only faint (0.11), so both
   # are LOW secondary rows. Hamstrings 0.86, a little under the machines:
   # the cable's pull on the knee fades toward the top (the model's
   # geometry). Gastrocnemius 0.34 (ExRx synergist; the ankle
   # stays near neutral, 99°; no EMG, so LOW with the faint paint). Gluteus
   # medius 0.20: ExRx lists the gluteus medius and minimus as stabilisers of
   # the one-leg stance. The gluteus maximus, painted faint with them, is
   # named among the stabilisers.
   activation=[("Hamstrings", P, HI, 0.86), ("Gastrocnemius", S, LOW, 0.34), ("Gluteus Medius", S, LOW, 0.20)],
   stabilisers=["gluteus maximus", "gluteus minimus", "quadratus lumborum", "obliques"],
   comparison=("KNEE DRIFTING", "Knee down, only the lower leg moves", "Knee swings forward with the curl",
               "With the knee pointing at the floor, the cable's pull goes into bending the knee and the hamstrings do the lifting.",
               "When the knee drifts forward the hip bends too, so the heel rises partly by swinging the thigh rather than by curling the knee."),
   glows=[glow(N, ["thigh_L", "shin_L"], A, 0.55, 0.05, 0.09),
          glow(N, ["shin_L", "foot_L"], SOFT, 0.20, 0.07, 0.07)])

SETUP[N] = [
    "Strap the cuff round your left ankle and clip it to the low pulley.",
    "Face the stack and hold the frame handles in front of you.",
    "Stand on your right foot, knee soft, the left foot hanging just behind it.",
    "Start with the left knee a little bent and the cable taut.",
]

# ---------------------------------------------------------------- Swiss Ball Leg Curl

N = "Swiss Ball Leg Curl"
ex(name=N, var="swissBallLegCurl",
   # Side-on (yaw -1.35), lying in a band across the middle of the frame
   # (v ~0.37-0.66): the ball at the left, the head at the right, the mat
   # under the shoulders. Labels sit above the body (0.16-0.26) and below
   # the ball and mat (0.72-0.80). The hip label is the higher of the right
   # pair so its leader drops left of the ribs pill; the heel label sits
   # below the ball (its leader crosses the ball) so that no top-left leader
   # runs through another pill; the tempo pill ends ~13 pt short of the hip
   # leader and clear of the knee at the top of the curl (v ~0.35).
   overrides={"hips": (ov(0.16), "trailing"), "ribs": (ov(0.26), "trailing"),
              "tempo": (ov(0.26), "leading"), "heels": (ov(0.72), "leading"),
              "arms": (ov(0.80), "trailing")},
   annotations=[
       ("heels", "Heels on top of the ball", "foot_L"),
       ("ribs", "Ribs down, no arch", "spine"),
       ("hips", "Hips stay off the floor", "pelvis"),
       ("tempo", "Roll the ball out slowly", "shin_L"),
       ("arms", "Arms flat, palms down", "hand_L"),
   ],
   cues={
       "heels": ("Foot Position",
                 "Both heels rest on top of the ball, about hip-width apart.",
                 "From the top of the ball the heels can press down and drag it in, then let it roll back out under control, so the curl has a firm base.",
                 "Setting the heels low on the side of the ball instead of on top, where they slip as it rolls.",
                 "Place your heels on top of the ball, hip-width apart, toes pointing up."),
       "ribs": ("Lower Back",
                "The glutes and hamstrings lift the hips, not the lower back.",
                "The top of the rep is a straight line from the shoulders to the knees. Arching to push the hips higher takes them past that line and moves the work onto the lower back.",
                "Arching the lower back at the top to push the hips higher.",
                "At the top, stop when your knees, hips and shoulders line up, ribs down and glutes tight."),
       "hips": ("Hip Position",
                "The hips stay up for the whole set.",
                "In this version the hips stay up between reps, so the hamstrings hold the bridge as well as curl the ball in, with the glutes helping a little.",
                "Letting the hips sink to the floor each time the legs straighten.",
                "Lift your hips before the first rep and keep them up until the last one, lowering only when the set is done."),
       "tempo": ("Lowering Speed",
                 "Roll the ball back out under control.",
                 "Rolling the ball out is the lowering half of the curl: the hamstrings work as they lengthen, and a slow roll-out keeps the ball from running away.",
                 "Kicking the ball away so the legs snap straight.",
                 "Curl the ball in over about a second, hold the top briefly, then take at least as long rolling it back out."),
       "arms": ("Arm Position",
                "The arms lie flat on the floor, out from the sides.",
                "Pressing the arms and palms into the floor gives a wide, steady base, so the hips can lift without the body rolling to one side.",
                "Lifting the arms off the floor, which leaves only the shoulders to balance on.",
                "Rest your arms on the floor a little out from your sides, palms down, and press them gently into the floor."),
   },
   # Paint: hamstrings bright; glutes and calves dim. Hamstrings 0.78, HIGH
   # but under the machines: Monajati 2017 measured ~50% MVIC in the ball
   # curl's lowering at 60-40° (74.8% in the Nordic), Youdas 2015
   # 51.9-59.6% in double-leg hamstring curls, and Guruhan 2021 found it
   # below the Nordic. Gluteus maximus 0.28 LOW: Youdas 2015 measured 10.9%
   # MVIC for this exact move (the ball bridge plus a hamstring curl), under
   # the plain double-leg bridge's 16.4%; dim paint, so SECONDARY. ExRx lists
   # it as a stabiliser of the held bridge. Gastrocnemius 0.30 (ExRx
   # synergist; no EMG; the toes stay pointed, 154° -> 142°).
   activation=[("Hamstrings", P, HI, 0.78), ("Gastrocnemius", S, LOW, 0.30), ("Gluteus Maximus", S, LOW, 0.28)],
   stabilisers=["erector spinae", "core", "obliques"],
   comparison=("HIPS SINKING", "Hips up through every rep", "Hips drop as the legs straighten",
               "Holding the bridge makes the hamstrings keep the hips up and curl the ball in together, with the glutes helping a little.",
               "Letting the hips drop between reps gives the hamstrings a pause at each bottom and turns every rep into a new bridge from the floor."),
   glows=[glow(N, ["thigh_L", "shin_L"], A, 0.55, 0.09, 0.05),
          glow(N, ["pelvis"], SOFT, 0.30, 0.05, 0.04),
          glow(N, ["shin_L", "foot_L"], SOFT, 0.25, 0.07, 0.04)])

SETUP[N] = [
    "Lie on your back with your heels on top of the ball, hip-width apart.",
    "Lay your arms on the floor a little out from your sides, palms down.",
    "Lift your hips off the floor into a bridge, legs almost straight.",
]

# ---------------------------------------------------------------- Sliding Leg Curl

N = "Sliding Leg Curl"
ex(name=N, var="slidingLegCurl",
   # Side-on (yaw -1.35), lying in a band across the middle (v ~0.40-0.58),
   # the feet on sliders at the left, the head at the right. Labels above
   # (0.16-0.32) and below (0.64). The hip label's leader drops straight to
   # the pelvis, left of the ribs pill; the knee label sits alone on its row.
   overrides={"hips": (ov(0.16), "trailing"), "knees": (ov(0.26), "leading"),
              "ribs": (ov(0.32), "trailing"), "tempo": (ov(0.64), "leading"),
              "arms": (ov(0.64), "trailing")},
   annotations=[
       ("hips", "Hips rise as heels come in", "pelvis"),
       ("knees", "Legs almost straight", "patella_L"),
       ("ribs", "No arch at the top", "spine"),
       ("tempo", "Slide out slowly", "foot_L"),
       ("arms", "Arms out, palms down", "hand_L"),
   ],
   cues={
       "hips": ("Hip Drive",
                "The hips lift off the mat as the heels slide in.",
                "Bridging as you curl makes the hamstrings hold the hips up while they bend the knee, and brings the glutes in; with the hips left down, sliding the heels in carries little load.",
                "Leaving the hips low as the heels pull in, so the rep is just a knee bend on the floor.",
                "Squeeze your glutes and lift your hips off the mat as your heels slide in, then lower them as your legs straighten."),
       "knees": ("Bottom of the Rep",
                 "The legs stop just short of straight.",
                 "Stopping with the knees still slightly bent keeps the end of the slide under control and the hamstrings ready to pull the heels straight back in, rather than the knees snapping locked against the floor.",
                 "Snapping the knees straight at the end of each slide.",
                 "Slide your heels out until the legs are almost straight, knees still slightly bent, then pull them back in."),
       "ribs": ("Lower Back",
                "Keep the ribs down as the hips come up.",
                "Arching the lower back to get the hips higher moves the work off the glutes and hamstrings, and a pumped lower back is the usual sign of it.",
                "Pushing the belly up and arching the lower back as the heels come in.",
                "Brace your midsection, keep your ribs down and let the hips rise only as far as the glutes lift them."),
       "tempo": ("Lowering Speed",
                 "Slide the heels back out under control.",
                 "Sliding out is the lowering half: pressing the heels into the sliders keeps the hamstrings braking the slide, so they work as they lengthen instead of letting go.",
                 "Letting the sliders shoot out and the hips drop in one go.",
                 "Press your heels into the sliders and take at least as long sliding out as you did pulling in, lowering the hips as the legs straighten."),
       "arms": ("Arm Position",
                "The arms rest on the floor, palms down.",
                "Arms on the floor give a wide base, so the hips can lift straight up without the body tipping to one side.",
                "Folding the arms across the chest or lifting them off the floor, which leaves only the shoulders to balance on.",
                "Rest your arms on the floor out to your sides with the palms down and keep them relaxed."),
   },
   # Paint: hamstrings bright; glutes and calves dim. Hamstrings 0.84:
   # Hegyi 2019 put the prone and slide leg curls, with the straight-knee
   # bridge and upright hip extension, at the highest hamstring activity of
   # nine exercises (12RM loads); Gulgosteren 2025 measured the biceps
   # femoris at 70.5% MVIC in this two-leg supine sliding curl (healthy
   # players). Gluteus maximus 0.52 MODERATE (Gulgosteren 2025: 55.1% MVIC).
   # Gastrocnemius 0.36 LOW: no EMG; ExRx says dorsiflexion lets it assist,
   # and the ankles flex to 79° at the top; a judgement call.
   activation=[("Hamstrings", P, HI, 0.84), ("Gluteus Maximus", S, MOD, 0.52), ("Gastrocnemius", S, LOW, 0.36)],
   stabilisers=["core", "erector spinae", "obliques"],
   comparison=("HIPS STAYING DOWN", "Hips lift as the heels come in", "Hips stay low, knees just bend",
               "With the hips up, the hamstrings hold the bridge and pull the heels in together, and the glutes join in.",
               "With the hips left down, the heels slide in against little more than the sliders' friction, so most of the rep is wasted."),
   glows=[glow(N, ["thigh_L", "shin_L"], A, 0.55, 0.09, 0.04),
          glow(N, ["pelvis"], SOFT, 0.30, 0.05, 0.04),
          glow(N, ["shin_L", "foot_L"], SOFT, 0.25, 0.08, 0.03)])

SETUP[N] = [
    "Lie on your back with both heels on sliders, legs almost straight.",
    "Rest your arms on the floor out to your sides, palms down.",
    "Press your heels down, toes pointing up.",
]

# ---------------------------------------------------------------- Single-Leg Sliding Curl

N = "Single-Leg Sliding Curl"
ex(name=N, var="singleLegSlidingCurl",
   # As the Sliding Leg Curl, with the right leg held up (knee at v ~0.40-0.46)
   # above the working leg. The free-leg and hip labels sit top right, their
   # leaders running down-left without crossing; the knee and slide labels
   # sit below the body at the left, the arms label below at the right. The
   # slide label is kept short (ending ~x 0.33) so the knee label's leader,
   # rising from the row below, passes right of it.
   overrides={"free": (ov(0.16), "trailing"), "hips": (ov(0.32), "trailing"),
              "tempo": (ov(0.64), "leading"), "arms": (ov(0.64), "trailing"),
              "range": (ov(0.72), "leading")},
   annotations=[
       ("free", "Right leg up and still", "patella_R"),
       ("hips", "Hips level as they rise", "pelvis"),
       ("tempo", "Heel out slowly", "foot_L"),
       ("arms", "Arms wide, palms down", "hand_L"),
       ("range", "Left leg almost straight", "patella_L"),
   ],
   cues={
       "free": ("Free Leg",
                "The right leg stays up in the air, knee bent.",
                "Holding the right leg still keeps the pelvis quiet, so the left hamstrings and glutes do all of the curl.",
                "Kicking the right knee up toward the chest to swing the hips up.",
                "Lift your right foot off the floor, bend the knee to about a right angle and hold that leg still for the whole set."),
       "hips": ("Hip Position",
                "The pelvis rises level, both hips at the same height.",
                "With one foot down, the pelvis tends to drop on the free side. Keeping it level makes the left glutes and hamstrings hold the bridge instead of the lower back twisting.",
                "The right side of the pelvis dropping as the hips lift.",
                "Squeeze your left glute and lift your hips as the heel slides in, keeping both hip bones level."),
       "tempo": ("Lowering Speed",
                 "Lower out of the curl slowly on the left leg.",
                 "In training studies, lowering-only work has built about as much muscle as lifting-only work, so the one-leg lowering is worth doing before you can curl back in on one leg.",
                 "Dropping out of the curl, the left leg shooting straight and the seat hitting the mat.",
                 "Take at least as long sliding out as pulling in; if the one-leg curl back in is too hard, slide out on the left leg and pull back in with both feet."),
       "arms": ("Arm Position",
                "Both arms stay out on the floor, palms pressing down.",
                "Arms on the floor give a wide base, which one-leg bridging needs more than two, so the hips can lift without tipping.",
                "Lifting the arms off the floor as the hips rise, so nothing stops the body rolling toward the raised leg.",
                "Spread your arms on the floor, palms down, and press lightly to keep the body from tipping toward the free leg."),
       "range": ("Bottom of the Rep",
                 "Slide the left leg out until it is almost straight.",
                 "Sliding all the way out makes the left hamstrings brake the slide through their full range at the knee; stopping halfway leaves the stretched part of every rep out.",
                 "Stopping the slide halfway, the left knee still well bent.",
                 "Let the left heel travel out until the knee is only slightly bent, then curl it back toward you."),
   },
   # Paint: hamstrings bright; glutes and calves dim. Hamstrings 0.88, a
   # rank judgement (the hardest of the family's floor curls, one leg doing
   # the work of two), not a measured value for this model: Tsaklis 2015
   # rated its one-leg slide the highest intensity of ten exercises
   # (>= 80% MVIC, normalised to 80% of MVIC, the pelvis held up
   # throughout). Gluteus maximus 0.58, above the two-leg Sliding Leg
   # Curl's 0.52, since one leg carries the bridge (Youdas 2015: single-leg
   # bridge 32.6% vs double-leg 16.4% MVIC). Gastrocnemius 0.36 LOW as the
   # Sliding Leg Curl (same ankle, 119° -> 79°).
   activation=[("Hamstrings", P, HI, 0.88), ("Gluteus Maximus", S, MOD, 0.58), ("Gastrocnemius", S, LOW, 0.36)],
   stabilisers=["hip flexors", "obliques", "erector spinae"],
   comparison=("PELVIS DROPPING", "Hips level, right leg still", "Right hip drops as the hips rise",
               "With the pelvis level and the right leg still, the left hamstrings and glutes lift the hips and pull the heel in on their own.",
               "When the free side drops, the pelvis twists and the lower back takes over part of the bridge from the working leg."),
   glows=[glow(N, ["thigh_L", "shin_L"], A, 0.55, 0.09, 0.04),
          glow(N, ["pelvis"], SOFT, 0.30, 0.05, 0.04),
          glow(N, ["shin_L", "foot_L"], SOFT, 0.25, 0.08, 0.03)])

SETUP[N] = [
    "Lie on your back with your left heel on a slider, leg almost straight.",
    "Lift your right foot off the floor and hold the knee bent, thigh angled up.",
    "Spread your arms wide on the floor, palms down.",
]
