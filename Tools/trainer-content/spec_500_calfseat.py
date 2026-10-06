# Trainer content for the 401-500 folder (2026-10-04), family: calfseat. Six
# calf raises done sitting or reclined, from the builder's 401-500 set: 412
# Calf Press Machine (Legs/CalfPressMachine), 413 Horizontal Leg Press Calf
# Raise (Legs/HorizontalLegPressCalfRaise), 408 Barbell Seated Calf Raise
# (Legs/BarbellSeatedCalfRaise), 409 Dumbbell Seated Calf Raise
# (Legs/DumbbellSeatedCalfRaise), 410 Single-Leg Seated Calf Raise
# (Legs/SingleLegSeatedCalfRaise) and 407 Smith Machine Seated Calf Raise
# (Legs/SmithMachineSeatedCalfRaise). Same format as spec.py on top of
# common_1_50.py; spec_500.py imports this module and gen.py reads SPEC /
# SETUP. notes_500_calfseat.md maps the copy's claims to the sources below
# and records the model facts.
#
# What the models show, from the briefs (SCRATCH/briefs_legs), the trainer
# stills (SCRATCH/stills/<slug>_t{0,1,2,3,5}.png), tiers30.json, joints.json
# and the rigs, equipment and skinned shoes and thighs read from the USD with
# Blender's Python + pxr (SCRATCH/calfseat/rig.py, eqmove.py, eqpts.py,
# shoes.py, ang.py; the app's Y-up space, the lifter facing +z, their left
# +x). One body (torso, neck to pelvis, 0.592 m; shin 0.40 m); these rigs
# have toe joints at the ball of the foot (toe_L/R, 0.149 m from the ankle
# along the foot bone). Ankle = shin to foot-bone angle; on this rig a flat
# foot under a vertical shin reads 109-110 degrees (the Single-Leg Seated
# Calf Raise's right foot, flat on the floor, shin within 1.3 degrees of
# vertical), so neutral (foot at 90 degrees to the tibia, Kassiano 2023's 0)
# is taken as ~109 and dorsiflexion / plantar flexion are read from it.
# Every clip is 7.96 s with two identical reps by the ankle: heels lowest at
# 0-0.08 s, rising over ~0.8 s (0.12-0.88 s), held at the top ~1.2 s
# (0.92-2.12 s), lowered over ~1.2 s (2.17-3.29/3.33 s), held at the bottom
# ~0.7 s (to 4.08 s), then again. Unlike the library's five calf raises
# (which stop with the heels level or short of flat), ALL SIX sink the heels
# below their block or plate at the bottom, into a stretch.
# - Calf Press Machine: a plate-loaded 45 degree calf press sled (GYM_M14):
#   back pad, seat, a footplate on a carriage that runs up two 45 degree
#   rails, two plates on horns each side. The trunk lies back 51 degrees
#   from vertical on the pad, the hips at 94 -> 89 degrees; the hands hold
#   handles beside the seat (elbows 118). The balls of the feet sit on the
#   plate's lower edge, heels off it, feet straight, ankles 0.18 m apart
#   (hip-width: the hip joints are 0.18 m apart). Knees 168 degrees the
#   whole clip (12 short of straight). Ankle 85 -> 141: ~24 degrees
#   dorsiflexed to ~32 plantar flexed; at the bottom the heels hang ~4.4 cm
#   past the plate's face (about 12 degrees below its line), at the top
#   ~12 cm off it. The sled travels ~10.6 cm up the rails (7.5 cm up, 7.5
#   forward); the pelvis and seat stay put, the legs pivot ~5 degrees at the
#   hip as the plate goes out. Paint: gastrocnemius (both heads) and soleus
#   bright, hamstrings dim.
# - Horizontal Leg Press Calf Raise: a selectorised seated (horizontal) leg
#   press (GYM_M16): seat, back pad and head pad, a vertical footplate on a
#   carriage on two level rails, cabled to a weight stack on the lifter's
#   right. The trunk lies back 31 degrees, the hips at 116 -> 111, the legs
#   about level; hands on handles beside the seat (elbows 113). Balls of the
#   feet on the plate's lower edge, heels below it, ankles 0.18 m apart.
#   Knees 168 throughout. Ankle 88 -> 144: ~21 degrees dorsiflexed to ~35
#   plantar flexed, the heels ~4.4 cm past the plate's face at the bottom
#   (about 12 degrees below its line), ~10.5 cm off it at the top. The plate
#   travels 10.2 cm along the rails, the stack rises 10.7 cm. Paint as the
#   calf press.
# - Barbell, Dumbbell and Smith Machine Seated Calf Raise share one leg
#   motion: sitting upright (trunk 4 degrees forward) on a flat bench (pad top
#   0.42 m), the balls of both feet on the back edge of a 10 cm toe block,
#   heels off it, ankles 0.21 m apart, feet straight. Knees 85-89 degrees,
#   shins vertical (the knee within 1-8 cm of over the ankle), thighs level
#   at the bottom; as the heels rise the knees rise ~9.5 cm and the hips
#   close 87 -> 72 degrees. Ankle 94 -> 157: ~15 degrees dorsiflexed (the
#   heels ~4.5 cm below the top of the block, about 13 degrees below its
#   line) to ~48 plantar flexed (heels ~13 cm above it). Paint: gastrocnemius
#   and soleus bright, nothing dim.
#   * Barbell: a barbell with a 42 cm pad round its middle across the lower
#     thighs (the pad resting on them ~8 cm behind the knee joints), the
#     hands 0.60 m apart just outside the pad, elbows 108 -> 91; two plates
#     each side. The bar rises 5.7 cm.
#   * Dumbbell: a dumbbell stood on end on each lower thigh (~6 cm behind the
#     knee joint, its lower end resting on the thigh), the hands round the
#     handles, elbows 88 -> 78. The dumbbells rise 5.7 cm.
#   * Smith Machine: the Smith bar with a 42 cm pad round its middle across
#     the lower thighs, as the barbell; hands 0.60 m apart outside the pad
#     (elbows 108 -> 93); the bar runs on the guide rods and rises 5.7 cm;
#     safety stops set at 0.29-0.35 m, well below it.
# - Single-Leg Seated Calf Raise: the LEFT leg works for both reps. The toe
#   block sits only under the left foot; the right foot rests flat on the
#   floor beside it (right knee 101 degrees, still). One dumbbell stands on
#   the left lower thigh, the left hand round its handle (elbow 90 -> 82);
#   the right hand rests on the right thigh (elbow 111, still). The left leg
#   moves as above (knee 92-93 degrees, ankle 94 -> 156), the pelvis 3 cm
#   higher on the bench than in the two-leg models.
# - Highlight tiers (tiers30.json): GastrocnemiusLateral, GastrocnemiusMedial
#   and Soleus bright on all six; BicepsFemoris, Semimembranosus and
#   Semitendinosus dim on the two machines; nothing else lit.
#
# How they differ from the library: the Leg Press Calf Raise is a 45 degree
# sled too, but a full leg press with the knees at 170 and the heels stopping
# ~9 degrees short of flat; the Calf Press Machine is a compact dedicated
# calf sled that takes the heels well below the plate. The Horizontal Leg
# Press Calf Raise is the seated (level) leg press, cable-loaded, the seat
# distance setting the knee angle. The four seated raises are free-weight,
# Smith and one-leg versions of the library's machine Seated Calf Raise
# (thigh pads, handles), with the load resting on the lower thighs and the
# heels going below the block. Cue sets: top, bottom, knees, lock, tempo
# (calf press); top, bottom, seat, lock, tempo (horizontal); trunk or hands,
# knees, top, bottom, tempo (seated).
#
# Activation and the paint. The house rule makes every bright muscle a
# primary row, but on the seated raises the paint lights the gastrocnemius
# bright with the knees at ~90 degrees, where the evidence below says it
# does much less than the soleus (the library's Seated Calf Raise, painted
# soleus bright and gastrocnemius faint, ranks Soleus 0.86 primary and
# Gastrocnemius 0.30 secondary). Here both are primary: Soleus 0.86 (as the
# library) and Gastrocnemius 0.40, the lowest moderate value, the floor the
# library uses for a muscle painted bright that the EMG ranks low (the
# 351-400 Frog Pump's gluteus medius, 0.40 against a pooled ~19% MVIC). The
# PRIMARY rank and the 0.40 follow the paint, not the evidence: no source
# says the gastrocnemius works hard with the knee bent to 90 degrees. Price
# 2003 saw no significant gastrocnemius change on MRI at 90 degrees (25%
# 1RM), Cresswell 1995 its EMG falling as the knee bent, Kinoshita 2023 no
# significant gastrocnemius growth after 12 weeks of seated raises; only
# Signorile 2002 (the lateral head no different from the soleus at any knee
# angle) suggests some of it stays at work. On the evidence alone it would
# sit near the library's 0.30 secondary. The copy never ranks it with the
# soleus: it says the gastrocnemius is shortened and does less, and the
# soleus does most of the work. On the two machines (knees 168)
# the knee-straight ranking of the library's standing and leg press raises
# applies: Gastrocnemius 0.86 and Soleus 0.66, now both primary. The dim
# hamstrings are a LOW secondary row (0.20): no study measured them in a
# calf press; they cross the back of the knee with the gastrocnemius and are
# held long in these seats (hips ~90-115, knees 168). A judgement call, and
# the copy makes no claim about them.
#
# Sources (abstracts read on Europe PMC 2026-10-04, full texts where noted;
# details in notes_500_calfseat.md):
# - Signorile JF, Applegate B, Duque M, Cole N, Zink A 2002, J Strength Cond
#   Res 16(3):433-439, doi:10.1519/1533-4287(2002)016<0433:SROTTS>2.0.CO;2,
#   PMID 12173959 - 11 experienced subjects, plantar flexion at knee angles
#   90, 135 and 180 degrees: the soleus least active at 180, the medial
#   gastrocnemius most (above the soleus there); the lateral gastrocnemius
#   no different from the soleus at any angle; the soleus best targeted
#   with the knee at 90 degrees, the medial gastrocnemius with the leg
#   straight.
# - Cresswell AG, Loscher WN, Thorstensson A 1995, Exp Brain Res
#   105(2):283-290, doi:10.1007/BF00240964, PMID 7498381 - knee 180 -> 60
#   degrees (10 men, isometric): maximal plantar flexor torque fell to 60%,
#   gastrocnemius EMG fell at the same effort while soleus EMG held; the
#   gastrocnemius gives at least 40% of the torque with the leg straight.
# - Arampatzis A et al. 2006, J Biomech 39(10):1891-1902,
#   doi:10.1016/j.jbiomech.2005.05.010, PMID 15993886 - maximal isometric
#   plantar flexion: medial gastrocnemius EMG fell at pronounced knee flexion
#   despite no difference in its fascicle length.
# - Price TB et al. 2003, Magn Reson Imaging 21(8):853-861,
#   doi:10.1016/s0730-725x(03)00183-8, PMID 14599535 - dynamic plantar flexion
#   at 25% 1RM: knee straight, MRI showed both gastrocnemius heads working
#   and no soleus change; knee at 90 degrees, only the soleus; EMG agreed.
# - Kinoshita M, Maeo S, Kobayashi Y et al. 2023, Front Physiol 14:1272106,
#   doi:10.3389/fphys.2023.1272106, PMID 38156065 (full text PMC10753835) -
#   14 untrained adults, one leg standing, the other seated (knee 90), 12
#   weeks at 70% 1RM, 2 s up and 2 s down: gastrocnemius volume grew far more
#   standing (lateral 12.4% vs 1.7%, medial 9.2% vs 0.6%), the soleus about
#   the same (2.1% vs 2.9%).
# - Kassiano W et al. 2023, J Strength Cond Res 37(9):1746-1753,
#   doi:10.1519/JSC.0000000000004460, PMID 37015016 - 42 young women, 8
#   weeks of calf raises on a pin-loaded horizontal leg press: the initial
#   range (ankle 25 degrees dorsiflexed to neutral, 0 = foot at 90 degrees
#   to the tibia) grew the medial gastrocnemius more than the full (-25 to
#   +25) and final (0 to +25) ranges (15.2% vs 6.7% vs 3.4%), the lateral
#   head more than the final range (14.9% vs 6.2%; vs full 7.3%, not
#   significant). Ultrasound of the gastrocnemius only.
# - Kawakami Y, Muraoka T, Ito S, Kanehisa H, Fukunaga T 2002, J Physiol
#   540(Pt 2):635-646, doi:10.1113/jphysiol.2001.013459, PMID 11956349 -
#   plantar flexion with a counter-movement: the gastrocnemius fascicles
#   worked almost isometrically while the tendon stored and released elastic
#   energy.
# - Gentil P et al. 2020, Int J Environ Res Public Health 17(24):9487,
#   doi:10.3390/ijerph17249487, PMID 33352879 - 22 trained men, 10RM standing
#   calf raise: both gastrocnemius heads and the soleus at ~51% of each
#   muscle's own peak (the soleus works substantially with the knee
#   straight; not a ranking between muscles).
# - Akuzawa H, Imai A, Iizuka S, Matsunaga N, Kaneoka K 2017, Phys Ther
#   Sport 28:23-28, doi:10.1016/j.ptsp.2017.08.077, PMID 28950148 - tibialis
#   posterior, peroneus longus and flexor digitorum longus working in heel
#   raises (the stabiliser rows).
# - ExRx.net, read on the Wayback Machine (the live site blocks fetches):
#   Sled 45 degree Calf Press (Gastrocnemius/SL45CalfPress, snapshot
#   2024-01-05) and Lever 45 degree Calf Press (Gastrocnemius/LV45CalfPress,
#   2023-05-23): back on the pad, toes and balls of the feet on the lower
#   part of the platform with heels and arches off, push by extending the
#   ankles as far as possible, return until the calves are stretched,
#   reposition the feet if they slip, keep the knees straight or bend them
#   slightly only during the stretch (the quadriceps then join in); target
#   gastrocnemius, synergist soleus. Sled Seated Calf Press
#   (Gastrocnemius/SLSeatedCalfPress, 2023-11-22): the same on a seated leg
#   press, the seat placed away from the platform, "not so far that weight
#   bottoms out during stretch". Smith Seated Calf Raise
#   (Soleus/SMSeatedCalfRaise, 2023-12-26): bar pad round the middle of the
#   bar, calf block under the bar, bench near it; extend the ankles to bring
#   the lower thighs under the padded bar, disengage by rotating the bar;
#   safety stops can hold the bar at its lowest; adjust bench or block so the
#   thigh is close to horizontal; predominantly soleus, gastrocnemius in
#   active insufficiency since the knees are well bent; target soleus,
#   synergist gastrocnemius. Safety Bar Seated Calf Raise
#   (Soleus/SBSeatedCalfRaise, 2023-11-21) and Lever Seated Calf Raise
#   (Soleus/LVSeatedCalfRaise, 2022-10-06): lower thighs under the bar or
#   pads, the same soleus comment.
# - PureGym, How To Do Leg Press Calf Raises (puregym.com/exercises/legs/
#   calf-exercises/leg-press-calf-raises, read 2026-10-04): back against the
#   support, balls of the feet on the bottom edge of the plate; on a seated
#   machine set the seat so the knees are slightly bent with the plate at
#   rest; pause at the top; lower the heels below the plate to stretch the
#   calves; keep a slight bend, do not lock the knees; arms relaxed.
# - StrengthLog, Seated Calf Raise (strengthlog.com/seated-calf-raise, read
#   2026-10-04): seated calf raises mostly train the soleus because the
#   gastrocnemius is in a shortened position. StrengthLog, Calf Raise in Leg
#   Press (strengthlog.com/calf-raise-in-leg-press, read 2026-10-04): extend
#   the legs without over-extending the knees (with PureGym, the second
#   guide behind the soft-knee cue).
# - Fitbod, Seated Dumbbell Calf Raise and Seated Dumbbell One-Leg Calf
#   Raise (fitbod.me/exercises/..., read 2026-10-04): dumbbells near the end
#   of the thighs but not on the knees, knees at roughly 90 degrees, heels
#   hanging off the back of a plate and dropping below it, a hold at the top,
#   a slow lowering.
from common_1_50 import *


