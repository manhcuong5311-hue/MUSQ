# Trainer content for the 30-leg set (2026-09-28), family "calf": the five
# calf raises 083-087 from the HIKSEMI drive's "Calf 83-" folder (converted
# from SourceExports/Calf). Same format as spec.py, on top of
# common_legs30.py; spec_legs30.py collects this family with the others.
#
# What each model shows, from the rig (joint positions and angles every 0.5 s,
# equipment bounds from the USD, briefs_legs30/*.md) and the framing stills
# (<Slug>_a_start, _b_mid, _c_top, _d_rep2). All five do two reps in 8 s with
# the same timing: heels lowest at 0 s and 4 s, rising for ~0.9 s (0.17-1.08
# s), held at the top for ~0.85 s (1.12-1.96 s, heels highest at 1.3-1.4 s),
# lowered over ~1.7 s (2.0-3.71 s) and paused ~0.4 s with the heels lowest
# (3.75-4.12 s). Ankle angle = shin to foot bone (larger = heel higher); with
# the foot flat it reads ~98-99° on these rigs, the foot bone then pitched 14°
# down toward the ball of the foot. The rig's torso (neck to pelvis) is
# 0.59 m, shin 0.40 m; no rig has toe joints. Both feet point straight ahead
# (±2°) and the ankles sit 0.26-0.27 m apart (about hip width) in every model
# with both feet down.
# IMPORTANT: none of the five lowers the heels below a flat foot. The standing
# and single-leg models start at ankle 98-99°, foot pitch 14° (flat), with the
# ball of the foot on the back edge of the block and the heel level with its
# top; the seated model starts at 103°, the leg press at 108° (~9° short of
# flat). So they show no stretch below the step, and their whole range lies
# inside the band that grew the gastrocnemius least in Kassiano 2023 (flat
# to +25° plantar flexion). The copy asks for level as the minimum and names
# sinking below the step, if comfortable, as the part the study found grew
# the calf most; the model does not show that part (see the notes).
# - Standing Calf Raise (StandingCalfRaise, yaw -1.3: from the lifter's front
#   left, facing screen-left, the weight stack behind on the right). A
#   standing calf machine: the shoulders under a padded carriage that rides
#   up and down a guide, cabled to a weight stack. The balls of the feet on
#   the back edge of a 22 cm block (non-slip top 0.45 x 0.25 m), heels off
#   it. Hands on the carriage handles ~15 cm in front of and ~12 cm below the
#   shoulders. Knees 172° throughout (straight, not locked), hips 172-176°,
#   trunk vertical (0°). Ankle 99° -> 139°: the heels, hips and carriage rise
#   ~11 cm (pelvis 1.11 -> 1.22 m), the ankles coming ~7 cm forward over the
#   planted toes.
# - Seated Calf Raise (SeatedCalfRaise, yaw -1.3: facing screen-left, the
#   loaded lever and its plates on the left). Sitting upright (trunk 0°) on a
#   seat 0.61 m high, the thigh pads resting on the lower thighs just above
#   the knees, the hands on handles on the pad (elbows 82-112°). Knees 91-96°,
#   the shins about vertical (knee within 5 cm of over the ankle). The balls
#   of the feet on the back edge of a 22 cm footplate, heels off it. Ankle
#   103° -> 148°: the knees and pad rise ~10 cm, the hips stay on the seat
#   (hip angle 97° -> 84° as the thighs tip up).
# - Leg Press Calf Raise (LegPressCalfRaise, yaw -2.4: from behind on the
#   lifter's left, the sled above on the left, the seat back and head on the
#   right). A 45° sled leg press: trunk reclined 45° on the back pad, hips
#   91-96°, hands on the handles beside the seat. The balls of the feet on the
#   lower edge of the footplate, heels below it, ankles 0.27 m apart. Knees
#   170° throughout (just short of straight). Ankle 108° -> 148°: the sled
#   travels ~11 cm up its rails while the hips and knees hold still.
# - Single-Leg Calf Raise (SingleLegCalfRaise, yaw -1.3: facing screen-left,
#   the balance upright on the left). The LEFT leg works for both reps: the
#   ball of the left foot on the back edge of a 22 cm step, heel off it, the
#   hips shifted over it (pelvis 12 cm left of centre). The right knee is bent
#   136°, its foot hanging ~42 cm behind and ~30 cm above the step. A dumbbell
#   in the LEFT hand, arm straight (175°) at the side; the RIGHT hand holds a
#   fixed balance grip 1.4 m up (elbow 73° at the bottom, 99° at the top as
#   the body rises away from the grip, which sits 25-35 cm below the
#   shoulder). Left knee 172°, trunk 0°. Ankle 99° -> 139°,
#   the body rising ~11 cm.
# - Smith Machine Calf Raise (SmithMachineCalfRaise, yaw -0.8: three-quarter
#   from the front left, the lifter on the left of the screen, the machine
#   frame and stored plates on the right). The Smith bar across the upper
#   traps (~7 cm behind and ~1 cm below the neck joint), grip 0.64 m (hands
#   ~12 cm outside the shoulder joints, elbows sharply bent). The balls of the
#   feet on the back edge of a 20-22 cm deck, heels off it; the bar rides
#   straight up and down over the ankles. Knees 172°, trunk 0°. Ankle 98° ->
#   138°, the bar rising ~11 cm (1.70 -> 1.80 m).
#
# Sources (each checked; notes_legs30_calf.md maps the claims to them):
# - Signorile JF, Applegate B, Duque M, Cole N, Zink A 2002, J Strength Cond
#   Res 16(3):433-439, PMID 12173959 — 11 experienced lifters, plantar flexion
#   at knee angles 90, 135 and 180°: medial gastrocnemius greater than soleus
#   at 180°; soleus lower at 180° than at the other angles, medial
#   gastrocnemius higher; lateral gastrocnemius less affected; "the SOL can be
#   targeted most effectively with the knee flexed at 90 degrees and the MG
#   with the leg fully extended".
# - Cresswell AG, Löscher WN, Thorstensson A 1995, Exp Brain Res 105(2):
#   283-290, doi 10.1007/BF00240964 — as the knee bent from 180° to 60°,
#   plantar flexor torque fell to 60% and gastrocnemius EMG fell at the same
#   effort while soleus EMG stayed unchanged; the gastrocnemius gives at least
#   40% of the torque with the leg straight.
# - Arampatzis A et al. 2006, J Biomech 39(10):1891-1902, doi
#   10.1016/j.jbiomech.2005.05.010 — maximal isometric plantar flexion: medial
#   gastrocnemius EMG fell at pronounced knee flexion despite no difference
#   in its fascicle length; the authors credit the force-length potential of
#   the whole triceps surae, not slack alone.
# - Price TB et al. 2003, Magn Reson Imaging 21(8):853-861, doi
#   10.1016/s0730-725x(03)00183-8 — dynamic plantar flexion at 25% 1RM: knee
#   straight, MRI showed the medial and lateral gastrocnemius working and no
#   change in the soleus; knee at 90°, only the soleus; EMG agreed.
# - Hébert-Losier K, Schneiders AG, García JA, Sullivan SJ, Simoneau GG 2012,
#   J Strength Cond Res 26(11):3124-3133, doi 10.1519/JSC.0b013e31824435cf —
#   48 adults, single-leg heel raises at 0° and 45° knee flexion: soleus
#   activity 4% higher and both gastrocnemius heads 5% lower at 45°; the
#   authors doubt so small a shift matters for muscle-specific benefit.
# - Kinoshita M, Maeo S, Kobayashi Y et al. 2023, Front Physiol 14:1272106,
#   doi 10.3389/fphys.2023.1272106 — 14 untrained adults, one leg standing
#   (knee straight), the other seated (knee 90°), 12 weeks on machines, ankle
#   20° dorsiflexed to 30° plantar flexed, 2 s up and 2 s down: gastrocnemius
#   volume grew far more standing (lateral 12.4% vs 1.7%, medial 9.2% vs
#   0.6%); soleus grew similarly (2.1% vs 2.9%, no difference).
# - Kassiano W et al. 2023, J Strength Cond Res 37(9):1746-1753, doi
#   10.1519/JSC.0000000000004460 — 42 young women, 8 weeks of calf raises on a
#   horizontal leg press: training only the lower range (ankle 25° dorsiflexed
#   to neutral) grew the medial gastrocnemius more than the full range or the
#   upper range (15.2% vs 6.7% vs 3.4%) and the lateral head more than the
#   upper range (14.9% vs 6.2%; vs full 7.3%, not significant).
# - Kawakami Y, Muraoka T, Ito S, Kanehisa H, Fukunaga T 2002, J Physiol
#   540(Pt 2):635-646, doi 10.1113/jphysiol.2001.013459 — ankle plantar
#   flexion with and without a counter-movement: with it, the gastrocnemius
#   fascicles worked almost isometrically while the tendon stored and released
#   elastic energy, raising the work done.
# - Gentil P et al. 2020, Int J Environ Res Public Health 17(24):9487, doi
#   10.3390/ijerph17249487 — 22 trained men, 10RM standing machine calf raise
#   (knees fully extended, full ankle range, 2 s each way): medial and lateral
#   gastrocnemius and soleus all ~51-52% of each muscle's own peak (not
#   comparable between muscles).
# - Riemann BL, Limbaugh GK, Eitner JD, LeFavi RG 2011, J Strength Cond Res
#   25(3):634-639, doi 10.1519/JSC.0b013e3181cc22b8, and Nunes JP et al. 2020,
#   J Strength Cond Res 34(8):2347-2351, doi 10.1519/JSC.0000000000003674 —
#   toes out favours the medial gastrocnemius, toes in the lateral (EMG; and
#   growth over 9 weeks on a leg press calf raise): foot angle is a choice,
#   not a fault, so no cue treats it as one.
# - Akuzawa H, Imai A, Iizuka S, Matsunaga N, Kaneoka K 2017, Phys Ther Sport
#   28:23-28, doi 10.1016/j.ptsp.2017.08.077 — tibialis posterior, peroneus
#   longus and flexor digitorum longus activity during heel raises, changing
#   with foot position (the stabiliser rows).
# - ExRx.net, read through Internet Archive copies (exrx.net blocks automated
#   fetches): Lever Standing Calf Raise (Gastrocnemius/LVStandingCalfRaise,
#   snapshot 2023-04-07), Lever Seated Calf Raise (Soleus/LVSeatedCalfRaise,
#   2022-10-06), Sled 45° Calf Press (Gastrocnemius/SL45CalfPress,
#   2024-01-05), Dumbbell Single Leg Calf Raise
#   (Gastrocnemius/DBSingleLegCalfRaise, 2023), Smith Standing Calf Raise
#   (Gastrocnemius/SMStandingCalfRaise, 2024-01-05): toes and balls of the
#   feet on the block, heels off; raise the heels as high as possible, lower
#   until the calves are stretched; keep the knees straight or bend them
#   slightly only during the stretch (quadriceps then join in); standing,
#   sled and Smith: target gastrocnemius, synergist soleus; seated: target
#   soleus, "Gastrocnemius are in active insufficiency since knees are
#   significantly bent"; sled: reposition the stance if the feet slip; single
#   leg: hand on a support for balance, other leg bent to the rear, "Use
#   lighter load if you need to assist with hands used for support",
#   stabilisers gluteus medius and minimus, quadratus lumborum, obliques;
#   Smith: bar at upper-chest height, calf block under the bar, disengage the
#   bar by rotating it back.
# - StrengthLog, Standing Calf Raise and Seated Calf Raise guides: standing
#   trains the soleus and gastrocnemius together; seated mostly the soleus,
#   the gastrocnemius shortened.
# - NASM, Leg Press Calf Raise (exercise library): forefeet on the platform,
#   heels off; do not let the knees bend excessively. PureGym, How To Do Leg
#   Press Calf Raises (puregym.com/exercises/legs/calf-exercises/
#   leg-press-calf-raises, read 2026-09-28): balls of the feet on the bottom
#   edge of the plate first; on a 45° machine then press the plate off the
#   safety bars and extend the legs, keeping a slight bend; keep a slight bend
#   throughout, do not lock out; lower the heels below the plate. Its advice
#   to set the seat so the knees are slightly bent at rest is for the seated
#   (horizontal) leg press only and is not used for the model's 45° sled
#   (coaching guidance, cited as such).
# No EMG study of the leg press calf raise against the standing one, of the
# Smith machine calf raise or of the dumbbell single-leg calf raise was found;
# their rows follow the knee-straight studies above (see the notes).

