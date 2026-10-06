# Trainer content for the 401-500 folder, second round (415-444, 2026-10-04),
# family: tibialis. Five lifts for the muscles at the front of the shin, from
# the builder's 417-425 exports: 417 Tibialis Raise (Legs/TibialisRaise), 420
# Single-Leg Tibialis Raise (Legs/SingleLegTibialisRaise), 419 Wall Tibialis
# Raise (Legs/WallTibialisRaise), 418 Machine Tibialis Raise
# (Legs/MachineTibialisRaise) and 425 Banded Dorsiflexion
# (Legs/BandedDorsiflexion). Same format as spec.py on top of common_1_50.py;
# spec_500.py imports this module and gen.py reads SPEC / SETUP.
# notes_500_tibialis.md maps the copy's claims to the sources below and
# records the model facts.
#
# What the models show, from the leg briefs (SCRATCH/briefs2_legs), the
# trainer stills at 0/1/2/3/5 s (SCRATCH/stills), tiers2.json, joints.json
# and the rigs, equipment and skinned shoes read from the USD with Blender's
# Python + pxr (SCRATCH/tibialis/measure.py, timeline.py, tipdist.py; the
# app's Y-up space, the lifter facing +z, their left +x). Ankle angles are
# the rig's shin-to-foot-bone angle (ankle joint to the ball of the foot): it
# reads ~107° with the sole flat under a near-vertical shin (the bone points
# ~22° down), smaller as the toes come up; the foot at 90° to the tibia is
# ~112° (90° plus that 22°; the calf families quote ~109-111°). Every clip
# is 7.96 s with two identical reps (phases at 5-95% of the ankle's range):
# toes down to 0.12 s, lifting 0.17-0.83 s (~0.7 s), held up 0.88-2.17 s
# (~1.3 s), lowered 2.21-3.25 s (~1.1 s), resting down 3.29-4.12 s (~0.8 s),
# then again (the machine and band clips ~0.02-0.04 s earlier); the ankle is
# still only 1.0-2.0 s and 3.5-4.0 s, the rest being slow ease in and out.
# - Tibialis Raise: standing on a flat floor, no equipment and no support, feet
#   hip-width (ankles 0.25 m apart), arms hanging at the sides (elbows 170°),
#   knees 173-174° throughout. Ankle 107° -> 87°: the forefoot turns up ~24°
#   about the planted heels (foot bone 22° below level -> 2° above), the shoe
#   tips rise from 2 to 15.5 cm, the heels never leave the floor. As the toes
#   rise the pelvis travels ~8 cm back (and 1.5 cm up) and the trunk tips from
#   1° to 5° forward (hips 172° -> 167°), keeping the weight over the heels; all
#   of it comes back as the soles return flat. Paint: tibialis anterior,
#   tibialis posterior, fibularis longus and extensor digitorum longus bright,
#   nothing dim.
# - Single-Leg Tibialis Raise: the LEFT leg works (left knee 174°, ankle 105° ->
#   84°, the same forefoot lift and hip shift as above), the pelvis over the
#   left foot (11 cm left of centre). The right knee is bent 129°, the right
#   ankle 0.27-0.39 m behind the left heel, the foot only ~5.5 cm (the shoe's
#   lowest point) off the floor at the bottom of each rep, ~9 cm at the top; it
#   never touches down. The right hand holds a post (HG_SupportPost, 1.23 m
#   tall, 0.38 m to the right of the midline, level with the hips) at 1.10 m,
#   elbow 103-107°; the left arm hangs at the side. Paint: as the Tibialis
#   Raise, plus the quadriceps dim.
# - Wall Tibialis Raise: leaning back on a wall (HG_Wall, face at z -0.02): the
#   heels ~40 cm out from it (the ankle joints ~47 cm), feet hip-width, knees
#   168°, hips 156° -> 159°, the trunk 6° and the shins 16° back from vertical,
#   arms hanging at the sides. Ankle 128.5° -> 100°: the forefoot turns up ~26°
#   (shoe tips 2 -> 16 cm), heels down; as it does the body slides ~3 cm up the
#   wall. Because the shins lean back, each rep starts with the ankles ~17°
#   pointed (the free-standing raise starts about neutral) and travels 28°
#   (against 20°). Paint: as the Single-Leg raise (quadriceps dim).
# - Machine Tibialis Raise: seated on a flat bench (seat top 42 cm), knees 84°,
#   hips 81°, shins vertical, trunk 4° forward, hands resting on the thighs
#   (elbows 96°). The feet sit in a rocker lever (HG_TibLever): the heels in a
#   cradle behind the pivot, a roller pad across the tops of the feet (the
#   instep: it touches the shoe 5-12 cm ahead of the ankle joints, behind the
#   balls of the feet at 15 cm), the lever's axle (HG_TibAxle) level with and in
#   line with the ankle joints (y 0.17 m, z 0.44 m both). Ankle 126.5° -> 92°
#   (35°): from the toes ~15° below level (the foot bone 37° down) to ~20°
#   above; the roller rises ~6 cm, the heel cradle swings down, the heels stay
#   ~9-11 cm off the floor in the cradle. Paint: the four shin muscles, nothing
#   dim.
# - Banded Dorsiflexion: long-sitting on a mat (HG_Mat), legs straight (knees
#   170°), feet hip-width, a 4 cm towel roll (HG_TowelRoll) under the lower
#   calves ~15 cm above the ankles so the heels hang clear of the mat (the
#   shoe's lowest point 1.3 cm up with the toes pointed, 4.7 cm with them pulled
#   back); the trunk reclined 34° behind vertical (hips 122°), propped on
#   straight arms (elbows 171°) with the hands on the mat ~30 cm behind the
#   hips. A band (HG_BandL/R, two strands a side) runs from a low anchor
#   (HG_BandAnchor / HG_AnchorPost, 15-17 cm up, ~55 cm beyond the ankles) over
#   the tops of the feet across the forefoot (it touches the shoe 9-12 cm ahead
#   of the ankle joints, 3-6 cm behind the balls of the feet) and stays taut all
#   rep; its lever arm about the ankle grows ~10.6 -> 12.6 cm as the feet come
#   back. Ankle 122.7° -> 87.8° (35°): from ~11° pointed to ~24° past neutral.
#   Paint: the four shin muscles, nothing dim. (The calfmore family's Banded
#   Plantar Flexion sits upright holding its band; this one reclines on its
#   hands with the band anchored ahead.)
#
# How they differ from the library: there is no tibialis or dorsiflexion
# lift in the library; the nearest are the calf raises, which move the ankle
# the other way. The five set the house style: the copy names the tibialis
# anterior as the lifting muscle and never says the tibialis posterior or
# the fibularis lifts the toes. Cue sets: hips, knees, top, floor, tempo
# (free-standing); balance hand, free leg, level hips, top, floor (one
# leg); wall, foot distance, straight legs, top, tempo (wall); heels, seat,
# top, bottom, tempo (machine); recline, band position, top, bottom, return
# speed (band).
#
# Sources (abstracts and full texts read on Europe PMC / PubMed records
# 2026-10-04, ExRx on the Wayback Machine, the coaching pages live; details
# and what each supports in the notes):
# - ExRx.net (Wayback Machine; the live site returns 403): Reverse Calf Raise
#   (TibialisAnterior/BWReverseCalfRaise, snapshot 2026-05-20), Single Leg
#   Reverse Calf Raise (BWSingleLegRevCalfRaise, 2025-08-16), Lever Seated
#   Tibia Raise (plate loaded; LVSeatedTibiaRaisePL, 2023-06-01), Dumbbell
#   Reverse Calf Raise (2023-11-21), Lever Reverse Calf Raise (2023-11-21),
#   Calf Exercise Analyses (Kinesiology/CalfExercises, 2026-06-25: its Dorsal
#   Flexors, Tibia Raise, Reverse Calf Press, Reverse Calf Raise and Hip
#   Position Analysis sections) and the Tibialis Anterior muscle page
#   (2024-01-05): set-ups and execution (heels on the forward edge of a block,
#   a hand on a support for balance, the other leg lifted to the rear by
#   bending the knee, toes pulled up as far as possible and returned until
#   they point down, knees and hips straight throughout); the easier
#   versions (both legs; lighter load or heels further onto the platform if
#   the support hand has to help) and the harder ones (heels nearer the
#   edge, one leg); the one-leg stabilisers (gluteus medius and maximus,
#   quadratus lumborum, obliques); the seated tibia raise (feet under a
#   padded lever with the heels on a pedal; avoid pushing the pedal down with
#   the heels; scoot back until full plantar flexion is felt at the bottom;
#   set a criterion for the top; no significant stabilisers); the dorsal
#   flexors (tibialis anterior, extensor digitorum longus, extensor hallucis
#   longus, peroneus tertius); a largely continuous tension curve with a
#   chance to relax only at the bottom; the tibia raise's torque relatively
#   high throughout; dorsiflexion with the hips sharply bent and the knees
#   straight limiting or hardening the top (the hamstrings pulling on the
#   gastrocnemius) and a more reclined position recommended on the seated
#   reverse calf press for a fuller range; the tibialis anterior dorsal flexes
#   and inverts, from the lateral tibia to the medial cuneiform and first
#   metatarsal.
# - StrengthLog, Tibialis Raise (strengthlog.com/tibialis-raise, read
#   2026-10-04): the wall version, standing 20-30 cm from the wall, leaning on
#   it with slight core tension, legs straight, toes as high as possible
#   without the heels leaving the ground, lowered in a controlled manner;
#   tibialis anterior the primary muscle. Kettlebell Tibialis Raise
#   (strengthlog.com/kettlebell-tibialis-raise): squeeze at the top, lower.
# - Hinge Health, How to Do Tibialis Raises: A Hinge Health Guide
#   (hingehealth.com/resources/articles/tibialis-raises, 2024-07-26; Maureen
#   Lu, PT, DPT, clinical reviewer; read 2026-10-04 and re-read in review
#   2026-10-05): back against a wall, feet about a foot out; easier
#   with one foot at a time; harder with the feet further from the wall, so
#   the feet move through a bigger range when the toes lift.
# - Marsh E, Sale D, McComas AJ, Quinlan J 1981, J Appl Physiol 51(1):160-167,
#   doi:10.1152/jappl.1981.51.1.160, PMID 7263411 - the tibialis anterior's
#   optimum length near 10° of plantar flexion; maximum voluntary dorsiflexion
#   torque also at 10° of plantar flexion, falling sharply once the ankle was
#   dorsiflexed beyond 5°; at mid-position the tibialis anterior gave less
#   than half the maximum voluntary torque, the rest presumably from the long
#   toe extensors.
# - Baldim I, Miguel MS, Spinoso DH 2024, J Bodyw Mov Ther 40:862-867,
#   doi:10.1016/j.jbmt.2024.05.036, PMID 39593687 (abstract; the preprint's
#   full text, Research Square doi:10.21203/rs.3.rs-3851380/v1, for the
#   methods and table) - 30 young women, surface EMG: dorsiflexion against an
#   elastic band (supine, knee straight, band across the front of the
#   forefoot, 3 s up and 3 s down) worked the tibialis anterior at 49.84 +-
#   13.49% MVIC; its discussion: the peroneals control the ankle's inverting
#   moment.
# - Semple R, Murley GS, Woodburn J, Turner DE 2009, J Foot Ankle Res 2:24,
#   doi:10.1186/1757-1146-2-24, PMID 19691828 (PMC2739849, full text) -
#   tibialis posterior: its tendon's course makes it an inverter and plantar
#   flexor; the most powerful supinator of the hindfoot.
# - Hagen M, Schwiertz G, Landorf KB, Menz HB, Murley GS 2016, Hum Mov Sci
#   50:30-37, doi:10.1016/j.humov.2016.10.002, PMID 27721087 (abstract) - the
#   pronators and supinators (tibialis posterior, peroneus longus) play a key
#   role in the side-to-side stability of the ankle; each shank muscle's
#   activity follows its course around the ankle and subtalar axes.
# - Kim J, Kang S, Kim SJ 2022, Sci Rep 12:10796, doi:10.1038/s41598-022-14313-8,
#   PMID 35750787 (PMC9232603; full text) - its abstract and introduction:
#   the peroneus longus supports the lateral ankle ligaments (the notes only,
#   for the Fibularis Longus row's steadying role).
# No EMG study of these five lifts as the models do them was found, so every
# fraction but the band's is a judgement call: Tibialis Anterior 0.78 for the
# two-foot body-weight raises (the calfstand family's unloaded two-leg calf
# value), 0.86 where one shin carries the body or a loaded lever (the loaded
# calf value), 0.50 for the band (Baldim 2024's 49.84% MVIC for the same
# movement). The painted tibialis posterior and fibularis longus are listed
# as LOW secondary rows (see the notes for why they are not primary), the
# toe extensors and the dim quadriceps in the stabilisers.
from common_1_50 import *


