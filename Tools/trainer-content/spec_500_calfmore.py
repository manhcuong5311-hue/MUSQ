# Trainer content for the 401-500 folder (2026-10-04), family: calfmore. Six
# more calf exercises from the builder's second round (415-444): 415 Elevated
# Calf Raise (Legs/ElevatedCalfRaise), 416 Bent-Knee Calf Raise
# (Legs/BentKneeCalfRaise), 422 Calf Raise Hold (Legs/CalfRaiseHold), 423
# Calf Raise Pulse (Legs/CalfRaisePulse), 421 Farmer's Walk on Toes
# (Legs/FarmersWalkOnToes) and 424 Banded Plantar Flexion
# (Legs/BandedPlantarFlexion). Same format as spec.py on top of
# common_1_50.py; spec_500.py imports this module and gen.py reads SPEC /
# SETUP. notes_500_calfmore.md maps the copy's claims to the sources below and
# records the model facts.
#
# What the models show, from the briefs (SCRATCH/briefs2_legs, briefs2), the
# trainer stills (SCRATCH/stills), tiers2.txt, joints.json and the rigs,
# equipment and skinned shoes read from the USD with Blender's Python + pxr
# (SCRATCH/calfmore/measure.py and series.py, every frame; the app's Y-up
# space, the lifter facing +z, their left +x). One body (torso, neck to
# pelvis, 0.592 m) with toe joints at the ball of the foot (toe_L/R). Ankle =
# the rig's shin-to-foot-bone angle: ~106 degrees with the sole flat on the
# floor and the shin ~6 degrees forward, so neutral (the foot at 90 degrees
# to the tibia, Kassiano 2023's 0) reads ~112 on these rigs (106 + the 6
# degree lean; the bent-knee raise agrees, 97 + its 15.5 degree lean), and
# "degrees dorsiflexed / plantar flexed" below are read from 112. (Round 1
# read neutral as ~109; verification measured it on these rigs.)
# Every clip is 7.96 s and loops.
# - Elevated Calf Raise: both feet on a 15 cm step (HG_ForefootStep, 0.8 x
#   0.19 m), the front ~17 cm of each shoe on it (the balls of the feet ~7 cm
#   in from its back edge), the heels and arches off the back; no load, no
#   support, arms hanging (elbows 170), knees 175-176, trunk upright. Ankle
#   89 (~23 degrees dorsiflexed; the heels ~4-5 cm below the step's top) ->
#   142 (~30 plantar flexed; the heels ~13 cm above it), the heels travelling
#   ~17 cm; the body rises ~11 cm and drifts ~10 cm forward. Two reps: up
#   0.08-1.0 s, held at the top 1.0-2.08 s, down 2.08-3.42 s, resting in the
#   stretch 3.42-4.08 s. Paint: gastrocnemius (both heads) and soleus bright,
#   the hamstrings dim. The same step and stretch as the calfstand family's
#   Single-Leg Dumbbell Calf Raise, on two legs, with no dumbbell and no post.
# - Bent-Knee Calf Raise: on the floor, no equipment, feet hip-width (toes
#   ~10 degrees out), the knees held at 146 degrees (34 short of straight)
#   the whole clip, the hips at 147, the trunk 14-16 degrees forward, arms
#   hanging. Ankle 97 (heels on the floor; ~15 degrees dorsiflexed because
#   the shins lean ~16 degrees forward) -> 133 (~21 plantar flexed), the heels
#   1.4 -> 13.2 cm up; timing as the elevated raise. Paint: calves bright;
#   hamstrings and quadriceps (rectus femoris, the three vasti) dim.
# - Calf Raise Hold: on the floor, knees 175-176, arms hanging. Rises in
#   ~0.7 s (0.21-0.92 s), HOLDS at the top 0.92-7.17 s (~6.25 s; ankle 144.5,
#   ~32 plantar flexed, the heels ~12 cm up), lowers in ~0.7 s (7.17-7.83 s)
#   and rests ~0.4 s across the loop. Paint as the bent-knee raise.
# - Calf Raise Pulse: on the floor, knees 175-176, arms hanging. Rises in
#   ~0.55 s (0.21-0.75 s), then pulses: ten small dips and rises between
#   ankle ~131 and ~142 degrees (~19-30 plantar flexed), the heels moving
#   between ~10 and ~13 cm up (~3 cm), one every 0.67 s (dips at 1.0, 1.67
#   ... 7.0 s, tops at 1.33, 2.0 ... 7.33 s), never touching down; lowers in
#   ~0.6 s (7.33-7.92 s) and rests ~0.3 s across the loop. Paint as the
#   bent-knee raise.
# - Farmer's Walk on Toes: a dumbbell in each hand (handles front to back,
#   palms in, arms straight, 176), heels up the whole clip (the standing
#   heels ~11.5 cm up, ankles 130-137, ~18-25 plantar flexed, never lower),
#   stepping IN PLACE: one foot lifts (knee to ~132, the sole ~3 cm off the
#   floor) every 0.67 s, left and right in turn (12 steps in the clip, 1.5 a
#   second), the pelvis shifting ~2.6 cm toward the standing leg; no forward
#   travel at all (the ankles stay at the same z). Standing knees 168-175,
#   trunk upright (1 degree). Paint: calves bright; dim the forearm flexors
#   and extensors, brachioradialis, the three trapezius parts, rhomboid
#   major, the hamstrings and the quadriceps.
# - Banded Plantar Flexion: long-sitting on a mat (HG_Mat), the trunk
#   upright (4 degrees back), hips 90, knees 170, feet hip-width; a rolled
#   towel (HG_TowelRoll, 4 cm high) under the lower calves ~15 cm above the
#   ankle joints, so the heels hang clear of the mat; two bands, one round
#   the ball of each foot, the ends held in each hand ~19 cm ahead of and
#   ~23 cm above the hip joints (the wrists ~34 cm above the mat), the elbows
#   bent 87 and still all clip; the hand to ball-of-foot distance grows
#   73.5 -> 81.8 cm as the feet point. Ankle 109.6 (within ~2 degrees of
#   neutral, the toes pointing up) -> 149.6 (40 degrees on, ~38 plantar
#   flexed) over ~1 s,
#   held ~1.1 s (1.0-2.08 s), back over ~1.3 s (to 3.42 s), resting ~0.6 s;
#   two reps. Paint: calves bright, nothing dim.
#
# How they differ from the library and round 1: the library's calf raises
# (Standing, Seated, Leg Press, Single-Leg, Smith) and round 1's thirteen are
# all loaded or straight-knee or seated; here the elevated raise is the
# two-leg, unloaded stretch raise off a step; the bent-knee raise is the only
# STANDING raise with the knees held bent; the hold and the pulse are the
# only isometric and partial-range calf work; the farmer's walk on toes is a
# loaded carry done on the balls of the feet; the banded plantar flexion is
# the only non-weight-bearing calf exercise (the rehab staple). Cue sets:
# feet, bottom, top, knees, tempo (elevated); knees, toes, top, floor, tempo
# (bent-knee); height, toes, knees, body, breath (hold); top, range, knees,
# toes, rhythm (pulse); heels, posture, shoulders, hips, steps (farmer's
# walk); top, return, knees, hands, back (banded).
#
# Sources (abstracts read on Europe PMC 2026-10-04/05, full texts where
# noted; web pages read 2026-10-05; ExRx through the Internet Archive copies
# saved by the calfstand family, SCRATCH/calfstand/exrx; details in the
# notes):
# - ExRx.net: Standing Calf Raise (bodyweight, BWStandingCalfRaise, snapshot
#   2025-07-02): toes and balls of the feet on a calf block, arches and heels
#   off, a hand on a support for balance; raise the heels as high as
#   possible, lower until the calves are stretched; any step that will not
#   overturn can be the block; knees straight or bent slightly only in the
#   stretch, the quadriceps then synergists; target gastrocnemius, synergist
#   soleus. Calf Exercise Analyses (Kinesiology/CalfExercises, 2024-01-05):
#   the plantar flexors keep tension through the whole movement unless the
#   heel rests on the floor or the apparatus; the upper portion of a calf
#   exercise is relatively hard because, in most people, the ankle cannot
#   extend straight like other joints; in the seated calf raise, knee bent,
#   the soleus becomes the primary plantar flexor, the
#   biarticulate gastrocnemius needing a straight or nearly straight knee
#   (said of the seated raise, knee bent);
#   with the hips bent and the knees straight, tight hamstrings show as
#   lumbar flexion or a slight knee bend. Gastrocnemius, Soleus and Gluteus
#   Medius muscle pages (2024-01-05): the gastrocnemius from the femoral
#   condyles, in active insufficiency with the knee flexed and the ankle
#   plantar flexed (the soleus more active); the gluteus medius steadies the
#   pelvis so it does not sag when the opposite side is not supported.
# - Kassiano W, Costa B, Kunevaliki G, et al. 2023, J Strength Cond Res
#   37(9):1746-1753, doi:10.1519/JSC.0000000000004460, PMID 37015016 - 42
#   young women, 8 weeks of calf raises on a horizontal leg press: the
#   initial range (ankle 25 degrees dorsiflexed to neutral) grew the medial
#   gastrocnemius more than the full and final (neutral to 25 plantar
#   flexed) ranges (15.2% vs 6.7% vs 3.4%) and the lateral head more than
#   the final range (14.9% vs 6.2%).
# - Hebert-Losier K, Schneiders AG, Garcia JA, Sullivan SJ, Simoneau GG
#   2012a, J Strength Cond Res 26(11):3124-3133,
#   doi:10.1519/JSC.0b013e31824435cf, PMID 22190157 - 48 adults, one-leg
#   heel raises at 0 and 45 degrees of knee flexion: triceps surae 23% MVIC
#   straight, 21% bent; at 45 degrees the soleus 4% higher and both
#   gastrocnemius heads 5% lower; the authors note a 4-5% change may not be
#   enough to matter for muscle-specific benefits.
# - Hebert-Losier K et al. 2012b, J Strength Cond Res 26(11):3134-3147,
#   doi:10.1519/JSC.0b013e318243ff0e, PMID 22158096 - the same raises to
#   fatigue (45 and 48 raises): knee angle did not change triceps surae
#   fatigue; the gastrocnemius heads fatigued more than the soleus.
# - Price TB, Kamen G, Damon BM, et al. 2003, Magn Reson Imaging
#   21(8):853-861, doi:10.1016/s0730-725x(03)00183-8, PMID 14599535 -
#   plantar flexion at 25% 1RM: knee straight, MRI showed both gastrocnemius
#   heads (and the peroneus) working, not the soleus; knee at 45 degrees the
#   soleus and the lateral gastrocnemius, not the medial head; at 90 the
#   soleus only; EMG agreed.
# - Signorile JF, Applegate B, Duque M, Cole N, Zink A 2002, J Strength Cond
#   Res 16(3):433-439, doi:10.1519/1533-4287(2002)016<0433:SROTTS>2.0.CO;2,
#   PMID 12173959 - 11 experienced subjects at knee angles
#   90, 135 and 180: the medial gastrocnemius above the soleus at 180, the
#   soleus lower at 180 than at the bent angles, the lateral head less
#   affected by knee angle.
# - Cresswell AG, Loscher WN, Thorstensson A 1995, Exp Brain Res
#   105(2):283-290, doi:10.1007/BF00240964, PMID 7498381 - as the knee bent,
#   gastrocnemius EMG fell at the same effort while soleus EMG held.
# - Kinoshita M, Maeo S, Kobayashi Y, et al. 2023, Front Physiol 14:1272106,
#   doi:10.3389/fphys.2023.1272106, PMID 38156065 - standing (knee straight)
#   calf-raise training grew the gastrocnemius far more than seated (knee
#   90), the soleus about the same.
# - Oranchuk DJ, Storey AG, Nelson AR, Cronin JB 2019, Scand J Med Sci
#   Sports 29(4):484-503, doi:10.1111/sms.13375, PMID 30580468 - systematic
#   review of isometric training (26 outputs): training at longer muscle
#   lengths produced more hypertrophy than equal volumes at shorter lengths
#   and transferred more to dynamic performance.
# - Kawakami Y, Muraoka T, Ito S, Kanehisa H, Fukunaga T 2002, J Physiol
#   540(Pt 2):635-646, doi:10.1113/jphysiol.2001.013459, PMID 11956349 - six
#   men, maximal-effort plantar flexion with and without a dip first: with it
#   the medial gastrocnemius fascicles worked almost isometrically while the
#   tendon stored and released elastic energy.
# - Nakamura M, Kamazawa T, Sato S, Yosida R, Nosaka K 2025, Eur J Appl
#   Physiol 125(9):2625-2635, doi:10.1007/s00421-025-05782-6, PMID 40229595 -
#   bodyweight calf raises, both legs up in 1 s, one leg lowering in 3 s:
#   that leg gained strength (32.9%), thickness (9.1%) and range (30.4%),
#   the raise-only leg none.
# - Kim J, Kang S, Kim SJ 2022, Sci Rep 12:10796,
#   doi:10.1038/s41598-022-14313-8, PMID 35750787 (PMC9232603) - five healthy
#   men, double- and single-leg raises with the ankle everted (the weight
#   toward the big toe) or inverted (rolled onto the outside edge): inverted
#   raises did not recruit the peroneus longus well; the everted (proper)
#   raises drew more of it, shown in the rise phase. It did not test a neutral foot, so the copy
#   compares rolled-out raises with weight toward the big toe, as round 1.
# - Akuzawa H, Imai A, Iizuka S, Matsunaga N, Kaneoka K 2017, Phys Ther
#   Sport 28:23-28, doi:10.1016/j.ptsp.2017.08.077, PMID 28950148 - tibialis
#   posterior, peroneus longus and flexor digitorum longus work in heel
#   raises (the stabiliser rows).
# - Stastny P, Lehnert M, Zaatar A, et al. 2015, J Hum Kinet 45:157-165,
#   doi:10.1515/hukin-2015-0016, PMID 25964819 (PMC4415828) - 16 trained men,
#   farmer's walk at 75% of 6RM: gluteus medius 26-47% MVIC (group means).
# - Uchida MC, Nishida MM, Sampaio RA, Moritani T, Arai H 2016, J Phys Ther
#   Sci 28(4):1266-1271, doi:10.1589/jpts.28.1266, PMID 27190465 (full text
#   PMC4868225) - Thera-Band tension measured at 25-250% elongation: tension
#   rises as the band is stretched, for every colour.
# - Web guides (read 2026-10-05): The Prehab Guys, Farmer Carry - Dumbbell,
#   On Toes (stand tall, shoulder blades slightly back, weight toward the
#   toes, slow, controlled, quiet steps, the heels never touching the floor,
#   shoulders not sagging forward; you feel the shoulder blades and calves)
#   and Toe Walking (do not let the heel drop when you put weight on it, do
#   not let the knees bend, you may feel the quadriceps); Fitbod, Dumbbell
#   Toe Walks (dumbbells at the sides, heels up, weight on the balls of the
#   feet, shoulders back, chest up; secondary forearms and trapezius);
#   Physitrack, Soleus Raises and Calf raises on step with knees bent (the
#   knees slightly bent throughout); Lyfta, Bodyweight Standing Pulse Calf
#   Raise (rise as high as you can with straight knees, lower slightly, not
#   all the way, and rise again; then lower with control; do not rush);
#   Caliverse, Calf Raise Hold (a one-leg version: hold the top breathing
#   steadily, the knee still, upright without leaning forward; its listed
#   mistakes: bending the knee, using momentum, rising onto the outer foot
#   edges, holding the breath, lowering too quickly; the copy calls it a
#   guide, singular, as the only hold guide read); Physitrack, Resisted ankle plantar
#   flexion in long sitting and Ankle plantar flexion against resistance
#   band (long sitting, band under the foot, ends held for tension, knee
#   straight and facing the ceiling, point the foot, control or slow the
#   return); UMass Memorial Health / WebMD Ignite, Plantar Flexion
#   (Strength) (leg straight, band round the foot, push with the ball of the
#   foot, pull the band toward you, hold, return); NASA Kennedy Space Center
#   RehabWorks, Basic Ankle Protocol (Plantar Flexion w/ Theraband: a roll
#   or rolled towel under the calf to lift the ankle off the floor, the band
#   round the ball of the foot, point slowly and return slowly).
# No EMG study of these six exact exercises was found, so every fraction
# below is a judgement call anchored on the round-1 calf families' values
# (LOADED 0.86 / 0.66 and UNLOADED 0.78 / 0.60 with the knee straight; the
# seated 0.86 soleus) and moved by knee angle and load as the studies above
# order them; every secondary fraction is a low, paint-led judgement for a
# minor role.
from common_1_50 import *