from common_legs30 import *

NAMES = ["Standing Calf Raise", "Seated Calf Raise", "Leg Press Calf Raise",
         "Single-Leg Calf Raise", "Smith Machine Calf Raise"]


def calf_glows(name, both=True, dx=0.015, dy=0.0, rx=0.045, ry=0.075):
    """The calves between knee and ankle, nudged toward the back of the shin
    (to the right on the screen-left-facing framings): the near (left) calf
    full, the far one soft."""
    g = [glow(name, ["shin_L", "foot_L"], A, 0.55, rx=rx, ry=ry, dx=dx, dy=dy)]
    if both:
        g.append(glow(name, ["shin_R", "foot_R"], SOFT, 0.32, rx=rx * 0.9, ry=ry * 0.9, dx=dx, dy=dy))
    return g


# ---------------------------------------------------------------- shared cues

TOP = ("Top of the Rep",
       "Rise onto the balls of the feet as high as the ankles allow and hold for a moment.",
       "The calves work by pointing the ankles, and a calf raise has a short range to begin with. Rising as high as you can and holding briefly makes every rep reach the top of that range instead of turning back partway.",
       "Stopping with the heels only partway up, the ankles never fully pointed.",
       "Push through the balls of the feet until the heels are as high as they go, hold for a moment, then lower.")
