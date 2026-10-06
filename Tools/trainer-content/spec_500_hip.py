# Trainer content for the 401-500 folder (2026-10-04), family: hip. One
# exercise from the builder's 401-500 set: 376 Dumbbell Hip Thrust
# (Legs/DumbbellHipThrust). Same format as spec.py on top of common_1_50.py;
# spec_500.py imports this module and gen.py reads SPEC / SETUP.
# notes_500_hip.md maps the copy's claims to the sources below and records
# the model facts.
#
# What the model shows, from the brief (SCRATCH/briefs_legs/DumbbellHipThrust
# .md), the trainer stills (SCRATCH/stills/dumbbell-hip-thrust_t*.png),
# tiers30.json, joints.json and the rig, equipment and skinned meshes read
# from the USD with Blender's Python + pxr (SCRATCH/calfseat/rig.py,
# SCRATCH/hip/hang.py, shoes.py; the app's Y-up space, the lifter facing +z,
# their left +x; torso, neck to pelvis, 0.592 m):
# - Upper back across the long side of a low flat bench (pad top 0.36 m, its
#   front edge at the shoulder joints, i.e. near the top of the shoulder
#   blades). A dumbbell (34 cm long, 16 cm heads) lies across the hips, its
#   handle over the hip joints (the hip crease), and both hands hold it by
#   the heads (hands ~0.30 m apart, elbows 85 -> 132 degrees). Feet flat on
#   the floor the whole clip, ankles 0.40 m apart (the shoulder joints are
#   0.39 m apart), toes turned out 8 degrees; at the top the knees sit ~3 cm
#   inside the ankles each side (0.34 m apart).
# - The hips drive up from a trunk-thigh angle of 115 to 169 degrees, the
#   pelvis from 0.205 to 0.462 m; at the top the knees, hips and shoulders
#   are in line (knee-hip-shoulder 179 degrees, the hips 0.5 cm under the
#   line), the trunk level, the shins vertical and the knees at 90 degrees
#   (69 at the bottom). At the bottom the trunk slopes up 30 degrees to the
#   bench and the seat stays ~5-8 cm off the floor (the gluteus maximus
#   mesh's lowest point 7.7 cm up): the hips never rest on the floor. The
#   back rocks on the bench edge, the shoulder joints moving ~6 cm toward the
#   head as the trunk turns over it, a pivot rather than a slide (the
#   shoulder blades stay on the pad). The spine keeps one shape (spine-chest-
#   neck 174 degrees throughout); the chin tucks ~18 degrees toward the
#   chest at the top (chest-neck-head 178 -> 160), so the eyes look along the
#   body rather than at the ceiling. The copy makes no head cue.
# - Timing (pelvis height): two reps in 7.96 s; still at the bottom to
#   0.29 s, up over ~1.0 s (0.33-1.33 s), held at the top ~0.8 s
#   (1.38-2.17 s), down over ~1.3 s (2.21-3.54 s), ~0.7 s at the bottom.
# - Highlight tiers (tiers30.json): GluteusMaximus, GluteusMedius,
#   GluteusMinimus and the four quadriceps bright; BicepsFemoris,
#   Semimembranosus, Semitendinosus and ErectorSpinae dim.
#
# How it differs from the library: the Barbell Hip Thrust is the same lift
# on the same bench and body (pelvis 0.20 -> 0.48 m there, knees 69 -> 90),
# with a padded barbell held either side of the pad; here a single dumbbell
# lies across the hip crease, held at both ends, so the hands sit close
# together over the hips and the load is limited to one dumbbell. The Glute
# Bridge and Single-Leg Glute Bridge start from the floor with the shoulders
# down, so the hips travel a shorter arc; the Frog Pump turns the knees out
# with the soles together. Its paint also differs from the barbell model's
# (there the glutes bright and the hamstrings dim): the quadriceps and all
# three glutes are bright, so the quadriceps are a primary row here (the
# glutes grouped under the gluteus maximus row, as the Glute Bridge). Cue
# set as the barbell's: hips, ribs, feet, bench, and the dumbbell in place
# of the bar.
#
# Sources (abstracts read on Europe PMC 2026-10-04; details in
# notes_500_hip.md):
# - ExRx.net, Barbell Hip Thrust (GluteusMaximus/BBHipThrust, read on the
#   Wayback Machine, snapshot 2025-01-18): upper back on the long side of
#   the bench, feet about shoulder width, knees bent; raise by extending
#   the hips until straight; a 40-46 cm bench (the model's is 36 cm), which
#   may need securing; find a comfortable contact hinge position on the
#   bench and avoid sliding; keep the bar from rolling back near the top
#   with the hands; movement through the hips with the torso rigid; avoid
#   chest arching and anterior pelvic tilt, both producing spinal
#   hyperextension. Target gluteus maximus; synergist quadriceps; dynamic
#   stabiliser hamstrings; stabiliser erector spinae.
# - StrengthLog, Hip Thrust (strengthlog.com/hip-thrust, read 2026-10-04):
#   back against a sturdy bench, feet about shoulder width, knees bent;
#   extend the hips; the knees at about 90 degrees at the top. Primary
#   glutes; secondary adductors and quadriceps.
# - Fitness Volt, Dumbbell Hip Thrust (V Vukas, 17 Oct 2023, updated 11 Aug
#   2024, fitnessvolt.com/dumbbell-hip-thrust-guide, read 2026-10-04): the
#   dumbbell horizontally in the hip crease, held at each end so it stays in
#   place; shoulder blades against the bench edge; feet shoulder-width, toes
#   turned out slightly; knees to head in a straight line at the top.
# - Contreras B, Vigotsky AD, Schoenfeld BJ, Beardsley C, Cronin J 2015,
#   J Appl Biomech 31(6):452-458, doi:10.1123/jab.2014-0301, PMID 26214739 -
#   13 trained women, estimated 10RM: barbell hip thrust vs back squat, mean
#   upper gluteus maximus 69.5 vs 29.4 %MVIC, lower 86.8 vs 45.4, biceps
#   femoris 40.8 vs 14.9; vastus lateralis 99.5 vs 110 (not different).
# - Collazo Garcia CL, Rueda J, Suarez Luginick B, Navarro E 2020, J Strength
#   Cond Res 34(9):2449-2455, doi:10.1519/JSC.0000000000002859, PMID
#   30335717 - 7 trainers, 40% 1RM, four foot and force variations: EMG
#   differed in every muscle but the gluteus medius.
# - Neto WK, Vieira TL, Gama EF 2019, J Sports Sci Med 18(2):198-206, PMID
#   31191088 (PMC6544005, full text read) - systematic review of the barbell
#   hip thrust: knee flexion near 90 degrees leaves the hamstrings
#   insufficient, so the gluteus maximus works harder (citing a prone
#   hip-extension study, Kwon and Lee 2013); gluteus medius mean EMG ~45%
#   MVIC (Collazo Garcia's, the only gluteus medius data in its table); vastus
#   lateralis 35-100% MVIC across studies; feet further out raise the
#   biceps femoris and semitendinosus and lower the quadriceps without
#   changing the gluteus maximus (Collazo Garcia).
# - Delgado J, Drinkwater EJ, Banyard HG, Haff GG, Nosaka K 2019, J Strength
#   Cond Res 33(10):2595-2601, doi:10.1519/JSC.0000000000003290, PMID
#   31356511 - 8 trained men: at 1RM the hip thrust gave more gluteus maximus
#   activity than the back squat, and the squat more vastus lateralis than
#   the hip thrust.
# - Brazil A, Needham L, Palmer JL, Bezodis IN 2021, PLoS One
#   16(3):e0249307, doi:10.1371/journal.pone.0249307, PMID 33780488 - 19
#   trained men, 70% 1RM: extensor demand far greater at the hip than at the
#   knee or the pelvis and trunk; the hip extensor moment falls through the
#   lift rather than staying constant.
# - Plotkin DL, Rodas MA, Vigotsky AD et al. 2023, Front Physiol
#   14:1279170, doi:10.3389/fphys.2023.1279170, PMID 37877099 - untrained
#   college-aged adults, 9 weeks of hip thrust or back squat training:
#   similar gluteal growth, more quadriceps growth after squats; more gluteal
#   EMG in the hip thrust did not consistently predict more growth (so the
#   copy makes no growth claim).
from common_1_50 import *


