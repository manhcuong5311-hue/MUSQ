# Trainer content for the 30-leg set 02-27 (2026-09-28), family "barbell":
# Box Squat, Pause Squat, Safety Bar Squat, Zercher Squat, Overhead Squat and
# Landmine Squat. Same entry format as spec.py, on top of common_legs30.py;
# spec_legs30.py collects the families (python3 spec_legs30.py barbell).
#
# What each model shows, from the motion briefs (briefs_legs30/<Slug>.md:
# joint angles, positions and equipment every 0.5 s; Y up, the lifter faces
# +z, their left is +x) and the app's stills with the final framing. Every
# model squats on both legs at once, symmetrically (left and right angles
# within 1°), two reps per clip, and is framed three-quarter from the
# lifter's front-left (yaw -1.0, -0.8 for the overhead squat, -0.9 for the
# landmine squat): the lifter faces screen-left-front, their left hand on
# the right of the screen. The rig's torso (neck to pelvis) is 0.59 m, the
# shoulder joints ~0.38-0.40 m apart. Angles: knee and hip are inner angles
# (180 straight); trunk lean is the neck-over-pelvis line from vertical;
# thigh is degrees below horizontal toward the knee (+5° = the hip joint
# ~4 cm above the knee joint, i.e. about parallel; +12° = just above).
# - Box Squat (10 s, yaw -1.0): a straight barbell high on the upper traps
#   (bar centre ~6 cm behind the neck joint and level with it), grip 0.78 m
#   (hands ~20 cm outside each shoulder, elbows bent and pointing down). A
#   box behind the lifter, 0.43 m high, 0.64 m wide, its front edge ~18 cm
#   behind the ankles. Ankles 0.50 m apart (about 1.3 times the shoulder-joint
#   width: a little wider than the shoulders), toes out 20°. Top 0-0.6 s,
#   down in ~1.1 s, then SITS on the box for ~1.2 s (1.75-2.96 s: the pelvis
#   joint 0.51 m high, 8 cm above the box top, 33 cm behind the ankles), up in
#   ~1.0 s, 1.5 s standing, and again. On the box: knees 84°, hips 56°, thighs
#   about parallel (+5°), shins only 9° forward (15-19° on the way down and
#   up), the kneecaps ~7 cm ahead of the ankles, and the trunk leaning 44°
#   (4° standing). The hips travel 39 cm down and 33 cm back.
# - Pause Squat (12 s, yaw -1.0): the same high bar and grip. Ankles 0.42 m
#   apart (about shoulder width), toes out 12°. Down in ~1.1 s, a still hold
#   at the bottom of ~2.5 s (1.75-4.21 s: nothing moves by more than 1 cm or
#   1°), up in ~1.0 s. Bottom: knees 63°, hips 68°, thighs about parallel
#   (+5°), shins 31° forward, kneecaps ~21 cm ahead of the ankles, trunk 29°;
#   the hips drop 46 cm. Knees 172° standing.
# - Safety Bar Squat (10 s, yaw -1.0): a safety squat bar drawn as one: a
#   padded yoke across the upper back and shoulders, two handles running
#   forward over the shoulders, held with both hands ~19 cm in front of and
#   ~9 cm below the shoulder joints (hands 0.34 m apart, elbows bent and
#   pointing down), and cambered ends that drop the sleeves and plates below
#   the yoke (their centre ~14 cm below and ~13 cm in front of the neck
#   joint). Ankles 0.42 m apart, toes out 12°. Down ~1.1 s, ~0.9 s at the
#   bottom (a slow turn, not a hold), up ~1.0 s. Bottom: knees 62°, hips 75°,
#   thighs about parallel (+6°), shins 34°, kneecaps ~22 cm ahead of the
#   ankles, trunk 23° (6° less than the straight-bar pause squat model).
# - Zercher Squat (10 s, yaw -1.0): a straight barbell in the crooks of the
#   elbows (elbows bent to ~46°), hands clasped together in front of the
#   chest (0.18 m apart, ~6 cm below the shoulder joints). The bar sits at
#   lower-chest height, ~23 cm below and ~12 cm in front of the neck joint
#   standing (25 cm below and 7 cm in front at the bottom). Ankles 0.46 m
#   apart, toes out 15°. Same timing as the safety bar squat. Bottom: knees
#   61°, hips 80°, thighs about parallel (+5°), shins 33°, kneecaps ~22 cm
#   ahead of the ankles, trunk 17°: the most upright of the four.
# - Overhead Squat (8 s, yaw -0.8): a straight barbell held overhead on
#   straight arms (elbows ~170°), grip 0.92 m (hands ~26 cm outside each
#   shoulder; wide, though narrower than a typical snatch grip), the bar
#   ~49 cm above and ~4-5 cm behind the neck joint and straight over the
#   ankles (it moves only up and down, within 1 cm fore-aft, all clip).
#   Ankles 0.42 m apart, toes out 12°. Knees 161° at the top (never fully
#   locked). Down in ~1.0 s, ~0.75 s at the bottom, up in ~1.75 s. Bottom:
#   knees 57°, hips 85°, thighs just above parallel (+12°), shins 47°, the
#   kneecaps ~29 cm ahead of the ankles (well past the toes), trunk 18°.
# - Landmine Squat (8 s, yaw -0.9): a barbell pivoting in a landmine base on
#   the floor ~2 m in front of the lifter, one plate on the sleeve and a
#   short crosswise handle (0.33 m wide) at the bar's end, held with both
#   hands 0.24-0.28 m apart at chest height: at the top ~38 cm in front of
#   and ~10 cm below the shoulder joints (elbows 97°), at the bottom ~20 cm in
#   front (elbows 46°) as the bar's arc brings the handle toward the chest.
#   The plate sits ~16 cm beyond the handle. Legs and timing as the overhead
#   squat (knees 161° -> 57°, hips 163° -> 87°, thighs +12°, shins 47°,
#   kneecaps ~29 cm ahead of the ankles); trunk 5° -> 15°.
#
# Sources (each checked on PubMed abstracts or the page itself;
# notes_legs30_barbell.md maps the claims to them):
# - Swinton PA, Lloyd R, Keogh JWL, Agouris I, Stewart AD 2012, J Strength
#   Cond Res 26(7):1805-1816, doi 10.1519/JSC.0b013e3182577067 — traditional,
#   powerlifting and box squats in 12 powerlifters at 30-70% 1RM: the box and
#   powerlifting squats used wide stances (92.1 and 89.6 cm vs 48.3 cm) and a
#   more vertical shin with the centre of mass moving back; the largest spine
#   and ankle moments in the traditional squat, then the powerlifting squat,
#   then the box squat; the largest hip moments in the powerlifting squat.
# - McBride JM, Skinner JW, Schafer PC, Haines TL, Kirby TJ 2010, J Strength
#   Cond Res 24(12):3195-3199, doi 10.1519/JSC.0b013e3181f6399a — squat vs box
#   squat at 60-80% 1RM: minimal differences; peak force (70%) and peak power
#   (80%) slightly higher in the box squat; muscle activity (vastus lateralis,
#   vastus medialis, biceps femoris, longissimus) generally higher in the
#   squat; the box removes the stretch-shortening cycle.
# - Paoli A, Marcolin G, Petrone N 2009, J Strength Cond Res 23(1):246-250,
#   doi 10.1519/JSC.0b013e3181876811 — back squats at three stance widths:
#   only the gluteus maximus differed, higher at the widest stance.
# - McCaw ST, Melrose DR 1999, Med Sci Sports Exerc 31(3):428-436, doi
#   10.1097/00005768-199903000-00012 — stance width did not change the
#   quadriceps but did change the adductor longus and gluteus maximus.
# - Wilson GJ, Elliott BC, Wood GA 1991, Med Sci Sports Exerc 23(3):364-370
#   — bench press at 95%: the boost from the prior stretch decayed with the
#   pause, half-life 0.85 s.
# - Pallarés JG, Sánchez-Medina L, Pérez CE, De La Cruz-Sánchez E,
#   Mora-Rodriguez R 2014, J Sports Sci 32(12):1165-1175, doi
#   10.1080/02640414.2014.889844 — a 2-s pause between the eccentric and
#   concentric phases made bench press and squat velocity tests more
#   repeatable.
# - Martínez-Cava A, Hernández-Belmonte A, Courel-Ibáñez J, Conesa-Ros E,
#   Morán-Navarro R, Pallarés JG 2021, Int J Sports Physiol Perform
#   16(7):927-933, doi 10.1123/ijspp.2020-0348 — 10 weeks of squats with a
#   ~2-s pause vs rebound: both improved; the pause group had larger effect
#   sizes in the strength tests (ES 0.76-1.12 vs 0.45-0.92); the pause is
#   agreed to lower acute performance.
# - Hecker KA, Carlson LA, Lawrence MA 2019, J Strength Cond Res 33(Suppl
#   1):S45-S51, doi 10.1519/JSC.0000000000002912 — safety squat bar vs
#   straight bar, 12 powerlifters at 75% 3RM: 3RM 11.3% lower; trunk and hip
#   flexion 7.3° and 5.7° less; lower trapezius +50.3%; rectus abdominis,
#   hamstrings (15-17%), vastus lateralis (9.3%) and medial gastrocnemius
#   lower, attributed to the lighter load.
# - Vantrease WC, Townsend JR, Sapp PA, Henry RN, Johnson KD 2021, J Strength
#   Cond Res 35(Suppl 1):S1-S5, doi 10.1519/JSC.0000000000003541 — 1RM 11.6%
#   higher with the straight bar (144.7 vs 128.8 kg); similar muscle activation (7 muscles)
#   and bar velocity at the same relative loads.
# - Johansson DG, Marchetti PH, Stecyk SD, Flanagan SP 2024, J Strength Cond
#   Res 38(5):825-834, doi 10.1519/JSC.0000000000004719 — at 85% 1RM the
#   straight bar gave more hip flexion and peak hip extensor torque and more
#   load; the safety squat bar slightly more knee flexion with no difference
#   in knee kinetics; suited where a more upright posture or lower load is
#   preferred.
# - Kristiansen E, Larsen S, Haugen ME, Helms E, van den Tillaar R 2021, Int J
#   Environ Res Public Health 18(16):8351, doi 10.3390/ijerph18168351 —
#   safety-bar, high-bar and low-bar 3RM: least load with the safety bar;
#   more gluteus maximus activity than the high-bar squat; larger knee
#   extension moments than the low-bar squat.
# - Gullett JC, Tillman MD, Gutierrez GM, Chow JW 2009, J Strength Cond Res
#   23(1):284-292, doi 10.1519/JSC.0b013e31818546bb — front squat as effective
#   as the back squat in overall muscle recruitment with lower knee
#   compressive forces and extensor moments.
# - Yavuz HU, Erdag D, Amca AM, Aritan S 2015, J Sports Sci 33(10):1058-1066,
#   doi 10.1080/02640414.2014.984240 — maximal front vs back squats: more
#   vastus medialis in the front squat, more semitendinosus in the back squat,
#   more trunk lean in the back squat.
# - Aspe RR, Swinton PA 2014, J Strength Cond Res 28(10):2827-2836, doi
#   10.1519/JSC.0000000000000462 — back vs overhead squat at 60-90% 3RM: the
#   overhead squat drew slightly more rectus abdominis and external oblique on
#   the way down (~2-7%); the back squat more erector spinae and all
#   lower-body muscles on the way up, and more peak force.
# - Collins KS, Klawitter LA, Waldera RW, Mahoney SJ, Christensen BK 2021, J
#   Strength Cond Res 35(10):2661-2668, doi 10.1519/JSC.0000000000004094 —
#   goblet vs landmine squat at 30% body mass: the landmine squat reduced
#   vastus medialis and lateralis activity and vertical force and increased
#   the backward horizontal force; hamstring changes differed by sex.
# - Caterisano A et al. 2002, J Strength Cond Res 16(3):428-432 — gluteus
#   maximus share of the concentric EMG rose with depth (16.9% partial, 28.0%
#   parallel, 35.4% full); the vasti and biceps femoris shares did not.
# - Glassbrook DJ, Helms ER, Brown SR, Storey AG 2017, J Strength Cond Res
#   31(9):2618-2634, doi 10.1519/JSC.0000000000002007 — high-bar squats: more
#   upright torso, more knee flexion, more quadriceps; low-bar: more lean and
#   more erector, adductor and glute activity.
# - Fry AC, Smith JC, Schilling BK 2003, J Strength Cond Res 17(4):629-633,
#   doi 10.1519/1533-4287(2003)017<0629:EOKPOH>2.0.CO;2 — stopping the knees
#   at the toes cut knee torque but raised hip torque and trunk lean; the
#   knees moving slightly past the toes may be appropriate.
# - Powers CM 2010, J Orthop Sports Phys Ther 40(2):42-51, doi
#   10.2519/jospt.2010.3337 — hip, pelvis and trunk control affects knee
#   mechanics (clinical commentary).
# - StrengthLog exercise guides (strengthlog.com/box-squat, /pause-squat,
#   /safety-bar-squat, /zercher-squat, /overhead-squat, /landmine-squat, read
#   2026-09-28): muscles listed (quads, glutes, adductors, lower back; calves
#   secondary; trapezius secondary in the overhead squat; lower back only
#   secondary in the landmine squat); box squat either touched or sat on for
#   a few moments; pause at least a second, count to three, about 90% of the
#   regular squat; safety bar load sits slightly further forward, handles ease
#   the shoulders; Zercher bar in the elbow crooks, rack just under elbow
#   height, elbows close, arms want to drop, pull the bar in, towel for
#   comfort; overhead squat grip wider than the shoulders, arms locked, bar
#   slightly behind the head in line with the heels, at least parallel;
#   landmine bar end in a corner, hands at the top of the chest, little
#   demand on the lower back.
# Found but not read in full (closed access; not used for any claim):
# Lincoln MA, Wheeler SG, Knous JL 2022/2023, Strength Cond J 45(2):241-250,
# doi 10.1519/SSC.0000000000000717 (safety squat bar technique); Ronai P,
# Scibek E 2024, ACSMs Health Fit J 28(4):59-65, doi
# 10.1249/FIT.0000000000000982 (landmine squat); Erdag D, Yavuz HU 2020,
# Adv Intell Syst Comput (ICSCCW-2019) 859-865, doi
# 10.1007/978-3-030-35249-3_114 (EMG of front, back, hack, sumo and Zercher
# squats; its abstract was not available). ExRx could not be read: exrx.net
# refuses automated fetches and the Internet Archive was offline on
# 2026-09-28.
# No EMG study of the Zercher squat or the pause squat (vs the same squat
# without a pause) was read; their rows are ranked from the closest studied
# lifts (the front and back squats) and kept modest (see the notes).

