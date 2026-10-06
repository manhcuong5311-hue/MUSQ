# Trainer content for the 401-500 folder (2026-10-04), family: calfstand.
# Seven straight-knee calf raises from the builder's 401-414 exports: 414
# Bodyweight Standing Calf Raise (Legs/BodyweightCalfRaise), 401 Dumbbell
# Standing Calf Raise (Legs/DumbbellStandingCalfRaise), 403 Single-Leg
# Dumbbell Calf Raise (Legs/SingleLegDumbbellCalfRaise), 411 standing
# single-leg machine calf raise (Legs/SingleLegMachineCalfRaise), 404 Donkey
# Calf Raise (Legs/DonkeyCalfRaise), 405 Machine Donkey Calf Raise
# (Legs/MachineDonkeyCalfRaise) and 406 Hack Squat Calf Raise
# (Legs/HackSquatCalfRaise). Same format as spec.py on top of common_1_50.py;
# spec_500.py imports this module and gen.py reads SPEC / SETUP.
# notes_500_calfstand.md maps the copy's claims to the sources below and
# records the model facts.
#
# What the models show, from the briefs (SCRATCH/briefs_legs), the trainer
# stills at 0/1/2/3/5 s (SCRATCH/stills), tiers30.json, joints.json and the
# rigs, equipment and skinned shoes read from the USD with Blender's Python +
# pxr (SCRATCH/calfstand/measure.py, heel.py, track.py; the app's Y-up space,
# the lifter facing +z, their left +x). Ankle angles below are the rig's
# shin-to-foot-bone angle (the foot bone runs from the ankle joint to the
# ball of the foot): it reads ~106° with the sole flat on the floor and the
# shin ~6° forward, since the bone already points 21° down there, so a reading
# under ~106° means the heel is below the ball of the foot; neutral (the foot
# at 90° to the tibia, Kassiano 2023's 0°) is taken as ~109°, as the calfseat
# family measured it. These rigs have
# toe joints (toe_L/R, the ball of the foot, ~15 cm from the ankle), which the
# ghosts use as the pivot. Every clip is 7.96 s with two identical reps: heels
# lowest to 0.08 s, rising 0.12-0.88 s (~0.8 s), held at the top 0.92-2.12 s
# (~1.2 s), lowered 2.17-3.33 s (~1.2 s), resting at the bottom 3.38-4.08 s
# (~0.7 s), then again. Knees 173-176° (straight, not locked) in all seven.
# - Bodyweight Standing Calf Raise: on a flat floor, no equipment, feet
#   hip-width (ankles 0.20 m apart, toes ~6° out), arms hanging at the sides
#   (elbows 170°), trunk upright. Ankle 106° -> 142°; the heels rise ~12 cm
#   (the skinned heel 1 -> 13 cm up) and come back down onto the floor each
#   rep; the body rises ~7 cm and drifts ~10 cm forward over the balls of the
#   feet. No step, so no stretch below level. Paint: gastrocnemius (both
#   heads) and soleus bright, nothing dim.
# - Dumbbell Standing Calf Raise: the same stance, floor and motion with a
#   dumbbell in each hand at the sides, arms straight (176°), the handles
#   running front to back (palms facing the thighs). ExRx's dumbbell standing
#   raise uses one dumbbell, a calf block and a hand on a support; the model
#   holds two and stands on the floor. Paint: calves bright; dim the forearm
#   flexors and extensors, brachioradialis, upper, middle and lower trapezius,
#   rhomboid major and the hamstrings.
# - Single-Leg Dumbbell Calf Raise: the LEFT leg works. The ball of the left
#   foot on the back edge of a 15 cm step (0.8 x 0.19 m), heel off it. At the
#   bottom the heel sinks ~5 cm below the step's top (ankle 88°, ~18° below
#   flat); at the top it is ~13 cm above it (141°). A dumbbell in the LEFT
#   hand, arm straight at the side; the RIGHT hand holds a 1.43 m post set
#   ahead and to the right, at 1.30 m, below the shoulder (elbow 73° at the
#   bottom, 97° at the top as the body rises away from it). The right knee is
#   bent 129°, its foot hanging ~30 cm behind the left heel and ~36 cm off the
#   floor. Hips over the left foot (pelvis 8 cm left of centre), trunk
#   upright. Paint: calves bright; the dumbbell set (forearms, trapezius,
#   rhomboid, hamstrings) only faint. Unlike the library's Single-Leg Calf
#   Raise (22 cm step, heel stops level, a balance handle), the heel here
#   drops below the step.
# - Single-Leg Machine Calf Raise: the LEFT leg works on a standing calf
#   machine (GYM_M24): the shoulders under two pads on a lever pivoted behind,
#   the hands on handles in front of the shoulders (elbows 43°), the ball of
#   the left foot on the back edge of a toe block (top 17 cm up, on a 6 cm
#   platform). Bottom ankle 85° (the heel ~5 cm below the block's top, ~21°
#   below flat), top 145°. The body rises ~12 cm straight up with the pads;
#   the stack rises ~7 cm. The right knee bent 129°, the foot hanging ~28 cm
#   behind and clear of the block. Trunk 2° forward. Paint: calves only.
# - Donkey Calf Raise: hinged at the hips with the forearms flat on a padded
#   column 0.87 m high (elbows 95°, hands palm down), the balls of both feet
#   on the back edge of a 12 cm block, heels off; no partner or added load.
#   Knees 173-174°. As the heels rise the hips rise ~9 cm while the shoulders
#   stay on the pad, so the hips close from 109° to 91° and the trunk tips
#   from ~24° to ~14° above level (ExRx: torso about parallel to the floor).
#   Ankle 96° (heels ~4 cm below the block's top, ~10° below flat) -> 155°.
#   Paint: calves bright, hamstrings dim.
# - Machine Donkey Calf Raise: the same body and motion 5 cm higher, on the
#   GYM_M24 frame: the lever's two pads rest across the lower back and hips
#   (1.19-1.28 m up, over the lumbar spine and pelvis), the forearms on a
#   separate pad 0.92 m up, the balls of the feet on the machine's toe block
#   (top 17 cm up), heels ~4 cm below it at the bottom. The stack rises ~8 cm.
#   Paint: calves bright, hamstrings dim.
# - Hack Squat Calf Raise: on a hack squat machine (GYM_M15), BACK on the
#   back pad and facing out, reclined 35° from vertical, the shoulders under
#   the shoulder pads, the hands on the handles beside the head (elbows
#   27-37°). The balls of the feet sit on the lower (back) edge of the
#   footplate, which slopes up 15° toward the front; heels and arches hang off
#   it. Knees 175°, hips 144° -> 152°. Ankle 77° (the heels ~9 cm below the
#   plate's edge, the deepest stretch of the seven) -> 138°; the sled rides
#   ~14 cm up its rails. Paint: calves bright; quadriceps and hamstrings dim.
#   ExRx calls this the Sled Hack Calf Press.
#
# How they differ from the library: the Standing Calf Raise (machine, both
# legs, heels stop level with the block), Single-Leg Calf Raise (dumbbell,
# 22 cm step, heel stops level, balance handle), Smith Machine Calf Raise,
# Leg Press Calf Raise and Seated Calf Raise. Two of the new seven stay on
# the floor (no stretch below level at all), and the other five drop the
# heels below the support, which none of the library's calf models does; the
# donkey pair hinge at the hips; the hack squat version rides a sled
# reclined 35°. Each cue set is its own: foot pressure, knees, top, floor,
# lowering speed (bodyweight); dumbbell position, knees, top, floor, tempo
# (dumbbell); balance hand, level hips, knee, top, stretch (single-leg
# dumbbell); body under the pads, free leg, knee, top, stretch (single-leg
# machine); hinge, back, knees, top, stretch (donkey); pad, back, knees, top,
# stretch (machine donkey); feet, back on the pad, knees, top, stretch (hack).
#
# Sources (abstracts read on Europe PMC / PubMed records 2026-10-04, ExRx on
# the Wayback Machine; details and what each supports in the notes):
# - ExRx.net (Wayback Machine; the live site returns 403): Standing Calf Raise
#   (bodyweight, BWStandingCalfRaise, snapshot 2025-07-02), Dumbbell Standing
#   Calf Raise (DBStandingCalfRaise, 2023-05-31), Dumbbell Single Leg Calf
#   Raise (DBSingleLegCalfRaise, 2023-06-09), Single Leg Calf Raise
#   (bodyweight, BWSingleLegCalfRaise, 2025-07-02), Lever Standing Calf Raise
#   (LVStandingCalfRaise, 2023-04-07), Weighted Donkey Calf Raise
#   (WTDonkeyCalfRaise, 2023-05-31), Lever Donkey Calf Raise
#   (LVDonkeyCalfRaise, 2024-01-05), Sled Donkey Calf Raise
#   (SLDonkeyCalfRaise, 2023-12-27), Sled Hack Calf Press (SLHackCalfPress,
#   2019-09-17), Calf Exercise Analyses (Kinesiology/CalfExercises,
#   2024-01-05) and the Gastrocnemius, Soleus, Hamstrings and Gluteus Medius
#   muscle pages (2024-01-05): set-ups, execution, target gastrocnemius and
#   synergist soleus on every page, stabilisers; keep the knees straight or
#   bend them slightly only during the stretch (quadriceps then synergists);
#   the dumbbell raises' stabilisers (upper and middle trapezius, levator
#   scapulae, gluteus medius and minimus; on one leg also quadratus lumborum
#   and obliques); a hand on a support for balance and a lighter load if the
#   hands have to help; assisting with the other leg as an easier version;
#   the donkey's torso about parallel to the floor, the lever pad on the
#   lower back and hips set just below the lowest point; the hack calf press
#   lying on the sled with the balls of the feet on the lower portion of the
#   platform; the analyses page on the hard top of a calf raise (the ankle
#   cannot lock out), load carried forward easing the top, the heel resting
#   on the floor, and hip flexion with straight knees stretching the
#   hamstrings (lumbar flexion or a knee bend at the bottom in those with
#   tight hamstrings); the gastrocnemius rising from the femoral condyles and
#   the soleus from the tibia and fibula; the gluteus medius steadying the
#   pelvis so it does not sag on the unsupported side.
# - Kassiano W, Costa B, Kunevaliki G, et al. 2023, J Strength Cond Res
#   37(9):1746-1753, doi:10.1519/JSC.0000000000004460, PMID 37015016 - 42
#   young women, 8 weeks of calf raises on a horizontal leg press: training
#   only the lower range (ankle 25° dorsiflexed to neutral) grew the medial
#   gastrocnemius more than the full or upper range (15.2% vs 6.7% vs 3.4%)
#   and the lateral head more than the upper range (14.9% vs 6.2%; vs full
#   7.3%, not significant).
# - Kinoshita M, Maeo S, Kobayashi Y, et al. 2023, Front Physiol 14:1272106,
#   doi:10.3389/fphys.2023.1272106, PMID 38156065 (PMC10753835) - 14 untrained
#   adults, one leg standing (knee straight), the other seated (knee 90°), 12
#   weeks: gastrocnemius volume grew far more standing (lateral 12.4% vs
#   1.7%, medial 9.2% vs 0.6%); the soleus grew similarly (2.1% vs 2.9%).
# - Signorile JF, Applegate B, Duque M, Cole N, Zink A 2002, J Strength Cond
#   Res 16(3):433-439, PMID 12173959 - 11 experienced subjects: medial
#   gastrocnemius above the soleus at a straight knee (180°); the soleus lower
#   at 180° than at 90° or 135°.
# - Cresswell AG, Loscher WN, Thorstensson A 1995, Exp Brain Res
#   105(2):283-290, doi:10.1007/BF00240964, PMID 7498381 - as the knee bent,
#   gastrocnemius EMG fell at the same effort while soleus EMG held; the
#   gastrocnemius gives at least 40% of plantar flexor torque with the leg
#   straight.
# - Price TB, Kamen G, Damon BM, et al. 2003, Magn Reson Imaging
#   21(8):853-861, doi:10.1016/s0730-725x(03)00183-8, PMID 14599535 - at 25%
#   1RM with the knee straight only the gastrocnemius heads (and peroneus)
#   showed on MRI; with the knee at 90° only the soleus.
# - Hebert-Losier K, Schneiders AG, Garcia JA, Sullivan SJ, Simoneau GG 2012,
#   J Strength Cond Res 26(11):3124-3133, doi:10.1519/JSC.0b013e31824435cf,
#   PMID 22190157 - 48 adults, one-leg heel raises: triceps surae 23% MVIC
#   with the knee straight; at 45° the soleus 4% higher and the gastrocnemius
#   5% lower.
# - Gentil P, Souza D, Santana M, et al. 2020, Int J Environ Res Public
#   Health 17(24):9487, doi:10.3390/ijerph17249487, PMID 33352879
#   (PMC7765981) - 22 trained men, 10RM standing machine calf raise, knees
#   straight: mean EMG of the lateral and medial gastrocnemius and soleus
#   50.7%, 52.2% and 51.3% of each muscle's own peak in the tests (full text:
#   normalised to each muscle's maximum), so the soleus works substantially
#   with the knee straight; a normalisation that does not rank the muscles.
# - Kawakami Y, Muraoka T, Ito S, Kanehisa H, Fukunaga T 2002, J Physiol
#   540(Pt 2):635-646, doi:10.1113/jphysiol.2001.013459, PMID 11956349 - in a
#   dip-and-push plantar flexion the gastrocnemius fascicles worked almost
#   isometrically while the tendon stored and released elastic energy.
# - Nakamura M, Kamazawa T, Sato S, Yosida R, Nosaka K 2025, Eur J Appl
#   Physiol 125(9):2625-2635, doi:10.1007/s00421-025-05782-6, PMID 40229595 -
#   15 sedentary men, 8 weeks of bodyweight calf raises: both legs raised the
#   heels in 1 s, one leg alone lowered them in 3 s; that leg gained plantar
#   flexor strength (32.9%), triceps surae thickness (9.1%) and dorsiflexion
#   range (30.4%), the raise-only leg none.
# - Kim J, Kang S, Kim SJ 2022, Sci Rep 12:10796,
#   doi:10.1038/s41598-022-14313-8, PMID 35750787 (PMC9232603) - five
#   healthy men, one- and two-leg heel raises (full text): raises with the
#   ankle everted (weight toward the big toe) drew more peroneus longus EMG
#   in the rise than raises with it inverted (rolled onto the outside edge
#   of the foot); its introduction, citing earlier work, says the soleus and
#   gastrocnemius work well either way and the peroneus longus supports the
#   lateral ankle ligaments.
# - Akuzawa H, Imai A, Iizuka S, Matsunaga N, Kaneoka K 2017, Phys Ther Sport
#   28:23-28, doi:10.1016/j.ptsp.2017.08.077, PMID 28950148 - tibialis
#   posterior, peroneus longus and flexor digitorum longus work in heel
#   raises, their share changing with foot position (the stabiliser rows).
# No EMG study of these seven exact lifts was found, so every fraction below
# is a judgement call. The calf fractions follow the library's knee-straight
# values (Gastrocnemius 0.86, Soleus 0.66; the studies above give the order
# with the knee straight, not the numbers) for the loaded raises and are set
# a little lower for the two unloaded ones; every secondary fraction is a
# low, paint-led judgement for a minor role (gripping, holding the shoulders
# still, or a muscle that is stretched rather than lifting; see the notes).
from common_1_50 import *