def ov(final):
    """Pre-squeeze override row for an on-screen row (spec_500.row() maps
    0.14-0.86 to 0.16-0.80)."""
    return round(0.14 + (final - 0.16) * (0.86 - 0.14) / (0.80 - 0.16), 4)


FOOT = ["tibialis posterior", "peroneals", "toe flexors"]

# Knees 168 degrees on the two machines: the gastrocnemius first, the soleus
# second (Signorile 2002: the medial head above the soleus with the leg
# straight, the lateral head no different; Price 2003, Cresswell 1995; the
# library's standing and leg press raises use 0.86 / 0.66; Gentil 2020 for
# the soleus still working hard). The split is a judgement; the studies give
# the order, not the numbers. Both painted bright, so both primary.
# Hamstrings dim: LOW, a judgement call (see the header).
ACT_PRESS = [("Gastrocnemius", P, HI, 0.86), ("Soleus", P, MOD, 0.66), ("Hamstrings", S, LOW, 0.20)]
# Knees ~90 degrees: the soleus does most of the work (Signorile 2002, Price
# 2003, Cresswell 1995, Arampatzis 2006, ExRx, StrengthLog; Kinoshita 2023:
# seated training barely grew the gastrocnemius). Soleus 0.86 as the
# library's Seated Calf Raise. The gastrocnemius is primary ONLY because the
# model paints it bright (the house rule), at 0.40, the lowest moderate
# value; the evidence alone would put it near the library's 0.30 secondary,
# and no source says it works hard with the knee bent. A judgement call (see
# the header); the copy only ever says it is shortened and does less.
ACT_SEATED = [("Soleus", P, HI, 0.86), ("Gastrocnemius", P, MOD, 0.40)]