from common_legs30 import *


def squat_glows(name, glute_dx=0.04):
    """Both thighs' quadriceps, then the glutes behind the hips (the lifter
    faces screen-left-front, so behind is to the right)."""
    return [glow(name, ["thigh_L", "patella_L", "thigh_R", "patella_R"], A, 0.55, rx=0.16, ry=0.07),
            glow(name, ["pelvis"], SOFT, 0.30, rx=0.08, ry=0.06, dx=glute_dx)]


# ---------------------------------------------------------------- shared cues

BAR = ("Bar Position",
       "The bar sits high across the upper traps.",
       "A high bar lets the torso stay more upright and keeps the quadriceps doing much of the work; in back squats a lower bar brings more forward lean.",
       "The bar sliding down onto the back of the shoulders, the chest tipping further forward to balance it.",
       "Set the bar across the upper traps just below the neck, hands wider than the shoulders, and squeeze the upper back tight under it.")

KNEES = ("Knee Tracking",
         "The knees travel forward and out in line with the toes.",
         "Knees that follow the feet keep the load straight through the joint. Knees caving inward often show the hips losing control of the thighs, so the knee takes the load at an angle.",
         "The knees caving inward toward each other at the bottom or on the way up.",
         "Push the knees out over the middle toes on the way down and keep them there as you stand up.")