def ov(final):
    """Pre-squeeze override row for an on-screen row (spec_500.row() maps
    0.14-0.86 to 0.16-0.80)."""
    return round(0.14 + (final - 0.16) * (0.86 - 0.14) / (0.80 - 0.16), 4)


N = "Dumbbell Hip Thrust"
ex(name=N, var="dumbbellHipThrust",
   # Framed three-quarter from the feet on the lifter's left (yaw -0.7), as
   # the Barbell Hip Thrust: the body lies in a band across the middle
   # (v 0.37-0.62), so the labels sit above it (ribs and dumbbell on the top
   # row, hips below them) and below the feet (feet and bench), never over
   # the shoes. The ribs cue tracks the right abdominal pec anchor, the
   # dumbbell cue the left hand; their leaders drop side by side to the
   # middle of the body without crossing.
   overrides={"ribs": (ov(0.16), "leading"), "dumbbell": (ov(0.16), "trailing"), "hips": (ov(0.27), "leading"),
              "feet": (ov(0.80), "leading"), "bench": (ov(0.80), "trailing")},
   annotations=[
       ("hips", "Hips up to a level torso", "pelvis"),
       ("ribs", "Ribs down, spine neutral", "support_PectoralisMajor_Abdominal_R"),
       ("feet", "Shins vertical at the top", "foot_L"),
       ("bench", "Back pivots on the bench", "scapula_L"),
       ("dumbbell", "Dumbbell in the hip crease", "hand_L"),
   ],
   cues={
       "hips": ("Hip Extension",
                "The hips rise until the torso is level with the floor.",
                "The gluteus maximus is the main hip extensor in this lift, and a rep ends only when the hips are straight; stopping short leaves out the end of the range, where the glutes are at their shortest.",
                "Stopping short of lockout, the hips hanging below the line of the knees and shoulders.",
                "Drive through the whole foot until your knees, hips and shoulders line up, hold for about a second, then lower under control."),
       "ribs": ("Spine Position",
                "The height comes from the hips, not the lower back.",
                "With the ribs down and the trunk braced, the hips lift the dumbbell. Arching the lower back or tipping the pelvis forward adds height through the spine instead of the hips.",
                "Flaring the ribs and arching the lower back at the top, so the lower back bows up above the line of the hips and shoulders.",
                "Brace before each rep, keep your ribs down and your trunk rigid, and stop when the torso is level."),
       "feet": ("Foot Position",
                "Set the feet so the shins are vertical at the top.",
                "With the knees near 90 degrees at the top the hamstrings are shortened at the knee and help less, so the glutes take more of the hip extension; in one small study, moving the feet further out raised hamstring activity and lowered quadriceps activity with no gain in glute activity.",
                "Setting the feet too far out, so the shins slope away and the knees open well past 90 degrees at the top.",
                "Plant your feet flat about shoulder-width apart, toes turned out a little, close enough that your shins stand vertical at the top."),
       "bench": ("Bench Contact",
                 "The upper back pivots on the edge of the bench.",
                 "Hinging on one spot lets the hips rise around a fixed point; sliding along the bench moves the hips away from the feet and changes the knee angle mid-rep.",
                 "Sliding the back up the bench as the hips rise, until the edge sits near the bottom of the shoulder blades.",
                 "Rest your upper back across the bench edge near the top of your shoulder blades and let the torso rock over that spot without sliding."),
       "dumbbell": ("Dumbbell Position",
                    "The dumbbell lies across the hip crease, held at both ends.",
                    "Across the hip crease the dumbbell loads hip extension directly. Holding it by both heads keeps it there, instead of letting it roll toward the stomach as the hips rise and the trunk levels out.",
                    "Letting the dumbbell roll off the hip crease and up onto the stomach near the top.",
                    "Lay the dumbbell across the crease of your hips, hold one head in each hand and keep it in place from the first rep to the last."),
   },
   # Activation follows the paint: the glutes and quadriceps bright
   # (PRIMARY), the hamstrings and erector spinae dim (SECONDARY). The three
   # glutes are grouped as the library's Glute Bridge groups the same bright
   # set: the gluteus maximus row stands for them, the gluteus medius and
   # minimus named with the stabilisers (a third primary row also truncated
   # the one-line legend on the simulator). Gluteus maximus 0.90 as the
   # library's Barbell Hip Thrust (the target in every source; Contreras
   # 2015). Quadriceps 0.55, a judgement call: Contreras 2015 measured the
   # vastus lateralis near the back squat at 10RM (99.5 vs 110 %MVIC), but
   # Delgado 2019 found it lower than the squat at 1RM, Neto 2019 summarises
   # 35-100% MVIC across studies, and Plotkin 2023 saw more quadriceps growth
   # after squats than after hip thrusts; ExRx and StrengthLog list the
   # quadriceps as a synergist or secondary. Above the barbell lift's 0.40
   # (where they were not painted), below the Glute Bridge's paint-led 0.66.
   # Hamstrings and erector spinae 0.45 as the barbell lift (the same
   # motion; Contreras 2015's biceps femoris 40.8% MVIC). The erector spinae
   # value is the library's and the paint's (dim), not the EMG's: the only
   # erector spinae data in Neto 2019's table (Andersen 2018, barbell hip
   # thrust) are ~83-93% MVIC, so 0.45 may understate it; it is kept at the
   # barbell lift's value since the motion is the same, and the copy makes
   # no claim about it.
   activation=[("Gluteus Maximus", P, HI, 0.90), ("Quadriceps", P, MOD, 0.55),
               ("Hamstrings", S, MOD, 0.45), ("Erector Spinae", S, MOD, 0.45)],
   stabilisers=["gluteus medius", "gluteus minimus", "adductors", "core"],
   comparison=("HIPS STOPPING SHORT", "Knees, hips and shoulders in line", "Hips hang below the line",
               "Finishing with the torso level takes the hips all the way to straight, the end of the range where the glutes are shortest.",
               "Stopping with the hips low cuts off the top of the range, so each rep ends before the glutes finish straightening the hips."),
   # The glutes under the pelvis and hip joints, nudged toward the near
   # (left) side; softer, the near quadriceps along the thigh.
   glows=[glow(N, ["pelvis", "thigh_L", "thigh_R"], A, 0.55, rx=0.11, ry=0.07, dx=0.03, dy=0.03),
          glow(N, ["thigh_L", "patella_L"], SOFT, 0.30, rx=0.07, ry=0.04, dy=-0.01)])

SETUP[N] = [
    "Sit on the floor with your upper back against the long side of a low bench, secured so it cannot slide.",
    "Lay a dumbbell across the crease of your hips and hold it by both heads.",
    "Plant your feet flat about shoulder-width apart, toes turned out a little, close enough that your shins will be vertical at the top.",
    "Lean back so the bench edge sits near the top of your shoulder blades.",
]