KAWAKAMI = ("Dropping quickly into the bottom and bouncing out lets the Achilles tendon stretch and spring back: "
            "in a quick dip-and-push ankle movement, the calf muscle fibres stayed nearly the same length while the "
            "tendon stored and returned energy. Lowering under control and pausing in the stretch keep the work on "
            "the calf muscles.")

SEATED_KNEE_WHY = ("The gastrocnemius crosses the knee, so with the knee bent this far it is shortened and does less; "
                   "in studies that bent the knee, gastrocnemius activity fell while soleus activity held, so the "
                   "soleus does most of the work. Setting the feet far out in front opens the knees and hands more "
                   "of it back to the gastrocnemius.")

SEATED_BOTTOM_WHY = ("Low in the rep the calf muscles are at their longest. In a study of straight-knee calf raises, "
                     "training only the range below a flat foot grew the gastrocnemius more than training only the "
                     "range above it. That study measured only the gastrocnemius, so it does not show the same for "
                     "the soleus; sinking below the block simply adds the stretched part of the range.")


def calves(name, sides="LR", dx=0.0, dy=0.0, rx=0.045, ry=0.07):
    """The calves between knee and ankle, nudged toward the back of the shin:
    the near (left) calf full, the far one soft."""
    g = []
    if "L" in sides:
        g.append(glow(name, ["shin_L", "foot_L"], A, 0.55, rx, ry, dx, dy))
    if "R" in sides:
        g.append(glow(name, ["shin_R", "foot_R"], SOFT, 0.32, rx * 0.9, ry * 0.9, dx, dy))
    return g


