# Trainer content for the 401-500 folder, second round (2026-10-04), family:
# cablecrunch. Four loaded crunches from the builder's 432-435 exports: 432
# Standing Cable Crunch (Abs/StandingCableCrunch), 433 Oblique Cable Crunch
# (Abs/ObliqueCableCrunch), 434 Machine Crunch (Abs/MachineCrunch) and 435 Ab
# Coaster Crunch (Abs/AbCoasterCrunch). Same format as spec.py on top of
# common_1_50.py; spec_500.py imports this module and gen.py reads SPEC /
# SETUP. notes_500_cablecrunch.md maps the copy's claims to the sources below
# and records the model facts.
#
# What the models show, measured on the rigs with Blender's Python + pxr
# (SCRATCH/cablecrunch/body.py, bones.py, rel.py, eq.py, skin.py; the app's
# Y-up space, the lifter facing +z, their left +x), the briefs
# (SCRATCH/briefs2, briefs2_legs), tiers2.txt, joints.json and the trainer
# stills at 0/1/2/3/5 s. "Flexion" below is the change in each bone's own
# orientation from the start of the clip, so the pelvis's tilt, the lumbar
# bend (spine bone against the pelvis) and the thoracic bend (chest bone
# against the spine bone) are told apart. All four clips are 7.96 s with two
# reps: the curl takes ~1.3-1.5 s, it is held ~0.5 s (to ~2.0 s), the return
# takes ~1.5 s and the lifter rests ~0.5 s before the second rep (4-8 s).
# - Standing Cable Crunch: back to a dual-pulley cable station (GYM_M29) whose
#   right-hand carriage is set high (pulley ~1.9 m) directly behind the
#   lifter, ~55 cm behind the heels; a rope (HG_Rope*) runs from it over the
#   head, one end held beside each side of the forehead (palms facing in,
#   hands at temple height ~13 cm in front of the head joint), elbow angle
#   47° (sharply bent), held in front at shoulder height. Feet hip-width (ankles 26 cm
#   apart), toes out ~9°, knees 169°. The trunk curls: neck-over-pelvis line
#   0° -> 35° forward; the chest bone turns 47°, of which the pelvis tilts 9°
#   forward, the lumbar spine 19° and the thoracic spine 19°; the head and
#   hands stay fixed to the chest (elbow angle 47° throughout), the elbows dropping
#   ~32 cm toward the thighs. The pelvis moves ~3.5 cm back, the knees bend
#   169° -> 160°. The stack rises ~21 cm. Paint: rectus abdominis bright;
#   obliques and posterior deltoid dim.
# - Oblique Cable Crunch: the same station, rope, stance and hold, but each
#   rep turns as it curls: the first (0-4 s) turns to the right, the left
#   elbow travelling down and across to the midline (toward the right hip),
#   the second (4-8 s) to the left. At the bottom the chest bone has flexed
#   ~46° and turned ~32° toward the working side with only ~4° of side bend;
#   the pelvis tilts 9° forward but does not turn, so the hips stay square;
#   knees 169° -> 160°. Paint: external and internal obliques and rectus
#   abdominis bright; posterior deltoid dim.
# - Machine Crunch: a seated crunch machine (GYM_M26): the chest against two
#   chest pads on a lever that pivots on hubs (HG_PivotHub) at the sides of
#   the seat back, ~73 cm up, about level with the lower ribs; the hands on
#   handles at about head height, the wrists 26 cm in front of the
#   shoulders and 29 cm from the midline, ~9 cm outside the shoulder joints
#   (palms facing in, elbow angle 67°, held);
#   seated with the knees at 98°, thighs level, feet flat on the floor and
#   tucked under the front roller (the roller's underside 2 mm above the
#   shoes); the back starts ~5-7 cm in front of the back pad. The chest bone
#   curls 34° (lumbar 10°, thoracic 24°); the pelvis does not move at all.
#   The stack rises ~35 cm. Paint: rectus abdominis bright; obliques dim.
# - Ab Coaster Crunch: kneeling on the carriage (HG_Carriage) of an ab coaster,
#   shins on its pad and feet hanging off the back end, hands palms down on
#   the handlebar (HG_Handlebar) in front at about hip height, ~48 cm apart,
#   elbows 136-143° (arms long, softly bent); the trunk tipped ~53° forward. The
#   carriage rolls ~41 cm forward and up the curved rails: the knees travel
#   ~35 cm forward and ~7 cm up, the pelvis rolls under (tilts back ~40°) and
#   the lower back rounds (the chest bone ~36° against the pelvis), while the
#   chest and shoulders stay nearly still (~2 cm). Because the pelvis rolls
#   back further than the thighs swing up (31°), the hip angle itself opens
#   ~9°: the knees climb by the pelvic curl, not by folding at the hips.
#   Knees 70° -> 62°. The thighs go from ~20° off upright at the bottom to
#   ~52° at the top (the hips sit behind the knees throughout, 15 cm at the
#   bottom and 35 cm at the top, so the bottom is cued by upright thighs; the
#   review's measurement). Paint: rectus abdominis bright; obliques, posterior
#   deltoid, triceps and the hip flexors (Sartorius mesh) dim.
#
# How they differ from the library: the Cable Crunch kneels facing the stack
# with the rope beside the head; the Decline Crunch and Crunch lie down with
# body weight; the Hanging Knee Raise hangs from a bar and lifts the knees.
# The standing pair stand facing away from a high pulley with the rope over
# the head; the oblique one alternates a turn on each rep; the machine crunch
# sits with the chest on pads and the feet under a roller; the ab coaster
# kneels and curls from the bottom up on a rolling carriage, closer to the
# Reverse Crunch and Hanging Knee Raise than to a crunch.
#
# Sources (abstracts read on Europe PMC / PubMed, full texts where noted;
# ExRx on the Wayback Machine since the live site returns 403; details and
# what each supports are in the notes):
# - ExRx.net (Wayback Machine): Cable Standing Overhead Crunch
#   (CBStandingOverheadCrunch, snapshot 2025-08-15), Cable Kneeling Crunch
#   (CBKneelingCrunch, 2026-02-06), Cable Standing Crunch (CBStandingCrunch,
#   2025-08-28), Cable Standing Twisting Crunch (old URL
#   CBStandingTwistingCrunch.html, 2018-02-10), Lever Seated Crunch
#   (LVSeatedCrunch, 2023-12-12), Lever Seated Crunch, chest pad
#   (LVSeatedCrunchChestPad, 2024-02-01), Sled Leg Hip Raise (Ab Coaster)
#   (SLLegHipRaise, 2025-08-16), Rectus Abdominis (2025-10-26) and Obliques
#   (2025-04-21) muscle pages: set-ups and execution; the movement happens at
#   the waist, not the hips, with the knees and hips stationary and the
#   elbows travelling toward the middle of the thighs; some lifters keep a
#   gap between chin and breastbone; the knees slightly bent on the standing
#   crunch; target rectus abdominis, synergist obliques; the lats, teres
#   major, posterior deltoid and triceps long head among the stabilisers of
#   the cable crunches held at the head, the arm-pad seated crunch machine
#   (its chest-pad version lists no stabilisers) and the ab coaster; the twisting
#   crunch flexes and twists the spine, one shoulder to the front centre,
#   alternating sides, target obliques with the rectus abdominis as
#   synergist; the seated machine flexes the waist in a C shape with the hips
#   stationary; the ab coaster slides forward and up by pulling the knees up
#   high with a deliberate C shape at the waist, iliopsoas, rectus femoris,
#   sartorius, tensor fasciae latae and obliques synergists; the rectus
#   abdominis from the pubic crest to the 5th-7th rib cartilages and xiphoid,
#   flexing the lumbar spine; the obliques from the lower ribs to the iliac
#   crest, inguinal ligament, pubis and linea alba, flexing the spine
#   (both sides), rotating it (right: left external with right internal) and
#   bending it sideways.
# - Sundstrup E, Jakobsen MD, Andersen CH, Jay K, Andersen LL 2012, Int J
#   Sports Phys Ther 7(4):372-380, PMID 22893857 (PMC3414069, full text) - 42
#   untrained adults, 10RM crunches on a seated crunch machine (Technogym,
#   feet behind ankle rollers, hands on handles at shoulder level) and on a
#   Swiss ball with elastic resistance: on the machine rectus abdominis 84%,
#   external obliques 79% / 71% (left / right) and rectus femoris 65% of
#   MVIC EMG (ball 104%, 86% / 79%, 27%); the authors put the high rectus
#   femoris down to the flexed hips and the fixed feet.
# - Stenger EM 2013, Electromyographic comparison of a variety of abdominal
#   exercises to the traditional crunch, MS thesis, University of
#   Wisconsin-La Crosse (advisor J Porcari), MINDS@UW handle 1793/67303 (full
#   text) - 14 young adults, 16 exercises incl. the Ab Coaster (hands on the
#   handles, knees on the pad supports, knees to the top of the track): upper
#   and lower rectus abdominis not different from a floor crunch (bars ~85%
#   and ~90% of it), external obliques and rectus femoris significantly
#   higher (bars ~145% and ~350% of the crunch's).
# - Moraes AC, Pinto RS, Valamatos MJ, et al. 2009, Phys Ther Sport
#   10(2):57-62, doi:10.1016/j.ptsp.2009.01.001, PMID 19376473 - loaded
#   crunches at 20-100% 1RM: the abdominals were recruited more at the
#   heaviest load; adjacent loads often did not differ.
# - Andersson EA, Nilsson J, Ma Z, Thorstensson A 1997, Eur J Appl Physiol
#   75(2):115-123, doi:10.1007/s004210050135, PMID 9118976 - 38 sit-up and leg
#   lift variants: in trunk-flexion sit-ups abdominal activation rose with the
#   flexion angle; flexed and supported legs raised hip flexor activation in
#   hip-flexion sit-ups without generally changing the abdominals'.
# - Crommert ME, Bjerkefors A, Tarassova O, Ekblom MM 2021, J Strength Cond
#   Res 35(2):428-435, doi:10.1519/JSC.0000000000002439, PMID 29319600 - fine
#   wire EMG on the right side in twisting curl-ups: internal oblique higher
#   turning right, external oblique higher turning left, rectus abdominis the
#   same in both directions.
# - Ha SY, Shin D 2020, J Back Musculoskelet Rehabil 33(5):857-863,
#   doi:10.3233/BMR-191558, PMID 32144977 - curl-ups: abdominal EMG did not
#   differ between the lifting (concentric) and lowering (eccentric) phases.
# - Ingleby L 2025, Cable Crunch Variations, Mirafit blog (1 Oct 2025; Wayback
#   2025-10-16) - the standing cable crunch facing away from the machine with
#   the rope over the shoulders, crunching forward from a stable stance;
#   contract with the core rather than pulling with the arms.
# - Motra (formerly Train Fitness), Ab Coaster exercise guide
#   (motra.com/exercises/abCoaster, read 2026-10-05) - common mistakes:
#   using momentum, pulling with the arms, arching the lower back, moving too
#   fast; full extension at the bottom without arching the back.
# No EMG study of a standing or twisting cable crunch was found, so those
# fractions are judgement calls anchored on the library's Cable Crunch (rectus
# abdominis 0.86, obliques 0.52); the machine and coaster fractions lean on
# Sundstrup 2012 and Stenger 2013 but are still judgement calls (nEMG is not
# the app's fraction). Activation follows the paint: bright rows primary, dim
# rows secondary; the coaster's dim posterior deltoid is named with the
# stabilisers because a fourth secondary name would overflow the one-line
# legend.
from common_1_50 import *