FEET = ("Foot Pressure",
        "The whole foot stays planted.",
        "Pressure through the heel and mid-foot keeps you balanced over the feet so the legs can drive the rep. Knees travelling forward is normal; heels lifting tips the load onto the toes.",
        "The heels peeling off the floor at the bottom, the weight rolling onto the toes.",
        "Keep the heels down and push the floor away through the whole foot, heel and mid-foot.")


def depth(parallel_word, mistake, correct):
    return ("Depth",
            "Each rep sinks until the thighs are " + parallel_word + ".",
            "Going down to about parallel takes the quadriceps and glutes through a long range; in back squats the glutes' share of the muscle activity rose with depth. Stopping high trains only the top of the lift.",
            mistake, correct)


# ---------------------------------------------------------------- box squat

ex(name="Box Squat", var="boxSquat",
   library=("QUADS + GLUTES", "BARBELL", "intermediate"),
   # Plates sweep the top of the frame; the box fills the lower right. The
   # bar label sits top left, above the left plate; the back label below
   # it, short so it ends before the head (u 0.36 at the bottom); the tight
   # label on the right at the same row, above the near hand and elbow on
   # the bar (hand_L 0.62, 0.47 at the bottom); the sit label low right over
   # the box face, its leader up to the hips (the pelvis lands at 0.63,
   # 0.64); the knee label low left, short so it ends before the knee on
   # the screen-left side (patella_R, the lifter's far knee, visible clear
   # of the near leg, u 0.27-0.35).
   overrides={"bar": (0.14, "leading"), "back": (0.32, "leading"), "tight": (0.32, "trailing"),
              "sit": (0.86, "trailing"), "knee": (0.68, "leading")},
   annotations=[
       ("bar", "Bar high on the traps", "support_TrapeziusUpper_L"),
       ("back", "Back flat", "chest"),
       ("tight", "Stay tight on the box", "spine"),
       ("sit", "Sit back to the box", "pelvis"),
       ("knee", "Knees out", "patella_R"),
   ],
   cues={
       "bar": BAR,
       "back": ("Back Position",
                "The back stays flat as the hips sit back and the chest leans forward.",
                "Sitting back to a box brings a clear forward lean. Held with a flat, braced back, the lean is balanced by the hips pushing back, and the more you lean, the more the brace has to hold.",
                "The upper and lower back rounding as the chest leans forward on the way down to the box.",
                "Brace before each rep, keep the chest proud and the back flat, and let the lean come from the hips folding."),
       "tight": ("Stay Tight on the Box",
                 "Sit on the box for a moment without letting go.",
                 "Pausing on the box takes away the bounce of a normal squat, so the legs start the way up from a standstill. The pause only works if the trunk stays braced: relaxing on the box lets the back round under the bar.",
                 "Relaxing on the box, the brace let go, the lower back rounding and the trunk rocking back, then rocking forward to get up.",
                 "Sit down under control, keep the brace and the lean you arrived with, then drive straight up from the box."),
       "sit": ("Sit Back",
               "The hips reach back to the box while the shins stay fairly upright.",
               "Sitting back keeps the shins closer to vertical and the weight further back; holding the knees back shifts part of the work from the knees to the hips and brings more forward lean.",
               "Squatting straight down, the knees shooting forward and the hips landing on the front edge of the box.",
               "Push the hips back first, keep the shins fairly upright and sit the middle of the hips onto the box."),
       "knee": ("Knee Tracking",
                "The knees push out over the turned-out toes.",
                "With the feet a little wider than the shoulders and the toes turned out, the knees follow the feet and the hips open, which gives the hips room to sit back between them. Knees caving inward often show the hips losing control of the thighs.",
                "The knees caving inward on the way down to the box or as you stand up from it.",
                "Point the toes out a little and push the knees out over them all the way down and up."),
   },
   # A little below the back squat for the quadriceps (McBride 2010: muscle
   # activity generally higher in the squat than the box squat; Swinton
   # 2012: more vertical shin, centre of mass back); the gluteus maximus
   # level with the back squat's 0.62, not above it: the one EMG study of
   # this lift (McBride 2010) found activity generally lower in the box
   # squat (the glutes were not measured). The hip-torque data (Fry 2003,
   # Swinton 2012) are context only, from knee-blocked or much wider box
   # squats than this model's. Adductors a stabiliser as in the app's Back
   # Squat; erector spinae just below the back squat's 0.45 (McBride 2010:
   # longissimus activity generally higher in the free squat).
   activation=[("Quadriceps", P, HI, 0.80), ("Gluteus Maximus", S, MOD, 0.62),
               ("Erector Spinae", S, MOD, 0.42)],
   stabilisers=["adductors", "hamstrings", "calves", "core"],
   comparison=("RELAXING ON THE BOX", "Tight on the box, trunk still", "Brace lost, trunk rocks back",
               "Staying braced on the box keeps the back flat, so the legs start the way up from a standstill with the trunk already set.",
               "Letting go on the box rounds the lower back under the bar, then the trunk has to rock forward to get the rep moving."),
   glows=squat_glows("Box Squat"))