# ---------------------------------------------------------------- Calf Press Machine

N = "Calf Press Machine"
ex(name=N, var="calfPressMachine",
   # Side-on from the front left (yaw -1.3): the lifter lies back across the
   # frame from the feet (top left, on the plate) to the head (right, v ~0.48);
   # the sled, plate and weight plates fill the left from v 0.25 to 0.50 and
   # move. Labels sit in the open band above the body: the two foot labels
   # top left and top right with leaders running down-left to the feet
   # (the right one always below the left one, so they never cross), the
   # two knee labels on the right above the head, the higher one to the far
   # knee, so its leader stays above the other's; tempo bottom right over the
   # static base frame. Pills hug the screen edges (gen.py), so every foot
   # leader has to cross the sled from above: below the legs a leader would
   # cross the calves, and two foot labels on one side cross each other's
   # pills. The top cue tracks the far toes and the heel cue the near ankle,
   # so at the bottom the heel leader passes ~12 pt clear of the toe dot (to
   # the far ankle and the near toes it ran through the toe dot).
   overrides={"top": (ov(0.16), "leading"), "bottom": (ov(0.24), "trailing"), "lock": (ov(0.32), "trailing"),
              "knees": (ov(0.40), "trailing"), "tempo": (ov(0.80), "trailing")},
   annotations=[
       ("top", "Ankles fully pointed", "toe_R"),
       ("bottom", "Heels sink below the plate", "foot_L"),
       ("knees", "Knees hold their angle", "patella_L"),
       ("lock", "Slight bend, never locked", "patella_R"),
       ("tempo", "Pause, lower slowly", "pelvis"),
   ],
   cues={
       "top": ("Top of the Rep",
               "Push the plate away through the balls of the feet until the ankles are fully pointed.",
               "The calves move the plate by pointing the ankles. Pushing until the ankles point no further, and holding there for a moment, takes every rep to the end of that range instead of turning back partway.",
               "Turning back with the ankles only partway pointed, the plate barely moving.",
               "Press through the balls of your feet until your ankles are as pointed as they go, hold for about a second, then let the plate back."),
       "bottom": ("Bottom of the Rep",
                  "Let the heels sink below the plate on every rep.",
                  "Low in the rep the calves are at their longest. In an eight-week study of calf raises on a horizontal leg press, training only the range below a flat foot grew the gastrocnemius more than training only the range above it, and at least as much as the full range.",
                  "Turning each rep around with the heels level with the plate or above it.",
                  "Let the plate come back until your heels sit below its lower edge and your calves feel a stretch, pause there briefly, then press again."),
       "knees": ("Knee Position",
                 "The knees hold one slight bend while the ankles move the plate.",
                 "With the knees nearly straight the gastrocnemius stays long and shares the work with the soleus. When the knees bend, the plate sinks toward you, the thighs push it back and part of the rep becomes a leg press.",
                 "Letting the knees bend as the plate comes back, then pushing it away with the thighs.",
                 "Fix your knees just short of straight and keep them there; move the plate only by pointing and flexing your ankles."),
       "lock": ("Soft Knees",
                "The knees stay just short of locked under the loaded plate.",
                "The usual guidance for this lift is a slight bend rather than locked knees under the plate. Holding that bend also keeps the knees from snapping straight, or past straight, each time the ankles push.",
                "Locking the knees and pushing them back past straight as the ankles press.",
                "Keep the same slight bend in your knees from the first rep to the last, arms relaxed on the handles."),
       "tempo": ("Tempo",
                 "Press in under a second, hold the top, let the plate back a little more slowly.",
                 KAWAKAMI,
                 "Letting the plate drop into the stretch and bouncing straight back out.",
                 "Press in under a second, hold the top for about a second, take a little longer letting the plate back and pause briefly in the stretch."),
   },
   activation=ACT_PRESS,
   stabilisers=FOOT,
   comparison=("HEELS STAYING HIGH", "Heels sink below the plate", "Heels stop at the plate",
               "Letting the heels sink below the plate takes the calves into their stretched range, which grew the gastrocnemius more than the upper range in a leg press calf study.",
               "Turning back at the plate leaves the stretched range out, so every rep stays in the upper part of the movement."),
   glows=calves(N, dx=0.05, dy=0.04, rx=0.08, ry=0.04) + [glow(N, ["thigh_L", "patella_L"], SOFT, 0.18, 0.07, 0.035, 0.0, 0.04)])