def ov(final):
    """Pre-squeeze override row for an on-screen row (spec_500.row() maps
    0.14-0.86 to 0.16-0.80)."""
    return round(0.14 + (final - 0.16) * (0.86 - 0.14) / (0.80 - 0.16), 4)


def lit(name, u, v, rx, ry, kind=A, opacity=0.55, anchor=("spine",)):
    """A glow centred on the lit muscles at (u, v), the mean centre of the
    painted pixels in the five trainer stills (SCRATCH/cablecrunch/orange.py),
    written as a nudge from the probed `anchor` joints like the other
    families' glows."""
    cu, cv = mean(name, list(anchor))
    return glow(name, list(anchor), kind, opacity, rx, ry, round(u - cu, 3), round(v - cv, 3))


# ---------------------------------------------------------------- Standing Cable Crunch

N = "Standing Cable Crunch"
ex(name=N, var="standingCableCrunch",
   # Side-on from the front left (yaw -1.35), facing screen-left; the cable
   # runs from the head to the top right, the head and hands swing left to
   # u ~0.30 at the bottom of the curl. Free space: top left above the hands,
   # left below the elbows (v > 0.43, u < 0.50), and a narrow strip right of
   # the back and hips (u > 0.71-0.75). The rope label sits top left with a
   # level leader to the near hand; the range label left of the belly, up to
   # the near elbow; the knee label left of the shins; two short labels on
   # the right reach into the back (chest) and the hips.
   overrides={"rope": (ov(0.16), "leading"), "range": (ov(0.45), "leading"), "stance": (ov(0.64), "leading"),
              "curl": (ov(0.34), "trailing"), "hips": (ov(0.58), "trailing")},
   annotations=[
       ("rope", "Hands fixed", "hand_L"),
       ("curl", "Round back", "chest"),
       ("range", "Elbows toward thighs", "forearm_L"),
       ("hips", "Hips still", "pelvis"),
       ("stance", "Knees soft", "patella_L"),
   ],
   cues={
       "rope": ("Rope Position",
                "The rope ends stay beside your forehead from the top of the rep to the bottom.",
                "With your hands fixed to your head, the only way to move the weight is to curl your trunk. ExRx counts the lats, rear shoulders and long head of the triceps among the stabilisers of cable crunches held at the head: their job is to hold the arms still. Pulling the rope down with them moves the stack with your arms instead.",
                "Dragging the rope down toward your chest with your arms as you curl.",
                "Hold one rope end beside each side of your forehead with your elbows in front, and let your hands travel only because your trunk curls."),
       "curl": ("Spinal Flexion",
                "Round your back so your ribs draw toward your pelvis.",
                "The rectus abdominis runs from the pubic bone up to the rib cartilages and the bottom of the breastbone, so it works by curling the spine. ExRx's note on the standing cable crunch is that the movement happens at the waist, not the hips. Bowing forward with a flat back lowers the rope with your body weight instead.",
                "Bowing forward from the hips with a flat back.",
                "Breathe out and round your back from the shoulders down, ribs drawing toward your hips, while your hips barely move."),
       "range": ("Range of Motion",
                 "Curl until your elbows have dropped well below your shoulders.",
                 "ExRx describes the curl as the elbows travelling toward the middle of the thighs. In a lab study of trunk-curl sit-ups, the abdominals were more active the further the trunk was curled, so a short nod leaves out the deeper part of the curl, where that study found them most active.",
                 "Stopping after a short nod, the back barely rounded.",
                 "Keep curling until your back is fully rounded and your elbows have travelled down toward your thighs, hold for a moment, then rise."),
       "hips": ("Hip Position",
                "Your hips stay over your feet while your trunk curls.",
                "Pushing the hips back and bending the knees lets your body weight drop the rope, so the stack moves while the abdominals do less. ExRx's standing cable crunch keeps the knees and hips still and moves only at the waist.",
                "Sitting your hips back and bending your knees to pull the weight down.",
                "Keep your hips stacked over your feet and your knees softly bent, not sinking; only your trunk curls."),
       "stance": ("Stance",
                  "Feet about hip-width, knees softly bent.",
                  "Facing away from the pulley, the cable pulls you up and back as you curl against it. A hip-width base with soft knees keeps you steady, and ExRx sets up its standing cable crunches with the knees slightly bent.",
                  "Standing with your feet together and your knees locked straight.",
                  "Stand about a step in front of the machine with your feet hip-width, toes turned out a little, and a slight bend in your knees."),
   },
   # Paint: rectus abdominis bright; obliques and posterior deltoid dim. No EMG
   # exists for this lift: the library's Cable Crunch values (0.86 / 0.52) for
   # the two abdominal rows, a judgement call; Moraes 2009 (more abdominal
   # recruitment at heavier crunch loads) is why a loaded crunch sits at the
   # top of the library's crunch values (a judgement: Sundstrup 2012 cites
   # earlier work where added load raised hip flexor rather than rectus
   # abdominis activity). Posterior deltoid 0.20 LOW: it only
   # holds the arms against the cable (ExRx stabiliser), a paint-led judgement.
   activation=[("Rectus Abdominis", P, HI, 0.86), ("Obliques", S, MOD, 0.52), ("Posterior Deltoid", S, LOW, 0.20)],
   stabilisers=["latissimus dorsi", "teres major", "triceps long head", "hip flexors"],
   comparison=("BOWING FROM THE HIPS", "Ribs curl toward the hips", "Flat back tips from the hips",
               "Rounding the spine draws the ribs toward the pelvis, the movement the rectus abdominis makes.",
               "Tipping from the hips with a flat back lowers the rope with your body weight while the abdominals stay nearly the same length."),
   glows=[lit(N, 0.555, 0.375, 0.06, 0.07), lit(N, 0.605, 0.40, 0.04, 0.055, SOFT, 0.30)])

