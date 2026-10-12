# Trainer content for the Desktop "300-400" folder (2026-10-12), family:
# thrust. Four hip thrusts from the builder's 377-380: Smith Machine Hip
# Thrust (377, Legs/SmithMachineHipThrust), Machine Hip Thrust (378,
# Legs/MachineHipThrust), Single-Leg Hip Thrust (379, Legs/SingleLegHipThrust)
# and B-Stance Hip Thrust (380, Legs/BStanceHipThrust). Same format as spec.py
# on top of common_1_50.py; spec_1012.py imports this module and gen.py reads
# SPEC / SETUP. notes_1012_thrust.md maps the copy's claims to the sources
# below and records the model facts.
#
# What the models show, measured from the rigs with Blender's Python + pxr
# ($LAB/r1012/thrust/: measure.py every frame, joints and angles; skin.py,
# mesh.py, load.py, gap.py on the skinned meshes: seat height, shoe soles,
# back on the bench, the load against the hips; edge.py, the bench edge in
# the chest's frame; proj.py, the equipment on screen; ghost.py, a port of
# FaultGhost.solve), the motion briefs (Tools/trainer-content/briefs_1012),
# tiers.txt, joints.json and the trainer stills at 0/1/2/3/5 s. The app's
# frame: Y up, the lifter faces +z, their left is +x. Every clip is 7.96 s
# at 24 fps, two identical 4 s reps, framed three-quarter from the feet on
# the lifter's left (yaw -0.7). One body (neck to pelvis 0.592 m, thigh
# 0.444 m, shin 0.398 m, shoulder joints 0.40 m apart).
# - All four share one trunk motion (the new Dumbbell Hip Thrust's too): the
#   trunk slopes up 44 degrees to the bench at the bottom and lies level at
#   the top (shoulder line -0.6 degrees), the spine keeps one shape
#   (spine-chest-neck 172/174 degrees all clip) and the chin tucks ~16
#   degrees at the top (chest-neck-head 176 -> 160), eyes along the body. The
#   upper back lies across the edge of a flat pad 41 cm high (the machine's
#   50 cm), the edge under the lower tips of the shoulder blades: in the
#   chest joint's frame it sits 11-12.5 cm up the spine, where the teres
#   major and infraspinatus meshes (the blades' lower ends) start at 12-14
#   cm. It moves only ~2 cm along the back over the rep while the shoulder
#   joints swing 13 cm toward the head: a pivot, not a slide. At the top the
#   knees, hips and shoulders are close to one line seen side-on (169.5-175
#   degrees, the hip joints 2-4 cm above the knee-shoulder line), the shins
#   within 4 degrees of vertical.
# - Smith Machine Hip Thrust: an M30 Smith rack; the bar (a 50 cm pad, 13 cm
#   thick, round its middle; two plates a side) runs straight up and down
#   its rails (z fixed) 23 cm, from 0.49 to 0.72 m. The pad rests on the top
#   of the thighs ~6-10 cm from the hip joints at the bottom and on the hip
#   crease at the top (its axis 4 cm toward the knees from the hip joints),
#   in contact all rep (gaps under 3 mm). Hands on the bar 62 cm apart, 6 cm
#   outside the pad, 9.2 cm from the bar's axis all rep, elbows 97 -> 155
#   degrees. Safety stops 7 cm under the carriages' lowest point (never
#   touched). Feet flat (soles at 1 mm) 40 cm apart at the ankles, toes out
#   8 degrees; knees 75 -> 100 degrees, ~3-6 cm inside the ankles each side.
#   Hips (trunk-thigh) 101 -> 168 (170 at 1.5 s), pelvis 0.20 -> 0.52 m; the
#   seat 8 cm off the floor at the bottom. Timing: still at the bottom to
#   0.42 s, up 0.46-1.54 s, held 1.58-2.25 s (~0.7 s), down 2.29-3.54 s, at
#   the bottom 3.58-4.42 s (~0.8 s).
# - Machine Hip Thrust: a plate-loaded lever machine: a fixed back pad (top
#   0.50 m, edge as above), a low seat (top 16 cm) under the hips, a
#   footplate rising toward the toes (the soles 6 cm up at the heels, 11 cm
#   at the toes), and a lever pivoting behind the back pad whose arms carry a
#   padded roller (60 cm long, 13 cm thick) across the hip crease, two
#   handles beside the hips and a 20 kg plate on a horn at the lifter's right.
#   The same body motion lifted 9 cm (pelvis 0.29 -> 0.61 m, trunk-thigh 104
#   -> 165, 170 at 1.5 s); knees 76 -> 105, feet as the Smith's on the
#   plate. The roller stays on the hip crease all rep (axis 2.5-4.5 cm toward
#   the knees from the hip joints, gaps under 3 mm) and rises 26 cm on its
#   arc. Hands on the handles (72 cm apart), elbows 58 -> 100. At the bottom
#   the seat just touches the seat pad (0-4 mm) for ~0.8 s. Timing as the
#   Smith's.
# - Single-Leg Hip Thrust: no load; arms spread along the bench top, hands
#   resting on the pad 1.08 m apart, still all clip (elbows 95 -> 81). Only
#   the LEFT leg works: its foot flat (the ankle 15 cm left of centre, toes
#   out 3 degrees), knee 73 -> 97.5, the knee within 2 cm of over the ankle
#   side to side, hip 99 -> 172 (173 at 2.25 s); pelvis 0.20 -> 0.52 m. The
#   RIGHT leg is held off the floor, unchanged all clip: the knee bent 75
#   degrees and the thigh drawn up 75 degrees from the trunk line, so at the
#   top it points straight up (15 degrees past vertical toward the head) with
#   the shin level, the foot 86 cm off the floor (22 cm at the bottom). The
#   pelvis stays level (hip joints at equal height to the millimetre) and
#   square all clip. Timing: still to 0.29 s, up 0.33-1.33 s, held
#   1.38-2.17 s (~0.8 s), down 2.21-3.54 s, at the bottom 3.58-4.29 s.
# - B-Stance Hip Thrust: a dumbbell (34 cm, 16 cm heads) across the hips,
#   centred and held by both heads (hands 29 cm apart, elbows 71 -> 149), its
#   heads resting on the hips (vertex gaps under 1 cm), the handle 3-5 cm
#   toward the knees from the hip joints; it rises 21.5 cm. The LEFT foot
#   flat under the knee (knee 75 -> 100, shin vertical at the top) works; the
#   RIGHT foot is 18 cm further forward (its heel about level with the ball
#   of the left foot), resting on its heel with the toes up all clip (the
#   heel at 1 mm, the toe end 7 cm up), its knee 109 -> 137. Hips 101 -> 168
#   (left), pelvis 0.20 -> 0.52 m, level and square all clip. Timing as the
#   single-leg's.
# - Paint (tiers.txt): GluteusMaximus, GluteusMedius, GluteusMinimus and the
#   four quadriceps bright on all four (the single-leg's Sartorius too, both
#   sides: the library's "Hip Flexors"); BicepsFemoris, Semimembranosus,
#   Semitendinosus and ErectorSpinae dim.
#
# How they differ from the library: the Barbell and Dumbbell Hip Thrusts are
# the same lift on the same bench; the Smith's bar cannot roll, as a free bar
# can, and runs in a fixed vertical track, so where it meets the hips is set
# by where the lifter sits; the machine's roller rides a lever arc and the
# lifter holds handles, with a seat and an angled footplate; the Single-Leg
# Glute Bridge works one leg from the floor with the shoulders down, a
# shorter arc; the B-stance keeps both feet down with the front one on its
# heel. Cue sets: the barbell family's hips, ribs, feet, bench and load for
# the Smith and the machine; hips, pelvis level, free leg, foot and ribs for
# the single-leg; hips, kickstand foot, working foot, pelvis level and
# dumbbell for the B-stance.
#
# Sources (opened 2026-10-12; abstracts on Europe PMC's REST API, full texts
# where noted; details and quotes in notes_1012_thrust.md):
# - ExRx.net, Barbell Hip Thrust (WeightExercises/GluteusMaximus/BBHipThrust,
#   Wayback id_ snapshot 2026-04-03): upper back on the corner of the bench,
#   feet about shoulder width, knees bent; grasp the bar to each side; raise
#   by extending the hips until straight; a 16-18 in (40-46 cm) bench; bar
#   across the upper hip flexors and lower abdomen, thick padding; find a
#   comfortable contact hinge position on the bench and avoid sliding; keep
#   the bar from rolling back near the top with the hands; movement through
#   the hip with the torso rigid; avoid chest arching and anterior pelvic
#   tilt, both producing spinal hyperextension. Target gluteus maximus;
#   synergists quadriceps; dynamic stabilisers hamstrings; stabilisers
#   erector spinae.
# - StrengthLog, Hip Thrust (strengthlog.com/hip-thrust): back against a
#   sturdy bench, feet about shoulder-width, knees about 90 degrees at the
#   top, hands on the bar to stabilise it, padding between bar and pelvis;
#   glutes primary, adductors and quads secondary; one or two legs.
# - StrengthLog, One-Legged Hip Thrust (strengthlog.com/one-legged-hip-
#   thrust): one foot on the floor, lift the other leg, push the hips up with
#   the glute of the leg on the floor, ~90 degrees at the working knee at the
#   top; glutes primary, adductors, abductors and quads secondary.
# - R Borchert, Grow Your Glutes with the Smith Machine Hip Thrust, REP
#   Fitness, 30 Jul 2025, updated 3 Aug 2026 (repfitness.com/blogs/guides/
#   smith-machine-hip-thrust): a barbell fixed to a vertical path; adjustable
#   safety stops keep the bar from dropping too low; bench parallel to the
#   bar; a pad round the bar; the bar over the upper thighs, just below the
#   hips; hands on the bar for guidance; the whole foot on the floor; knees
#   about 90 degrees and a neutral spine at the top; feet too far away and
#   the hamstrings take more of the work.
# - P Dale, B Stance Hip Thrusts, Fitness Volt, 19 Oct 2022, updated 11 Aug
#   2024 (fitnessvolt.com/b-stance-hip-thrusts): move one leg forward, pull
#   the toes up so you rest on the heel; the kickstand or helper leg, not the
#   main focus; drive the supporting foot into the floor through the heel;
#   the further the kickstand from the supporting leg, the harder the lift.
# - V Vukas, Dumbbell Hip Thrust, Fitness Volt, 17 Oct 2023, updated 11 Aug
#   2024 (fitnessvolt.com/dumbbell-hip-thrust-guide): the dumbbell
#   horizontally in the hip crease, held at each end so it stays in place;
#   knees to head in a straight line at the top; pause at the top.
# - Physitrack, single leg hip thrust (physitrack.com/exercise-library/how-
#   to-perform-the-single-leg-hip-thrust-exercise): lift one leg, keeping the
#   pelvis level; a straight line from the shoulders to the hip and knees;
#   its FAQ names the glutes, hamstrings and hip flexors as the muscles it
#   mainly works (core, quads and lower back less).
# - Contreras B, Vigotsky AD, Schoenfeld BJ, Beardsley C, Cronin J 2015,
#   J Appl Biomech 31(6):452-458, doi:10.1123/jab.2014-0301, PMID 26214739:
#   13 trained women, estimated 10RM, barbell hip thrust vs back squat: mean
#   upper gluteus maximus 69.5 vs 29.4 %MVIC, lower 86.8 vs 45.4, biceps
#   femoris 40.8 vs 14.9; vastus lateralis 99.5 vs 110 (no difference).
# - Delgado J, Drinkwater EJ, Banyard HG, Haff GG, Nosaka K 2019, J Strength
#   Cond Res 33(10):2595-2601, doi:10.1519/JSC.0000000000003290, PMID
#   31356511: 8 men; at 1RM more gluteus maximus in the hip thrust than the
#   squat, more vastus lateralis in the squat than the hip thrust.
# - Andersen V, Fimland MS, Mo DA et al. 2018, J Strength Cond Res
#   32(3):587-593, doi:10.1519/JSC.0000000000001826, PMID 28151780: 13
#   trained men at 1RM; the hip thrust gave the highest gluteus maximus
#   activation of the three lifts, the barbell deadlift more biceps femoris,
#   erector spinae no different.
# - Kennedy D, Casebolt JB, Farren GL et al. 2024, Sports Biomech
#   23(12):2935-2949, doi:10.1080/14763141.2022.2074875, PMID 35586943: 10
#   men; the barbell hip thrust gave more vastus lateralis activity than the
#   barbell glute bridge (and less gluteus maximus).
# - Collazo Garcia CL, Rueda J, Suarez Luginick B, Navarro E 2020, J Strength
#   Cond Res 34(9):2449-2455, doi:10.1519/JSC.0000000000002859, PMID
#   30335717: 7 personal trainers, 40% 1RM, feet moved away from the body
#   and two force directions; EMG differed in every muscle but the gluteus
#   medius.
# - Neto WK, Vieira TL, Gama EF 2019, J Sports Sci Med 18(2):198-206, PMID
#   31191088, PMC6544005 (full text): knee flexion near 90 degrees leaves the
#   hamstrings insufficient, so the gluteus maximus works harder (citing
#   Kwon and Lee 2013); feet placed forward raise hamstring and lower
#   quadriceps activity (Collazo Garcia); vastus lateralis 35-100% MVIC
#   across studies; gluteus medius ~45% MVIC; erector spinae ~85% MVIC (the
#   table's Andersen 2018 values 93/83%).
# - Brazil A, Needham L, Palmer JL, Bezodis IN 2021, PLoS One
#   16(3):e0249307, doi:10.1371/journal.pone.0249307, PMID 33780488: 19
#   trained men, 70% 1RM; extensor demand far greater at the hip than at the
#   knee or the pelvis-trunk joint.
# - Lehecka BJ, Edwards M, Haverkamp R et al. 2017, Int J Sports Phys Ther
#   12(4):543-549, PMID 28900560, PMC5534144 (full text): 26 analysed,
#   single-leg bridges (shoulders on the floor, arms folded): with the
#   working knee at 90 degrees, gluteus maximus 51 and gluteus medius 58
#   %MVIC with the free leg straight; with the free knee relaxed in flexion
#   and the thigh held vertical, 47 and 55 (no significant change) while the
#   free leg's rectus femoris fell from 20 to 7 %MVIC; the working leg's
#   rectus femoris 5-8 %MVIC.
# - Sorensen B, Aagaard P, Malchow-Moller L et al. 2021, Int J Sports Phys
#   Ther 16(3):704-714, doi:10.26603/001c.24150, PMID 34123523, PMC8168984
#   (full text): 21 female handball players; hamstring activity in the
#   single-leg barbell hip thrust (half the two-leg load) 67% of max vs 50%
#   in the two-leg thrust with the knees at 90 degrees; in the single-leg
#   thrust a stable, non-tilting pelvis needs hip and core stability.
# - Collings TJ, Bourne MN, Barrett RS et al. 2023, Med Sci Sports Exerc
#   55(4):650-660, doi:10.1249/MSS.0000000000003091, PMID 36918403: 14
#   female footballers, EMG-informed modelling: the single-leg hip thrust
#   with a 12RM load was among the top tier of eight hip exercises for
#   gluteus maximus force.
from common_1_50 import *