SETUP[N] = [
    "Sit with your back flat on the pad and hold the handles beside the seat.",
    "Put the balls of your feet on the lower edge of the plate, hip-width apart, heels off.",
    "Press the plate away until your knees are nearly straight; release the safety catches if the machine has them.",
    "Keep a slight bend in your knees before the first rep.",
]

# ---------------------------------------------------------------- Horizontal Leg Press Calf Raise

N = "Horizontal Leg Press Calf Raise"
ex(name=N, var="horizontalLegPressCalfRaise",
   # Side-on from the front left (yaw -1.3): legs level across the middle
   # (v ~0.55-0.65), the plate on the left, the stack column behind the
   # knees, the head at the right (v ~0.41). The top label sits top left over
   # the column, its leader down to the toes; the two knee labels top right,
   # the higher one to the far knee; the heel label bottom left over the
   # base rails, below the moving carriage; tempo bottom right.
   overrides={"top": (ov(0.16), "leading"), "lock": (ov(0.24), "trailing"), "seat": (ov(0.32), "trailing"),
              "bottom": (ov(0.80), "leading"), "tempo": (ov(0.80), "trailing")},
   annotations=[
       ("top", "Ankles fully pointed", "toe_L"),
       ("bottom", "Heels below the plate", "foot_R"),
       ("seat", "Seat back, knees soft", "patella_L"),
       ("lock", "Slight bend, never locked", "patella_R"),
       ("tempo", "Pause, lower slowly", "pelvis"),
   ],
   cues={
       "top": ("Top of the Rep",
               "Push the plate away through the balls of the feet until the ankles are fully pointed.",
               "The calves move the plate by pointing the ankles. Pushing until the ankles point no further, and holding there for a moment, takes every rep to the end of that range instead of turning back partway.",
               "Turning back with the ankles only partway pointed, the plate barely moving.",
               "Press through the balls of your feet until your ankles are as pointed as they go, hold for about a second, then let the plate back."),
       "bottom": ("Bottom of the Rep",
                  "Let the heels sink below the plate on every rep.",
                  "Low in the rep the calves are at their longest. In an eight-week study of calf raises on this kind of machine, a horizontal leg press, training only the range below a flat foot grew the gastrocnemius more than training only the range above it, and at least as much as the full range.",
                  "Turning each rep around with the heels level with the plate or above it.",
                  "Let the plate come back until your heels sit below its lower edge and your calves feel a stretch, pause there briefly, then press again."),
       "seat": ("Seat Position",
                "Set the seat so the knees are just short of straight with the feet on the plate.",
                "With the knees nearly straight the gastrocnemius stays long and shares the work with the soleus. Sitting too close leaves the knees well bent, which shortens the gastrocnemius and lets the thighs push the plate. Set the seat too far back and the stack can touch down before the heels reach the stretch.",
                "Sitting so close to the plate that the knees stay well bent through the whole set.",
                "Slide the seat back until your knees are just short of straight with the balls of your feet on the plate, but not so far that the stack rests before your heels drop below it."),
       "lock": ("Soft Knees",
                "The knees stay just short of locked as the plate moves.",
                "The usual guidance for this lift is a slight bend rather than locked knees under load. Holding that bend also keeps the knees from snapping straight, or past straight, each time the ankles push.",
                "Locking the knees and pushing them back past straight as the ankles press.",
                "Keep the same slight bend in your knees from the first rep to the last, arms relaxed on the handles."),
       "tempo": ("Tempo",
                 "Press in under a second, hold the top, let the plate back a little more slowly.",
                 KAWAKAMI,
                 "Letting the plate drop into the stretch and bouncing straight back out.",
                 "Press in under a second, hold the top for about a second, take a little longer letting the plate back and pause briefly in the stretch."),
   },
   activation=ACT_PRESS,
   stabilisers=FOOT,
   comparison=("SEAT TOO CLOSE", "Seat back, knees nearly straight", "Seat close, knees bent",
               "With the seat set back and the knees just short of straight, the ankles move the plate and both calf muscles share the work.",
               "Sitting too close keeps the knees bent, which shortens the gastrocnemius and lets the thighs help push the plate."),
   glows=calves(N, dx=0.04, dy=0.035, rx=0.09, ry=0.03) + [glow(N, ["thigh_L", "patella_L"], SOFT, 0.18, 0.08, 0.03, 0.0, 0.035)])