def ov(final):
    """Pre-squeeze override row for an on-screen row (spec_500.row() maps
    0.14-0.86 to 0.16-0.80)."""
    return round(0.14 + (final - 0.16) * (0.86 - 0.14) / (0.80 - 0.16), 4)


def calves(name, dx=0.015, dy=0.0, rx=0.045, ry=0.07, near="L", both=True):
    """The calves between knee and ankle, nudged toward the back of the shin
    (to the right on the screen-left-facing framings): the near (left) calf
    full, the far one soft. One-leg raises (`both=False`) glow only the
    working (left) calf; the right leg hangs relaxed."""
    far = "R" if near == "L" else "L"
    out = [glow(name, [f"shin_{near}", f"foot_{near}"], A, 0.55, rx, ry, dx, dy)]
    if both:
        out.append(glow(name, [f"shin_{far}", f"foot_{far}"], SOFT, 0.32, rx * 0.9, ry * 0.9, dx, dy))
    return out


# Knee straight, loaded: the library's Standing Calf Raise values. Both are
# painted bright, so both are PRIMARY; the gastrocnemius leads with the knee
# straight (Signorile 2002, Price 2003, Hebert-Losier 2012, Cresswell 1995),
# the soleus still works substantially (Gentil 2020: ~51% of its own peak,
# as the gastrocnemius heads, a normalisation that does not rank them;
# Kinoshita 2023: it grew about as much standing as seated). The split is a
# judgement; the studies give the order, not the numbers.
LOADED = [("Gastrocnemius", P, HI, 0.86), ("Soleus", P, MOD, 0.66)]
# Two legs and no added load: each calf lifts about half the body weight,
# less than the loaded raises, so a little lower (a judgement call; no EMG
# compares them; Hebert-Losier 2012 measured 23% MVIC for one-leg bodyweight
# raises, which carry the whole body on one calf).
UNLOADED = [("Gastrocnemius", P, HI, 0.78), ("Soleus", P, MOD, 0.60)]
FOOT = ["tibialis posterior", "peroneals"]