def ov(final):
    """Pre-squeeze override row for an on-screen row (spec_1012.row() maps
    0.14-0.86 to 0.16-0.80)."""
    return round(0.14 + (final - 0.16) * (0.86 - 0.14) / (0.80 - 0.16), 4)


# The four share the library's barbell / dumbbell activation (same paint,
# same motion): Gluteus Maximus 0.90 (the target in every source; Contreras
# 2015, Andersen 2018, Delgado 2019); Quadriceps PRIMARY 0.55 as on the
# Dumbbell Hip Thrust (painted bright; a judgement call between Contreras
# 2015's vastus lateralis near the squat at 10RM and Delgado 2019's below it
# at 1RM, Neto 2019's 35-100% MVIC range and Kennedy 2024's more than the
# glute bridge); Hamstrings and Erector Spinae SECONDARY 0.45 (dim; Contreras
# 2015's biceps femoris 40.8% MVIC; the erector value is the library's and
# the paint's, not the EMG's, which Neto 2019 puts near 85% MVIC). The three
# glutes are lit as one group: the gluteus maximus row stands for them, the
# medius and minimus named with the stabilisers.
GMAX, QUADS = ("Gluteus Maximus", P, HI, 0.90), ("Quadriceps", P, MOD, 0.55)
HAMS, ERECTORS = ("Hamstrings", S, MOD, 0.45), ("Erector Spinae", S, MOD, 0.45)