SETUP[N] = [
    "Sit with your back against the pad and hold the handles beside the seat.",
    "Put the balls of your feet on the lower edge of the plate, hip-width apart, heels off.",
    "Set the seat so your knees are just short of straight with the plate at rest.",
    "Select the weight and keep your arms relaxed.",
]

# ---------------------------------------------------------------- shared seated cues

SEATED_TOP = ("Top of the Rep",
              "Rise onto the balls of the feet as high as the ankles allow and hold for a moment.",
              "The calves lift the load by pointing the ankles, and a calf raise has a short range to begin with. Rising as high as you can and holding briefly takes every rep to the end of that range instead of turning back partway.",
              "Stopping with the heels only partway up, the load barely rising.",
              "Push through the balls of your feet until your heels are as high as they go, hold for about a second, then lower.")
SEATED_BOTTOM = ("Bottom of the Rep",
                 "The heels sink below the top of the block on every rep.",
                 SEATED_BOTTOM_WHY,
                 "Turning each rep around with the heels level with the block or higher.",
                 "Lower under control until your heels sit below the top of the block and your calves feel a stretch, pause briefly, then rise.")
SEATED_TEMPO = ("Tempo",
                "Rise in under a second, hold the top, lower a little more slowly.",
                KAWAKAMI,
                "Dropping fast into the bottom and bouncing straight back up.",
                "Rise in under a second, hold the top for about a second, take a little longer to lower and pause for a moment at the bottom.")


def seated_knees(load):
    return ("Knee Angle",
            "The knees stay bent at about a right angle, the shins upright.",
            SEATED_KNEE_WHY,
            "Setting the feet far out in front, so the knees open well past a right angle.",
            f"Put the balls of your feet on the block directly under your knees, thighs about level under the {load}.")


# ---------------------------------------------------------------- Barbell Seated Calf Raise

N = "Barbell Seated Calf Raise"
ex(name=N, var="barbellSeatedCalfRaise",
   # Three-quarter from the front left (yaw -0.8): the barbell crosses the
   # frame at v ~0.42-0.57 (plates at both sides, moving), the head at the
   # top middle, the feet on the block below. The trunk label sits top right,
   # short, so its leader drops to the left shoulder right of the head; the
   # tempo label top left above the left plate, its leader down to the right
   # hand on the bar; the knee label left between the plate and the block,
   # to the far knee; the two foot labels share the bottom row, one each
   # side, each to the foot on its own side.
   overrides={"trunk": (ov(0.24), "trailing"), "tempo": (ov(0.36), "leading"), "knees": (ov(0.62), "leading"),
              "top": (ov(0.80), "leading"), "bottom": (ov(0.80), "trailing")},
   annotations=[
       ("trunk", "Sit tall, still", "upper_arm_L"),
       ("knees", "Knees at 90°", "patella_R"),
       ("top", "Rise high, hold", "foot_R"),
       ("bottom", "Heels below the block", "foot_L"),
       ("tempo", "Pause, lower slowly", "hand_R"),
   ],
   cues={
       "trunk": ("Trunk and Arms",
                 "Sit tall; the hands only keep the bar in place.",
                 "The padded bar rests on the lower thighs, so leaning back while gripping it lifts it with the trunk and arms. The heels should be what raises the bar.",
                 "Leaning back and hauling on the bar to lift it off the thighs.",
                 "Sit upright, hold the bar lightly just outside the pad and let your heels drive it up."),
       "knees": seated_knees("bar"),
       "top": SEATED_TOP, "bottom": SEATED_BOTTOM, "tempo": SEATED_TEMPO,
   },
   activation=ACT_SEATED,
   stabilisers=FOOT,
   comparison=("ROCKING THE TRUNK", "Trunk still, heels lift the bar", "Trunk leans back to heave the bar",
               "Sitting still leaves the ankles to lift the bar, so the soleus does the work the seated raise is for.",
               "Leaning back and pulling on the bar moves it with the trunk and arms, and the calves do less."),
   glows=calves(N, dx=0.0, dy=-0.01, rx=0.035, ry=0.06))