def ov(final):
    """Pre-squeeze override row for an on-screen row (spec_500.row() maps
    0.14-0.86 to 0.16-0.80)."""
    return round(0.14 + (final - 0.16) * (0.86 - 0.14) / (0.80 - 0.16), 4)


def shins(name, dx=-0.012, dy=0.0, rx=0.035, ry=0.07, near="L", both=True):
    """The front of the shins between knee and ankle, nudged toward the shin
    bone (to the left on the screen-left-facing framings): the near (left)
    shin full, the far one soft. The one-leg raise glows the left shin only."""
    far = "R" if near == "L" else "L"
    out = [glow(name, [f"shin_{near}", f"foot_{near}"], A, 0.55, rx, ry, dx, dy)]
    if both:
        out.append(glow(name, [f"shin_{far}", f"foot_{far}"], SOFT, 0.32, rx * 0.9, ry * 0.9, dx, dy))
    return out


# The painted tibialis posterior and fibularis longus: LOW secondary rows for
# a steadying role (Hagen 2016: the ankle's supinators and pronators keep it
# stable side to side; Semple 2009: the tibialis posterior inverts and
# plantar flexes), never for lifting the toes. Sized by how much side-to-side
# balance each version asks: one heel 0.30, two heels 0.20, feet held in a
# lever or sitting 0.15. Judgement calls; no study measured them in these lifts.
def steadiers(f):
    return [("Tibialis Posterior", S, LOW, f), ("Fibularis Longus", S, LOW, f)]