HIPS_WHY = ("The gluteus maximus is the main hip extensor in this lift, and a rep ends only when the hips are straight; "
            "stopping short leaves out the end of the range, where the glutes are at their shortest.")
RIBS = ("Spine Position",
        "The height comes from the hips, not the lower back.",
        "With the ribs down and the trunk braced, the hips do the lifting. Arching the lower back or tipping the pelvis forward adds height through the spine instead of the hips.",
        "Flaring the ribs and arching the lower back at the top, so the lower back bows up above the line of the hips and shoulders.",
        "Brace before each rep, keep your ribs down and your trunk rigid, and stop when the torso is level.")
FEET_WHY = ("With the knees bent close to a right angle at the top, the hamstrings are shortened at the knee and can help less, "
            "so the glutes take more of the hip extension; feet set further out hand more of it to the hamstrings.")
PIVOT_WHY = ("Hinging on one spot lets the hips rise around a fixed point; sliding moves the hips away from the feet "
             "and changes the knee angle mid-rep.")
HIPS_COMPARISON = ("HIPS STOPPING SHORT", "Knees, hips and shoulders in line", "Hips hang below the line",
                   "Finishing with the torso level takes the hips all the way to straight, the end of the range where the glutes are shortest.",
                   "Stopping with the hips low cuts off the top of the range, so each rep ends before the glutes finish straightening the hips.")


