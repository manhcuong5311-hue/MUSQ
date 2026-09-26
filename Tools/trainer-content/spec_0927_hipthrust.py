# Trainer content for the late additions (batch 2026-09-27), family: barbell
# hip thrust. Source export 077 (SourceExports/Legs2/077_barbell_hip_thrust.usdc,
# resource BarbellHipThrust, feet turned out since 2026-09-27). Same format as
# spec.py; spec_0927.py imports this module and gen.py reads SPEC / SETUP.
#
# What the model shows, from the brief, the framing shots and the rig (joints
# sampled every 0.25 s over the first rep; torso, neck to pelvis, 0.59 m):
# - Barbell Hip Thrust: upper back on the long side of a low bench (top
#   ~0.36 m), the bench edge under the top of the shoulder blades, level with
#   the shoulder joints. A barbell with a thick foam pad (0.44 m long) lies
#   across the hip crease: at lockout the bar is ~2.5 cm toward the knees
#   from the hip joints, at the bottom ~10 cm. Both hands hold the bar just
#   outside the pad (hands 0.60 m apart), elbows 128-144 degrees, and only
#   steady it. Feet flat on the floor for the whole clip, ~0.40 m apart at
#   the ankles (about shoulder-width: the shoulder joints are 0.39 m apart),
#   toes turned out a little. The hips drive up from a trunk-thigh angle of
#   116 to 176 degrees (pelvis 0.20 -> 0.48 m); at lockout knees, hips and
#   shoulders sit level (0.47-0.48 m, knee-hip-shoulder 179-180 degrees),
#   the trunk is level with the floor and the shins are vertical, knees at
#   90 degrees (69 degrees at the bottom). The spine keeps one gentle shape
#   throughout (no extra arch at the top) and the head stays in line with
#   it (chest-neck-head 176 degrees), so it tips back with the trunk and
#   faces the ceiling at lockout. The back rocks on the bench edge: the
#   shoulder joints shift 3-6 cm toward the head as the trunk turns 30
#   degrees over it, a pivot rather than a slide. One rep every 4 s, peak
#   at 1.75 s, a brief hold at the top.
# - Not written to: the knees sit ~7 cm inside the ankles at lockout (knee
#   joints 0.26 m apart, ankles 0.40 m; 0.19 m apart at the bottom), so the
#   shins angle out, where the technique references ask for knees over the
#   toes. There is no knee cue; see notes_0927_hipthrust.md.
#
# Sources:
# - Contreras B, Cronin J, Schoenfeld B 2011, Barbell hip thrust, Strength
#   Cond J 33(5):58-61, doi:10.1519/SSC.0b013e31822fa09d (NSCA Exercise
#   Technique column): upper back across a secured bench slightly lower than
#   a low-bar squat position; pad the bar, placed at the crease of the hips
#   (the lift presses hard on the lower abdomen and pubic region); feet about
#   shoulder-width at a distance giving a 90-degree knee and a vertical tibia
#   at the top; brace; the extension comes from the hips, not the
#   lumbopelvic region, a slight arch is fine but excessive lumbar
#   hyperextension may load the posterior spine; knees track over the toes;
#   the back hinges across the bench with sliding kept to a minimum; feet
#   flat, push through the whole foot; head and neck in line with the spine;
#   hips rise until the torso is parallel with the ground, hold a one-count,
#   lower under control. Muscles: gluteus maximus, hamstrings and adductor
#   magnus as primary hip extensors; adductors and posterior gluteus medius
#   and minimus secondary; erector spinae stabilising; quadriceps as knee
#   extensors; bent knees limit the hamstrings (active insufficiency).
# - Contreras B, Vigotsky AD, Schoenfeld BJ, Beardsley C, Cronin J 2015,
#   J Appl Biomech 31(6):452-458, doi:10.1123/jab.2014-0301 — 13 trained
#   women, estimated 10RM: hip thrust vs back squat, mean upper gluteus
#   maximus 69.5 vs 29.4 %MVIC, lower 86.8 vs 45.4, biceps femoris 40.8 vs
#   14.9; vastus lateralis 99.5 vs 110 (not significantly different).
# - Contreras B, Vigotsky AD, Schoenfeld BJ, Beardsley C, Cronin J 2016,
#   J Appl Biomech 32(3):254-260, doi:10.1123/jab.2015-0091 — 13 trained
#   women, 10RM: the barbell hip thrust gave higher mean upper gluteus
#   maximus EMG than the American and band hip thrusts (69.5 vs 57.4 and
#   49.2 %MVIC); mean lower gluteus maximus was similar (American 89.9,
#   barbell 86.7, band 79.2).
# - Andersen V, Fimland MS, Mo DA et al. 2018, J Strength Cond Res
#   32(3):587-593, doi:10.1519/JSC.0000000000001826 — 13 trained men, 1RM:
#   the hip thrust gave more gluteus maximus activation than the hex bar
#   deadlift (16% over the whole lift, 26% in the upper part) and did not
#   differ from the barbell deadlift; the barbell deadlift gave 20% more
#   biceps femoris than the hip thrust; erector spinae did not differ.
# - Delgado J, Drinkwater EJ, Banyard HG, Haff GG, Nosaka K 2019, J Strength
#   Cond Res 33(10):2595-2601, doi:10.1519/JSC.0000000000003290 — 8 trained
#   men, 60 kg and 1RM: at 1RM the hip thrust gave more gluteus maximus
#   activity than the back squat (not different from the Romanian
#   deadlift); vastus lateralis was higher in the squat than the hip thrust.
# - Collazo Garcia CL, Rueda J, Suarez Luginick B, Navarro E 2020, J Strength
#   Cond Res 34(9):2449-2455, doi:10.1519/JSC.0000000000002859 — 7 trainers,
#   40% 1RM, four foot and force variations; EMG differed in every muscle but
#   the gluteus medius. Full text paywalled; values as tabulated by Neto 2019
#   (Table 2; column order inferred, see the notes): with the feet further
#   away, biceps femoris ~41 -> 72% and
#   semitendinosus ~32 -> 70% MVIC, vasti down (~27 -> 11%), gluteus maximus
#   about unchanged (~55 -> 51%).
# - Neto WK, Vieira TL, Gama EF 2019, J Sports Sci Med 18(2):198-206
#   (PMC6544005) — systematic review: hip thrust favours hip extensor
#   activation over the squat; the straight-bar deadlift gives more biceps
#   femoris; excitation order gluteus maximus, erector spinae, hamstrings,
#   quadriceps; feet forward raises hamstring and lowers quadriceps
#   activity without changing gluteus maximus excitation.
# - Neto WK, Soares EG, Vieira TL et al. 2020, J Sports Sci Med 19(1):195-203
#   (PMC7039033) — the traditional barbell hip thrust is among the exercises
#   with very high gluteus maximus activation (>60% MVIC).
# - Williams MJ, Gibson NV, Sorbie GG, Ugbolue UC, Brouner J, Easton C 2021,
#   J Strength Cond Res 35(1):16-24, doi:10.1519/JSC.0000000000002651 —
#   12 male team-sport athletes, 3RM: peak gluteus maximus EMG higher in the
#   hip thrust than the back squat and split squat.
# - Brazil A, Needham L, Palmer JL, Bezodis IN 2021, PLoS One 16(3):e0249307,
#   doi:10.1371/journal.pone.0249307 — 19 trained men, 70% 1RM: extensor
#   demand far greater at the hip than the knee or pelvis-trunk; the hip
#   extensor moment peaks early (~14% of the lift) and falls toward lockout
#   rather than staying constant; a real knee extensor demand (knee range
#   21 +/- 7 degrees, as in the model); the pelvis-trunk extensor moment
#   mainly resists trunk flexion (range 12 +/- 21 degrees).
# - Plotkin DL, Rodas MA, Vigotsky AD et al. 2023, Front Physiol 14:1279170,
#   doi:10.3389/fphys.2023.1279170 — training study: hip thrust training
#   grew the glutes no more than back squat training (similar growth), so
#   the higher EMG does not mean more growth; the copy makes no hypertrophy
#   claim. (Barbalho et al. 2020, Int J Sports Med 41(5):306-310, is left
#   out: its data were flagged as improbable and a retraction was called
#   for (Stronger by Science 2020), though it has not been retracted.)
# - ExRx.net, Barbell Hip Thrust
#   (https://exrx.net/WeightExercises/GluteusMaximus/BBHipThrust; exrx.net
#   blocks direct fetches, the wording was checked through search-result
#   text): upper back against the side of the bench, bar rolled back and
#   centred over the hips, across the upper hip flexors and lower abdomen,
#   thick bar padding or a foam pad if the pelvis and hip flexors do not pad
#   it enough; feet about shoulder-width; extend the hips until straight; a
#   16-18 in (40-46 cm) bench so the torso starts at about 45 degrees; hands
#   on the bar keep it from rolling back near the top. Target gluteus
#   maximus; quadriceps synergist; hamstrings dynamic stabilisers; erector
#   spinae stabiliser; rectus abdominis and obliques antagonist stabilisers.
# - StrengthLog, Hip Thrust (https://www.strengthlog.com/hip-thrust/): back
#   against a bench, pad between bar and pelvis, feet about shoulder-width,
#   knees ~90 degrees at the top; glutes primary, adductors and quadriceps
#   secondary.
#
# Evidence is thin or mixed for the quadriceps: Contreras 2015's vastus
# lateralis (99.5 %MVIC at 10RM, no different from the squat) is
# deliberately discounted against Delgado 2019 (well below the squat at 1RM,
# 8 men) and Collazo Garcia 2020 (low vasti at 40% 1RM), so it sits at the
# bottom of the moderate band. The erector spinae sit level with the
# hamstrings: second in Neto 2019's excitation order, the second-largest
# extensor moment (pelvis-trunk) in Brazil 2021 and no different from the
# deadlifts in Andersen 2018, though ExRx calls them a stabiliser.
# The knee-angle claim rests on one study of seven people (Collazo Garcia
# 2020) plus the active-insufficiency reasoning in Contreras 2011.
#
# Labels: every cue is pinned with `overrides`. The body fills the middle
# band (v 0.37-0.62), so the pills sit above it (ribs and bar on row 0.14,
# hips on 0.26, which squeezes to 0.27: clear of the top of the pad, which
# lies at v ~0.32 on the top plateau, and just over the top edge of the
# left plate) and below the feet (feet and bench on 0.86), never over the
# shoes. The ribs cue tracks support_PectoralisMajor_Abdominal_R, which
# sits on the top of the lower ribcage, under the right end of the pad (at
# the bottom of the rep it sits at the pad's lower corner): the `chest`
# joint lies inside the trunk behind the near hip, so from this view its
# dot lands on the red glute patch at lockout. The _L and sternal pec
# anchors come within 10-21 pt of hand_L, so they are not used. Checked
# against all eight probed positions with 29 pt pills: no two cues share a
# joint, no leaders cross or pass through a pill, the closest leader
# passes ~14 pt from another pill (ribs by the hips pill's corner, at the
# bottom of the rep), the ribs and bar dots stay 35-40 pt apart and every
# dot is at least ~90 pt clear of every pill.