# ---------------------------------------------------------------- Tibialis Raise

N = "Tibialis Raise"
ex(name=N, var="tibialisRaise",
   overrides={"tempo": (ov(0.18), "trailing"), "hips": (ov(0.44), "trailing"),
              "knees": (ov(0.58), "leading"), "top": (ov(0.74), "leading"),
              "floor": (ov(0.80), "trailing")},
   annotations=[
       ("hips", "Hips stay tall", "pelvis"),
       ("knees", "Knees straight", "patella_L"),
       ("top", "Toes high, hold", "toe_L"),
       ("floor", "Soles back down", "foot_L"),
       ("tempo", "Lower slowly", "head"),
   ],
   cues={
       "hips": ("Tall Hips",
                "Stay tall; the hips ease back only a little as the toes rise.",
                "With the toes up, your heels are all you stand on, so your weight has to move back over them, and a small shift of the hips does it. ExRx keeps the hips straight in this lift; it notes that lifting the feet with the hips bent far and the knees straight pulls the hamstrings and calves tight, which can make the top harder or cut it short.",
                "Folding forward at the hips and pushing the backside out to stay balanced.",
                "Keep your chest up and your hips nearly straight, and let them drift back a little as the toes come up."),
       "knees": ("Straight Knees",
                 "The knees stay straight from the first rep to the last.",
                 "ExRx keeps the knees straight in its standing toe raises, so only the ankles move. Bending them tips the shins forward over flat feet, which bends the ankles up before the toes have moved and leaves less room for the lift.",
                 "Bending the knees and sinking back to keep your balance.",
                 "Straighten your knees without locking them hard, and let the lift come from the ankles alone."),
       "top": ("Top of the Rep",
               "Lift the toes as high as they go and hold for about a second.",
               "In a lab study of the muscles that lift the foot, they made the most force with the foot pointed slightly down and lost force quickly once the ankle bent up past a few degrees. The top is where they are weakest, so pausing there makes the hardest part of each rep count.",
               "Tapping the toes up only partway before lowering.",
               "Pull the fronts of your feet up toward your shins until they stop, keep the heels down, hold for about a second, then lower."),
       "floor": ("Bottom of the Rep",
                 "Lower until the soles rest flat on the floor every rep.",
                 "On flat ground the floor is the bottom of the range, where the front of the shin is longest. ExRx sets this lift up with the heels on the edge of a block so the toes can drop below level and start each rep longer still. Hovering above the floor does the opposite and trims every rep.",
                 "Keeping the toes hovering off the floor between reps.",
                 "Lower until the whole sole is back on the floor, let it rest there for a moment, then lift again."),
       "tempo": ("Lowering Speed",
                 "Lower the toes under control; do not let them drop.",
                 "The muscle at the front of the shin lowers the foot as well as lifting it, working as it lengthens. Letting the feet fall hands that half of every rep to gravity, and the toes slap the floor.",
                 "Letting the toes drop and slap the floor after each lift.",
                 "Lift in under a second, hold the top, then take a little longer to lower and set the soles down quietly."),
   },
   # Paint: the four shin muscles bright, nothing dim. Tibialis Anterior 0.78
   # PRIMARY (two feet, body weight only; a judgement, see the header).
   activation=[("Tibialis Anterior", P, HI, 0.78)] + steadiers(0.20),
   stabilisers=["toe extensors", "core"],
   comparison=("HIPS FOLDING", "Tall, hips nearly straight", "Folds at the hips to balance",
               "Staying tall with only a small hip shift keeps your weight over the heels and leaves the ankles free to lift the toes all the way.",
               "Folding far forward at the hips with straight knees pulls the hamstrings and calves tight, which ExRx notes can make the top of the lift harder or cut it short."),
   glows=shins(N))