BOTTOM = ("Bottom of the Rep",
          "The heels come back down at least to level with the step on every rep.",
          "Low in the rep the calves are at their longest. In an eight-week study on a leg press calf machine, training only the stretched range below a flat foot grew the gastrocnemius more than training only the range above it, and at least as much as the full range. Level with the step is the least to aim for; the extra growth in that study came from the part below it, so let the heels sink below the step if your ankles are comfortable.",
          "Keeping the heels well above the step between reps, so every rep stays near the top.",
          "Lower under control until the heels are level with the step, then, if your ankles and Achilles tendons are comfortable, let them sink below it into a stretch before rising.")
KNEES = ("Straight Knees",
         "The knees stay straight but soft, so only the ankles move.",
         "The gastrocnemius crosses the knee as well as the ankle, so it works hardest with the knee straight; bending the knee shortens it and its activity falls. Dipping at the knees to bounce the weight up also brings the thighs into the lift, taking work away from the calves.",
         "Bending the knees at the bottom to dip and drive the weight up with the thighs.",
         "Keep a soft, fixed bend in the knees, rise and lower by the ankles alone, and choose a load you can move that way.")
TEMPO = ("Tempo",
         "Rise in about a second, hold at the top, lower more slowly.",
         "Dropping quickly into the bottom and bouncing out lets the Achilles tendon stretch and spring back: in a quick dip-and-push ankle movement, the calf muscle fibres stayed nearly the same length while the tendon stored and returned energy. A controlled lowering and a short pause keep the lift on the calf muscles.",
         "Dropping fast into the bottom and bouncing straight back up.",
         "Rise in about a second, hold the top briefly, take about two seconds to lower and pause for a moment at the bottom.")