def glute_glows(n, dx=0.03, dy=0.03, knee="patella_L"):
    """The glutes under the pelvis and hip joints, nudged toward the near
    (left) side; softer, the near quadriceps along the thigh."""
    return [glow(n, ["pelvis", "thigh_L", "thigh_R"], A, 0.55, rx=0.11, ry=0.07, dx=dx, dy=dy),
            glow(n, ["thigh_L", knee], SOFT, 0.30, rx=0.07, ry=0.04, dy=-0.01)]


# ---------------------------------------------------------------- Smith Machine Hip Thrust
N = "Smith Machine Hip Thrust"
ex(name=N, var="smithMachineHipThrust",
   # The body lies in a band across the middle (v ~0.35-0.64) with the
   # rack's uprights behind; the bar's plates sweep v 0.29-0.52 at the left
   # edge and 0.23-0.53 at the right. The mistake view lifts the model 0.09
   # of the view and shrinks it (roomBelow 0.26) while the labels stay put,
   # which brings the left plate's top up to v ~0.21, so the left pills sit
   # at 0.12 (ribs) and 0.18 (hips, a short label so the ribs leader clears
   # its end by ~25 pt), the bar on the right at 0.16 (in the mistake view
   # its right end touches the right plate's rim) and feet and bench at
   # 0.74, just below the shoes. Leaders as on the barbell layout.
   overrides={"ribs": (ov(0.12), "leading"), "bar": (ov(0.16), "trailing"), "hips": (ov(0.18), "leading"),
              "feet": (ov(0.74), "leading"), "bench": (ov(0.74), "trailing")},
   annotations=[
       ("hips", "Hips up, torso level", "pelvis"),
       ("ribs", "Ribs down, spine neutral", "support_PectoralisMajor_Abdominal_R"),
       ("feet", "Shins vertical at the top", "foot_L"),
       ("bench", "Back pivots on the bench", "scapula_L"),
       ("bar", "Pad on the hip crease", "hand_L"),
   ],
   cues={
       "hips": ("Hip Extension",
                "The hips rise until the torso is level with the floor.",
                HIPS_WHY,
                "Stopping short of lockout, the hips hanging below the line of the knees and shoulders.",
                "Drive through your whole foot until your knees, hips and shoulders line up, pause for a moment, then lower until your seat is just off the floor."),
       "ribs": RIBS,
       "feet": ("Foot Position",
                "Set the feet so the shins are vertical at the top.",
                FEET_WHY,
                "Setting the feet too far out, so the shins slope away and the knees open well past a right angle at the top.",
                "Plant your feet flat about shoulder-width apart, toes turned out a little, close enough that your shins stand about vertical at the top."),
       "bench": ("Bench Contact",
                 "The upper back pivots on the edge of the bench.",
                 PIVOT_WHY,
                 "Sliding the back up the bench as the hips rise, until the edge sits under the middle of the back.",
                 "Rest your upper back across the bench edge under the lower tips of your shoulder blades and let your torso rock over that spot without sliding."),
       "bar": ("Bar Position",
               "The padded bar runs straight up and down its track and sits across the hip crease at the top.",
               "A Smith bar runs in a fixed track and cannot roll along your body, so where it meets you is set by where you sit. Over the hip crease it loads hip extension directly and the thick pad spreads the pressure on the pelvis; the hands only steady it.",
               "Setting the bench too close to the bar, so at the top the pad presses into the stomach instead of the hips.",
               "Sit so the pad starts on the tops of your thighs just below the hip crease and settles onto the crease as you rise; hold the bar just outside the pad."),
   },
   activation=[GMAX, QUADS, HAMS, ERECTORS],
   stabilisers=["gluteus medius", "gluteus minimus", "adductors", "core"],
   comparison=HIPS_COMPARISON,
   glows=glute_glows(N))