SETUP[N] = [
    "Stand on a flat floor with your feet about hip-width apart, pointing straight ahead.",
    "Let your arms hang by your sides, near a wall or rail you can touch if you tip back.",
    "Straighten your knees, keeping them soft rather than locked.",
    "Start with both soles resting flat on the floor.",
]

# ---------------------------------------------------------------- Single-Leg Tibialis Raise

N = "Single-Leg Tibialis Raise"
ex(name=N, var="singleLegTibialisRaise",
   overrides={"post": (ov(0.22), "leading"), "hips": (ov(0.44), "trailing"),
              "free": (ov(0.58), "trailing"), "top": (ov(0.62), "leading"),
              "floor": (ov(0.80), "leading")},
   annotations=[
       ("post", "Light grip", "hand_R"),
       ("free", "Right foot stays up", "foot_R"),
       ("hips", "Hips level", "pelvis"),
       ("top", "Toes high, hold", "toe_L"),
       ("floor", "Sole flat", "toe_L"),
   ],
   cues={
       "post": ("Balance Hand",
                "The right hand rests on the post only to keep you steady.",
                "ExRx sets up the one-leg toe raise with a hand on a support for balance, and points you to an easier version if that hand starts to help. Pulling on the post leans you toward it and takes weight off the left heel, so the shin has less to lift.",
                "Leaning toward the post and pulling on it as the toes come up.",
                "Rest your right hand on the post with a loose grip and stand upright over the left foot. If the hand has to help, go back to both feet for a while."),
       "free": ("Free Leg",
                "The right foot stays off the floor, the knee bent behind you.",
                "ExRx has you lift the other leg to the rear by bending the knee, and lists using both legs as the easier version. Here the right foot hangs only a few centimetres above the floor at the bottom of each rep, so it is easy to let it touch down and share the work.",
                "Touching the right foot down between reps to rest or rebalance.",
                "Keep the right knee bent and the foot hanging behind the left heel from the first rep to the last."),
       "hips": ("Level Hips",
                "Both hips stay level while you balance on the left heel.",
                "On one leg the hip muscles of the standing side hold the pelvis up; ExRx names the gluteus medius and maximus, quadratus lumborum and obliques as this lift's stabilisers. Level hips keep your weight stacked over the left heel, while the muscles either side of the ankle stop the foot rolling in or out.",
                "The right hip sagging toward the floor as the toes come up.",
                "Tighten the left hip, keep both hip bones at the same height and let the right leg hang loose."),
       "top": ("Top of the Rep",
               "Pull the left toes up as high as they go and hold.",
               "The muscles at the front of the shin are weakest with the foot pulled right up, and on one leg there is no second foot to share the load. Holding the top for a second works them where the rep is hardest.",
               "Lowering again with the toes only partway up.",
               "Lift the front of the left foot until it stops, heel down, hold for about a second, then lower."),
       "floor": ("Bottom of the Rep",
                 "Set the left sole flat on the floor between reps.",
                 "Lowering all the way returns the foot to the floor, where the front of the shin is longest, so each lift uses the whole range this flat-floor version has. ExRx sets the one-leg toe raise up with the heel on the edge of a platform, so the toes can drop below it.",
                 "Starting each lift with the toes still hovering above the floor.",
                 "Lower under control until the whole left sole touches the floor, pause briefly, then lift again."),
   },
   # Paint: the four shin muscles bright, the quadriceps dim. Tibialis
   # Anterior 0.86 PRIMARY (one shin lifts against the whole body; a
   # judgement). The steadiers 0.30: balancing on one heel. The dim
   # quadriceps (holding the standing knee straight) are named in the
   # stabilisers: a third secondary name would run the one-line legend past
   # its ~43 characters (as the calfstand family's rhomboids).
   activation=[("Tibialis Anterior", P, HI, 0.86)] + steadiers(0.30),
   stabilisers=["toe extensors", "quadriceps", "gluteus medius", "gluteus maximus", "quadratus lumborum", "obliques"],
   comparison=("FREE FOOT TOUCHING", "Right foot hangs behind", "Right foot taps the floor",
               "With the right foot off the floor, the left shin lifts against your weight alone on every rep.",
               "Touching the right foot down turns part of each rep into a two-foot toe raise, the easier version ExRx lists."),
   glows=shins(N, both=False))