# ---------------------------------------------------------------- Bodyweight Standing Calf Raise

N = "Bodyweight Standing Calf Raise"
ex(name=N, var="bodyweightStandingCalfRaise",
   # Side-on from the front-left (yaw -1.3), facing screen-left, the body
   # in a narrow column down the middle (u ~0.40-0.65), nothing else in the
   # frame. Short pills, so none reaches the calves or torso: tempo right of
   # the head; knees, toes and top on the left, the toes label above the top
   # label so their leaders, both ending at the balls of the feet, do not
   # cross; the floor label right of the heels with a short leader.
   overrides={"tempo": (ov(0.24), "trailing"), "knees": (ov(0.56), "leading"),
              "toes": (ov(0.72), "leading"), "top": (ov(0.80), "leading"),
              "floor": (ov(0.80), "trailing")},
   annotations=[
       ("toes", "Over the big toes", "toe_R"),
       ("knees", "Knees straight", "patella_L"),
       ("top", "Rise high, hold", "toe_L"),
       ("floor", "Heels touch down", "foot_L"),
       ("tempo", "Lower slowly", "chest"),
   ],
   cues={
       "toes": ("Foot Pressure",
                "Rise straight up over the big and second toes.",
                "Rolling onto the little-toe side as you rise tips the ankles outward. In a small heel-raise study, raises rolled that way drew less work from the peroneus longus, the muscle down the outside of the lower leg that steadies the ankle, than raises with the weight toward the big toe.",
                "Rolling onto the outside edges of the feet at the top, the ankles bowing outward.",
                "Keep your weight over the balls of the feet behind the big and second toes and let the heels rise straight up behind them."),
       "knees": ("Straight Knees",
                 "The knees stay straight on the way up and the way down.",
                 "The gastrocnemius starts above the knee, so it pulls hardest with the knee straight. In studies that bent the knee, its activity fell while the soleus kept working. A dip at the knees also lets the thighs spring you up instead of the calves.",
                 "Dipping the knees at the bottom and springing up with the thighs.",
                 "Straighten your knees without locking them hard before the first rep, and move only at the ankles."),
       "top": ("Top of the Rep",
               "Rise as high as the ankles allow and hold it for about a second.",
               "The ankle cannot lock out the way a knee or an elbow does, so the calves still hold your weight at the top, and ExRx notes the top of a calf raise stays hard for that reason. Holding there finishes each rep where the work is.",
               "Turning back down with the heels only partway up.",
               "Push through the balls of the feet until the heels are as high as they go, then hold for about a second before lowering."),
       "floor": ("Bottom of the Rep",
                 "Lower until the heels touch the floor on every rep.",
                 "On flat ground the heels stop at the floor, so touching down is the whole range this version has; hovering above it trims every rep. Once it gets easy, standing with the balls of the feet on a step lets the heels sink below level, and in an eight-week calf-raise study training that stretched range grew the gastrocnemius more than training the range above it.",
                 "Staying up on the toes between reps, the heels never reaching the floor.",
                 "Lower until your heels touch the floor lightly, rest there for a moment, then rise again."),
       "tempo": ("Lowering Speed",
                 "Take longer to lower than to rise.",
                 "In an eight-week study of bodyweight calf raises, both legs pushed the heels up, then one leg lowered them alone over three seconds. That leg gained strength and calf thickness; the leg that only pushed up did not. The way down is part of the work, not a rest, so take it slowly.",
                 "Dropping straight back to the floor after each rise.",
                 "Rise in under a second, hold the top, then take a slower count to lower and touch down softly."),
   },
   # Paint: gastrocnemius and soleus bright, nothing dim. UNLOADED (two legs,
   # body weight only; see above).
   activation=UNLOADED,
   stabilisers=FOOT + ["toe flexors", "core"],
   comparison=("ROLLING OUT", "Weight over the big toes", "Ankles roll out at the top",
               "Rising straight over the big and second toes keeps the ankles square, and the peroneus longus down the outside of the leg works with the calves.",
               "Rolling onto the outside edges tips the ankles out, and in a small heel-raise study that drew less work from the peroneus longus."),
   glows=calves(N))