# Knee straight (172° standing, 170° on the leg press): gastrocnemius first,
# soleus a clear second. Medial gastrocnemius above the soleus at 180°, the
# soleus lower at 180° than with the knee bent (Signorile 2002); only the
# gastrocnemius heads lit up on MRI at 0° knee flexion and 25% 1RM (Price
# 2003); gastrocnemius a little higher and soleus a little lower straight
# than at 45° (Hébert-Losier 2012). The soleus still works in every calf
# raise (Kinoshita 2023: it grew as much standing as seated), so it stays
# near the top of the moderate band.
ACT_STRAIGHT = [("Gastrocnemius", P, HI, 0.86), ("Soleus", S, MOD, 0.66)]
# Knee at ~90°: soleus first, gastrocnemius low (Cresswell 1995, Arampatzis
# 2006, Price 2003, Signorile 2002; ExRx: active insufficiency; Kinoshita
# 2023: seated training barely grew the gastrocnemius).
ACT_SEATED = [("Soleus", P, HI, 0.86), ("Gastrocnemius", S, LOW, 0.30)]
FOOT = ["tibialis posterior", "peroneals", "toe flexors"]

# ---------------------------------------------------------------- standing machine

ex(name="Standing Calf Raise", var="standingCalfRaise",
   library=("GASTROCNEMIUS", "MACHINE", "beginner"),
   # Facing screen-left, the stack on the right; the hands reach forward to
   # the left at shoulder height (u 0.39-0.47, v 0.26-0.32), so the tempo
   # label sits top right (19 characters, clear of the head at u 0.52) and
   # the left side keeps to the knee and the feet. The two foot labels share
   # the lowest row, one each side of the feet, each leader to the foot on
   # its own side (foot_R u 0.46-0.50, foot_L u 0.51-0.54) so they do not
   # cross. Tempo is listed last so the cue list opens on a cue with a ghost.
   overrides={"tempo": (0.14, "trailing"), "body": (0.50, "trailing"), "knees": (0.62, "leading"),
              "top": (0.86, "leading"), "bottom": (0.86, "trailing")},
   annotations=[
       ("body", "Hips under the pads", "pelvis"),
       ("knees", "Knees straight, soft", "patella_L"),
       ("top", "Heels as high as they go", "foot_R"),
       ("bottom", "Heels down to level", "foot_L"),
       ("tempo", "Pause, lower slowly", "chest"),
   ],
   cues={
       "body": ("Body Position",
                "The body stays in a straight line under the shoulder pads.",
                "Standing tall sends the load straight down through the legs to the balls of the feet. Pushing the hips back folds the body under the pads, and snapping the hips forward again can heave the weight up without the calves.",
                "Pushing the hips back and tipping the chest forward under the pads.",
                "Stand tall with the hips under the shoulders, brace the trunk and let the ankles do the moving."),
       "knees": KNEES, "top": TOP, "bottom": BOTTOM, "tempo": TEMPO,
   },
   activation=ACT_STRAIGHT,
   stabilisers=FOOT + ["upper back", "core"],
   comparison=("KNEES DIPPING", "Straight knees, ankles move", "Knees dip to bounce the load",
               "With the knees held straight, the ankles do all the moving and the gastrocnemius works at the length where it contributes most.",
               "Dipping at the knees brings the thighs into the lift and shortens the gastrocnemius, so the calves do less of each rep."),
   glows=calf_glows("Standing Calf Raise"))