SETUP["Box Squat"] = [
    "Set a box a short step behind where you will stand after walking the bar out, at a height that puts your thighs about parallel when seated.",
    "Take the bar high across your upper traps, hands wider than your shoulders.",
    "Step back until the box is a short step behind your heels.",
    "Set your feet a little wider than your shoulders, toes turned out, and brace.",
]

# ---------------------------------------------------------------- pause squat

ex(name="Pause Squat", var="pauseSquat",
   library=("QUADRICEPS", "BARBELL", "intermediate"),
   # As the box squat's framing without the box: the bar label top left,
   # the brace label below it (short, clear of the head at 0.37-0.38 on u),
   # the pause label on the right at the brace label's row, above the near
   # hand (hand_L 0.61, 0.47 at the bottom), the depth label below it by
   # the hips, the knee label left on the middle row, short, so it leaves
   # the knee on the screen-left side (patella_R, the lifter's far knee,
   # visible clear of the near leg, reaching u 0.23 at the bottom) clear.
   # The brace label is short (Chest up) so its leader passes below the
   # bar label's trap dot during the hold.
   overrides={"bar": (0.14, "leading"), "brace": (0.32, "leading"), "pause": (0.32, "trailing"),
              "depth": (0.68, "trailing"), "knee": (0.50, "leading")},
   annotations=[
       ("bar", "Bar high on the traps", "support_TrapeziusUpper_L"),
       ("brace", "Chest up", "chest"),
       ("pause", "Hold still 2-3 seconds", "spine"),
       ("depth", "Pause at parallel", "pelvis"),
       ("knee", "Knees out", "patella_R"),
   ],
   cues={
       "bar": BAR,
       "brace": ("Brace in the Hole",
                 "The chest stays up and the trunk stays braced for the whole pause.",
                 "Held at the bottom, the trunk has to stay rigid with no bounce to help. A braced trunk keeps the bar over the middle of the foot, so the legs can start the way up without the chest folding first.",
                 "The chest sinking toward the knees and the upper back rounding while you wait out the pause.",
                 "Take a big breath and brace before you go down, keep the chest up during the hold, and stand up with the chest and hips rising together."),
       "pause": ("The Pause",
                 "A real stop at the bottom, still for two to three seconds.",
                 "A pause takes the bounce out of the bottom. In the bench press the extra force from that bounce faded with a half-life under a second, so a two-second hold removes most of it and the legs have to start the rep on their own. In training, squats with a pause of about two seconds built strength at least as well as bounced squats.",
                 "Cutting the pause short, a quick touch and a bounce out of the bottom instead of a still hold.",
                 "Lower under control, stop dead at the bottom and count two or three, then drive up hard while staying braced."),
       "depth": depth("about parallel",
                      "Pausing above parallel, the hips stopping high to make the hold easier.",
                      "Sink until the thighs are about parallel, hold that depth without sinking or rising, then stand up."),
       "knee": KNEES,
   },
   # The back squat's ranks (the app's Back Squat: 0.90 / 0.62 / 0.45). No
   # study compared muscle activity with and without a pause; the pause
   # changes the timing, not the muscles (Martínez-Cava 2021; Pallarés 2014).
   activation=[("Quadriceps", P, HI, 0.90), ("Gluteus Maximus", S, MOD, 0.62),
               ("Erector Spinae", S, MOD, 0.45)],
   stabilisers=["adductors", "hamstrings", "calves", "core"],
   comparison=("CHEST SINKING IN THE HOLE", "Still and braced at the bottom", "Chest sinks during the pause",
               "A braced trunk holds the bottom position still, so the legs start the rep from a standstill with the bar over the feet.",
               "Letting the chest sink during the pause rounds the upper back and pitches the bar forward, so the hips shoot up first on the way out."),
   glows=squat_glows("Pause Squat"))