SETUP[N] = [
    "Set a rope on a high pulley, above head height, and stand facing away from the machine about a step in front of it.",
    "Bring the rope over your head and hold one end beside each side of your forehead.",
    "Stand with your feet hip-width, toes turned out a little, knees softly bent.",
    "Raise your elbows in front of you to about shoulder height and stand tall before the first rep.",
]

# ---------------------------------------------------------------- Oblique Cable Crunch

N = "Oblique Cable Crunch"
ex(name=N, var="obliqueCableCrunch",
   # Three-quarter from the front left (yaw -0.4): the lifter faces the
   # camera turned to screen-left, the cable station's tower fills the right
   # half behind them (u ~0.45-0.82). In the first rep the head and hands
   # swing to screen-left (the lifter's right), the right elbow out to
   # u ~0.18; in the second the left elbow swings out to u ~0.77. Labels on
   # the left track the lifter's right side, which is nearest the open
   # space: the rope label top left to the right hand, the turn label to the
   # right lower chest, the hips label to the right hip. The lifter's left
   # side reaches u ~0.72 (0.80 at the elbow in the second rep), so the two
   # right-hand labels are short and sit over the tower's static right post:
   # the curl label at waist height to the lumbar spine, the sides label
   # above the elbows to the left shoulder, the one that crosses first.
   overrides={"rope": (ov(0.13), "leading"), "twist": (ov(0.44), "leading"), "hips": (ov(0.52), "leading"),
              "curl": (ov(0.47), "trailing"), "sides": (ov(0.20), "trailing")},
   annotations=[
       ("twist", "Turn as you curl", "support_PectoralisMajor_Abdominal_R"),
       ("curl", "Round down", "spine"),
       ("hips", "Hips square", "thigh_R"),
       ("rope", "Hands by your face", "hand_R"),
       ("sides", "Alternate", "upper_arm_L"),
   ],
   cues={
       "twist": ("Rotation",
                 "Each rep curls down and turns one shoulder across toward the opposite hip.",
                 "Turning the trunk to the right uses the left external oblique and the right internal oblique, and turning left the reverse (ExRx). In a study with fine-wire electrodes in twisting curl-ups, the internal oblique worked harder turning toward its own side and the external oblique turning away from it, while the rectus abdominis worked the same either way.",
                 "Curling straight down with your shoulders square, no turn.",
                 "As you curl, bring your left elbow down and across toward your right hip; on the next rep, your right elbow toward your left hip."),
       "curl": ("Curl and Turn",
                "The turn rides on a curl: your back rounds as the shoulder comes across.",
                "ExRx's twisting cable crunch flexes and twists the spine in one movement, and the obliques help curl the trunk as well as turn it. Turning with your back upright leaves out the curl, the part the rectus abdominis and the obliques share.",
                "Twisting your shoulders round while your back stays upright.",
                "Round your back as you turn so your chest drops toward the opposite thigh, then rise and untwist together."),
       "hips": ("Hips Square",
                "Your hips and knees face forward while your ribcage turns.",
                "The obliques run from the lower ribs to the pelvis and the sheath around the rectus abdominis, so they turn the ribcage against the pelvis. Let your hips swing round with your shoulders and the turn comes from the hips and feet instead, leaving the obliques less to do.",
                "Letting your hips and knees swing round with your shoulders.",
                "Keep your hips and knees pointing straight ahead and your feet planted; only your ribcage turns."),
       "rope": ("Rope Position",
                "The rope ends stay beside your forehead through the curl and the turn.",
                "Fixed hands make your trunk move the weight. Hauling the rope down with your arms moves the stack with your shoulders and arms, and the curl and turn of the trunk get smaller.",
                "Hauling the rope down with your arms as you turn.",
                "Keep a hand beside each side of your forehead and let your elbows travel only because your trunk curls and turns."),
       "sides": ("Alternate Sides",
                 "The reps alternate: one to the right, the next to the left.",
                 "Each turn works one side's external oblique with the other side's internal oblique, so switching every rep trains both pairs evenly, as ExRx's standing twisting crunch does.",
                 "Turning further to your stronger side, or doing every rep to the same side.",
                 "Come back to upright and square between reps, then turn the other way, matching the depth on both sides."),
   },
   # Paint: external and internal obliques and rectus abdominis bright;
   # posterior deltoid dim. No EMG of a standing twisting cable crunch: ExRx
   # makes the obliques the target and the rectus abdominis the synergist, so
   # the obliques lead (0.80) with the rectus abdominis close behind (0.72;
   # Crommert 2021: its activity did not change with the direction of a
   # twisting curl-up). Both are judgement calls; the posterior deltoid as on
   # the standing crunch.
   activation=[("Obliques", P, HI, 0.80), ("Rectus Abdominis", P, HI, 0.72), ("Posterior Deltoid", S, LOW, 0.20)],
   stabilisers=["latissimus dorsi", "triceps long head", "transverse abdominis", "hip flexors"],
   comparison=("TURNING FROM THE HIPS", "Ribs turn, hips stay square", "Hips swing round with the shoulders",
               "Turning the ribcage over still hips makes the obliques do the turning.",
               "When the hips swing round too, the turn comes from the hips and feet and the obliques have less to do."),
   glows=[lit(N, 0.54, 0.40, 0.08, 0.055), lit(N, 0.47, 0.41, 0.035, 0.05, SOFT, 0.30)])