SETUP["Standing Calf Raise"] = [
    "Set the shoulder pads so they sit on your shoulders with your heels down.",
    "Step onto the block with the balls of your feet on its edge, heels off.",
    "Set your feet hip-width apart, toes forward, and hold the handles.",
    "Stand up tall under the pads, knees straight but soft.",
]

# ---------------------------------------------------------------- seated machine

ex(name="Seated Calf Raise", var="seatedCalfRaise",
   library=("SOLEUS", "MACHINE", "beginner"),
   # Facing screen-left: the lever and plates on the left at knee height,
   # the knees at u 0.31-0.35, the hands on the pad at u 0.36-0.49, v
   # 0.35-0.40, the body on the right. The trunk label goes top left, above
   # the hands; the knee label is kept to 12 characters so it ends before the
   # far knee (u 0.31). The calves span u 0.25-0.42, v 0.53-0.70, so both
   # foot labels go on the lowest row, one each side, each leader to the
   # foot on its own side (foot_R u 0.26-0.30, foot_L u 0.30-0.35); the
   # tempo label sits on the right over the seat.
   overrides={"trunk": (0.14, "leading"), "knees": (0.50, "leading"), "top": (0.86, "leading"),
              "bottom": (0.86, "trailing"), "tempo": (0.68, "trailing")},
   annotations=[
       ("trunk", "Sit tall, no rocking", "chest"),
       ("knees", "Knees at 90°", "patella_L"),
       ("top", "Rise high, hold", "foot_R"),
       ("bottom", "Heels back to level", "foot_L"),
       ("tempo", "Pause, lower slowly", "pelvis"),
   ],
   cues={
       "knees": ("Knee Angle",
                 "The knees stay bent at about a right angle under the pad, the shins upright.",
                 "The gastrocnemius crosses the knee, so with the knees bent this far it is shortened and adds little; in studies that bent the knee, gastrocnemius activity fell while soleus activity held, which leaves the soleus doing most of the work. Setting the feet far out in front opens the knees and lets the gastrocnemius back in.",
                 "Placing the feet far out in front, so the knees open well past a right angle.",
                 "Sit so the pad rests on the lower thighs just above the knees, with the balls of the feet on the platform edge directly under the knees."),
       "trunk": ("Trunk and Arms",
                 "The trunk stays still and the hands only steady the pad.",
                 "The pad rests on the lower thighs, so leaning back and pulling on the handles can heave it up with the trunk and arms. The ankles should be what lifts it.",
                 "Leaning back and hauling on the handles to lift the pad.",
                 "Sit tall, hold the handles lightly and let the heels drive the pad up."),
       "top": ("Top of the Rep",
               "Rise onto the balls of the feet, lifting the pad as high as the ankles allow, and hold for a moment.",
               TOP[2],
               "Stopping with the heels only partway up, the pad barely rising.",
               "Push through the balls of the feet until the heels are as high as they go, hold for a moment, then lower."),
       "bottom": ("Bottom of the Rep",
                  "The heels come back down to about level with the platform on every rep.",
                  "Low in the rep the calf muscles are at their longest. In a study of straight-knee calf raises, training only the stretched range below a flat foot grew the gastrocnemius more than training only the range above it. That study measured only the gastrocnemius, so it does not show the same for the soleus; about level with the platform is the least to aim for, and letting the heels sink below it, if comfortable, adds the stretched part.",
                  "Keeping the heels high between reps, so the pad only bobs near the top.",
                  "Lower under control until the heels are level with the platform, then, if your ankles are comfortable, let them sink below it into a stretch before rising."),
       "tempo": TEMPO,
   },
   activation=ACT_SEATED,
   stabilisers=FOOT,
   comparison=("ROCKING THE TRUNK", "Trunk still, heels lift the pad", "Trunk leans back to heave the pad",
               "Sitting still leaves the ankles to lift the pad, so the soleus does the work the seated raise is for.",
               "Leaning back and pulling on the handles moves the pad with the trunk and arms, and the calves do less."),
   glows=calf_glows("Seated Calf Raise"))