SETUP["Pause Squat"] = [
    "Set the rack's safety bars just below the depth you will pause at.",
    "Take the bar high across your upper traps, hands wider than your shoulders.",
    "Step back and set your feet about shoulder-width, toes turned slightly out.",
    "Take a big breath and brace before each rep.",
]

# ---------------------------------------------------------------- safety bar squat

ex(name="Safety Bar Squat", var="safetyBarSquat",
   library=("QUADRICEPS", "SAFETY BAR", "intermediate"),
   # The handles are held in front of the chest (hand_L at 0.44-0.47 on u),
   # so the handles label sits top left above the left plate; the upper back
   # label top right above the right plate; knee low left, depth and feet
   # low right.
   overrides={"handles": (0.14, "leading"), "torso": (0.14, "trailing"), "knee": (0.68, "leading"),
              "depth": (0.68, "trailing"), "feet": (0.86, "trailing")},
   annotations=[
       ("handles", "Hands on the handles", "hand_L"),
       ("torso", "Upper back tight", "support_TrapeziusUpper_L"),
       ("knee", "Knees out", "patella_R"),
       ("depth", "Thighs parallel", "pelvis"),
       ("feet", "Whole foot planted", "foot_L"),
   ],
   cues={
       "handles": ("Handles",
                   "The yoke rests on the upper back; the hands hold the handles in front.",
                   "The padded yoke carries the load and the handles steady it, so the shoulders do not have to reach back for a bar. Held in close with the elbows down, the handles keep the yoke seated on the back.",
                   "Holding the handles loosely out in front, the arms reaching forward, so the yoke can shift on the back.",
                   "Hold both handles firmly just in front of the chest, elbows pointing down, and keep them there through the rep."),
       "torso": ("Upper Back",
                 "The upper back stays tight as the bar tries to tip you forward.",
                 "The bar's cambered ends put the load slightly further forward than a straight bar, so the upper back works to hold the chest up; in one study, lower trapezius activity was about half again as high as with a straight bar, and lifters squatted with a more upright trunk.",
                 "The upper back rounding and the chest dropping toward the knees at the bottom as the bar pushes forward.",
                 "Brace, squeeze the shoulder blades back into the pads and keep the chest up, most of all as you start back up."),
       "knee": KNEES,
       "depth": depth("about parallel",
                      "Stopping above parallel, the hips staying high.",
                      "Sink until the thighs are about parallel, then drive up without the chest dropping first."),
       "feet": FEET,
   },
   # Same relative load: similar muscle activation to a straight bar
   # (Vantrease 2021); at the same fraction of each bar's 3RM, the vastus
   # lateralis 9% and hamstrings 15-17% lower (Hecker 2019, put down to the
   # lighter load), so the quadriceps sit a step below the back squat's
   # 0.90; gluteus maximus as the back squat (Kristiansen 2021: more than a
   # high-bar squat); erector spinae a little lower for the more upright
   # trunk (Hecker 2019, Johansson 2024: less hip flexion and hip torque);
   # the trapezius listed for the +50% lower trapezius (Hecker 2019), low as
   # it only holds the posture.
   activation=[("Quadriceps", P, HI, 0.86), ("Gluteus Maximus", S, MOD, 0.62),
               ("Erector Spinae", S, MOD, 0.40), ("Lower Trapezius", S, LOW, 0.36)],
   stabilisers=["adductors", "hamstrings", "calves", "core"],
   comparison=("UPPER BACK ROUNDING", "Chest up, back tight", "Chest folds, back rounds",
               "Holding the upper back tight keeps the trunk upright under the bar's forward pull, so the legs drive the rep.",
               "When the upper back gives way, the chest drops toward the knees and the load moves out in front of the feet."),
   glows=squat_glows("Safety Bar Squat"))