SETUP[N] = [
    "Stand beside a sturdy post and hold it lightly with your right hand.",
    "Put your weight on your left foot, toes forward, knee straight.",
    "Bend your right knee to lift that foot behind you.",
    "Stand tall with your hips level over the left foot.",
]

# ---------------------------------------------------------------- Wall Tibialis Raise

N = "Wall Tibialis Raise"
ex(name=N, var="wallTibialisRaise",
   overrides={"tempo": (ov(0.24), "trailing"), "wall": (ov(0.44), "trailing"),
              "knees": (ov(0.56), "leading"), "feet": (ov(0.64), "leading"),
              "top": (ov(0.80), "leading")},
   annotations=[
       ("wall", "Back on the wall", "scapula_L"),
       ("feet", "Heels well out", "foot_L"),
       ("knees", "Legs straight", "patella_L"),
       ("top", "Toes up", "toe_L"),
       ("tempo", "Lower slowly", "head"),
   ],
   cues={
       "wall": ("Lean on the Wall",
                "Your upper back and hips rest on the wall for the whole set.",
                "StrengthLog sets this raise up leaning back on a wall with the trunk lightly braced. The wall holds your balance, so the toes can come all the way up without you tipping backward, as you might on a free-standing raise.",
                "Letting the hips drift forward off the wall, the knees bending.",
                "Rest your upper back and backside on the wall, brace your trunk lightly and keep them there as the toes rise and lower."),
       "feet": ("Foot Distance",
                "Set your heels well out from the wall, here about 40 cm.",
                "The further out your feet, the more your shins lean back and the more pointed the ankles are when each rep starts. A physical therapy guide makes this raise harder by moving the feet further from the wall for that bigger range; standing close shortens every rep.",
                "Standing with the heels close to the wall, the shins almost upright.",
                "Walk your feet out until your shins lean back, then lean on the wall. StrengthLog starts 20 to 30 cm out; move further as the raise gets easier."),
       "knees": ("Straight Legs",
                 "The legs stay long, the knees nearly straight.",
                 "StrengthLog keeps the legs straight for this raise. Bending the knees lets you slide down the wall and brings the shins upright over the feet, which takes away the lean that gives this version its longer range.",
                 "Bending the knees and sliding down the wall.",
                 "Keep your knees straight without locking them and let only the fronts of your feet move."),
       "top": ("Top of the Rep",
               "Lift the toes as high as they go, heels down, and hold.",
               "StrengthLog has you lift the toes as high as possible without the heels leaving the floor. The front of the shin is weakest with the foot pulled right up, so a second's hold works the hardest part of the range. Your back may slide a little up the wall as the toes rise.",
               "Stopping with the toes halfway up.",
               "Draw the tops of your feet toward your shins until they stop, hold for about a second, then lower."),
       "tempo": ("Lowering Speed",
                 "Lower the toes slowly back to the floor.",
                 "StrengthLog has you lower the toes in a controlled way. The shin muscles let the foot down as well as lift it, so a slow return keeps them working instead of letting the feet slap the floor.",
                 "Dropping the toes so the feet slap the floor.",
                 "Lower for about a second, set the soles down quietly, then lift again."),
   },
   # Paint: the four shin muscles bright, the quadriceps dim. Tibialis
   # Anterior 0.78 PRIMARY (two feet, body weight; the longer range is not a
   # heavier load; a judgement). The dim quadriceps (holding the knees
   # straight as you lean) are named in the stabilisers for legend width.
   activation=[("Tibialis Anterior", P, HI, 0.78)] + steadiers(0.20),
   stabilisers=["toe extensors", "quadriceps", "core"],
   comparison=("FEET TOO CLOSE", "Heels well out from the wall", "Heels close to the wall",
               "With the feet well out the shins lean back, so each rep starts with the ankles more pointed and the toes travel further.",
               "Close to the wall the shins stand nearly upright and every rep starts higher, so the toes travel a shorter way."),
   glows=shins(N))