SETUP[N] = [
    "Set a low block in front of a flat bench and sit on the end of the bench.",
    "Put the balls of your feet on the edge of the block, hip-width apart, heels off.",
    "Rest a padded barbell across your lower thighs, just above the knees.",
    "Hold the bar just outside the pad, knees at about a right angle.",
]

# ---------------------------------------------------------------- Dumbbell Seated Calf Raise

N = "Dumbbell Seated Calf Raise"
ex(name=N, var="dumbbellSeatedCalfRaise",
   # Side-on from the front left (yaw -1.3), facing screen left: the
   # dumbbells stand on the thighs at the left (v ~0.35-0.52), the bench on
   # the right, the feet on the block bottom left. The dumbbell label sits
   # top left, its leader down to the near hand; the knee label left of the
   # shins to the far knee; tempo right over the bench to the hips; the foot
   # labels below the shoes, one each side.
   overrides={"hands": (ov(0.16), "leading"), "knees": (ov(0.56), "leading"), "tempo": (ov(0.72), "trailing"),
              "top": (ov(0.83), "trailing"), "bottom": (ov(0.83), "leading")},
   annotations=[
       ("hands", "Dumbbells rest on the thighs", "hand_L"),
       ("knees", "Knees at 90°", "patella_R"),
       ("top", "Rise high, hold", "foot_L"),
       ("bottom", "Heels below the block", "foot_R"),
       ("tempo", "Pause, lower slowly", "pelvis"),
   ],
   cues={
       "hands": ("Dumbbell Position",
                 "The dumbbells stand on the lower thighs; the hands only steady them.",
                 "Standing on the thighs just above the knees, the dumbbells load the calves through the shins. Lifting them with the arms as the heels rise takes that weight off the calves.",
                 "Lifting the dumbbells off the thighs with the arms as the heels rise.",
                 "Stand a dumbbell on end on each lower thigh, just above the knee, and keep your hands round the handles without pulling up."),
       "knees": seated_knees("dumbbells"),
       "top": SEATED_TOP, "bottom": SEATED_BOTTOM, "tempo": SEATED_TEMPO,
   },
   activation=ACT_SEATED,
   stabilisers=FOOT + ["forearms"],
   comparison=("HEELS STAYING HIGH", "Heels sink below the block", "Heels stop at the block",
               "Sinking the heels below the block takes the calves through the stretched part of their range on every rep.",
               "Turning back at the block leaves the stretched range out, so every rep stays in the upper part of the movement."),
   glows=calves(N, dx=0.035, dy=-0.01, rx=0.04, ry=0.07))

SETUP[N] = [
    "Set a low block in front of a flat bench and sit on the end of the bench.",
    "Put the balls of your feet on the edge of the block, hip-width apart, heels off.",
    "Stand a dumbbell on end on each lower thigh, just above the knee.",
    "Hold the handles to steady them, knees at about a right angle.",
]

# ---------------------------------------------------------------- Single-Leg Seated Calf Raise