def ov(final):
    """Pre-squeeze override row for an on-screen row (spec_500.row() maps
    0.14-0.86 to 0.16-0.80)."""
    return round(0.14 + (final - 0.16) * (0.86 - 0.14) / (0.80 - 0.16), 4)


def calves(name, dx=0.015, dy=0.0, rx=0.045, ry=0.07, near="L"):
    """Both calves between knee and ankle, nudged toward the back of the shin
    (to the right on the screen-left-facing framings): the near (left) calf
    full, the far one soft."""
    far = "R" if near == "L" else "L"
    return [glow(name, [f"shin_{near}", f"foot_{near}"], A, 0.55, rx, ry, dx, dy),
            glow(name, [f"shin_{far}", f"foot_{far}"], SOFT, 0.32, rx * 0.9, ry * 0.9, dx, dy)]


# Knee straight, body weight on two legs: the calfstand family's UNLOADED
# values (its bodyweight standing raise and donkey raise). Both calves are
# painted bright, so both are PRIMARY; the gastrocnemius leads with the knee
# straight (Signorile 2002, Price 2003, Cresswell 1995), the soleus still
# works hard. The numbers are a judgement; the studies give the order.
UNLOADED = [("Gastrocnemius", P, HI, 0.78), ("Soleus", P, MOD, 0.60)]
# Knee straight and a dumbbell in each hand, one foot at a time between
# steps: the calfstand family's LOADED values (its dumbbell raises).
LOADED = [("Gastrocnemius", P, HI, 0.86), ("Soleus", P, MOD, 0.66)]
FOOT = ["tibialis posterior", "peroneals", "toe flexors"]

