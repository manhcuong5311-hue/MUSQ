# Trainer content for the 401-500 folder, third round (445-474, 2026-10-05),
# family: antiext. Three anti-extension core exercises from the builder's
# exports: 466 Stability Ball Rollout (Abs/StabilityBallRollout), 467 Body Saw
# (Abs/BodySaw) and 468 Bear Crawl (Abs/BearCrawl). Same format as spec.py on
# top of common_1_50.py; spec_500.py imports this module and gen.py reads
# SPEC / SETUP. notes_500_antiext.md maps the copy's claims to the sources
# below and records the model facts.
#
# What the models show, measured from the rigs with Blender's Python + pxr
# (SCRATCH/antiext/rig.py dumps every joint every frame, measure.py and
# lumb.py read angles, heights and the spine's shape, skin.py the skinned
# meshes' lowest points above the mat; the app's Y-up space, the lifter
# facing +z, their left +x, the mat's top at y 0), the trainer stills at
# 0/1/2/3/5 s, joints.json and tiers.json. Every clip is 7.96 s on one body
# (torso, neck to pelvis, 0.59 m) on a mat (HG_Mat). In all three the head is
# held a little up from the rig's standing neutral (the neck-to-head line
# 20-26 deg toward the back of the chest-to-neck line, the same every frame:
# rollout 26, body saw 20, bear crawl 22, against ~4 deg in the bind pose),
# about in line with the trunk, the face turned down and ahead (in the
# rollout its axis 24-36 deg below level, toward the ball at full reach).
# - Stability Ball Rollout: kneeling, knees 24 cm apart and planted (the knee
#   skin within 0.7 cm of the mat at every sampled moment), the toes of the
#   shoes on the mat, the shins angled 20 deg up from the knees. The forearms rest on top of a 66 cm
#   stability ball (HG_StabilityBall; the forearm skin within 0.5 cm of the
#   ball, the hands 4-6 cm above it), wrists 22 cm apart (the shoulders 39 cm),
#   palms facing in. Start (0-0.42 s): the trunk (pelvis to neck) 43 deg
#   above level, hips ~151 deg, upper arms ~96 deg from the trunk, elbows
#   ~114 deg. Rolls out 0.46-1.21 s, the ball travelling 53 cm; holds at full
#   reach 1.25-2.33 s: hips ~175 deg (knees, hips and shoulders in one line),
#   the trunk 28 deg above level, upper arms ~153 deg from the trunk (arms
#   overhead), elbows ~147 deg, the knees still down; rolls back 2.38-3.12 s;
#   rests at the start 3.17-4.42 s; rep 2 the same, 4.46-7.12 s. The back
#   keeps a slight, constant rounding (the chest 2-4 cm toward the back from
#   the pelvis-neck line), never an arch.
# - Body Saw: forearm plank, forearms parallel and fixed on the mat, elbows
#   34 cm apart (shoulders 39 cm), fists; the toes on two sliders
#   (HG_SliderL/R, under the shoes' toes at every sampled moment), ankles 22 cm apart; knees
#   171-175 deg, hips ~173 deg, the body one straight line 8 deg above level
#   (pelvis 25-27 cm up), unchanged all clip. The body slides on the sliders:
#   at the start the shoulders are ~11 cm in front of the elbows (upper arm
#   ~59 deg from the trunk, elbows ~71 deg); it slides back 0.04-1.5 s until
#   the shoulders are ~11 cm behind the elbows (upper arm ~104 deg, elbows
#   ~116 deg), the sliders travelling 22 cm; pause to 2.0 s; slides forward
#   2.0-3.5 s; pause to 4.1 s; rep 2 the same, 4.1-7.5 s. The pelvis rises
#   ~2 cm mid-slide as the upper arms pass upright.
# - Bear Crawl: on hands and toes, knees hovering (their skin 3.7-4.0 cm off
#   the mat when both feet are down, ~5-7 cm while stepping), knees ~6 cm in
#   front of the hips, hips ~86 deg, knees ~68 deg; the back flat and level
#   (shoulders 55 cm, hips 52 cm up, the trunk 2-3 deg above level); hands
#   38 cm apart under the shoulders (wrists ~5 cm behind the shoulder line at
#   rest, ~3 cm in front to ~12 cm behind while crawling: the right hand
#   lands ~2 cm in front of its shoulder stepping forward and ~12 cm behind
#   stepping back), supporting elbows 150-165 deg. Steps: the RIGHT hand and
#   LEFT foot forward together 0.29-1.71 s (~14 cm, lifted ~7 cm), the LEFT hand and
#   RIGHT foot 2.29-3.71 s, then the same two steps backward, 4.29-5.71 and
#   6.29-7.71 s, ~0.6 s with all four down between steps; the pelvis travels
#   14 cm forward and back. The hips stay level all clip (no roll), the body
#   turning +-2.5 deg about the vertical and shifting +-1 cm sideways. Logged
#   in seconds (ExerciseCatalog.timedExercises).
# Paint (tiers.json): rollout, RectusAbdominis and Sartorius bright,
# DeltoidPosterior and the two obliques dim; body saw, RectusAbdominis bright,
# DeltoidPosterior, the obliques and SerratusAnterior dim; bear crawl,
# DeltoidAnterior and RectusAbdominis bright, the obliques, RectusFemoris and
# the three vasti, Sartorius and the three triceps heads dim. The rig paints
# the hip flexors on the sartorius, so that row is "Hip Flexors"
# (legend-only, as in spec_abs.py); "Serratus Anterior" is legend-only too.
#
# How they differ from the library: the Ab Wheel Rollout rolls a wheel out
# from the knees with the hands; the Plank holds still on the forearms; the
# Bird Dog and Dead Bug move one arm and the opposite leg with the knees or
# back down. Here the forearms roll a ball out from the knees, the whole
# forearm plank slides back and forth over planted elbows, and the body
# crawls on hands and toes with the knees off the floor.
#
# Sources (abstracts read on Europe PMC 2026-10-05, full text where noted;
# details and what each supports in the notes):
# - Escamilla RF, Lewis C, Bell D, Bramblet G, Daffron J, Lambert S, Pecson A,
#   Imamura R, Paulos L, Andrews JR 2010, J Orthop Sports Phys Ther
#   40(5):265-276, doi:10.2519/jospt.2010.3073, PMID 20436242 - 18 subjects,
#   eight Swiss ball and two traditional exercises (the crunch and bent-knee
#   sit-up): the roll-out's upper and lower
#   rectus abdominis (63, 53% MVIC), external and internal oblique (46, 46%)
#   significantly greater than most others; with the pike the most effective
#   for the rectus abdominis, obliques and latissimus dorsi while minimizing
#   the lumbar paraspinals and rectus femoris (the roll-out's rectus femoris
#   among the lowest, 6-10%; the paraspinals under 10% in all) (abstract;
#   the full text is paywalled, so how the roll-out was set up is not used).
# - Escamilla RF, Babb E, DeWitt R, et al. 2006, Phys Ther 86(5):656-671,
#   doi:10.1093/ptj/86.5.656, PMID 16649890 - 21 adults: the Power Wheel
#   roll-out among the exercises with the highest rectus abdominis, oblique
#   and latissimus dorsi activity; lumbar paraspinal activity low and similar
#   in all (abstract).
# - McGill S, Andersen J, Cannon J 2015, J Sports Sci 33(4):419-426,
#   doi:10.1080/02640414.2014.946437, PMID 25111163 (author's copy, full
#   text) - 14 men; the body saw done with the feet in suspension straps,
#   the knees bent at the start and the forearms on the ground, the legs
#   straightening as the body sawed back as far as possible over 2 s, 1 s
#   held, 2 s back to the knees-bent start, 1 s held (a 1 Hz metronome):
#   rectus abdominis 103% MVC at the peak (normalised to isometric
#   maximums; the authors note dynamic efforts often exceed 100%),
#   serratus anterior almost 140%, the external oblique above the internal in
#   every task, ~2400 N of spine compression, the least of the four
#   exercises ("the most spine conserving way").
# - Pyka DT, Costa PB, Coburn JW, Brown LE 2017, Int J Kinesiol Sports Sci
#   5(4):26-32, doi:10.7575/aiac.ijkss.v.5n.4p.26 (open access, full text) -
#   40 recreationally active adults (17 women, 23 men), the bear position
#   (wrists under the shoulders, elbows straight, knees under the navel and
#   raised slightly off the ground, neutral spine) held, with opposite hand
#   and foot lifted in place, and crawling (right hand and left foot
#   together, set down half a hand's length from the stationary hand, then
#   left hand and right foot); lost form: a non-neutral spine, hips raised
#   into the air, knees dropped to the ground, bent elbows. In the crawl,
#   rectus femoris 52%, rectus abdominis 24%, external oblique 140% and
#   erector spinae 12% MVC (each normalised to the largest of its maximal
#   efforts; the abdominals' were a resisted sit-up and a twist); all four
#   higher than in the static hold.
# - NASM, The Plank: Coaching Progressions and Variations for Every Client
#   (H. Cherry, nasm.org blog, 2021, updated 2026-07-25, read 2026-10-05):
#   forearm plank setup (elbows under the shoulders, forearms parallel, feet
#   hip-width, a straight line head to heels, quadriceps engaged, ribs down,
#   glutes squeezed, chin slightly tucked); the body saw and walkout increase
#   the lever length and the anti-extension demand; sagging hips read as a
#   loss of anterior core engagement, piked hips as making it easier; head
#   errors both ways ("Hold an apple under your chin"); stop the set when the
#   posture breaks.
# - The Prehab Guys exercise library (theprehabguys.com/vimeo-video/
#   ab-roll-out-2/, plank-body-saw-2/ and bear-crawls-forward-and-backward/,
#   read 2026-10-05): Ab Roll Out - Swissball (kneeling, forearms and hands
#   on top of the ball, roll out slowly with the back flat, push into the
#   ball to bring it back when you cannot go further, elbows in line with
#   the shoulders); Plank Body Saw (forearm plank, elbows under the shoulders,
#   back flat and knees straight, move back and forth with the shoulders, not
#   by moving the feet, elbows not too far out or in); Bear Crawls Forward and
#   Backward (knees about half an inch off the ground, one hand and the
#   opposite leg together, a few steps forward then back, hips and back still,
#   the cup of water on the lower back).
# - ACE Exercise Library: Kneeling ABC's (kneeling behind a stability ball,
#   the body leaning forward about 45 deg with the elbows on top of the ball,
#   a straight line from head to knees) and Bear Crawl (alternate arm and leg
#   with the back straight and the hips and shoulders at the same height)
#   (acefitness.org, read 2026-10-05).
# - University of Calgary SIPRC, SHRED injuries, Multidirectional bear crawl
#   (ucalgary.ca, read 2026-10-05): neutral head and neck, flat level back,
#   opposite arm and leg together forward and backward; faults: a sagging
#   lower back, a rounded upper back, knees too far back, hips dipping side
#   to side ("Hips square towards floor").
# - OpenStax Anatomy and Physiology 2e, 11.5 (openstax.org, read
#   2026-10-05): the deltoid also flexes and extends the arm.
# No EMG reports the three exactly as the models do them (the studied body saw
# hung the feet in straps, the studied roll-out's set-up is in the paywalled
# full text); the studies report %MVIC, which the app's fractions are not, so
# every fraction below is a judgement call anchored on the library's nearest
# lifts (Ab Wheel Rollout, Plank, Push-Up, Reverse Crunch) and the order the
# studies give.
from common_1_50 import *