SETUP["Safety Bar Squat"] = [
    "Set the safety bar in a rack at about shoulder height.",
    "Step under it so the padded yoke rests across your upper back and shoulders.",
    "Take a handle in each hand in front of you and stand up to lift it off.",
    "Step back and set your feet about shoulder-width, toes turned slightly out.",
]

# ---------------------------------------------------------------- zercher squat

ex(name="Zercher Squat", var="zercherSquat",
   library=("QUADRICEPS", "BARBELL", "advanced"),
   # The bar crosses the chest. The near elbow (forearm_L) projects onto the
   # chest joint, so the elbow label points at the far elbow instead
   # (forearm_R, screen-left, the bar through it: u 0.37-0.44, v 0.38-0.56)
   # from the top left, and the back label sits top right on the chest, so
   # the leaders do not cross; knee low left, depth and feet low right.
   overrides={"crook": (0.14, "leading"), "back": (0.14, "trailing"), "knee": (0.68, "leading"),
              "depth": (0.68, "trailing"), "feet": (0.86, "trailing")},
   annotations=[
       ("crook", "Bar in the elbow crooks", "forearm_R"),
       ("back", "Chest up, back flat", "chest"),
       ("knee", "Knees out", "patella_R"),
       ("depth", "Thighs parallel", "pelvis"),
       ("feet", "Whole foot planted", "foot_L"),
   ],
   cues={
       "crook": ("Bar in the Elbows",
                 "The bar sits in the crooks of the elbows, pulled in against the body.",
                 "Held in the elbows at lower-chest height, the load sits in front of the body like a front or goblet squat, which lets the torso stay upright. The arms tend to drop as you go down; pulling the bar in keeps it close and the trunk tall.",
                 "The arms sagging away from the body and the hands dropping, the bar rolling toward the forearms and pulling the chest forward.",
                 "Hook the bar deep in the elbow crooks, clasp the hands, keep the elbows close together and pull the bar in toward the body all the way down and up."),
       "back": ("Back Position",
                "The chest stays up and the back flat under a load held out in front.",
                "A load in front of the body pulls the trunk forward, so the upper and lower back work to hold it upright; front-loaded squats are done with less trunk lean than back squats. Rounding under the bar puts that load on a bent spine.",
                "The upper and lower back rounding, the chest folding over the bar at the bottom.",
                "Brace hard before each rep and keep the chest up behind the bar from the bottom to the top."),
       "knee": KNEES,
       "depth": depth("about parallel",
                      "Stopping above parallel, the hips staying high.",
                      "Sink until the thighs are about parallel with the chest up, then drive up through the whole foot."),
       "feet": FEET,
   },
   # No EMG study of the Zercher squat was read. Ranked from the front
   # squat (the app's Front Squat: quadriceps 0.94, erector spinae 0.50,
   # gluteus maximus 0.40; Gullett 2009, Yavuz 2015), since both hold the
   # load in front with an upright trunk (the model's 17° at the bottom), a
   # step lower for the quadriceps because the arms usually limit the load
   # (StrengthLog), the erector spinae a touch lower and the gluteus maximus
   # as the front squat's (no source for moving it either way). The arms
   # holding the bar are stabilisers.
   activation=[("Quadriceps", P, HI, 0.88), ("Erector Spinae", S, MOD, 0.48),
               ("Gluteus Maximus", S, MOD, 0.40)],
   stabilisers=["upper back", "biceps", "adductors", "core"],
   comparison=("ARMS SAGGING", "Bar pulled in, chest up", "Arms drop, chest follows",
               "With the bar pulled in tight in the elbow crooks, the load stays close and the trunk stays upright over the feet.",
               "When the arms sag away from the body, the bar drifts forward and drags the chest and upper back down with it."),
   glows=squat_glows("Zercher Squat"))