KAWAKAMI_WHY = ("Dropping into the stretch and rising straight out of it lets the Achilles tendon do part of the job: "
                "in an all-out dip-and-push ankle movement, the gastrocnemius fibres stayed nearly the same length "
                "while the tendon stretched, stored the energy and gave it back. A brief settle at the bottom leaves less of "
                "that spring, so more of the lift comes from the calves.")

# ---------------------------------------------------------------- Elevated Calf Raise

N = "Elevated Calf Raise"
ex(name=N, var="elevatedCalfRaise",
   # Side-on from the front left (yaw -1.3), facing screen-left: the body in
   # a narrow column (u ~0.40-0.65), the step low across the middle (u
   # ~0.35-0.62, v ~0.83-0.95). Tempo right of the head; knees and the two
   # foot labels on the left, over the open floor in front; the bottom label
   # right, below the calves, to the near heel.
   overrides={"tempo": (ov(0.26), "trailing"), "knees": (ov(0.56), "leading"),
              "feet": (ov(0.70), "leading"), "top": (ov(0.78), "leading"),
              "bottom": (ov(0.80), "trailing")},
   annotations=[
       ("feet", "Balls of feet on step", "toe_R"),
       ("bottom", "Sink below step", "foot_L"),
       ("top", "Up high, pause", "toe_L"),
       ("knees", "Knees straight", "patella_L"),
       ("tempo", "No bouncing", "chest"),
   ],
   cues={
       "feet": ("Foot Position",
                "Only the front of each foot goes on the step; the heels hang off the back edge.",
                "ExRx sets this raise up with the toes and balls of the feet on a calf block and the arches and heels off it, and says any step that will not tip over can be the block. With the heels free they can drop below the step, which is the point of standing on it.",
                "Standing with the whole foot on the step, so the heels have nowhere lower to go.",
                "Put the balls of your feet on the step, hip-width apart and toes forward, with the arches and heels clear of the back edge."),
       "bottom": ("Stretch at the Bottom",
                  "Let the heels sink below the step on every rep.",
                  "Here the heels go about 5 cm below the top of the step, so the calves work through their stretched range, below a flat foot. In an eight-week calf-raise study, training only that lower range grew the gastrocnemius more than training only the range above it. Turning back level with the step leaves it out.",
                  "Turning each rep around with the heels level with the step.",
                  "Lower until your heels are below the step and your calves feel stretched, settle there, then rise."),
       "top": ("Top of the Rep",
               "Rise until the heels are as high as they go, then pause.",
               "From the bottom of the stretch to the top the heels travel about 17 cm here, from the stretch below the step to full height. ExRx notes the top of a calf raise stays hard because the ankle cannot straighten out the way other joints do, so a short pause there keeps the calves working at that end too.",
               "Lowering again before the heels reach full height.",
               "Push through the balls of your feet until the heels are as high as they go, pause for about a second, then lower."),
       "knees": ("Straight Knees",
                 "Keep the knees straight but not braced back, from bottom to top.",
                 "The gastrocnemius starts on the thigh bone above the knee, so it lifts best with the knee straight or nearly straight. ExRx keeps the knees straight here, or bends them slightly only in the stretch, and counts the quadriceps as helpers once they bend, so a deeper dip brings the thighs into the rise.",
                 "Bending the knees in the stretch and straightening them to spring back up.",
                 "Set the knees straight without locking them hard, and move only at the ankles."),
       "tempo": ("Tempo",
                 "Lower under control, settle at the bottom, then rise; no bouncing.",
                 KAWAKAMI_WHY,
                 "Dropping into the stretch and rebounding straight out of it.",
                 "Rise in under a second, take a little longer to lower, and let the heels settle below the step for a moment before the next rep."),
   },
   # Paint: calves bright (PRIMARY, UNLOADED: two legs, body weight only),
   # hamstrings dim -> a LOW secondary row; no source measures them in a
   # calf raise (a paint-led judgement, as the calfstand family's 0.15).
   activation=UNLOADED + [("Hamstrings", S, LOW, 0.15)],
   stabilisers=FOOT + ["core"],
   comparison=("HEELS STOP AT THE STEP", "Heels sink below the step", "Heels stop level with the step",
               "Sinking below the step takes the calves through their stretched range, the part that grew the gastrocnemius most in a calf-raise study.",
               "Stopping level with the step keeps every rep in the range above a flat foot, which grew it least in that study."),
   glows=calves(N))