SETUP["Seated Calf Raise"] = [
    "Sit on the seat with the balls of your feet on the edge of the platform, heels off.",
    "Set the pad on your lower thighs, just above the knees, knees at about 90°.",
    "Hold the handles, rise onto your toes a little and release the safety catch.",
    "Sit tall with your trunk still.",
]

# ---------------------------------------------------------------- leg press

ex(name="Leg Press Calf Raise", var="legPressCalfRaise",
   library=("GASTROCNEMIUS", "MACHINE", "beginner"),
   # From behind on the left: the sled and feet top left (feet u 0.15-0.30, v
   # 0.28-0.30), the knees at v 0.39, the near hand at u 0.34, v 0.47, the
   # head and far hand on the right. Both foot labels use the top row, one
   # each side; the knee labels go down the left below the near calf (a
   # label at 0.33 on screen would cover it), the bend label short enough to
   # end before the near hand; tempo sits low right over the seat box.
   overrides={"top": (0.14, "leading"), "bottom": (0.14, "trailing"), "knees": (0.50, "leading"),
              "lock": (0.68, "leading"), "tempo": (0.68, "trailing")},
   annotations=[
       ("top", "Push through the forefeet", "foot_L"),
       ("bottom", "Heels back down", "foot_R"),
       ("knees", "Knees stay put", "patella_L"),
       ("lock", "Soft knees, not locked", "patella_R"),
       ("tempo", "Pause, lower slowly", "pelvis"),
   ],
   cues={
       "knees": ("Knee Position",
                 "The knees hold one angle, so only the ankles move the sled.",
                 "With the knees nearly straight the gastrocnemius stays long and does much of the work alongside the soleus. Letting the knees bend lets the sled sink toward you, and pushing it back with the thighs turns part of the rep into a leg press.",
                 "Letting the knees bend at the bottom so the sled sinks, then pushing it back up with the thighs.",
                 "Set the knees nearly straight and keep them there, moving the sled only by pointing and flexing the ankles."),
       "lock": ("Soft Knees",
                "The knees stay just short of locked under the sled.",
                "Leg press calf raise guides advise keeping a slight bend rather than locking the knees out under the loaded sled. Holding that slight bend also keeps the knees from snapping straight each time the ankles push.",
                "Snapping the knees straight and locking them under the loaded sled.",
                "Keep a slight bend in the knees from the first rep to the last, and do not let them snap straight as the ankles push the sled."),
       "top": ("Top of the Rep",
               "Push the plate away through the balls of the feet until the ankles are fully pointed, and hold for a moment.",
               "The calves work by pointing the ankles, and a calf raise has a short range to begin with. Pointing the ankles as far as they go and holding briefly makes every rep reach the top of that range instead of turning back partway.",
               "Stopping with the ankles only partway pointed, the sled barely moving.",
               "Press through the balls of the feet until the ankles are as pointed as they go, hold for a moment, then let the sled back."),
       "bottom": ("Bottom of the Rep",
                  "The sled comes back until the ankles are close to flat.",
                  "Low in the rep the calves are at their longest. In an eight-week study of calf raises on a leg press, training only the stretched range below a flat foot grew the gastrocnemius more than training only the range above it, and at least as much as the full range. Coming back to about a flat foot is the least to aim for; the extra growth in that study came from going past flat, so go a little past it if comfortable.",
                  "Keeping the ankles pointed between reps, so the sled only moves near the top.",
                  "Let the sled come back under control until the ankles are at or close to flat, and a little past flat if comfortable, before pressing again."),
       "tempo": ("Tempo",
                 "Press in about a second, hold at the top, let the sled back more slowly.",
                 TEMPO[2], TEMPO[3],
                 "Press in about a second, hold the top briefly, take about two seconds to let the sled back and pause for a moment at the bottom."),
   },
   activation=ACT_STRAIGHT,
   stabilisers=FOOT,
   comparison=("SLED SINKING", "Knees fixed, ankles move", "Knees bend, sled sinks",
               "Holding the knees at one angle leaves the ankles to move the sled, so the whole rep comes from the calves.",
               "When the knees bend the sled sinks and the thighs push it back, turning part of the rep into a leg press."),
   glows=calf_glows("Leg Press Calf Raise", dx=0.0, dy=0.015, rx=0.07, ry=0.05))