def ov(final):
    """Pre-squeeze override row for an on-screen row (spec_500.row() maps
    0.14-0.86 to 0.16-0.80)."""
    return round(0.14 + (final - 0.16) * (0.86 - 0.14) / (0.80 - 0.16), 4)


# ---------------------------------------------------------------- Stability Ball Rollout

N = "Stability Ball Rollout"
ex(name=N, var="stabilityBallRollout",
   # Three-quarter from the front-left (yaw -0.8), head on the left: the ball
   # fills the left of the frame (v ~0.48-0.69, partly off the left edge at
   # full reach), the lifter runs from the hands over the ball (v ~0.43) down
   # to the knees and feet on the right (v ~0.59-0.64). Pills above the body
   # on both sides and below the mat on both sides, so none sits on the
   # ball. Top left, arms (to the near hand on top of the ball, the leader
   # passing left of the head); top right, head and hips, the head pill
   # above so its leader passes left of the hips pill; below the mat, tempo
   # (to the chest, up through the open space between the ball and the
   # knees) on the left under the ball, its short pill ending left of the
   # reach pill (to the near hip) on the right, so the tempo leader clears it.
   overrides={"arms": (ov(0.22), "leading"), "head": (ov(0.18), "trailing"),
              "hips": (ov(0.34), "trailing"), "reach": (ov(0.72), "trailing"),
              "tempo": (ov(0.80), "leading")},
   annotations=[
       ("hips", "Hips in line, no sag", "pelvis"),
       ("reach", "Roll till hips straighten", "thigh_L"),
       ("head", "Head in line", "head"),
       ("arms", "Forearms on top of ball", "hand_L"),
       ("tempo", "Control the roll", "chest"),
   ],
   cues={
       "hips": ("Hip Line",
                "At full reach your knees, hips and shoulders make one straight line.",
                "Rolling the ball away lengthens the lever your trunk holds up, so gravity pulls the hips toward the mat and the lower back toward an arch, and the abdominals hold it straight. In an EMG study of a Swiss ball roll-out the rectus abdominis and obliques worked harder than in most of the ten exercises compared, while the lower-back muscles stayed low.",
                "Letting the hips sag toward the mat and the lower back arch at full reach.",
                "Brace your abs and pull your ribs down so the hips stay in line with your trunk, and stop the roll before they start to drop."),
       "reach": ("Range",
                 "Roll the ball out until your hips are straight, about half a metre here.",
                 "The further the ball rolls, the longer the lever your trunk has to hold, and opening the hips to straight is what turns the lean into a rollout. Prehab Guys' guide rolls the ball out slowly with a flat back and brings it back in when you cannot go any further.",
                 "Stopping the roll short, with the hips still bent.",
                 "Let the ball roll under your forearms until knees, hips and shoulders line up, only as far as your back stays flat, then press it back."),
       "head": ("Head Position",
                "Your head stays about in line with your back, eyes down toward the ball.",
                "The neck is the top end of the line you are holding. NASM's plank coaching counts both craning the neck back and dropping the head as errors that can disrupt the body's alignment.",
                "Craning the head up to look far ahead as the ball rolls away.",
                "Keep a long neck, your head about in line with your back, and your eyes down toward the ball rather than up at the wall ahead."),
       "arms": ("Forearms on the Ball",
                "Your forearms rest on top of the ball and stay there as it rolls.",
                "The ball rolls under your forearms, so they carry your upper body as the arms reach overhead. Prehab Guys' guide puts the forearms and hands on top of the ball, pushes into it to bring it back and keeps the elbows in line with the shoulders.",
                "Elbows splaying out to the sides of the ball.",
                "Keep both forearms on top of the ball, elbows no wider than your shoulders, and press down into it as it rolls out and back."),
       "tempo": ("Tempo",
                 "Roll out over about three quarters of a second, hold about a second, then roll back.",
                 "Prehab Guys' guide rolls the ball out slowly. At a pace you could stop at any point, you can halt the roll where your back is still flat, instead of the ball carrying you past it.",
                 "Letting the ball run away and dropping into the end of the roll.",
                 "Roll out under control, hold about a second at full reach, roll back, and rest a moment at the start before the next rep."),
   },
   # Rectus abdominis and sartorius (Hip Flexors) bright (PRIMARY); posterior
   # deltoid and obliques dim. Escamilla 2010's roll-out: upper and lower
   # rectus 63/53% MVIC and both obliques 46%, among the highest of ten
   # exercises; the rectus sits HIGH (0.82), under the library Ab Wheel
   # Rollout's 0.88 (the wheel's longer lever, rated advanced against this
   # row's intermediate), the obliques MODERATE (0.62) under it, as dim
   # secondaries and in the EMG's ratio. Hip Flexors are bright but the one
   # hip flexor measured, the rectus femoris, was among the lowest in the
   # roll-out (6-10% MVIC); mechanically the hip flexors hold the hips from
   # sagging into extension at full reach (the iliopsoas was not measured),
   # so they stay a primary row at 0.40, the lowest moderate value, as the
   # calfseat family did with the bright gastrocnemius, and the copy never
   # says they work hard. Posterior deltoid: a shoulder extensor (OpenStax:
   # the deltoid also extends the arm), it holds the arms from being drawn
   # further overhead and helps pull the ball back; not measured, LOW 0.30.
   # The latissimus dorsi (Escamilla 2006: the Power Wheel roll-out among the
   # most active exercises for it; Escamilla 2010's conclusion names it for
   # the roll-out and pike, though its results put the roll-out outside the
   # top latissimus group) is not painted, so it is named with the
   # stabilisers. All judgement calls.
   activation=[("Rectus Abdominis", P, HI, 0.82), ("Hip Flexors", P, MOD, 0.40),
               ("Obliques", S, MOD, 0.62), ("Posterior Deltoid", S, LOW, 0.30)],
   stabilisers=["transverse abdominis", "latissimus dorsi", "gluteus maximus"],
   comparison=("HIPS SAGGING", "Knees to shoulders in one line", "Hips drop, lower back arches",
               "With the ribs down and the hips in line, the abs hold the trunk straight while the ball rolls out under the forearms.",
               "Once the hips sag, the long lever bends the body at the hips and lower back instead of the abs holding it straight; shorten the roll until the line holds."),
   glows=[glow(N, ["spine", "chest"], A, 0.55, 0.09, 0.05, 0.0, 0.0),
          glow(N, ["pelvis", "thigh_L"], SOFT, 0.28, 0.05, 0.035, 0.01, 0.01)])