SETUP[N] = [
    "Stand on a sturdy step that will not tip, near a wall or rail you can touch for balance.",
    "Put the balls of both feet on the step, hip-width apart, heels hanging off the back edge.",
    "Let your arms hang by your sides and stand tall.",
    "Set your knees straight but not locked.",
]

# ---------------------------------------------------------------- Bent-Knee Calf Raise

N = "Bent-Knee Calf Raise"
ex(name=N, var="bentKneeCalfRaise",
   # Side-on from the front left (yaw -1.3), facing screen-left, the knees
   # bent forward toward the left (u ~0.43-0.52, v ~0.62), the hips back to
   # the right (u ~0.61). Knees left at the knee; toes and top on the left
   # over the floor in front of the feet; tempo right of the head; floor
   # right, below the calves.
   overrides={"tempo": (ov(0.26), "trailing"), "knees": (ov(0.56), "leading"),
              "toes": (ov(0.70), "leading"), "top": (ov(0.78), "leading"),
              "floor": (ov(0.80), "trailing")},
   annotations=[
       ("knees", "Same knee bend", "patella_L"),
       ("toes", "Over the big toes", "toe_R"),
       ("top", "Rise high, pause", "toe_L"),
       ("floor", "Heels down", "foot_L"),
       ("tempo", "Lower slowly", "chest"),
   ],
   cues={
       "knees": ("Knee Bend",
                 "Bend the knees partway and keep exactly that bend all the way up and down.",
                 "The gastrocnemius crosses the back of the knee, so a bent knee slackens it and moves part of the work onto the soleus, which starts below the knee; ExRx notes the soleus becomes more active as the knee bends. In a heel-raise study the shift at a 45° bend was small, so both muscles keep working; what matters is that the bend stays. Straightening the knees on the way up undoes it and lets the thighs push you up.",
                 "Straightening the knees as the heels rise, then bending them again on the way down.",
                 "Bend your knees about a third of the way to a right angle before the first rep and keep them there; only the ankles move."),
       "toes": ("Foot Pressure",
                "Push up through the big and second toes.",
                "Where the weight sits on the foot changes which muscles help. In a small heel-raise study that tracked foot pressure with insoles, raises tipped onto the little-toe side drew less from the peroneus longus, which runs down the outside of the lower leg and braces the ankle, than raises pressing toward the big toe.",
                "Rolling onto the outside edges of the feet as the heels rise, the ankles bowing out.",
                "Press through the ball of each foot behind the big and second toes, knees tracking over the toes, and lift the heels straight up."),
       "top": ("Top of the Rep",
               "Rise as high as the ankles allow and pause.",
               "With the knees bent the heels still rise about 12 cm here. A short pause at the top, which ExRx notes stays hard because the ankle cannot straighten out, makes each rep finish at the end of the range instead of turning back early.",
               "Turning back down with the heels only halfway up.",
               "Push through the balls of your feet until the heels are as high as they go with the knees still bent, pause for about a second, then lower."),
       "floor": ("Bottom of the Rep",
                 "Bring the heels back down to the floor every rep.",
                 "On flat ground the floor is the bottom of the range, and with the shins leaning forward over bent knees the ankles are already past a right angle there. Hovering above the floor trims every rep at its longest point, the stretched end of the range.",
                 "Hovering on the balls of the feet between reps so the heels never touch down.",
                 "Lower until your heels touch the floor lightly, knees still bent, then rise again."),
       "tempo": ("Lowering Speed",
                 "Lower more slowly than you rise.",
                 "In an eight-week study of bodyweight calf raises, a leg that also lowered the heel on its own over three seconds gained strength and calf thickness, while the leg that only pushed up gained neither. The way down counts, so do not just drop.",
                 "Dropping the heels straight back down after each rise.",
                 "Rise in under a second, pause, then take a slower count back down to the floor."),
   },
   # Paint: calves bright, so both PRIMARY. With the knees bent 34 degrees
   # the soleus is ranked first (the library row is SOLEUS): Price 2003 saw
   # the soleus and the lateral gastrocnemius active on MRI at a 45 degree
   # bend, not the medial head; Hebert-Losier 2012a measured the soleus 4%
   # higher and the gastrocnemius 5% lower at 45 than straight; Signorile
   # 2002 and Cresswell 1995 give the same direction; ExRx (the soleus more
   # active as the knee bends, the primary plantar flexor in the seated,
   # 90 degree raise). The shift is modest at this bend, so the
   # gastrocnemius stays a strong primary: Soleus 0.70, Gastrocnemius 0.62,
   # about two-fifths of the way (34 of 90 degrees) from
   # the UNLOADED knee-straight 0.78 / 0.60 toward the seated 0.40 / 0.86,
   # the soleus ranked first only narrowly; a judgement, no EMG of this
   # exact raise. (Review: the draft's 0.72 / 0.58 moved further than the
   # small 45 degree shift the copy cites.) Dim: Quadriceps 0.30 LOW
   # (holding the 34 degree knee bend under body weight; no EMG, a
   # judgement), Hamstrings 0.15 LOW (paint-led).
   activation=[("Soleus", P, HI, 0.70), ("Gastrocnemius", P, MOD, 0.62),
               ("Quadriceps", S, LOW, 0.30), ("Hamstrings", S, LOW, 0.15)],
   stabilisers=FOOT + ["core"],
   comparison=("KNEES STRAIGHTENING", "Knees hold their bend", "Knees straighten as the heels rise",
               "Keeping the same bend leaves the ankles to do the lifting with part of the work moved onto the soleus.",
               "Straightening the knees on the way up turns it back into a straight-knee raise and lets the thighs help."),
   glows=calves(N, dx=0.02))