SETUP["Leg Press Calf Raise"] = [
    "Sit with your back flat on the pad and hold the handles beside the seat.",
    "Put the balls of your feet on the lower edge of the platform, hip-width apart, heels off.",
    "Press the sled up until your knees are nearly straight, then release the safety stops.",
    "Keep a slight bend in your knees; if your feet start to slip, re-engage the stops before you reset them.",
]

# ---------------------------------------------------------------- single leg

ex(name="Single-Leg Calf Raise", var="singleLegCalfRaise",
   library=("GASTROCNEMIUS", "DUMBBELL", "intermediate"),
   # Left leg working, facing screen-left, the balance upright at the left
   # (u ~0.26) with the right hand on its grip (u 0.34, v 0.37); the bent
   # right leg hangs behind on the right (foot u 0.67, v 0.64-0.68). The
   # support label is kept to 12 characters so it ends before the upright;
   # both foot labels point at the working foot: the top label at row 0.68
   # (v 0.64) over the upright, clear of the working toes (u 0.28-0.32, v
   # 0.78-0.80) that a lowest-row pill on the left would cover; the bottom
   # label on the lowest row at the right. Tempo is listed last so the cue
   # list opens on a cue with a ghost.
   overrides={"support": (0.32, "leading"), "tempo": (0.32, "trailing"), "knee": (0.62, "leading"),
              "top": (0.68, "leading"), "bottom": (0.86, "trailing")},
   annotations=[
       ("support", "Balance only", "hand_R"),
       ("knee", "Knee straight", "patella_L"),
       ("top", "Rise high, hold", "foot_L"),
       ("bottom", "Heel down to level", "foot_L"),
       ("tempo", "Pause, lower slowly", "chest"),
   ],
   cues={
       "support": ("Balance Hand",
                   "The free hand rests on the handle for balance only.",
                   "On one leg a light hold keeps you steady, so the working calf can go through its range. Pushing down on the handle takes part of your body weight on the arm, so the calf lifts less; if you need to push, the load is too heavy.",
                   "Leaning on the handle and pushing down on it to help lift the body.",
                   "Hold the handle lightly with the elbow relaxed, stay upright over the working foot and use a lighter dumbbell if you have to push on it."),
       "knee": ("Working Knee",
                "The working knee stays straight but soft.",
                KNEES[2],
                "Bending the working knee at the bottom to dip and bounce back up.",
                "Keep a soft, fixed bend in the working knee and move only at the ankle."),
       "top": ("Top of the Rep",
               "Rise onto the ball of the foot as high as the ankle allows and hold for a moment.",
               TOP[2],
               "Stopping with the heel only partway up, the ankle never fully pointed.",
               "Push through the ball of the foot until the heel is as high as it goes, hold for a moment, then lower."),
       "bottom": ("Bottom of the Rep",
                  "The heel comes back down at least to level with the step on every rep.",
                  "Low in the rep the calf is at its longest. In an eight-week study on a leg press calf machine, training only the stretched range below a flat foot grew the gastrocnemius more than training only the range above it, and at least as much as the full range. Level with the step is the least to aim for; the extra growth in that study came from the part below it, so let the heel sink below the step if your ankle is comfortable.",
                  "Keeping the heel well above the step between reps, so every rep stays near the top.",
                  "Lower under control until the heel is level with the step, then, if your ankle and Achilles tendon are comfortable, let the heel sink below the step into a stretch before rising."),
       "tempo": TEMPO,
   },
   activation=ACT_STRAIGHT,
   stabilisers=FOOT + ["gluteus medius", "obliques", "forearms"],
   comparison=("LEANING ON THE HANDLE", "Light hand, calf lifts you", "Arm pushes down on the handle",
               "A light hand only steadies you, so the working calf lifts your body and the dumbbell.",
               "Pushing down on the handle takes part of your weight on the arm; if you need to, use a lighter dumbbell."),
   glows=calf_glows("Single-Leg Calf Raise", both=False))