SETUP[N] = [
    "Set a flat bench about 40 cm high lengthwise behind the Smith bar, far enough back that the bar will sit over your hips.",
    "Wrap the middle of the bar in a thick pad and set the safety stops just below the bar's lowest point.",
    "Sit on the floor with your back to the bench and slide under the bar until the pad rests on the tops of your thighs, just below the hip crease.",
    "Plant your feet flat about shoulder-width apart, toes turned out a little, and rest your upper back on the bench edge under your shoulder blades.",
    "Hold the bar just outside the pad and turn it off its hooks.",
]

# ---------------------------------------------------------------- Machine Hip Thrust
N = "Machine Hip Thrust"
ex(name=N, var="machineHipThrust",
   # The body across the middle (v ~0.36-0.64); the lever's plate sweeps the
   # left edge from v 0.59 up to 0.24 (0.17 in the mistake view) and its arm
   # and roller the middle (v 0.33-0.48). One pill fits above the plate on
   # the left (hips, 0.12); ribs and roller stack on the right (0.16, 0.21;
   # the roller's short label keeps its pill ~12 pt clear of the ribs
   # leader); feet and pad at 0.74, below the footplate. The roller cue
   # tracks the left hand, on its handle at the roller's end.
   overrides={"hips": (ov(0.12), "leading"), "ribs": (ov(0.16), "trailing"), "roller": (ov(0.21), "trailing"),
              "feet": (ov(0.74), "leading"), "pad": (ov(0.74), "trailing")},
   annotations=[
       ("hips", "Hips up to a level torso", "pelvis"),
       ("ribs", "Ribs down, spine neutral", "support_PectoralisMajor_Abdominal_R"),
       ("feet", "Shins vertical at the top", "foot_L"),
       ("pad", "Back pivots on the pad", "scapula_L"),
       ("roller", "Roller on hip crease", "hand_L"),
   ],
   cues={
       "hips": ("Hip Extension",
                "The hips rise until the torso is level with the floor.",
                HIPS_WHY,
                "Stopping short of lockout, the hips hanging below the line of the knees and shoulders.",
                "Drive through your whole foot until your knees, hips and shoulders line up, pause for a moment, then lower until you just touch the seat."),
       "ribs": RIBS,
       "feet": ("Foot Position",
                "Set the feet so the shins are vertical at the top.",
                FEET_WHY,
                "Setting the feet too far up the footplate, so the shins slope away and the knees open well past a right angle at the top.",
                "Plant your feet flat on the footplate about shoulder-width apart, toes turned out a little, where your shins stand about vertical at the top."),
       "pad": ("Back Pad",
               "The upper back pivots on the edge of the back pad.",
               PIVOT_WHY,
               "Sliding the back up the pad as the hips rise, until the edge sits under the middle of the back.",
               "Rest your upper back across the pad's edge under the lower tips of your shoulder blades and let your torso rock over it without sliding."),
       "roller": ("Roller Pad",
                  "The padded roller sits across the crease of the hips and rides up with them.",
                  "The lever carries the roller on a fixed arc, so it stays where you set it; across the hip crease it loads hip extension directly, as the bar does in a barbell hip thrust.",
                  "Starting with the roller on the stomach instead of the hip crease, so it presses into the stomach at the top.",
                  "Settle the roller onto the crease of your hips before the first rep and hold the handles beside it."),
   },
   activation=[GMAX, QUADS, HAMS, ERECTORS],
   stabilisers=["gluteus medius", "gluteus minimus", "adductors", "core"],
   comparison=HIPS_COMPARISON,
   glows=glute_glows(N))