SETUP[N] = [
    "Stand on flat ground with your feet hip-width apart and toes pointing ahead.",
    "Bend your knees partway and lean your trunk slightly forward to stay balanced.",
    "Arms hang loose at your sides; keep a wall within reach for balance.",
    "Set that knee bend before the first rep and hold it for the whole set.",
]

# ---------------------------------------------------------------- Calf Raise Hold

N = "Calf Raise Hold"
ex(name=N, var="calfRaiseHold",
   # As the elevated raise without the step: the body a narrow column, the
   # feet on the floor (v ~0.80-0.84). Body right of the head; knees, toes
   # and height on the left over the floor in front; breath right, below the
   # hands.
   overrides={"body": (ov(0.26), "trailing"), "breath": (ov(0.44), "trailing"), "knees": (ov(0.56), "leading"),
              "toes": (ov(0.70), "leading"), "height": (ov(0.80), "trailing")},
   annotations=[
       ("height", "Heels stay high", "foot_L"),
       ("toes", "Weight on big toes", "toe_R"),
       ("knees", "Knees straight", "patella_L"),
       ("body", "Stand tall", "neck"),
       ("breath", "Keep breathing", "chest"),
   ],
   cues={
       "height": ("Hold Height",
                  "Rise as high as you can and keep the heels there for the whole hold.",
                  "ExRx notes the top of a calf raise stays hard, because the ankle cannot straighten out to rest on. As the calves tire, the heels can creep down to an easier height. The hold also works the calves at their shortest; in a review of isometric training, holds at longer muscle lengths built more muscle than holds at shorter ones, so use it alongside full-range raises.",
                  "The heels sinking lower as the seconds go by.",
                  "Rise in under a second until the heels are as high as they go, then keep them at that height until the time is up."),
       "toes": ("Foot Pressure",
                "Hold the weight over the big and second toes.",
                "A guide to this hold lists rising onto the outer edges of the feet as a common mistake. In a small heel-raise study, the peroneus longus, which steadies the outside of the ankle, worked harder during the rise with the weight toward the big toe than with the ankle rolled out.",
                "Drifting onto the outside edges of the feet partway through the hold.",
                "Keep both feet pressing through the ball of the foot behind the big and second toes, ankles square."),
       "knees": ("Straight Knees",
                 "The knees stay straight and still for the whole hold.",
                 "The gastrocnemius crosses the back of the knee and holds the heels up best with the knee straight or nearly so. Letting the knees soften as you tire brings the thighs in and lowers you a little at a time.",
                 "Knees softening into a bend as the hold goes on.",
                 "Straighten your knees without locking them hard before you rise, and keep them that way until you lower."),
       "body": ("Tall Body",
                "Stand tall, hips under the shoulders.",
                "To balance on the balls of the feet, your weight has to stay over them. A guide to this hold has you stay upright without leaning forward; folding at the hips moves the weight of the trunk ahead and makes the balance harder to keep.",
                "Folding forward at the hips during the hold.",
                "Stack your head, shoulders and hips over the balls of your feet and hold that line; touch a wall lightly if you need balance."),
       "breath": ("Breathing",
                  "Breathe steadily through the hold.",
                  "A guide to this hold has you breathe steadily at the top and lists holding the breath among the common mistakes. The model rises in under a second, holds for about six and lowers in under a second.",
                  "Holding your breath and straining until the hold ends.",
                  "Breathe in and out evenly while the heels stay up, count the time, then lower under control."),
   },
   # Paint: calves bright (PRIMARY, UNLOADED: two legs, body weight, held at
   # the top), hamstrings and quadriceps dim -> LOW secondary rows for the
   # minor job of holding the straight knees steady (paint-led judgements; no
   # EMG of either in a calf raise hold). Quadriceps 0.20, Hamstrings 0.15.
   activation=UNLOADED + [("Quadriceps", S, LOW, 0.20), ("Hamstrings", S, LOW, 0.15)],
   stabilisers=FOOT + ["core"],
   comparison=("HEELS SINKING", "Heels stay at full height", "Heels creep down during the hold",
               "Holding at full height keeps the calves working at the top of the range for the whole time.",
               "Letting the heels creep down turns the hold into an easier one at a lower height."),
   glows=calves(N))