SETUP[N] = [
    "Stand on a flat floor, feet about hip-width apart, toes pointing forward.",
    "Let your arms hang by your sides; rest a hand on a wall if you wobble.",
    "Straighten your knees without locking them hard.",
    "Stand tall with your weight spread over the whole foot.",
]

# ---------------------------------------------------------------- Dumbbell Standing Calf Raise

N = "Dumbbell Standing Calf Raise"
ex(name=N, var="dumbbellStandingCalfRaise",
   # As the Bodyweight Standing Calf Raise, with a dumbbell hanging beside
   # each hip (the near one across u ~0.36-0.70 at v ~0.50, its long axis
   # front to back). The arms label sits left, its leader over the dumbbell's
   # front plate to the wrist; the rest as the bodyweight raise. The arms
   # pill is short (the review's lab shots showed the longer Dumbbells at
   # sides over the far dumbbell's front plate at the top of the rep, whose
   # left edge comes out to u ~0.30, and Hang at sides only ~3 pt clear of
   # it); at 0.44 it also stays below the ghost's swung hands (u 0.27,
   # v 0.39) in the arms fault.
   overrides={"arms": (ov(0.44), "leading"), "knees": (ov(0.60), "leading"),
              "tempo": (ov(0.24), "trailing"), "top": (ov(0.80), "leading"),
              "floor": (ov(0.80), "trailing")},
   annotations=[
       ("arms", "Hang still", "hand_L"),
       ("knees", "Knees straight, soft", "patella_L"),
       ("top", "Heels high, hold", "toe_L"),
       ("floor", "Heels back down", "foot_L"),
       ("tempo", "No bouncing", "chest"),
   ],
   cues={
       "arms": ("Dumbbell Position",
                "The dumbbells hang straight down beside your hips.",
                "Hanging at your sides, the dumbbells load you straight down through the ankles. ExRx notes that load carried slightly forward of the feet makes the top of a calf raise a little easier, so letting the dumbbells swing forward takes work off the calves where the rep is hardest, and pulls you off balance.",
                "Letting the dumbbells swing forward in front of the thighs as you rise.",
                "Hold the dumbbells with straight arms, palms facing your thighs, and keep them beside your hips from the bottom of the rep to the top."),
       "knees": ("Straight Knees",
                 "The knees stay straight but soft while the dumbbells go up and down.",
                 "The gastrocnemius crosses the back of the knee, so it works best with the knee straight. Bending the knees at the bottom shortens it and lets the thighs bounce the dumbbells up; ExRx notes the quadriceps join in once the knees bend.",
                 "Bending the knees to bounce the dumbbells up out of the bottom.",
                 "Keep the knees straight but not jammed back, and lift the dumbbells with your ankles alone."),
       "top": ("Top of the Rep",
               "Finish high on the balls of the feet and pause.",
               "A calf raise moves through a short range, and its top end is where the calves are shortest and the ankle never locks out. Rising all the way and pausing there makes every rep use that end of the range instead of turning back early.",
               "Stopping each rise with the heels only partway up.",
               "Rise until the heels are as high as they go, pause for about a second with the dumbbells still at your sides, then lower."),
       "floor": ("Bottom of the Rep",
                 "The heels come all the way back to the floor each rep.",
                 "On the floor the heels can only come down to level, so touching down every rep is the least to aim for. ExRx sets this lift up with the balls of the feet on a calf block so the heels can drop lower, and in an eight-week study training that stretched range below a flat foot grew the gastrocnemius more than training the range above it.",
                 "Keeping the heels off the floor between reps, so each rep stays near the top.",
                 "Lower under control until your heels touch the floor, rest for a moment, then rise."),
       "tempo": ("Tempo",
                 "Lower in a controlled way and rest on the floor; never bounce.",
                 "Dropping fast and bouncing straight back up lets the Achilles tendon stretch and recoil. In a quick dip-and-push ankle movement the calf muscle fibres stayed nearly the same length while the tendon stored and returned the energy, so a bounce hands part of the rep to the tendon.",
                 "Dropping the heels fast and bouncing straight back up.",
                 "Rise in about a second, hold the top, take a little longer to lower and let the heels settle before the next rep."),
   },
   # Paint: calves bright (PRIMARY, LOADED). Dim: the forearms (grip), the
   # trapezius with the rhomboid, and the hamstrings -> three LOW secondary
   # rows for minor holding roles; none of them moves the load. Forearms
   # 0.30 as the library's dumbbell lunges (gripping the dumbbells; no EMG).
   # Trapezius 0.28: holding the shoulders up under the dumbbells; ExRx lists
   # the upper and middle trapezius and levator scapulae as this lift's
   # stabilisers (no EMG). Hamstrings 0.15: painted dim, no source measures
   # them in a calf raise; a paint-led judgement, the lowest row. The rhomboids, lit with the
   # trapezius, are named in the stabilisers: a fourth secondary name would
   # run the one-line legend past its ~43 characters.
   activation=LOADED + [("Forearms", S, LOW, 0.30), ("Trapezius", S, LOW, 0.28), ("Hamstrings", S, LOW, 0.15)],
   stabilisers=["rhomboids", "levator scapulae", "gluteus medius"] + FOOT,
   comparison=("DUMBBELLS SWINGING", "Dumbbells still at your sides", "Dumbbells swing forward",
               "With the dumbbells hanging beside your hips the calves carry the load straight up, all the way to the top.",
               "Swinging them forward moves the load ahead of the feet, which eases the top of the rep and tips you off balance."),
   glows=calves(N) + [glow(N, ["forearm_L", "hand_L"], SOFT, 0.25, 0.03, 0.05, 0.0, 0.0)])