SETUP[N] = [
    "Kneel on a mat with your knees about hip-width apart and a stability ball in front of you.",
    "Rest your forearms on top of the ball, elbows no wider than your shoulders.",
    "Lean forward onto the ball until your trunk is at about 45°, hips slightly bent.",
    "Brace your abs and pull your ribs down before the ball starts to roll.",
]

# ---------------------------------------------------------------- Body Saw

N = "Body Saw"
ex(name=N, var="bodySaw",
   # Three-quarter from the front-left (yaw -0.8), head on the left: the body
   # is a thin band across v ~0.45-0.55 from the fists (u ~0.16) to the toes
   # (u ~0.86), sliding ~0.08 left and right; nothing above it. Three pills
   # above (range and tempo left, the long range pill above so its leader to
   # the near shoulder passes right of the short tempo pill, whose leader
   # drops to the head; hips right) and two below the mat (elbows left,
   # knees right), so every leader meets the body from the open side.
   overrides={"range": (ov(0.20), "leading"), "tempo": (ov(0.30), "leading"),
              "hips": (ov(0.30), "trailing"),
              "elbows": (ov(0.70), "leading"), "knees": (ov(0.70), "trailing")},
   annotations=[
       ("hips", "Hips in line, no sag", "pelvis"),
       ("range", "Shoulders past the elbows", "upper_arm_L"),
       ("elbows", "Forearms planted, parallel", "forearm_L"),
       ("knees", "Knees straight", "patella_L"),
       ("tempo", "Slow, even saw", "head"),
   ],
   cues={
       "hips": ("Body Line",
                "Your body stays straight from head to heels while it slides.",
                "Sliding back takes your elbows further in front of you, lengthening the lever your trunk holds up. NASM's plank coaching names the body saw as a harder anti-extension progression for that reason, and reads sagging hips as the front of the core letting go.",
                "Hips sagging toward the mat as the body slides back.",
                "Squeeze your glutes, pull your ribs down and keep your hips in line between your shoulders and heels through the whole slide."),
       "range": ("Range",
                 "Your shoulders travel from in front of your elbows to behind them, about 20 cm.",
                 "The further your shoulders slide behind your elbows, the longer the lever the abs hold. In an EMG study of a body saw done with the feet in suspension straps, starting from bent knees and sawing back as far as possible, the rectus abdominis reached about 103% of an isometric maximum and the serratus anterior almost 140%.",
                 "Rocking only a few centimetres, the shoulders staying over the elbows.",
                 "Push back until your shoulders are well behind your elbows, as far as the line holds, then pull forward until they are in front again, moving from the shoulders, not the feet."),
       "elbows": ("Forearms",
                  "Your forearms stay planted and parallel, elbows about shoulder-width apart.",
                  "The forearms are the fixed point the body saws over, so they stay put while the shoulders travel over them. NASM's plank setup puts the forearms parallel, and Prehab Guys' body saw keeps the elbows from drifting too far in or out.",
                  "Elbows splayed wide, the forearms angled in.",
                  "Set your forearms parallel, elbows about shoulder-width apart, and press them into the mat for the whole set."),
       "knees": ("Straight Legs",
                 "Your knees stay straight and your toes ride on the sliders.",
                 "Straight legs keep the lever long from shoulders to toes, so the abs carry it instead of bent knees shortening it. Prehab Guys keeps the knees straight and the back flat as the shoulders move the body, and NASM's plank setup engages the quadriceps.",
                 "Bending the knees and letting them drop toward the mat as you slide.",
                 "Tighten your thighs so the legs stay long, toes on the sliders, and let the feet glide only as your shoulders move you."),
       "tempo": ("Tempo",
                 "Each slide takes about a second and a half, with a short pause at each end.",
                 "In the EMG study the body saw was timed to a metronome: two seconds out, a one-second hold, two seconds back. A slow saw keeps the abs holding the line as the lever changes, rather than momentum carrying you through it.",
                 "Sawing fast and bouncing at each end.",
                 "Slide back over a slow count, pause, slide forward, pause, and stop the set when your hips start to sag."),
   },
   # Rectus abdominis bright (PRIMARY); posterior deltoid, obliques and
   # serratus anterior dim. McGill 2015's (suspension-strap) body saw: rectus
   # abdominis 103% MVC at the peak, serratus anterior almost 140%, the
   # external oblique above the internal (the table's 57 vs 24%). The rectus
   # sits HIGH (0.85), between the library Plank's 0.78 and Ab Wheel's 0.88
   # (the library row rates it advanced). The serratus anterior was the most
   # active muscle measured, but it is painted dim, so it stays secondary,
   # MODERATE (0.66), under the rectus (legend-only, as in the library); the
   # obliques MODERATE (0.58), a touch over the Plank's 0.56. The posterior
   # deltoid, a shoulder extensor (OpenStax), pulls the body forward over the
   # elbows from the back end of the saw (mechanics, not measured); as a third
   # secondary row it would overrun the one-line legend (SERRATUS ANTERIOR ·
   # OBLIQUES · POSTERIOR DELTOID, 48 characters), so it is named with the
   # stabilisers, as the stability family did with the dead bug's. All
   # judgement calls.
   activation=[("Rectus Abdominis", P, HI, 0.85), ("Serratus Anterior", S, MOD, 0.66),
               ("Obliques", S, MOD, 0.58)],
   stabilisers=["posterior deltoid", "transverse abdominis", "quadriceps", "gluteus maximus"],
   comparison=("HIPS SAGGING", "Straight line, head to heels", "Hips sink as the body slides back",
               "With the glutes tight and the ribs down, the abs hold the body straight while the shoulders saw it back and forth over the elbows.",
               "When the hips sag, the longer lever wins and the lower back arches; NASM reads it as the front of the core letting go, so shorten the slide."),
   glows=[glow(N, ["spine", "chest"], A, 0.55, 0.09, 0.03, 0.0, 0.0),
          glow(N, ["upper_arm_L", "scapula_L"], SOFT, 0.28, 0.04, 0.03, 0.0, 0.01)])