SETUP[N] = [
    "Stand tall on a flat floor with your feet under your hips.",
    "Let your arms hang; stand close enough to a wall to touch it if you sway.",
    "Straighten your knees, but do not snap them back.",
    "Rise onto the balls of your feet and hold for the set time.",
]

# ---------------------------------------------------------------- Calf Raise Pulse

N = "Calf Raise Pulse"
ex(name=N, var="calfRaisePulse",
   # As the hold. Rhythm right of the head; knees, toes and top on the left;
   # range right, below the calves, to the near heel.
   overrides={"tempo": (ov(0.26), "trailing"), "knees": (ov(0.56), "leading"),
              "toes": (ov(0.70), "leading"), "top": (ov(0.78), "leading"),
              "range": (ov(0.80), "trailing")},
   annotations=[
       ("top", "Full height first", "toe_L"),
       ("range", "Small pulses", "foot_L"),
       ("knees", "Knees straight", "patella_L"),
       ("toes", "Over the big toes", "toe_R"),
       ("tempo", "Steady pulses", "chest"),
   ],
   cues={
       "top": ("Top Position",
               "Rise all the way first; every pulse comes back up to full height.",
               "The pulses are meant to work the very top of the range, where the ankle cannot straighten out and ExRx notes a calf raise stays hard. A pulse guide has you rise as high as you can before the first one. Pulsing from halfway up misses that end of the range.",
               "Starting the pulses with the heels only halfway up, never reaching full height again.",
               "Rise until your heels are as high as they go, then dip a little and come back to that same height on every pulse."),
       "range": ("Pulse Size",
                 "Each pulse drops the heels only a little; they stay off the floor until the set is done.",
                 "Here the heels move about 3 cm per pulse and never touch down, so the calves get no rest; ExRx points out they hold tension the whole time unless the heel rests on the floor. The trade-off is range: in an eight-week calf-raise study, training only the upper part grew the gastrocnemius less than training the stretched part below a flat foot, so pair pulses with full-range raises.",
                 "Letting the heels drop most of the way to the floor between pulses.",
                 "Lower the heels a few centimetres, no more, and push straight back up; touch the floor only after the last pulse."),
       "knees": ("Straight Knees",
                 "Keep the knees straight; the pulse comes from the ankles.",
                 "Quick, small pulses make it easy to bob at the knees instead. The gastrocnemius crosses the knee and works best with it straight or nearly straight, and a knee bob turns each pulse into a little bounce from the thighs.",
                 "Bobbing at the knees in time with the pulses.",
                 "Set your knees straight without locking them, and let only the heels move up and down."),
       "toes": ("Foot Pressure",
                "Pulse over the big and second toes.",
                "Over many pulses the weight can drift onto the outside edges of the feet. One small heel-raise study found the peroneus longus, down the outside of the lower leg, did less when the ankle rolled out than when the weight stayed toward the big toe.",
                "Rolling onto the outside edges of the feet as the pulses go on.",
                "Keep your weight behind the big and second toes on every pulse, ankles square."),
       "tempo": ("Rhythm",
                 "Pulse at a steady, controlled pace; no bouncing.",
                 "The model pulses about three times every two seconds. A pulse guide warns against rushing; a fast bounce lets the Achilles tendon help spring the heels back up, since in an all-out dip-and-push ankle movement the tendon, not the gastrocnemius fibres, stored the energy and handed it back.",
                 "Bouncing the heels as fast as possible.",
                 "Keep each pulse small and even, about three every two seconds, then lower the heels to the floor under control after the last one."),
   },
   # Paint as the hold: calves bright (UNLOADED), hamstrings and quadriceps
   # dim (LOW, paint-led judgements, as the hold).
   activation=UNLOADED + [("Quadriceps", S, LOW, 0.20), ("Hamstrings", S, LOW, 0.15)],
   stabilisers=FOOT + ["core"],
   comparison=("HEELS DROPPING", "Small pulses near the top", "Heels drop to the floor between pulses",
               "Keeping the pulses small and high keeps the calves working at the top of the range with no rest.",
               "Dropping the heels most of the way turns the pulses into quick partial reps and takes them out of the top of the range."),
   glows=calves(N))