SETUP[N] = [
    "Load plates on the machine's horn and sit on its low seat with your back to the back pad.",
    "Lean back so the edge of the back pad sits under the lower tips of your shoulder blades.",
    "Bring the roller down onto the crease of your hips and hold the handles on either side of it.",
    "Plant your feet flat on the footplate about shoulder-width apart, toes turned out a little.",
]

# ---------------------------------------------------------------- Single-Leg Hip Thrust
N = "Single-Leg Hip Thrust"
ex(name=N, var="singleLegHipThrust",
   # Smaller figure (zoom 0.659), the body across v ~0.45-0.67 and the free
   # right leg sweeping the upper left (its knee and foot up to v ~0.33 at
   # the top). The free-leg pill sits top left above the swing, ribs top
   # right; the two hip cues track the two hip joints (the working left for
   # lockout, the free side for the level pelvis) from below, and the foot
   # pill sits under the planted foot.
   overrides={"free": (ov(0.16), "leading"), "ribs": (ov(0.16), "trailing"), "hips": (ov(0.80), "trailing"),
              "level": (ov(0.80), "leading"), "foot": (ov(0.72), "leading")},
   annotations=[
       ("hips", "Hips up to a level torso", "thigh_L"),
       ("level", "Pelvis level, no hip drop", "thigh_R"),
       ("free", "Free knee up and still", "patella_R"),
       ("foot", "Shin vertical at top", "foot_L"),
       ("ribs", "Ribs down, spine neutral", "support_PectoralisMajor_Abdominal_R"),
   ],
   cues={
       "hips": ("Hip Extension",
                "The working hip straightens until the torso is level with the floor.",
                "The gluteus maximus is the main hip extensor, and here one leg's glutes lift the hips with no help from the other; stopping short leaves out the end of the range, where the glute is at its shortest.",
                "Stopping short of lockout, the hips hanging below the line of the knee and shoulders.",
                "Drive through your whole left foot until your left knee, hips and shoulders line up, pause for a moment, then lower under control."),
       "level": ("Pelvis Level",
                 "Both hip bones stay at the same height, up and down.",
                 "With one foot down, the pelvis tends to sag on the free side; the working side's gluteus medius steadies it, so the lift stays square over the working leg.",
                 "Letting the hip on the free side sag as you rise.",
                 "Keep both hip bones level and square from the bottom of the rep to the top."),
       "free": ("Free Leg",
                "The free knee stays bent and drawn up toward the chest.",
                "A still free leg keeps momentum out of the lift, so the planted leg does the work. In a study of single-leg bridges, holding the free thigh upright with the knee bent, instead of the leg out straight, cut the free leg's front-thigh activity by about two-thirds with glute activity about the same.",
                "Letting the free leg swing away from the chest to help heave the hips up.",
                "Lift your right knee toward your chest, bent, and hold it there, still, as the hips move."),
       "foot": ("Foot Position",
                "The working foot sits under the knee at the top.",
                "With the shin vertical, the knee is bent close to a right angle at the top, so the hamstrings help less and the glutes do more of the hip extension; a foot set further out hands more of it to the hamstrings.",
                "Planting the foot too far out, so the shin slopes away and the knee opens well past a right angle at the top.",
                "Plant your left foot flat, toes pointing ahead, where your shin stands about vertical at the top."),
       "ribs": RIBS,
   },
   # Paint: the glutes and quadriceps bright, as the two-leg thrusts, plus
   # the hip flexors (the rig's Sartorius, both sides) bright: they hold the
   # free knee up. Hip Flexors (a legend-only name) is a PRIMARY row at
   # 0.40, the lowest moderate value, as the seated calf raises' painted
   # gastrocnemius: Lehecka 2017 measured the free leg's rectus femoris at 7%
   # MVIC with the thigh upright and the knee bent (20% with the leg
   # straight), so the paint (and Physitrack's FAQ, which names the hip
   # flexors among the muscles it mainly works), not the EMG, sets the rank,
   # and the copy never says they work hard. Gluteus maximus 0.88, a
   # judgement call: no load but one leg (the Single-Leg Glute Bridge 0.86,
   # the loaded thrusts 0.90; Collings 2023 ranked the loaded single-leg hip
   # thrust among the top gluteus maximus exercises). Hamstrings 0.50, above
   # the two-leg 0.45:
   # Sorensen 2021 measured more hamstring activity in the single-leg barbell
   # thrust than the two-leg one (67 vs 50% of max). The gluteus medius
   # holds the pelvis level (Lehecka 2017: 55-58% MVIC in single-leg
   # bridges) but is lit with the glute group, so it is named with the
   # stabilisers, as on the other thrusts.
   activation=[("Gluteus Maximus", P, HI, 0.88), QUADS, ("Hip Flexors", P, MOD, 0.40),
               ("Hamstrings", S, MOD, 0.50), ERECTORS],
   stabilisers=["gluteus medius", "gluteus minimus", "adductors", "obliques"],
   comparison=("HIP DROPPING", "Hip bones level, knee to shoulders in line", "Free side's hip sags",
               "With the pelvis level, the working leg's glutes straighten the hip all the way while the free leg stays still.",
               "Letting the free side sag tips the pelvis off level, the drop the working side's gluteus medius is there to stop."),
   glows=[glow(N, ["pelvis", "thigh_L"], A, 0.55, rx=0.10, ry=0.07, dx=0.02, dy=0.03),
          glow(N, ["thigh_L", "patella_L"], SOFT, 0.30, rx=0.07, ry=0.04, dy=-0.01)])