SETUP["Single-Leg Calf Raise"] = [
    "Stand on a sturdy step beside a support, a dumbbell in the hand on the working side.",
    "Put the ball of the working foot on the edge of the step, heel off.",
    "Hold the support lightly with your free hand for balance.",
    "Bend the other knee to lift that foot behind you and stand tall over the working foot.",
]

# ---------------------------------------------------------------- Smith machine

ex(name="Smith Machine Calf Raise", var="smithMachineCalfRaise",
   library=("GASTROCNEMIUS", "MACHINE", "beginner"),
   # Three-quarter framing with the lifter on the left of the screen (u
   # 0.14-0.40) and the frame on the right: most labels sit on the right over
   # the frame, stacked down the body; only the far foot's label goes on the
   # left, on the lowest row over the deck. Tempo is listed last so the cue
   # list opens on a cue with a ghost.
   overrides={"tempo": (0.32, "trailing"), "body": (0.50, "trailing"), "knees": (0.62, "trailing"),
              "top": (0.86, "trailing"), "bottom": (0.86, "leading")},
   annotations=[
       ("body", "Hips under the bar", "pelvis"),
       ("knees", "Knees straight, soft", "patella_L"),
       ("top", "Heels as high as they go", "foot_L"),
       ("bottom", "Heels down to level", "foot_R"),
       ("tempo", "Pause, lower slowly", "chest"),
   ],
   cues={
       "body": ("Body Position",
                "The body stays in a straight line under the bar.",
                "The bar can only move straight up and down, so the body has to stay stacked under it for the push to go straight up through the balls of the feet. Pushing the hips back tips the chest forward and lets the hips help heave the bar up.",
                "Pushing the hips back and tipping the chest forward under the fixed bar.",
                "Stand tall with the hips under the bar, brace the trunk and let the ankles do the moving."),
       "knees": KNEES, "top": TOP, "bottom": BOTTOM, "tempo": TEMPO,
   },
   activation=ACT_STRAIGHT,
   stabilisers=FOOT + ["upper back", "core"],
   comparison=("HEELS STAY HIGH", "Heels down to level each rep", "Heels hover high between reps",
               "Coming down to level on every rep uses the whole range above the step; sinking a little below it, if comfortable, adds the stretch.",
               "Hovering with the heels high cuts every rep short near the top and never lets the calves lengthen."),
   glows=calf_glows("Smith Machine Calf Raise", dx=0.01))

SETUP["Smith Machine Calf Raise"] = [
    "Set the bar at upper-chest height with a calf block under it.",
    "Step under the bar, rest it on your upper traps and grip it just outside your shoulders.",
    "Put the balls of your feet on the edge of the block, heels off, hip-width apart.",
    "Stand up tall, turn the bar to unhook it and keep the knees straight but soft.",
]

if __name__ == "__main__":
    probs = validate(NAMES) + validate_library(NAMES)
    print("\n".join(probs) or "OK")