SETUP[N] = [
    "Stand with your back to a wall and walk your heels out, here about 40 cm from it.",
    "Lean back until your upper back and backside rest on the wall.",
    "Set your feet hip-width apart, toes forward, legs straight.",
    "Let your arms hang by your sides and brace your trunk lightly.",
]

# ---------------------------------------------------------------- Machine Tibialis Raise

N = "Machine Tibialis Raise"
ex(name=N, var="machineTibialisRaise",
   overrides={"tempo": (ov(0.20), "trailing"), "seat": (ov(0.20), "leading"),
              "top": (ov(0.40), "leading"), "heels": (ov(0.80), "trailing"),
              "bottom": (ov(0.86), "leading")},
   annotations=[
       ("heels", "Heels light", "foot_L"),
       ("seat", "Shins upright", "patella_R"),
       ("top", "Lift, hold", "toe_R"),
       ("bottom", "Toes down", "toe_L"),
       ("tempo", "Lower slowly", "head"),
   ],
   cues={
       "heels": ("Heels Light",
                 "The shin muscles lift the pad; the legs do not press down.",
                 "ExRx warns against using other muscles to push the heel pedal down as the lever rises. Here the lever turns about the same line as your ankles, so pushing down through your legs cannot lift the pad; only the muscles at the front of the shins can, by turning the feet up.",
                 "Driving the heels down into the cradle to help the pad up.",
                 "Let your heels rest in the cradle without pushing, and lift the pad by pulling the fronts of your feet toward your shins."),
       "seat": ("Seat Position",
                "Sit so your shins stand upright under your knees.",
                "The angle of the shins sets where each rep starts. Sitting too far forward pushes the knees ahead of the ankles and bends the feet up in the lever before you begin, so the toes cannot point as far down. ExRx has you slide back on the bench until you feel the toes fully pointed at the bottom.",
                "Sitting too far forward, the knees out ahead of the ankles.",
                "Shuffle back until your shins are upright and the toes can point down past level at the bottom, then sit tall with your hands on your thighs."),
       "top": ("Top of the Rep",
               "Lift the pad until your feet will not come up further, then hold.",
               "ExRx notes the load on this kind of tibia raise stays fairly high through the whole lift, and the shin muscles are weakest with the foot pulled up. It also suggests setting yourself a clear top position so that every rep reaches it.",
               "Turning the pad back down before the feet are fully up.",
               "Pull the tops of your feet up as far as they go, hold for about a second, then lower."),
       "bottom": ("Bottom of the Rep",
                  "Let the pad take your toes down past level before each lift.",
                  "ExRx has you lower until the toes point downward. In a lab study the muscles that lift the foot were strongest with it pointed about 10 degrees down, so starting each rep there uses their best length; turning back with the feet level starts every rep short.",
                  "Starting each lift with the feet still level.",
                  "Lower slowly until your toes point down past level and you feel the stretch along the fronts of your shins, then lift."),
       "tempo": ("Lowering Speed",
                 "Bring the pad down under control after each lift.",
                 "ExRx notes that these lifts keep the shin muscles under largely continuous tension, with a chance to relax at the bottom. On the way down they let the pad back as they lengthen; letting it fall skips that half of each rep.",
                 "Letting the pad drop back down after each lift.",
                 "Lift in under a second, hold, then let the pad back down over a slightly longer count."),
   },
   # Paint: the four shin muscles bright, nothing dim. Tibialis Anterior 0.86
   # PRIMARY (a machine lever, used loaded although the model shows no
   # plates, whose torque ExRx calls relatively high throughout; a
   # judgement). The steadiers 0.15: the feet are held in the
   # lever. ExRx lists no significant stabilisers for the seated tibia raise.
   activation=[("Tibialis Anterior", P, HI, 0.86)] + steadiers(0.15),
   stabilisers=["toe extensors", "core"],
   comparison=("FEET STOP LEVEL", "Toes point down at the bottom", "Feet stop level",
               "Letting the pad take the toes past level starts each lift with the shin muscles long, close to where they are strongest.",
               "Stopping with the feet level cuts off the stretched start of every rep, the part ExRx has you reach by sliding back on the bench."),
   glows=shins(N, dx=-0.01, rx=0.035, ry=0.075))