from common_0927 import *

N = "Barbell Hip Thrust"

ex(name=N, var="barbellHipThrust",
   annotations=[
       ("hips", "Hips up to a level torso", "pelvis"),
       ("ribs", "Ribs down, spine neutral", "support_PectoralisMajor_Abdominal_R"),
       ("feet", "Shins vertical at the top", "foot_L"),
       ("bench", "Back pivots on the bench", "scapula_L"),
       ("bar", "Padded bar in hip crease", "hand_L"),
   ],
   cues={
       "hips": ("Hip Extension",
                "The hips rise until the torso is level with the floor.",
                "The gluteus maximus is the main hip extensor in this lift, and a rep only ends when the hips are straight; stopping short leaves out the end of the range, where the glutes are at their shortest.",
                "Stopping short of lockout, with the hips hanging below the line of the knees and shoulders.",
                "Drive through the whole foot until knees, hips and shoulders line up, hold for a one-count, then lower under control."),
       "ribs": ("Spine Position",
                "The height comes from the hips, not the lower back.",
                "With the ribs down and the pelvis near neutral, the hips lift the bar; arching the lower back adds height through the spine instead of the hips, and a big arch under load can add stress to the lower back.",
                "Flaring the ribs and arching the lower back at the top, so the lower back bows up above the line of the hips and shoulders.",
                "Brace before each rep, keep the ribs down and the head in line with the spine, and stop when the torso is level."),
       "feet": ("Foot Position",
                "Set the feet so the shins are vertical at the top.",
                "With the knees near 90 degrees at lockout the hamstrings are shortened at the knee and can help less, so the glutes take more of the hip extension; in one small study, moving the feet further out raised hamstring activity and lowered quadriceps activity with no gain in glute activity.",
                "Setting the feet too far out, so the shins slope away and the knees open well past 90 degrees at the top.",
                "Plant the feet flat about shoulder-width apart, toes turned out a little, close enough that the shins stand vertical at lockout."),
       "bench": ("Bench Contact",
                 "The upper back pivots on the edge of the bench.",
                 "Hinging on one spot lets the hips rise around a fixed point; sliding along the bench moves the hips away from the feet and changes the knee angle mid-rep.",
                 "Sliding the back up the bench as the hips rise, until the edge sits near the bottom of the shoulder blades.",
                 "Rest the upper back across the bench edge near the top of the shoulder blades and let the torso rock over that spot without sliding."),
       "bar": ("Bar Position",
               "A padded bar sits in the crease of the hips.",
               "Over the hip crease the bar loads hip extension directly, and a thick pad spreads the pressure on the pelvis; the hands only keep it from rolling toward the stomach.",
               "Letting the bar roll off the hip crease and up onto the stomach near the top.",
               "Roll the bar into the hip crease over a thick pad and steady it with both hands just outside the pad."),
   },
   # Ranks from the EMG and joint-moment studies above; conservative.
   # Gluteus maximus is the target in every source. Hamstrings about half
   # the glute signal (Contreras 2015, 40.8 vs 69.5-86.8 %MVIC; below the
   # barbell deadlift in Andersen 2018). Erector spinae level with them:
   # second in Neto 2019's excitation order, the second-largest extensor
   # moment (pelvis-trunk) in Brazil 2021, and no different from the
   # deadlifts in Andersen 2018. Quadriceps at the bottom of the band:
   # Contreras 2015's vastus lateralis (99.5 %MVIC at 10RM) is set against
   # Delgado 2019 (well below the squat at 1RM, 8 men) and Collazo Garcia
   # 2020 (low vasti at 40% 1RM).
   activation=[("Gluteus Maximus", P, HI, 0.90), ("Hamstrings", S, MOD, 0.45),
               ("Erector Spinae", S, MOD, 0.45), ("Quadriceps", S, MOD, 0.40)],
   stabilisers=["adductors", "gluteus medius", "core"],
   comparison=("ARCHING THE LOWER BACK", "Hips straight, torso level", "Lower back arches at the top",
               "Stopping with knees, hips and shoulders in line keeps the finish at the hips, where the glutes do the work.",
               "Arching the lower back pushes the bar higher without more hip extension, so the extra height comes from the spine, not the glutes."),
   overrides={"ribs": (0.14, "leading"), "bar": (0.14, "trailing"), "hips": (0.26, "leading"),
              "feet": (0.86, "leading"), "bench": (0.86, "trailing")},
   # The glutes sit under the pelvis and hip joints (nudged toward the near,
   # left side, where they show); the hamstrings under the near thigh.
   glows=[glow(N, ["pelvis", "thigh_L", "thigh_R"], A, 0.55, rx=0.12, ry=0.08, dx=0.04, dy=0.02),
          glow(N, ["thigh_L", "patella_L"], SOFT, 0.30, rx=0.08, ry=0.05, dy=0.04)])
SETUP[N] = [
    "Sit on the floor with your upper back against the long side of a low bench, secured so it cannot slide.",
    "Roll a padded barbell over your thighs until it rests in the crease of your hips.",
    "Plant your feet flat, about shoulder-width apart and close enough that your shins will be vertical at the top, toes turned out a little.",
    "Lean back so the bench edge sits near the top of your shoulder blades and hold the bar either side of the pad.",
]

if __name__ == "__main__":
    probs = validate(["Barbell Hip Thrust"])
    print("\n".join(probs) or "OK")