SETUP[N] = [
    "Set your feet hip-width apart on flat ground, toes forward.",
    "Arms by your sides; a hand on a wall is fine if you wobble.",
    "Keep your knees long but unlocked.",
    "Rise onto the balls of your feet as high as you can before the first pulse.",
]

# ---------------------------------------------------------------- Farmer's Walk on Toes

N = "Farmer's Walk on Toes"
ex(name=N, var="farmersWalkOnToes",
   # Three-quarter from the front left (yaw -1.0): the lifter faces the
   # camera turned to screen-left; the far dumbbell on the left (u
   # ~0.27-0.40, v ~0.47-0.55), the near one and the near arm on the right
   # (u ~0.50-0.72); the feet low in the middle. Every label that points at
   # the body sits on the left, where only the far arm and dumbbell are (a
   # right-hand leader to the hips or chest would cross the near dumbbell or
   # arm): posture to the head, shoulders to the far shoulder, hips to the
   # far hip below the far dumbbell, steps to the far foot; heels right, to
   # the near ankle.
   overrides={"posture": (ov(0.16), "leading"), "shoulders": (ov(0.27), "leading"), "hips": (ov(0.62), "leading"),
              "steps": (ov(0.80), "leading"), "heels": (ov(0.80), "trailing")},
   annotations=[
       ("heels", "Heels stay up", "foot_L"),
       ("posture", "Walk tall", "head"),
       ("shoulders", "Shoulders back", "upper_arm_R"),
       ("hips", "Hips level", "thigh_R"),
       ("steps", "Short, quiet steps", "foot_R"),
   ],
   cues={
       "heels": ("Heels Up",
                 "Stay on the balls of the feet for the whole set; the heels never touch the floor.",
                 "Keeping the heels up is what makes this a calf exercise: the calves hold your body and both dumbbells on the balls of the feet the whole time, and on one foot each time the other lifts. One guide to walking on the toes warns against letting the heel drop as a foot takes the weight.",
                 "The heels dropping to the floor each time a foot takes the weight.",
                 "Rise onto the balls of your feet before the first step and stay as tall on them as you can until the set time is up."),
       "posture": ("Posture",
                   "Stand tall, ribs over the hips.",
                   "Upright, the weight of your body and the dumbbells runs straight down onto the balls of the feet. Leaning over the dumbbells tips that weight ahead of the feet, so you chase your balance instead of holding the heels up; guides for this walk say to stand tall, chest up.",
                   "Leaning forward over the dumbbells as the set goes on.",
                   "Brace your trunk and keep your head, ribs and hips stacked over the balls of your feet for the whole set."),
       "shoulders": ("Shoulders",
                     "Shoulder blades slightly back, the dumbbells hanging straight at your sides.",
                     "The dumbbells pull the shoulders down and forward for the whole set. Guides for this walk cue the shoulders back, and one says you will feel the shoulder blades working along with the calves; letting the shoulders sag forward rounds the upper back over the weights.",
                     "Shoulders sagging forward, the upper back rounding over the dumbbells.",
                     "Draw your shoulder blades gently back and down, chest up, arms straight, and keep them there without shrugging."),
       "hips": ("Level Hips",
                "Keep the hips level each time a foot lifts.",
                "Every step leaves you on one foot for a moment. The gluteus medius on the standing side holds the pelvis level; ExRx describes it keeping the pelvis from sagging on the side with no leg under it, and in one farmer's walk study it worked at about a quarter to half of its maximum.",
                "The hip of the lifting leg dropping as that foot leaves the floor.",
                "Shift your weight onto the standing foot, firm up that hip and keep both hip bones level as the other foot lifts."),
       "steps": ("Steps",
                 "Short, quiet steps on the spot, each foot just clearing the floor.",
                 "This version marches on the spot: each foot lifts only a few centimetres, about three steps every two seconds, so you stay on the balls of the feet throughout. One guide for this walk calls for controlled, quiet steps, one at a time. If you have the room you can walk forward the same way.",
                 "Stamping or taking long, reaching steps that bring the heels down.",
                 "Lift one foot a few centimetres, set it down on its ball, then the other, quietly and evenly until the set time is up."),
   },
   # Paint: calves bright (PRIMARY, LOADED: body weight plus two dumbbells,
   # on one foot between steps). Dim: the forearms, trapezius, rhomboid,
   # hamstrings and quadriceps. Three LOW/MODERATE secondary rows for minor
   # roles (Fitbod's Dumbbell Toe Walks lists forearms and trapezius as
   # secondary; the Prehab Guys' Toe Walking says you may feel the
   # quadriceps): Forearms 0.40 (holding the dumbbells for a whole timed
   # set; between the calfstand dumbbell raise's 0.30 and the library
   # Farmer's Carry's 0.80, where grip is the target; no EMG, a judgement),
   # Trapezius 0.30 (holding the shoulders under the dumbbells; the dumbbell
   # raise's 0.28, a judgement), Quadriceps 0.25 (steadying the standing
   # knee; a judgement). The rhomboids and hamstrings go in the stabilisers:
   # a fourth secondary name would run the one-line legend past its ~43
   # characters.
   activation=LOADED + [("Forearms", S, MOD, 0.40), ("Trapezius", S, LOW, 0.30), ("Quadriceps", S, LOW, 0.25)],
   stabilisers=["gluteus medius", "rhomboids", "hamstrings", "core"] + FOOT[:2],
   comparison=("HEELS DROPPING", "Heels up, on the balls of the feet", "Heels touch down with each step",
               "Staying on the balls of the feet keeps the calves holding you and both dumbbells for the whole set.",
               "Letting the heels touch down gives the calves a rest on every step and turns it into an ordinary carry."),
   glows=calves(N, dx=0.0, rx=0.04, ry=0.07) + [glow(N, ["forearm_L", "hand_L"], SOFT, 0.25, 0.03, 0.05, 0.0, 0.0)])