SETUP[N] = [
    "Stand on a flat floor, feet about hip-width apart, toes forward.",
    "Hold a dumbbell in each hand at your sides, palms facing your thighs.",
    "Stand tall with straight arms and your shoulders down.",
    "Keep your knees straight but not locked.",
]

# ---------------------------------------------------------------- Single-Leg Dumbbell Calf Raise

N = "Single-Leg Dumbbell Calf Raise"
ex(name=N, var="singleLegDumbbellCalfRaise",
   # Facing screen-left (yaw -1.3): the post rises on the left (u ~0.30),
   # the right hand on it at u 0.36, v 0.39; the dumbbell beside the left hip;
   # the step low left under the working foot; the free leg hangs back to
   # the right (foot u ~0.65, v ~0.73). All but the bottom label sit on the
   # left, in front of the lifter, so no leader crosses the dumbbell arm or
   # the hanging leg. At the top of the rep the body drifts ~10 cm forward
   # and hides the right hand and the post behind the chest (hand_R stays at
   # u 0.36, v 0.39, a little inside the belly's front edge even at the
   # bottom). Any leader to it crosses the front of the chest at the top;
   # the post pill sits at 0.24, which keeps that run shorter than from the
   # draft's 0.16 (where it ran down the whole chest), clears the head and
   # chest by ~15 pt and, in the lean fault's front view, sits beside the
   # post's top, clear of the ghost's arm and hand (u 0.26, v 0.30).
   overrides={"post": (ov(0.24), "leading"), "hips": (ov(0.40), "leading"),
              "knee": (ov(0.60), "leading"), "top": (ov(0.72), "leading"),
              "bottom": (ov(0.80), "trailing")},
   annotations=[
       ("post", "Light grip", "hand_R"),
       ("hips", "Hips level", "pelvis"),
       ("knee", "Knee straight", "patella_L"),
       ("top", "Rise high, hold", "toe_L"),
       ("bottom", "Heel below the step", "foot_L"),
   ],
   cues={
       "post": ("Balance Hand",
                "The right hand holds the post only to stay steady.",
                "ExRx sets up one-leg calf raises with a hand on a support for balance, and advises a lighter load if the hand has to help. The post sits below your shoulder, so any help comes from leaning on it and pushing down, which takes body weight off the working calf.",
                "Leaning toward the post and pressing down on it to help the heel up.",
                "Rest your right hand on the post with a loose grip and a relaxed elbow and stay upright over the left foot. If you find yourself pushing, drop to a lighter dumbbell."),
       "hips": ("Level Hips",
                "Both hips stay level while you balance on the left foot.",
                "On one leg the gluteus medius of the standing side holds the pelvis up; ExRx describes it steadying the pelvis so it does not sag on the side with no leg under it. Level hips keep your weight over the left foot, so the left calf does the lifting.",
                "The right hip sagging toward the floor as the left heel rises.",
                "Firm up the left hip and keep both hip bones level, the right leg hanging relaxed behind you."),
       "knee": ("Working Knee",
                "The left knee stays straight; only the ankle moves.",
                "The left gastrocnemius runs from above the knee to the heel, so a straight knee keeps it long enough to pull hard. Bending the knee in the stretch shortens it and lets the thigh spring you back up.",
                "Bending the left knee in the stretch, then straightening it to drive up.",
                "Keep the left knee straight but soft from the bottom of the rep to the top."),
       "top": ("Top of the Rep",
               "Rise onto the ball of the left foot as high as it goes and hold.",
               "At the top one calf holds your whole body and the dumbbell, and because the ankle never locks out it keeps working there. Reaching the top and holding for a second makes each rep use the whole range.",
               "Turning back down with the left heel only partway up.",
               "Push through the ball of the left foot until the heel is as high as it goes, hold for about a second, then lower."),
       "bottom": ("Stretch at the Bottom",
                  "Let the left heel sink below the step on every rep.",
                  "Here the heel drops a few centimetres below the step, into the stretched range. In an eight-week calf-raise study, training only the range below a flat foot grew the gastrocnemius more than training only the range above it. Stopping level with the step leaves that part out.",
                  "Stopping with the heel level with the step, never letting it sink below.",
                  "Lower slowly until the heel is below the step and the calf feels stretched, pause there briefly, then rise."),
   },
   # Paint: calves bright (PRIMARY, LOADED: one leg carries the body and the
   # dumbbell). The dumbbell set is only faint: Forearms 0.24 and Trapezius
   # 0.20 as LOW secondary rows (below the two-dumbbell raise's 0.30 / 0.28:
   # one dumbbell; no EMG, a judgement), the rhomboids and hamstrings named
   # among the stabilisers with ExRx's one-leg stabilisers.
   activation=LOADED + [("Forearms", S, LOW, 0.24), ("Trapezius", S, LOW, 0.20)],
   stabilisers=["gluteus medius", "quadratus lumborum", "obliques", "rhomboids", "hamstrings"] + FOOT,
   comparison=("HEEL STOPS AT LEVEL", "Heel sinks below the step", "Heel stops level with the step",
               "Sinking below the step works the calf through its stretched range, which grew the gastrocnemius more than the range above level in a calf-raise study.",
               "Stopping at level keeps every rep in the range above a flat foot, the part that grew it least in that study."),
   glows=calves(N, both=False) + [glow(N, ["forearm_L", "hand_L"], SOFT, 0.18, 0.03, 0.05, 0.0, 0.0)])