SETUP[N] = [
    "Sit on the bench and slide your feet under the roller, heels in the cradle.",
    "Line your ankles up with the lever's pivot, shins upright.",
    "Check the roller rests across the tops of your feet, ahead of the ankles.",
    "Sit tall with your hands resting on your thighs.",
]

# ---------------------------------------------------------------- Banded Dorsiflexion

N = "Banded Dorsiflexion"
ex(name=N, var="bandedDorsiflexion",
   overrides={"band": (ov(0.20), "leading"), "top": (ov(0.32), "leading"),
              "recline": (ov(0.72), "trailing"), "tempo": (ov(0.76), "leading"),
              "bottom": (ov(0.84), "leading")},
   annotations=[
       ("recline", "Lean back on hands", "hand_L"),
       ("band", "Band on forefoot", "toe_L"),
       ("top", "Toes back", "toe_R"),
       ("bottom", "Let toes point away", "foot_L"),
       ("tempo", "Slow return", "foot_R"),
   ],
   cues={
       "recline": ("Lean Back",
                   "Sit back on straight arms, hands on the mat behind you.",
                   "With the legs straight, folding forward at the hips pulls the hamstrings and calves tight, and ExRx notes this can shorten the top of a foot lift or make it harder; for a seated machine version it recommends a more reclined seat for a fuller range. Leaning back on your hands eases that pull.",
                   "Sitting bolt upright or hunching over the legs.",
                   "Put your hands on the mat behind your hips, arms straight, and lean back until your trunk is well behind upright."),
       "band": ("Band Position",
                "The band wraps over the tops of both feet, across the forefoot.",
                "In a lab study of band exercises for the ankle, the band for this movement sat across the front of the forefoot. Well ahead of the ankle it has good leverage against the lift; slipped back toward the ankle it has little.",
                "Letting the band slide back up the feet toward the ankles.",
                "Loop the band over the tops of both feet, across the forefoot, and check it is still there between sets."),
       "top": ("Top of the Rep",
               "Pull the tops of your feet back toward your shins as far as they go.",
               "A band pulls harder the further it stretches, so it is heaviest at the top, just where the muscles at the front of the shin are weakest. Tested lying on the back, band dorsiflexion worked the tibialis anterior at about half the activity of a maximal contraction.",
               "Stopping the pull with the feet only halfway back.",
               "Draw the feet back until they will not come further, hold for about a second, then let them return."),
       "bottom": ("Bottom of the Rep",
                  "Between pulls, let the band tip your feet forward past upright.",
                  "Returning past upright starts each pull with the front of the shin long. The muscles that lift the foot are strongest with it pointed slightly down, so a short return starts every rep where they have less to give.",
                  "Keeping the feet half pulled back between reps.",
                  "Let the band take your feet forward past upright, toes pointing away, before the next pull."),
       "tempo": ("Return Speed",
                 "Control the feet on the way back; do not let the band snap them forward.",
                 "The band pulls hardest near the top and stays taut through the return, so a controlled return keeps the shin muscles working against it as they lengthen. Letting it snap the feet forward skips that half of the rep.",
                 "Letting the band snap the feet forward after each pull.",
                 "Pull back in about a second, hold, and let the feet return over a slightly longer count."),
   },
   # Paint: the four shin muscles bright, nothing dim. Tibialis Anterior 0.50
   # PRIMARY: Baldim 2024 measured 49.84% MVIC for band dorsiflexion (supine,
   # knee straight, band across the forefoot). The steadiers 0.15: sitting,
   # the feet unloaded.
   activation=[("Tibialis Anterior", P, MOD, 0.50)] + steadiers(0.15),
   stabilisers=["toe extensors", "triceps", "core"],
   comparison=("SITTING UPRIGHT", "Leaning back on your hands", "Sitting up over the legs",
               "Reclined on your hands the hips stay more open, as ExRx recommends for a fuller range when the feet lift with the knees straight.",
               "Sitting up tightens the hamstrings and calves behind the straight knees, which can cut the top of each pull short."),
   glows=shins(N, dx=0.0, dy=-0.012, rx=0.07, ry=0.03))

SETUP[N] = [
    "Sit on a mat, legs straight, a rolled towel under your lower calves.",
    "Loop a band from a low anchor in front of your feet over the tops of both feet.",
    "Slide back until the band is taut with your toes pointing away.",
    "Lean back onto straight arms, hands on the mat behind your hips.",
]