SETUP[N] = [
    "Clip a rope to a high pulley and stand with your back to the machine, a step out from it.",
    "Take one rope end in each hand beside your forehead, the rope running over your head.",
    "Plant your feet hip-width apart with your hips and knees facing straight ahead.",
    "Pick the side you turn to first; the reps alternate from then on.",
]

# ---------------------------------------------------------------- Machine Crunch

N = "Machine Crunch"
ex(name=N, var="machineCrunch",
   # Side-on from the front left (yaw -1.35), facing screen-left: the machine
   # (tower, back pad, seat, the lever running from the pivot hub up to the
   # handles) fills the right and the bottom; the hands and handles swing
   # from u ~0.56 to ~0.38 at the top left. Free space: top left, the middle
   # left below the elbows, a narrow strip left of the shins. The handle
   # label sits top left to the near hand; the curl label middle left, its
   # leader passing under the elbows to the chest; the tempo label above it
   # to the far elbow; the feet label left of the shins to the ball of the
   # near foot; the hips label bottom right over the seat's frame.
   overrides={"arms": (ov(0.14), "leading"), "tempo": (ov(0.44), "leading"), "curl": (ov(0.53), "leading"),
              "feet": (ov(0.70), "leading"), "hips": (ov(0.70), "trailing")},
   annotations=[
       ("arms", "Arms only hold on", "hand_L"),
       ("curl", "Curl into a C", "chest"),
       ("hips", "Hips planted", "pelvis"),
       ("feet", "Feet loose", "toe_L"),
       ("tempo", "Slow return", "forearm_R"),
   ],
   cues={
       "arms": ("Handles",
                "Your hands hold the handles at about head height; your chest on the pads moves the lever.",
                "With your chest against the pads, curling your trunk is what turns the lever. ExRx's chest-pad version of this machine only has you place your hands on the lever and lists the abdominals alone as the working muscles; hauling the handles down moves the weight with your arms instead.",
                "Pulling the handles down with your arms, elbows driving toward your knees.",
                "Hold the handles lightly with your elbows bent where they start, and let your chest push the pads down."),
       "curl": ("Spinal Flexion",
                "Curl forward into a C, your lower ribs closing toward your pelvis.",
                "ExRx describes this machine as flexing the waist into a C shape with the hips stationary. The lever pivots beside you about level with your lower ribs, so it follows a curl of the upper and middle back; tipping forward from the hips with a flat back leaves the spine, and the abdominals with it, nearly still.",
                "Tipping forward from the hips with a flat back.",
                "Breathe out and curl your chest toward your thighs, rounding your upper and middle back while your hips stay put."),
       "hips": ("Seat Contact",
                "Your hips stay planted on the seat.",
                "On this machine the curl happens above the hips, which the seat holds still, and ExRx keeps the hips stationary through it. Lifting or sliding the hips forward lets your legs and hip flexors help drive the pads down, leaving less for your abdominals.",
                "Lifting your hips off the seat or sliding forward to drive the pads down.",
                "Sit back on the seat with your hips planted and keep them there; only your trunk bends."),
       "feet": ("Foot Roller",
                "Your feet rest under the roller; they don't pull on it.",
                "In a 42-person study of a seated crunch machine used with the feet behind ankle rollers, the rectus femoris worked at 65% of its maximum against 27% in a ball crunch, and the authors pointed to the bent hips and the fixed feet. In a sit-up study, bent and supported legs raised hip flexor activity without generally changing the abdominals'.",
                "Pulling your feet up hard against the roller to help the curl.",
                "Tuck your feet under the roller with your heels on the floor and leave them relaxed there."),
       "tempo": ("Tempo",
                 "Let the weight back as slowly as you curled.",
                 "In a curl-up study, abdominal activity did not differ between curling up and lowering back down, so the return is half of every rep. Letting the stack pull you back upright hands that half to gravity.",
                 "Letting the weight snap you back upright between reps.",
                 "Curl down over about a second and a half, pause, then take about as long to sit back up with the stack under control."),
   },
   # Paint: rectus abdominis bright; obliques dim. Sundstrup 2012 (seated
   # crunch machine, 10RM): rectus abdominis 84%, external obliques 71-79% of
   # MVIC EMG. Rectus Abdominis 0.84 PRIMARY from it; the obliques, dim in
   # the paint, stay SECONDARY at 0.62 MODERATE, under the rectus abdominis
   # as Sundstrup's values are, a judgement call (nEMG is not the app's
   # fraction). The rectus femoris (65% there) is not painted, so the hip
   # flexors are named with the stabilisers; the three arm stabilisers come
   # from ExRx's arm-pad seated crunch (its chest-pad version lists none),
   # for the arms holding the handles, a judgement call.
   activation=[("Rectus Abdominis", P, HI, 0.84), ("Obliques", S, MOD, 0.62)],
   stabilisers=["hip flexors", "latissimus dorsi", "triceps long head", "posterior deltoid"],
   comparison=("PULLING WITH THE ARMS", "Chest pushes the pads", "Arms haul the handles",
               "With your chest on the pads, curling the trunk turns the lever, so the abdominals lift the weight.",
               "Hauling the handles down turns the lever with your arms, and less of the weight is left for the abdominals."),
   glows=[lit(N, 0.653, 0.47, 0.06, 0.045), lit(N, 0.70, 0.475, 0.035, 0.04, SOFT, 0.30)])