SETUP[N] = [
    "Stand on a sturdy step beside a post, a dumbbell in your left hand.",
    "Put the ball of your left foot on the back edge of the step, heel off.",
    "Hold the post loosely with your right hand.",
    "Bend your right knee to lift that foot behind you and stand tall over the left foot.",
]

# ---------------------------------------------------------------- Single-Leg Machine Calf Raise

N = "Single-Leg Machine Calf Raise"
ex(name=N, var="singleLegMachineCalfRaise",
   # Facing screen-left (yaw -1.3): the hands and handles above the head at
   # the left (u ~0.30-0.41, v ~0.21-0.31), the lever arm and the machine's
   # uprights on the right, the toe block and platform low across the frame,
   # the free foot hanging back to the right (u ~0.69, v ~0.73). Three
   # labels on the left over the open floor; free and bottom on the right,
   # below the lever arm and clear of the hanging foot. The front of the
   # body reaches u ~0.30-0.37 down the left side, so the left pills are
   # short: the review's lab shot showed Hips under the pads over the chest
   # and belly all rep and Left knee straight touching the thigh.
   overrides={"pads": (ov(0.36), "leading"), "free": (ov(0.58), "trailing"),
              "knee": (ov(0.58), "leading"), "top": (ov(0.70), "leading"),
              "bottom": (ov(0.80), "trailing")},
   annotations=[
       ("pads", "Stand tall", "pelvis"),
       ("free", "Right foot stays off", "foot_R"),
       ("knee", "Knee straight", "patella_L"),
       ("top", "Pads up high, hold", "toe_L"),
       ("bottom", "Heel below the block", "foot_L"),
   ],
   cues={
       "pads": ("Body Under the Pads",
                "Stand tall with your hips under the shoulder pads.",
                "The pads load your shoulders, so the push has to run straight down a tall body into the ball of the foot. With the hips pushed back the body folds under the pads, and snapping the hips forward can start the lever moving without the calf.",
                "Pushing the hips back and leaning the chest forward under the pads.",
                "Keep your shoulders, hips and left ankle stacked in one line, brace your trunk and move only at the ankle."),
       "free": ("Free Leg",
                "The right foot stays off the block for the whole set.",
                "ExRx lists using the other foot to help as an easier version of the one-leg calf raise. Letting the right foot touch down at the bottom quietly turns the rep into a two-leg raise, and the left calf lifts less of the load.",
                "Putting the right foot down on the block at the bottom to push off.",
                "Bend your right knee and keep that foot hanging behind the left heel from the first rep to the last."),
       "knee": ("Working Knee",
                "The left knee stays straight under the pads.",
                "The gastrocnemius crosses the knee, and in studies that bent the knee its activity fell while the soleus kept working. A straight left knee keeps it in the lift; a dip at the bottom lets the thigh drive the pads up.",
                "Dipping the left knee at the bottom and pushing the pads up with the thigh.",
                "Keep the left knee straight but soft and raise the pads by pointing the ankle."),
       "top": ("Top of the Rep",
               "Drive the pads up as high as the left ankle allows and hold.",
               "The ankle cannot lock out, so the calf still holds the machine's load at the top, where ExRx notes calf raises stay hardest. Pausing there makes every rep finish at the top of the range.",
               "Lowering again with the pads only partway up.",
               "Rise until the left heel is as high as it goes, hold for about a second, then lower under control."),
       "bottom": ("Stretch at the Bottom",
                  "Let the left heel drop below the block each rep.",
                  "The heel sinks a few centimetres below the block here, into the stretched range. In an eight-week calf-raise study that range, below a flat foot, grew the gastrocnemius more than the range above it. ExRx advises setting the lever just below your lowest point, so the pads stay on your shoulders through the whole stretch.",
                  "Stopping each rep with the heel level with the block.",
                  "Lower slowly until the heel is below the block and the calf is stretched, pause briefly, then drive up."),
   },
   # Paint: calves bright, nothing dim. LOADED (machine load on one leg).
   # Stabilisers: ExRx's one-leg raise (gluteus medius, quadratus lumborum,
   # obliques) and lever standing raise (upper trapezius under the pads).
   activation=LOADED,
   stabilisers=["gluteus medius", "quadratus lumborum", "obliques", "upper trapezius"] + FOOT,
   comparison=("FREE FOOT HELPING", "Right foot off the block", "Right foot pushes off the block",
               "With the right foot hanging behind, the left calf lifts the whole load on its own.",
               "Touching the right foot down turns the bottom of each rep into a two-leg raise, so the left calf does less."),
   glows=calves(N, both=False))

SETUP[N] = [
    "Set the shoulder pads so the lever rests just below your lowest point.",
    "Step under the pads and put the ball of your left foot on the edge of the block, heel off.",
    "Hold the handles and stand up tall, left knee straight but soft.",
    "Bend your right knee so that foot hangs behind you, clear of the block.",
]

# ---------------------------------------------------------------- Donkey Calf Raise