SETUP["Zercher Squat"] = [
    "Set the bar in a rack just below elbow height.",
    "Hook the bar into the crooks of your elbows and clasp your hands in front of your chest.",
    "Stand up to lift it off, step back and set your feet about shoulder-width, toes slightly out.",
    "Wrap the bar in a towel or pad if it digs into your elbows.",
]

# ---------------------------------------------------------------- overhead squat

ex(name="Overhead Squat", var="overheadSquat",
   library=("QUADRICEPS", "BARBELL", "advanced"),
   # The bar and plates fill the top third. The bar label sits top right by
   # the near hand (hand_L at 0.65); the elbow label just below it by the
   # near elbow (forearm_L at 0.59, v 0.30-0.47); the torso label on the
   # left at mid height, short, clear of the head (u 0.42); knee low left,
   # depth low right.
   overrides={"bar": (0.14, "trailing"), "elbows": (0.32, "trailing"), "torso": (0.50, "leading"),
              "knee": (0.68, "leading"), "depth": (0.68, "trailing")},
   annotations=[
       ("bar", "Bar over the ankles", "hand_L"),
       ("elbows", "Elbows locked", "forearm_L"),
       ("torso", "Chest up", "chest"),
       ("knee", "Knees over the feet", "patella_R"),
       ("depth", "Thighs to parallel", "pelvis"),
   ],
   cues={
       "bar": ("Bar Position",
               "The bar stays over the ankles, slightly behind the head.",
               "Stacked over the feet, the bar needs little effort to balance and travels straight down and up. Arms drifting forward put the bar in front of the feet, where the shoulders and back have to fight to hold it.",
               "The arms drifting forward on the way down, the bar ending up over the toes.",
               "Push up into the bar, keep it over the ankles and slightly behind the head from the top of the rep to the bottom."),
       "elbows": ("Locked Arms",
                  "The elbows stay locked with a wide grip.",
                  "Straight, locked arms hold the bar at a steady height over the head. A grip wider than the shoulders, with the elbows locked and the arms pushing up into the bar, gives the bar a stable base.",
                  "The elbows softening and bending, the bar sinking toward the head.",
                  "Take a wide grip, lock the elbows and keep pushing up into the bar through the whole rep."),
       "torso": ("Torso Position",
                 "The chest stays up and the trunk close to upright.",
                 "With the bar overhead, the trunk has to stay nearly upright to keep the bar over the feet. Any forward lean takes the bar forward with it, which is why this squat asks for good hip, ankle and shoulder mobility.",
                 "The chest dropping forward at the bottom, taking the bar out in front of the feet.",
                 "Brace, keep the chest up and sit the hips down between the heels rather than back."),
       "knee": ("Knee Tracking",
                "The knees travel well forward over the feet and never cave inward.",
                "In an upright squat the knees travel well forward, past the toes, which is normal as long as the heels stay down. Knees caving inward often show the hips losing control of the thighs.",
                "The knees caving inward toward each other at the bottom or on the way up.",
                "Push the knees out over the middle toes on the way down and keep them there as you stand up."),
       "depth": depth("about parallel",
                      "Stopping well above parallel, the hips staying high to keep the bar balanced.",
                      "Sink until the thighs are about parallel, or lower if the bar stays over the ankles, then stand up. If the bar drifts forward before you get there, work on mobility with a lighter bar."),
   },
   # Aspe & Swinton 2014: at the same relative loads the back squat drew
   # more activity from every lower-body muscle and the erector spinae on
   # the way up, and the overhead squat's loads are lower; so every row sits
   # below the back squat's (0.90 / 0.62 / 0.45). The overhead squat's
   # extra abdominal activity was small (2-7%), so the abdominals stay with
   # the stabilisers. The trapezius row is mechanics and StrengthLog (listed
   # as secondary), not EMG, so it is kept low.
   activation=[("Quadriceps", P, HI, 0.80), ("Gluteus Maximus", S, MOD, 0.50),
               ("Erector Spinae", S, MOD, 0.40), ("Trapezius", S, LOW, 0.34)],
   stabilisers=["deltoids", "core", "adductors", "calves"],
   comparison=("BAR DRIFTING FORWARD", "Bar stacked over the ankles", "Arms drift, bar over the toes",
               "With the bar over the ankles and the arms locked, the bar balances over the feet and travels straight down and up.",
               "Once the bar drifts in front of the feet, the shoulders and back have to fight to hold it and the lifter tips forward."),
   glows=squat_glows("Overhead Squat", glute_dx=0.03))