SETUP[N] = [
    "Set the seat height so the chest pads sit across your upper chest.",
    "Sit tall with your back close to the back pad and your feet tucked under the roller, heels down.",
    "Hold the handles in front of your shoulders at about head height, palms facing in, elbows bent.",
    "Pick a weight you can curl for every rep without your hips lifting off the seat.",
]

# ---------------------------------------------------------------- Ab Coaster Crunch

N = "Ab Coaster Crunch"
ex(name=N, var="abCoasterCrunch",
   # Side-on from the front left (yaw -1.35): the lifter kneels facing
   # screen-left with the hands on the handlebar at the left (u ~0.20), the
   # carriage and curved rails below (v ~0.55-0.75), the feet hanging off to
   # the right. Free space: the whole top band (v < 0.25), the right side
   # above the feet (u > 0.70) and below the base. The arms label sits top
   # left to the near hand; the tempo label top right to the lower back; the
   # curl label right of the hips; the return label right of the feet; the
   # range label bottom left, its leader up past the rails to the near knee.
   overrides={"arms": (ov(0.20), "leading"), "tempo": (ov(0.16), "trailing"), "curl": (ov(0.40), "trailing"),
              "return": (ov(0.66), "trailing"), "range": (ov(0.80), "leading")},
   annotations=[
       ("curl", "Pelvis under", "pelvis"),
       ("arms", "Arms long", "hand_L"),
       ("range", "Knees up the track", "patella_L"),
       ("return", "Back to start", "toe_L"),
       ("tempo", "Steady pace", "spine"),
   ],
   cues={
       "curl": ("Pelvic Curl",
                "Your knees come up because your pelvis rolls under and your lower back rounds.",
                "Swinging the knees forward with a flat lower back is hip flexion, the hip flexors' job; the abdominals curl the spine. ExRx's write-up for the machine asks for a deliberate C shape at the waist, and in a small study of abdominal exercises and gadgets the ab coaster drew much more rectus femoris, a hip flexor, than a floor crunch did.",
                "Swinging your knees forward while your lower back stays flat or arched.",
                "As the carriage rolls, tuck your tailbone under and round your lower back so your knees climb toward your chest."),
       "arms": ("Arm Position",
                "Your arms hold the bar long, the elbows only softly bent.",
                "ExRx lists the lats, rear shoulders and long head of the triceps as stabilisers on this machine: they hold your upper body steady while your trunk works. Pulling with the arms is on one coaching guide's list of common mistakes for the machine, and it drags the carriage with your upper body.",
                "Bending your elbows and pulling your chest toward the bar.",
                "Hold the bar with your palms down and your elbows only softly bent, and keep your shoulders over the same spot."),
       "range": ("Range of Motion",
                 "Roll your knees as far up the track as the curl allows.",
                 "ExRx's version slides forward and up by pulling the knees up high. Your lower back keeps rounding all the way up the track, so turning back early cuts the curl short.",
                 "Turning back with the carriage only partway up the curve.",
                 "Keep rolling until your knees are under your shoulders and your lower back is fully rounded, hold for a moment, then roll back."),
       "return": ("Bottom Position",
                  "Roll all the way back until your thighs are nearly upright again.",
                  "A coaching guide for the machine asks for a full return at the bottom, without arching the back, before each curl. Turning around in the middle of the track trims every rep and lets momentum start the next one.",
                  "Turning around halfway back and bouncing straight into the next rep.",
                  "Let the carriage roll back until your thighs are almost upright and your back is long, not arched, then start the next curl."),
       "tempo": ("Tempo",
                 "Roll up and back at an even pace.",
                 "One coaching guide lists using momentum and moving too fast among the common mistakes on this machine. The carriage rolls freely along the rails, so a quick drop can swing you into the next rep with less work from your abdominals.",
                 "Throwing the carriage up and letting it crash back down.",
                 "Take about a second and a half to roll up, hold briefly, then take about as long to roll back."),
   },
   # Paint: rectus abdominis bright; obliques, posterior deltoid, triceps and
   # hip flexors (Sartorius mesh) dim. Stenger 2013: rectus abdominis about
   # the floor crunch's level (not different), external obliques and rectus
   # femoris significantly higher. Rectus Abdominis 0.80 (the library's
   # Crunch); Obliques 0.64 (the crunch's 0.45 raised for Stenger's higher
   # external oblique bar; the library's Hanging Knee Raise uses 0.64, and
   # Stenger's captain's chair crunch had a similar bar); Hip Flexors 0.50
   # (much higher than in a crunch in Stenger, but dim in the paint and the
   # model's hip angle opens as the pelvis curls); Triceps Brachii 0.25 LOW
   # (holding the arms long on the bar, ExRx stabiliser). All judgement
   # calls; the posterior deltoid goes with the stabilisers (legend width).
   activation=[("Rectus Abdominis", P, HI, 0.80), ("Obliques", S, MOD, 0.64), ("Hip Flexors", S, MOD, 0.50),
               ("Triceps Brachii", S, LOW, 0.25)],
   stabilisers=["posterior deltoid", "latissimus dorsi", "teres major", "pectoralis major"],
   comparison=("SWINGING THE KNEES", "Pelvis rolls under", "Knees swing, back stays flat",
               "Rolling the pelvis under curls the lower spine, which is the abdominals' job.",
               "Swinging the knees forward with a flat back leaves more of the lift to the hip flexors."),
   glows=[lit(N, 0.45, 0.39, 0.08, 0.05), lit(N, 0.53, 0.40, 0.04, 0.035, SOFT, 0.30)])

SETUP[N] = [
    "Stand behind the machine facing the handlebar.",
    "Kneel on the carriage pad with your shins flat on it and your feet hanging off the back end.",
    "Lean forward and hold the handlebar palms down, hands just outside your shoulders, arms long.",
    "Let the carriage settle at the bottom of the track, your thighs almost upright and your back long.",
]