N = "Donkey Calf Raise"
ex(name=N, var="donkeyCalfRaise",
   # Hinged, facing screen-left (yaw -1.3): the head top left (u ~0.29,
   # v ~0.23), the forearm pad and column on the left, the back running up to
   # the hips top right (u ~0.80, v ~0.35), the legs down the right, the
   # block low in the middle. The mistake view lifts the model ~0.1, which
   # puts the hips where any top-right pill sits, so the labels are on the
   # left: back above the head, its leader along the top of the back (its
   # fault turns 0.5 so the lifted head clears the pill); hinge between the
   # head and the hands on the pad, a short leader down to the near hand;
   # knees, its leader under the forearm pad to the far knee (the leftmost
   # one, so it does not cross the near leg); bottom at 0.84 right, below
   # the heels.
   overrides={"hinge": (ov(0.36), "leading"), "back": (ov(0.13), "leading"),
              "knees": (ov(0.52), "leading"), "top": (ov(0.80), "leading"),
              "bottom": (ov(0.84), "trailing")},
   annotations=[
       ("hinge", "Forearms rest", "hand_L"),
       ("back", "Back long", "spine"),
       ("knees", "Knees straight", "patella_R"),
       ("top", "Rise high, hold", "toe_R"),
       ("bottom", "Heels below the block", "foot_L"),
   ],
   cues={
       "hinge": ("Hinged Position",
                 "Stay folded forward with the forearms resting on the pad.",
                 "ExRx sets the donkey raise with the trunk about parallel to the floor. Its explanation is that with the hips bent and the knees straight, the stretched hamstrings pull against the gastrocnemius behind the knee, which may help it keep tension near the top. Pushing up out of the hinge turns it back into a standing raise.",
                 "Pushing up on the arms so the chest rises out of the hinge as the heels come up.",
                 "Rest your forearms on the pad, keep your trunk close to level and let your chest stay down as the heels rise."),
       "back": ("Long Back",
                "The lower back stays long, not rounded.",
                "With the hips bent and the knees straight, tight hamstrings pull on the pelvis. ExRx notes this tends to show as the lower back rounding, or the knees bending, at the bottom of a hip-bent calf exercise.",
                "The lower back rounding up as the heels sink into the stretch.",
                "Fold from the hips with a long spine from tailbone to head. If it rounds at the bottom, use a higher support so the hips bend a little less."),
       "knees": ("Straight Knees",
                 "The knees stay straight through the whole rep.",
                 "The gastrocnemius crosses the knee, so it needs a straight knee to work at length. In the hinge the hamstrings are already pulled tight, and bending the knees is the easy way to ease them; ExRx flags that bend in the stretch for anyone with tight hamstrings.",
                 "Bending the knees as the heels drop, the hips sinking toward the block.",
                 "Keep the knees straight but soft, and stretch only as far as you can with them held that way."),
       "top": ("Top of the Rep",
               "Rise onto the balls of the feet as high as you can and hold.",
               "Rising as high as the ankles go and holding briefly takes every rep to the end of the calves' range instead of turning back partway, and here the hips rise with the heels while the chest stays down.",
               "Lowering again with the heels only partway up, the hips barely rising.",
               "Push through the balls of the feet until the heels are as high as they go, hold for about a second, then lower."),
       "bottom": ("Stretch at the Bottom",
                  "Let the heels sink below the block every rep.",
                  "The heels drop a few centimetres below the block, into the stretched range below a flat foot. In an eight-week calf-raise study, training that range grew the gastrocnemius more than training the range above it.",
                  "Stopping with the heels level with the block.",
                  "Lower under control until the heels are below the block and the calves feel stretched, pause, then rise."),
   },
   # Paint: calves bright, hamstrings dim. UNLOADED (body weight only, and
   # part of the upper body rests on the forearms). Hamstrings 0.20 LOW, a
   # minor role: ExRx says the bent hips with straight knees stretch them,
   # so they are held long rather than lifting anything; painted dim; no
   # EMG, a judgement. Stabilisers from ExRx's donkey pages
   # (serratus anterior, pectoralis major holding the trunk on the support).
   activation=UNLOADED + [("Hamstrings", S, LOW, 0.20)],
   stabilisers=["serratus anterior", "pectoralis major", "erector spinae"] + FOOT,
   comparison=("CHEST RISING", "Hinged, forearms resting", "Chest pushes up off the pad",
               "Staying folded over the pad keeps the hips bent with the knees straight, the position the donkey raise is built around.",
               "Pushing up through the arms lifts the trunk out of the hinge and turns the rep into a standing raise on a support."),
   glows=calves(N) + [glow(N, ["thigh_L", "patella_L"], SOFT, 0.22, 0.04, 0.07, 0.03, 0.0)])

SETUP[N] = [
    "Bend forward at the hips and rest your forearms on a pad at about hip height.",
    "Step back onto a block so the balls of your feet sit on its edge, heels off.",
    "Place your feet so your hips sit above your ankles and your trunk is close to level.",
    "Straighten your knees without locking them.",
]

# ---------------------------------------------------------------- Machine Donkey Calf Raise

N = "Machine Donkey Calf Raise"
ex(name=N, var="machineDonkeyCalfRaise",
   # As the Donkey Calf Raise, with the lever's pads on the lower back and
   # the lever arm running off to the right above the hips, which takes the
   # right-hand rows below 0.15. The pad label (no ghost, trainer view only)
   # sits top right between the eye button (~3 pt above it) and the lever's
   # bracket (~6 pt below it at the top of the rep, its highest; measured on
   # the review's lab shot), the only free spot on that side; the back
   # label top left above the head, its leader along the top of the back to
   # the lower back. Its fault turns the lifter 0.5 toward the camera so the
   # lifted head clears the pill (see the faults file).
   overrides={"pad": (ov(0.15), "trailing"), "back": (ov(0.13), "leading"),
              "knees": (ov(0.52), "leading"), "top": (ov(0.80), "leading"),
              "bottom": (ov(0.84), "trailing")},
   annotations=[
       ("pad", "Pad on the hips", "pelvis"),
       ("back", "Back flat", "spine"),
       ("knees", "Knees straight", "patella_R"),
       ("top", "Rise high, hold", "toe_R"),
       ("bottom", "Heels below the block", "foot_L"),
   ],
   cues={
       "pad": ("Pad Position",
               "The pad rests across your lower back and hips.",
               "ExRx sets the lever donkey raise with the lower back and hips under the pad, and the lever resting just below the lowest point of the rep. Over the hips the load presses straight down through the legs; higher on the back it presses the trunk down instead.",
               "Setting the pad up on the middle of the back.",
               "Back into the machine until the pad rests across your lower back and hips, with the lever set just below your lowest point."),
       "back": ("Flat Back",
                "Keep the back flat under the loaded pad.",
                "The pad presses on the lower back while the hips are bent. ExRx notes that tight hamstrings in a hip-bent calf exercise show up as the lower back rounding at the bottom, and here that rounding happens under load.",
                "The lower back rounding up into the pad at the bottom of the stretch.",
                "Brace your trunk and keep a long, flat back under the pad, and stretch only as far as you can without it rounding."),
       "knees": ("Straight Knees",
                 "The knees stay straight; the ankles lift the pad.",
                 "The gastrocnemius works at length across a straight knee. With the pad on the hips, bending the knees at the bottom lets the thighs drive it up instead, and ExRx counts the quadriceps as helpers once the knees bend.",
                 "Bending the knees at the bottom and straightening them to drive the pad up.",
                 "Keep a soft, fixed bend in the knees and raise the pad by pointing the ankles."),
       "top": ("Top of the Rep",
               "Lift the pad as high as the ankles allow and hold.",
               "The ankle never locks out, so the calves keep holding the pad at the top, where ExRx notes calf raises stay hardest. Holding there for a moment finishes each rep at the top of the range.",
               "Lowering the pad again before the heels are fully up.",
               "Rise until your heels are as high as they go, hold for about a second, then lower the pad under control."),
       "bottom": ("Stretch at the Bottom",
                  "Let the heels sink below the block before each rise.",
                  "Below the block the calves work in their stretched range. In an eight-week calf-raise study, training below a flat foot grew the gastrocnemius more than training above it, so stopping level leaves that part out.",
                  "Keeping the heels level with the block, the pad only bobbing near the top.",
                  "Lower the pad slowly until your heels are below the block and your calves feel stretched, pause, then drive up."),
   },
   # Paint: calves bright, hamstrings dim. LOADED (the stack on the hips).
   # Hamstrings 0.20 LOW as the Donkey Calf Raise (stretched in the hinge
   # rather than lifting, painted dim; a judgement). Stabilisers from ExRx's Lever Donkey Calf
   # Raise (serratus anterior, pectoralis major).
   activation=LOADED + [("Hamstrings", S, LOW, 0.20)],
   stabilisers=["serratus anterior", "pectoralis major", "erector spinae"] + FOOT,
   comparison=("KNEES DRIVING THE PAD", "Knees straight, ankles lift the pad", "Knees bend and push the pad up",
               "With the knees held straight the ankles do all the lifting, and the gastrocnemius works across a straight knee.",
               "Bending and straightening the knees lets the thighs push the pad up, so the calves do less of each rep."),
   glows=calves(N) + [glow(N, ["thigh_L", "patella_L"], SOFT, 0.22, 0.04, 0.07, 0.03, 0.0)])