SETUP[N] = [
    "Stand between two dumbbells, feet hip-width apart.",
    "Bend at the knees and hips, back flat, and take each handle in the middle, palms facing in.",
    "Stand up tall with the dumbbells hanging at your sides, arms straight.",
    "Rise onto the balls of your feet, then march on the spot for the set time.",
]

# ---------------------------------------------------------------- Banded Plantar Flexion

N = "Banded Plantar Flexion"
ex(name=N, var="bandedPlantarFlexion",
   # From the front left (yaw -0.8): the lifter sits on the right (head u
   # 0.72, v 0.37), the legs run left along the mat to the feet at u
   # ~0.18-0.35, v ~0.55-0.68; the bands run from the hands (v ~0.54) to the
   # feet; the mat across v ~0.66-0.76. Everything above v ~0.33 and the
   # left above the feet is open. Hands (to the far fist, left of the
   # torso) and top (to the far toes) on the left above the legs; back
   # right above the head; return (to the far heel) and knees (to the near
   # knee) on the bottom row below the mat, their leaders over the static
   # mat.
   overrides={"hands": (ov(0.30), "leading"), "top": (ov(0.40), "leading"), "back": (ov(0.17), "trailing"),
              "return": (ov(0.80), "leading"), "knees": (ov(0.80), "trailing")},
   annotations=[
       ("top", "Point the toes fully", "toe_R"),
       ("return", "Back up slowly", "foot_R"),
       ("knees", "Legs straight", "patella_L"),
       ("hands", "Hands still, band taut", "hand_R"),
       ("back", "Sit tall", "head"),
   ],
   cues={
       "top": ("Point the Foot",
               "Push the balls of the feet into the bands until the toes point as far as they go, and pause.",
               "An elastic band pulls harder the further it is stretched, so the end of the push, toes fully pointed, is where it resists most. Here the ankles point about 40° from where they start. Stopping short leaves out the part of the range where the band pulls hardest.",
               "Turning back with the toes only partway pointed.",
               "Press through the balls of your feet until your toes point as far as they go, hold for about a second, then let them come back."),
       "return": ("The Return",
                  "Let the bands draw the feet back slowly until the toes point straight up.",
                  "Physiotherapy guides for this exercise point the foot slowly and return it slowly to the start, under control. The model comes all the way back to a right angle at the ankle each rep, so every push starts from the same place; cutting the return short leaves the feet half pointed.",
                  "Letting the feet stay half pointed between reps, so each push starts partway through.",
                  "Resist the bands as they pull your toes back up, take a little longer than the push, and pause with the toes pointing at the ceiling."),
       "knees": ("Straight Legs",
                 "The legs stay straight, kneecaps facing the ceiling.",
                 "Guides set this exercise up with the leg straight and the kneecap facing up. With the knee straight the gastrocnemius, which crosses the back of the knee, stays long enough to help the soleus point the foot; ExRx notes that bending the knee makes the soleus more active. Bending the knees also lets the feet slide toward you, which slackens the bands.",
                 "Bending the knees so they lift off the mat and the feet slide toward you.",
                 "Keep your legs long on the mat with a rolled towel under the lower calves, kneecaps up, and move only at the ankles."),
       "hands": ("Band Tension",
                 "Hold the band ends still beside your hips so the bands stay taut.",
                 "A band only resists as far as it is stretched; in a study of exercise bands the pull rose steadily with how far they were pulled out. If the hands drift forward as the feet push, the bands slacken and the calves push against less. One guide even has you draw the band toward you as you push.",
                 "Letting the hands follow the feet forward, the bands going slack.",
                 "Hold the two ends of each band in the hand on that side, elbows bent at your sides, and keep your hands still while the feet push."),
       "back": ("Sitting Posture",
                "Sit up tall on the mat.",
                "Sitting with straight legs bends the hips while the knees are straight, which stretches the hamstrings. ExRx notes that in calf exercises done with the hips bent and the knees straight, tight hamstrings can show as a subtly rounded lower back or a slight knee bend. Sitting tall keeps the pelvis upright and the legs flat.",
                "Slumping, the lower back rounding and the head dropping forward.",
                "Sit up on your sit bones with your chest lifted; if your back rounds, sit with it against a wall."),
   },
   # Paint: calves bright, nothing dim. Knees 170: the gastrocnemius leads,
   # as on the calfseat family's 168-degree machines, but against an elastic
   # band, far lighter than body weight (Uchida 2016 measured even the
   # heaviest, gold, Thera-Band under 9 kgf at 250% elongation), so both are
   # set lower: Gastrocnemius
   # 0.60, Soleus 0.48 (both MODERATE, PRIMARY). No EMG for banded plantar
   # flexion was found; a judgement call.
   activation=[("Gastrocnemius", P, MOD, 0.60), ("Soleus", P, MOD, 0.48)],
   stabilisers=FOOT + ["forearms"],
   comparison=("BAND GOING SLACK", "Hands still, bands taut", "Hands drift forward with the feet",
               "With the hands held still the bands stretch further as the toes point, so the calves push against more toward the end.",
               "Letting the hands follow the feet slackens the bands, and the calves push against little at the point where the band should pull hardest."),
   glows=calves(N, dx=0.0, dy=0.02, rx=0.08, ry=0.03))

SETUP[N] = [
    "Sit on a mat with your legs straight out in front of you, feet hip-width apart.",
    "Put a rolled towel under your lower calves so your heels are just off the mat.",
    "Loop a band round the ball of each foot and hold the ends beside your hips, elbows bent.",
    "Sit tall and pull the bands taut with your toes pointing up.",
]