SETUP[N] = [
    "Sit on the floor with your upper back against the long side of a flat bench about 40 cm high.",
    "Plant your left foot flat in line with your left hip, knee bent; the left leg works in this demo.",
    "Lean back so the bench edge sits under the lower tips of your shoulder blades, and spread your arms along the bench.",
    "Lift your right knee toward your chest and hold it there, bent; switch sides for the next set.",
]

# ---------------------------------------------------------------- B-Stance Hip Thrust
N = "B-Stance Hip Thrust"
ex(name=N, var="bStanceHipThrust",
   # As the dumbbell thrust's layout: the body across v ~0.35-0.64, open
   # above it on both sides and below the feet. The front (right) foot sits
   # far left (u ~0.13-0.20, v 0.60), the working foot at u 0.46.
   overrides={"hips": (ov(0.16), "leading"), "dumbbell": (ov(0.16), "trailing"), "level": (ov(0.27), "leading"),
              "kickstand": (ov(0.74), "leading"), "foot": (ov(0.74), "trailing")},
   annotations=[
       ("hips", "Hips up to a level torso", "thigh_L"),
       ("kickstand", "Front foot on its heel", "foot_R"),
       ("foot", "Back shin vertical at top", "foot_L"),
       ("level", "Hips level and square", "thigh_R"),
       ("dumbbell", "Dumbbell in the hip crease", "hand_L"),
   ],
   cues={
       "hips": ("Hip Extension",
                "The hips rise until the torso is level with the floor.",
                "The gluteus maximus is the main hip extensor in this lift, and here the back leg's glutes do most of the work; stopping short leaves out the end of the range, where the glutes are at their shortest.",
                "Stopping short of lockout, the hips hanging below the line of the back knee and shoulders.",
                "Drive through your whole left foot until your left knee, hips and shoulders line up, pause for a moment, then lower under control."),
       "kickstand": ("Kickstand Foot",
                     "The front foot rests on its heel with the toes up, a little ahead of the working foot.",
                     "On its heel with the toes pulled up, the front foot is a helper: it steadies you and assists a little, so the back leg does most of the work; the further ahead the kickstand sits, the harder the lift becomes.",
                     "Planting the front foot flat and pushing through it, so the lift turns back into a two-leg hip thrust.",
                     "Set your right heel about level with the ball of your left foot, pull the toes up and keep most of the push in your left foot."),
       "foot": ("Working Foot",
                "The back foot sits flat, the shin vertical at the top.",
                "Pressing through the whole back foot keeps the load on the working leg; with its shin vertical, the knee is bent close to a right angle at the top, so the hamstrings help less and the glutes do more of the hip extension.",
                "Setting the back foot too far out, so its shin slopes away and the knee opens well past a right angle at the top.",
                "Plant your left foot flat, toes turned out a little, where its shin stands about vertical at the top, and push through it."),
       "level": ("Pelvis Level",
                 "Both hip bones stay at the same height, up and down.",
                 "With most of the load on one leg, the load can shift and tip the pelvis toward the lighter side; keeping the hips level and square keeps the lift on the working leg's glutes.",
                 "Letting the hip on the kickstand side sag as the hips rise.",
                 "Keep both hip bones level and square from the bottom of the rep to the top."),
       "dumbbell": ("Dumbbell Position",
                    "The dumbbell lies across the hip crease, held at both ends.",
                    "Across the hip crease the dumbbell loads hip extension directly. Holding it by both heads keeps it there, instead of letting it roll toward the stomach as the hips rise and the trunk levels out.",
                    "Letting the dumbbell roll off the hip crease and up onto the stomach near the top.",
                    "Lay the dumbbell across the crease of your hips, hold one head in each hand and keep it in place from the first rep to the last."),
   },
   activation=[GMAX, QUADS, HAMS, ERECTORS],
   stabilisers=["gluteus medius", "gluteus minimus", "adductors", "core"],
   comparison=("KICKSTAND PUSHING", "Back leg drives, front heel steadies", "Both feet flat and pushing",
               "With the front foot up on its heel, the back leg's glutes and thigh do most of the lifting.",
               "Pushing through a flat front foot shares the load between the legs, so the working side does less."),
   glows=glute_glows(N))

SETUP[N] = [
    "Sit on the floor with your upper back against the long side of a flat bench about 40 cm high.",
    "Lay a dumbbell across the crease of your hips and hold it by both heads.",
    "Plant your left foot flat with the knee bent; the left leg works in this demo.",
    "Set your right foot a little ahead, its heel about level with the ball of your left foot, and pull its toes up.",
    "Lean back so the bench edge sits under the lower tips of your shoulder blades; switch sides for the next set.",
]