SETUP[N] = [
    "Set the lever so the pad rests just below your lowest point.",
    "Stand on the block with the balls of your feet on its edge, heels off.",
    "Fold forward under the pad so it rests across your lower back and hips.",
    "Rest your forearms on the front pad and straighten your knees.",
]

# ---------------------------------------------------------------- Hack Squat Calf Raise

N = "Hack Squat Calf Raise"
ex(name=N, var="hackSquatCalfRaise",
   # Three-quarter from the front-left (yaw -0.6): the lifter faces the
   # camera turned to screen-left, back on the sloping pad; the left hand
   # and handle top right (u ~0.76, v ~0.22), the rails and plates on the
   # right, the footplate low across the frame. Back, knees and feet on the
   # left (the right knee and foot are on the left of the screen), top and
   # bottom on the right over the static frame and platform.
   overrides={"back": (ov(0.24), "leading"), "knees": (ov(0.50), "leading"),
              "feet": (ov(0.70), "leading"), "top": (ov(0.70), "trailing"),
              "bottom": (ov(0.80), "trailing")},
   annotations=[
       ("back", "Back on the pad", "spine"),
       ("knees", "Knees straight", "patella_R"),
       ("feet", "Balls of feet on edge", "toe_R"),
       ("top", "Sled high, hold", "foot_L"),
       ("bottom", "Heels below the plate", "foot_L"),
   ],
   cues={
       "feet": ("Foot Position",
                "Only the balls of the feet sit on the lower edge of the platform.",
                "With the heels and arches hanging off the platform's lower edge, the heels can drop below it into the stretch and rise well above it. ExRx notes that not every hack squat platform is open at its lower end; some take a calf block instead.",
                "Setting the whole foot on the platform, so the heels have nowhere to drop.",
                "Place the balls of your feet on the lower edge of the platform, hip-width apart, with the heels and arches off it."),
       "back": ("Back on the Pad",
                "Your back and hips stay flat against the back pad.",
                "The shoulder pads carry the load down the line of the sled. With your back and hips on the pad that line runs straight through your legs to the balls of the feet; letting the hips slide forward off the pad bends the knees and lets the thighs help.",
                "The hips sliding forward off the back pad, the knees bending under the sled.",
                "Press your back, hips and shoulders into the pads and keep them there as the sled rises and lowers."),
       "knees": ("Straight Knees",
                 "The knees stay straight; only the ankles move the sled.",
                 "The gastrocnemius crosses the back of the knee, so a straight knee keeps it long. In a 12-week study, calf raises with the knee straight grew it far more than the same training with the knee bent to 90°. Letting the knees bend as the sled comes down also turns part of the rep into a squat.",
                 "Bending the knees as the heels drop, so the sled sinks and the thighs push it back up.",
                 "Keep a slight, fixed bend in the knees and move the sled with the ankles alone."),
       "top": ("Top of the Rep",
               "Push the sled up as far as the ankles go and hold.",
               "The calves work by pointing the ankles, and holding the sled at the top for a moment makes each rep reach the end of that range instead of turning back partway.",
               "Letting the sled back down before the ankles are fully pointed.",
               "Press through the balls of the feet until the heels are as high as they go, hold for about a second, then lower the sled."),
       "bottom": ("Stretch at the Bottom",
                  "Let the heels drop well below the platform's edge.",
                  "Here the heels drop well below the platform, deep into the stretched range below a flat foot. Training that range grew the gastrocnemius more than training the range above it in an eight-week calf-raise study.",
                  "Stopping each rep with the heels about level with the platform.",
                  "Lower the sled slowly until your heels are well below the platform's edge and the calves feel stretched, pause, then push up."),
   },
   # Paint: calves bright (PRIMARY, LOADED); quadriceps and hamstrings dim.
   # Both are LOW secondary rows for minor roles: Quadriceps 0.25, steadying
   # the straight knees under the sled (ExRx counts them as synergists only
   # once the knees bend, which this model does not do); Hamstrings 0.15.
   # No EMG for either; paint-led judgements. ExRx lists no significant
   # stabilisers for the hack
   # calf press, so only the foot muscles and core are named.
   activation=LOADED + [("Quadriceps", S, LOW, 0.25), ("Hamstrings", S, LOW, 0.15)],
   stabilisers=FOOT + ["core"],
   comparison=("KNEES BENDING", "Knees fixed, ankles move the sled", "Knees bend and the sled sinks",
               "Holding the knees straight leaves the ankles to move the sled, so the gastrocnemius does the work across a straight knee.",
               "When the knees bend, the sled sinks and the thighs push it back up, turning part of the rep into a squat."),
   glows=calves(N, dx=0.0, rx=0.04, ry=0.07, near="L") + [glow(N, ["thigh_L", "patella_L"], SOFT, 0.20, 0.04, 0.07, 0.0, 0.0)])

SETUP[N] = [
    "Stand on the platform with your back against the pad and your shoulders under the shoulder pads.",
    "Set the balls of your feet on the platform's lower edge, hip-width apart, heels hanging off.",
    "Hold the handles and straighten your knees to stand the sled up; release the safety catch if it has one.",
    "Keep a slight bend in the knees and your back flat on the pad.",
]