SETUP[N] = [
    "Kneel on a mat and put a slider under the toes of each foot.",
    "Set your forearms on the mat, parallel, elbows about shoulder-width apart.",
    "Step your legs back one at a time, toes on the sliders, feet about hip-width apart.",
    "Brace into a straight forearm plank, shoulders a little ahead of your elbows, before the first slide.",
]

# ---------------------------------------------------------------- Bear Crawl

N = "Bear Crawl"
ex(name=N, var="bearCrawl",
   # Three-quarter from the front-left (yaw -0.8), head on the left: the
   # back runs across v ~0.39-0.43, the hands sit on the mat at v ~0.58-0.61,
   # the hovering knees at v ~0.57 and the feet at v ~0.52-0.58 on the right;
   # the stepping limbs move ~0.03-0.06 on screen. Two pills above the back
   # (back left, to the lumbar spine; hips right, to the near hip) and three
   # below: pair (to the far, right hand) and hands (to the near, left hand)
   # left, the short pair pill above so the hands leader rises past its end;
   # knees right. Round 1 had the hands pill top left at 0.31, to the near
   # shoulder: in the lifted mistake view the shoulder sat at the pill's end.
   overrides={"back": (ov(0.24), "leading"), "hips": (ov(0.26), "trailing"),
              "pair": (ov(0.69), "leading"), "hands": (ov(0.78), "leading"),
              "knees": (ov(0.74), "trailing")},
   annotations=[
       ("knees", "Knees hover, low", "patella_L"),
       ("back", "Back flat and level", "spine"),
       ("hips", "Hips square, no rocking", "thigh_L"),
       ("pair", "Opposite hand, foot", "hand_R"),
       ("hands", "Hands under shoulders", "hand_L"),
   ],
   cues={
       "knees": ("Knee Height",
                 "Your knees hover a few centimetres off the mat, under your hips.",
                 "With the knees off the floor your thighs and abs hold the body up instead of the knees resting on it. In an EMG study of the bear crawl the knees were raised only slightly off the ground, and raising the hips into the air or dropping the knees to the ground counted as lost form.",
                 "Pushing the hips up into the air, knees high off the mat.",
                 "Lift your knees just clear of the mat, about 4 cm here, keep them under your hips and hold that height while you crawl."),
       "back": ("Flat Back",
                "Your back stays flat and level, hips and shoulders at the same height.",
                "ACE's bear crawl keeps the back straight with the hips and shoulders at the same height, and the University of Calgary's injury-prevention coaching lists a sagging lower back and a rounded upper back among the faults. Prehab Guys' cue is a cup of water on your lower back that must not spill.",
                "The lower back sagging toward the mat between the arms and legs.",
                "Brace your abs and keep your back flat from shoulders to hips, your head about in line with it."),
       "hips": ("Level Hips",
                "Your hips stay square to the floor while a foot is up.",
                "Each step leaves one hand and the opposite foot holding you, so the trunk muscles have to stop the hips rolling toward the lifted side. Calgary's coaching warns against hips dipping side to side, and in an EMG study of the bear crawl the external oblique was the most active of the four muscles measured.",
                "The hip on the side of the lifted foot dipping or rolling as you step.",
                "Keep both hip bones pointing at the mat as each foot lifts, and take smaller steps if your hips rock."),
       "pair": ("Opposite Limbs",
                "The right hand and left foot step together, then the left hand and right foot.",
                "Stepping a hand and the opposite foot together leaves the other diagonal pair holding you, and it is how ACE, Calgary's coaching and Prehab Guys set the crawl up. The EMG study stepped the right hand and left foot, then the left hand and right foot.",
                "Stepping with the hand and foot of the same side.",
                "Move the right hand and left foot a short step together, set them down, then the left hand and right foot; crawl back the same way."),
       "hands": ("Hand Position",
                 "Your hands land about under your shoulders with the arms nearly straight; each step here is about 14 cm.",
                 "Stacked under the shoulders, the arms take your weight straight down, so the shoulders and trunk can hold still while a hand lifts. The EMG study set the wrists under the shoulders, set each stepping hand down half a hand's length from the other, and counted bent elbows as lost form.",
                 "Reaching the hands far out in front of the shoulders.",
                 "Set each hand under its shoulder with the arm long, take short, slow steps, and push the floor away."),
   },
   # Anterior deltoid and rectus abdominis bright (PRIMARY); obliques,
   # quadriceps (rectus femoris and vasti), sartorius (Hip Flexors) and
   # triceps dim. Pyka 2017's crawl: rectus femoris 52%, rectus abdominis 24%,
   # external oblique 140%, erector spinae 12% MVC (each muscle normalised to
   # the largest of its maximal efforts); no deltoid or triceps measured.
   # The anterior deltoid holds each arm forward under its shoulder with the body's weight on it and swings the
   # hand forward (shoulder flexion; OpenStax: the deltoid flexes the arm), so
   # it sits MODERATE (0.58), a little over the library Push-Up's secondary
   # 0.52, level with the rectus abdominis (0.58: moderate, under the Plank's
   # 0.78 and the Dead Bug's 0.68, as Pyka's crawl had the rectus abdominis
   # at only 24% MVC, under the rectus femoris and external oblique). The
   # obliques (0.54) were the most active muscle in the EMG but are painted
   # dim, so they stay secondary, just under the two bright rows; the
   # quadriceps (0.50) hold the bent knees off the floor (Pyka's rectus
   # femoris 52%); the hip flexors (0.40) swing each foot forward (the hip
   # flexes 86 -> 76 deg in the step; the rectus femoris is one). The triceps,
   # painted dim, keep the supporting elbows nearly straight; a fourth
   # secondary row would overrun the one-line legend, so they are named with
   # the stabilisers. All judgement calls.
   activation=[("Anterior Deltoid", P, MOD, 0.58), ("Rectus Abdominis", P, MOD, 0.58),
               ("Obliques", S, MOD, 0.54), ("Quadriceps", S, MOD, 0.50), ("Hip Flexors", S, MOD, 0.40)],
   stabilisers=["triceps", "serratus anterior", "transverse abdominis"],
   comparison=("HIPS UP", "Knees hover, back flat", "Hips pushed up, knees high",
               "With the knees just off the mat and the back flat, the shoulders, abs and thighs hold the body still while opposite limbs step.",
               "Pushing the hips up shortens the lever and takes work off the abs; the EMG study counted hips raised into the air as lost form."),
   glows=[glow(N, ["spine", "chest"], A, 0.50, 0.08, 0.03, 0.0, 0.015),
          glow(N, ["upper_arm_L", "scapula_L"], A, 0.45, 0.035, 0.03, 0.0, 0.01),
          glow(N, ["patella_L", "thigh_L"], SOFT, 0.25, 0.03, 0.05, 0.0, 0.0)])

SETUP[N] = [
    "Kneel on a mat on all fours, hands under your shoulders and knees under your hips.",
    "Tuck your toes under so the balls of your feet are on the mat.",
    "Brace your abs and lift your knees a few centimetres off the mat, back flat.",
    "Crawl a few short steps forward, opposite hand and foot together, then crawl back.",
]