SETUP["Overhead Squat"] = [
    "Learn it with an empty bar or a dowel before adding weight.",
    "Set your feet about shoulder-width, toes turned slightly out.",
    "Take a grip well wider than your shoulders and press the bar overhead.",
    "Lock your elbows with the bar over your ankles, slightly behind your head, and brace.",
]

# ---------------------------------------------------------------- landmine squat

ex(name="Landmine Squat", var="landmineSquat",
   library=("QUADRICEPS", "LANDMINE", "beginner"),
   # The lifter stands right of centre, the bar and plate on the left. The
   # handle label sits top left above the plate; the torso label on the
   # right; the depth label low left (on the right it covered the hips at
   # the bottom, and one row higher its leader crossed the torso label's);
   # the knee and foot labels on the lowest row, left and right, below the
   # bar's lower end.
   overrides={"handle": (0.14, "leading"), "torso": (0.32, "trailing"), "depth": (0.68, "leading"),
              "knee": (0.86, "leading"), "feet": (0.86, "trailing")},
   annotations=[
       ("handle", "Handle at chest height", "hand_L"),
       ("torso", "Chest up", "chest"),
       ("depth", "Thighs to parallel", "pelvis"),
       ("knee", "Knees over the feet", "patella_R"),
       ("feet", "Whole foot planted", "foot_L"),
   ],
   cues={
       "handle": ("Handle Position",
                  "Both hands hold the handle at chest height in front of the body; it rides in toward the chest as you sink.",
                  "The bar pivots on the floor in front of you, so its end travels on an arc that comes toward the chest as you squat. Held close, the load stays near the body and the trunk can stay upright.",
                  "Letting the handle drift away from the chest, the arms reaching forward so the load pulls the body forward.",
                  "Hold the handle at chest height with the elbows down, let it ride in toward you as you sink, and do not let it drift further out."),
       "torso": ("Torso Position",
                 "The chest stays up behind the handle.",
                 "The bar leans on you from its pivot in front, pushing back as well as down into your hands, so you can sit down with an upright trunk; compared with a goblet squat, the landmine squat produced more backward and less vertical force, and it asks little of the lower back.",
                 "Folding at the hips at the bottom, the chest dropping toward the handle and the back rounding.",
                 "Brace, keep the chest up and sit the hips down between the heels."),
       "depth": depth("about parallel",
                      "Stopping well above parallel, the hips staying high.",
                      "Sink until the thighs are about parallel, then drive up through the whole foot."),
       "knee": ("Knee Tracking",
                "The knees travel well forward over the feet and never cave inward.",
                "With the load in front and the trunk upright, the knees travel well forward, past the toes, which is normal as long as the heels stay down. Knees caving inward often show the hips losing control of the thighs.",
                "The knees caving inward toward each other at the bottom or on the way up.",
                "Push the knees out over the middle toes on the way down and keep them there as you stand up."),
       "feet": FEET,
   },
   # Collins 2021: the landmine squat drew less vastus medialis and
   # lateralis activity than the goblet squat at the same load (the app's
   # Goblet Squat: quadriceps 0.85, gluteus maximus 0.52), so the
   # quadriceps sit below it; the glutes as the goblet squat (not measured);
   # the erector spinae low (StrengthLog: lower back only secondary).
   activation=[("Quadriceps", P, HI, 0.78), ("Gluteus Maximus", S, MOD, 0.52),
               ("Erector Spinae", S, LOW, 0.30)],
   stabilisers=["adductors", "upper back", "forearms", "core"],
   comparison=("HANDLE DRIFTING AWAY", "Handle at chest height", "Arms reach, handle drifts away",
               "Held at chest height, the handle rides in on its arc and the trunk stays upright over the feet.",
               "When the arms reach forward, the load moves away from the body and pulls the chest down and forward."),
   glows=squat_glows("Landmine Squat"))

SETUP["Landmine Squat"] = [
    "Set one end of a barbell in a landmine or a corner and load the other end.",
    "Lift the loaded end (or a handle attachment on it) and hold it with both hands in front of your chest, at chest height.",
    "Stand facing the anchor, feet about shoulder-width, toes turned slightly out.",
    "Stand tall and brace before each rep.",
]

if __name__ == "__main__":
    names = ["Box Squat", "Pause Squat", "Safety Bar Squat", "Zercher Squat", "Overhead Squat", "Landmine Squat"]
    print("\n".join(validate(names) + validate_library(names)) or "OK")