N = "Single-Leg Seated Calf Raise"
ex(name=N, var="singleLegSeatedCalfRaise",
   # As the Dumbbell Seated Calf Raise, the right foot resting on the floor
   # behind the left one. The dumbbell label top left; the knee label short,
   # left of the dumbbell's lower head; tempo right over the bench; the top
   # label bottom left over the block to the left toes, the heel label
   # bottom right to the left ankle.
   overrides={"hand": (ov(0.16), "leading"), "knee": (ov(0.48), "leading"), "tempo": (ov(0.66), "trailing"),
              "top": (ov(0.83), "leading"), "bottom": (ov(0.76), "trailing")},
   annotations=[
       ("hand", "Dumbbell on the left thigh", "hand_L"),
       ("knee", "Knee at 90°", "patella_L"),
       ("top", "Rise high, hold", "toe_L"),
       ("bottom", "Heel below the block", "foot_L"),
       ("tempo", "Pause, lower slowly", "pelvis"),
   ],
   cues={
       "hand": ("Dumbbell Position",
                "One dumbbell stands on the left thigh; the left hand only steadies it.",
                "On end on the lower thigh, just above the knee, the dumbbell loads the left calf through the shin. Lifting it with the arm as the heel rises takes that weight off the calf.",
                "Lifting the dumbbell off the thigh with the arm as the heel rises.",
                "Stand the dumbbell on end on your left thigh just above the knee, hold the handle without pulling up and rest your right hand on your right thigh."),
       "knee": ("Knee Angle",
                "The left knee stays bent at about a right angle, the shin upright.",
                SEATED_KNEE_WHY,
                "Setting the left foot far out in front, so the knee opens well past a right angle.",
                "Put the ball of your left foot on the block directly under the knee and rest your right foot flat on the floor beside the block."),
       "top": ("Top of the Rep",
               "Rise onto the ball of the left foot as high as the ankle allows and hold for a moment.",
               "The calf lifts the load by pointing the ankle, and a calf raise has a short range to begin with. Rising as high as you can and holding briefly takes every rep to the end of that range instead of turning back partway.",
               "Stopping with the left heel only partway up, the dumbbell barely rising.",
               "Push through the ball of your left foot until the heel is as high as it goes, hold for about a second, then lower."),
       "bottom": ("Bottom of the Rep",
                  "The left heel sinks below the top of the block on every rep.",
                  SEATED_BOTTOM_WHY,
                  "Turning each rep around with the left heel level with the block or higher.",
                  "Lower under control until your left heel sits below the top of the block and the calf feels a stretch, pause briefly, then rise."),
       "tempo": ("Tempo",
                 "Rise in under a second, hold the top, lower a little more slowly.",
                 KAWAKAMI,
                 "Dropping fast into the bottom and bouncing straight back up.",
                 "Rise in under a second, hold the top for about a second, take a little longer to lower and pause for a moment at the bottom; then switch legs."),
   },
   activation=ACT_SEATED,
   stabilisers=FOOT + ["forearms"],
   comparison=("STOPPING SHORT", "Heel rises as high as it goes", "Heel stops halfway up",
               "Rising until the left ankle points no further takes each rep to the top of the calf's short range.",
               "Turning back halfway cuts the short range down further, so each rep does less work."),
   glows=calves(N, sides="L", dx=0.035, dy=-0.01, rx=0.04, ry=0.07))

SETUP[N] = [
    "Set a low block in front of a flat bench and sit on the end of the bench.",
    "Put the ball of your left foot on the edge of the block, heel off, and rest your right foot flat on the floor.",
    "Stand a dumbbell on end on your left thigh, just above the knee, and hold it with your left hand.",
    "Rest your right hand on your right thigh; switch legs after the set.",
]

# ---------------------------------------------------------------- Smith Machine Seated Calf Raise

N = "Smith Machine Seated Calf Raise"
ex(name=N, var="smithMachineSeatedCalfRaise",
   # Near head-on from the front left (yaw -0.4), zoomed in: the shoulders
   # span u 0.28-0.83, the padded bar crosses at v ~0.48-0.52 and moves, the
   # far leg at u 0.22-0.40, the near one at 0.44-0.62, the bench to the
   # right. Space is tight, so: tempo top left, its leader down to the far
   # shoulder, left of the head; the hands label short (10 characters, so it
   # starts right of the near hip), below the bar, its leader straight up
   # across the bar to the left hand; the knee label (as feet under the
   # knees, 16 characters, clear of the near calf) right over
   # the bench legs to the near ankle; the heel label bottom left to the far
   # ankle, the top label bottom right to the near toes.
   overrides={"tempo": (ov(0.20), "leading"), "hands": (ov(0.57), "trailing"), "knees": (ov(0.74), "trailing"),
              "bottom": (ov(0.83), "leading"), "top": (ov(0.83), "trailing")},
   annotations=[
       ("hands", "Light grip", "hand_L"),
       ("knees", "Feet under knees", "foot_L"),
       ("top", "Rise high, hold", "toe_L"),
       ("bottom", "Heels below the block", "foot_R"),
       ("tempo", "Pause, lower slowly", "upper_arm_R"),
   ],
   cues={
       "hands": ("Arms",
                 "The hands only steady the bar; the heels lift it.",
                 "The padded Smith bar rests on the lower thighs and runs on its guides, so whatever the arms pull up, the calves do not have to lift. Hauling on it turns part of each rep into an arm lift.",
                 "Pulling the bar up off the thighs with the arms as the heels rise.",
                 "Hold the bar lightly just outside the pad, arms relaxed, sit tall and let your heels drive it up its track."),
       "knees": ("Knee Angle",
                 "The knees stay bent at about a right angle, the thighs level.",
                 SEATED_KNEE_WHY,
                 "Setting the feet far out in front, so the knees open well past a right angle.",
                 "Set the bench and block so your thighs are about level, with the balls of your feet on the block directly under your knees."),
       "top": SEATED_TOP, "bottom": SEATED_BOTTOM, "tempo": SEATED_TEMPO,
   },
   activation=ACT_SEATED,
   stabilisers=FOOT,
   comparison=("FEET TOO FAR OUT", "Shins upright, knees at 90°", "Feet out front, knees open",
               "With the shins upright and the knees at a right angle, the gastrocnemius is shortened and the soleus does most of the lifting.",
               "Setting the feet far out opens the knees, which hands part of the work the seated raise gives the soleus back to the gastrocnemius."),
   glows=calves(N, dx=0.0, dy=-0.01, rx=0.035, ry=0.06))

SETUP[N] = [
    "Set the bar just above knee height with its pad round the middle, a low block under it and a bench behind.",
    "Sit facing the bar with the balls of your feet on the edge of the block, heels off.",
    "Rise onto your toes to bring your lower thighs under the padded bar and grip it outside the pad.",
    "Unhook the bar by rotating it, with the safety stops set below your lowest point.",
]
