# Trainer content for the legs batch 300-350 (2026-09-26): split squats and
# rear-foot-elevated (Bulgarian) split squats from the quads series, converted
# from SourceExports/300-350 (316-322). Same format as spec.py, on top of
# common_300_350.py; spec_300_350.py collects this family with the lunges.
#
# What each model shows, from the rig (joint positions and angles sampled
# every 0.5 s, equipment bounds from the USD) and the framing screenshots.
# Every model keeps the LEFT foot forward for both reps (no leg switch), is
# framed from the lifter's left (the front leg on the left of the screen, the
# lifter facing screen-left) and does two reps in 8 s: 1.75 s down, a 0.33 s
# pause at the bottom, 1.42 s up. The rig's torso (neck to pelvis) is 0.59 m.
# - Barbell Split Squat (yaw -1.3): high bar across the upper traps (bar
#   ~11 cm behind and ~3 cm below the neck joint), grip ~0.78 m (hands ~20 cm
#   outside each shoulder, elbows bent and pointing down). Ankles ~0.90 m apart
#   front to back at the top (front 0.40 m ahead of the hips, back 0.50 m
#   behind), ~0.23 m apart side to side (hip width). Front foot flat; the back
#   foot stays on its ball all clip, heel up (back ankle 16-19 cm off the
#   floor, rising and coming ~8 cm forward as the knee drops). The hips sink
#   straight down (27 cm, at most 3 cm forward) to front knee 90°, back knee
#   87°, the front thigh just above parallel (~10° down to the knee), the front
#   shin ~9° forward with the kneecap ~9 cm behind the ball of the foot, and
#   the back kneecap ~12 cm off the floor (the builder: knee ~5 cm clear).
#   Front knee nearly straight at the top (175°). Trunk 3-6° forward; the bar
#   drifts ~6 cm forward as the trunk tips a little.
# - Dumbbell Split Squat (yaw -1.3): the same legs and trunk (3-6°). A
#   dumbbell in each hand at arm's length (elbows straight), handles pointing
#   front to back (palms in), hands ~0.32 m either side of the midline beside
#   the hips, 2-8 cm in front of the start hip line.
# - Smith Machine Split Squat (yaw -1.0): the same legs. Smith bar across the
#   upper traps, same grip as the barbell. The bar runs straight up and down
#   (no fore-aft travel) above the start hip line, the rails ~3 cm behind it,
#   about midway between the front ankle and the back ball of the foot. Trunk
#   9° forward at the top and 6° at the bottom: the lifter sinks under the
#   fixed bar and gets slightly more upright.
# - Front-Foot-Elevated Split Squat (yaw -1.3): dumbbells at the sides as the
#   dumbbell split squat. The whole front foot flat on a 10 cm step (0.52 x
#   0.42 m); back foot on the floor, on its ball. Ankles ~0.86 m apart front to
#   back at the top (0.46 m ahead, 0.40 m behind), ~0.23 m side to side. Much
#   deeper: front knee 175° -> 63°, front hip (trunk-thigh) 141° -> 80°, the
#   front thigh ~3° past parallel, the front shin 23° forward with the kneecap
#   level with the ball of the foot; back knee 88°, back kneecap ~10 cm off
#   the floor (the builder: ~4 cm clear). The hips drop 37 cm (27 cm in the
#   flat split squat) and travel ~18 cm forward toward the front foot. Trunk
#   4-9° forward.
# - Rear-Foot-Elevated Split Squat (yaw -1.3): dumbbells at the sides, palms
#   in. Back foot laces-down on a flat bench, pad top 0.48 m (the rig's
#   standing knee height), the ankle ~8 cm onto the pad and the toes behind it
#   at the same height. Front ankle 0.36 m ahead of the hips, 0.75 m in front
#   of the bench edge; feet ~0.24 m apart side to side. Front knee 154° at the
#   top (never fully straight) -> 79°, the front thigh about parallel (~3°
#   down to the knee), the front shin 14° forward with the kneecap ~7 cm behind
#   the ball of the foot; the back knee stays bent (71-81°) and its kneecap
#   bottoms out ~16 cm off the floor. Hips drop 33 cm straight down (at most
#   2 cm forward). Trunk 6° -> 12° forward at the bottom. Compared with the
#   older Bulgarian Split Squat model (BulgarianSplitSquatUpright, framed
#   front-on): that one stands wider (feet ~0.32 m apart side to side vs
#   ~0.24 m) and a little shorter (ankles 0.77 m apart front to back vs
#   0.83 m), locks the front knee out further at the top (167° vs 154°), leans
#   more at the bottom (10° -> 20° vs 6° -> 12°) and drops in ~1.2 s with a
#   longer hold at the bottom; the legs, bench height and depth (front knee
#   ~77-79°) are otherwise the same exercise.
# - Barbell Bulgarian Split Squat (yaw -1.0): the rear-foot-elevated legs
#   (same bench, stance and depth; front knee 151° -> 77°) with the high bar
#   and grip of the barbell split squat (bar ~11 cm behind and 1-3 cm below
#   the neck joint). Trunk 6° -> 12°; the bar moves ~8 cm forward from the top
#   to the bottom as the trunk tips.
# - Smith Machine Bulgarian Split Squat (yaw -1.0): the same legs (front knee
#   153° -> 78°) inside the Smith machine, the bench behind the rails (its edge
#   0.39 m behind the hips), the bar on the upper traps running straight up and
#   down above the start hip line, the rails ~3 cm in front of it. The trunk
#   holds 12-14° forward all clip, more than the free-bar version at the top.
#
# Sources (each checked; notes_300_350_splitsquat.md maps the claims to them):
# - Mausehund L, Skard AE, Krosshaug T 2019, J Strength Cond Res 33(Suppl 1):
#   S85-S94, doi 10.1519/JSC.0000000000002617 — high-bar barbell split squat,
#   rear-foot-elevated split squat and single-leg squat at 6-8RM to failure:
#   no difference in vastus lateralis (95-101% MVIC) or gluteus maximus
#   (71-79% MVIC) peaks between them; biceps femoris higher in the RFESS
#   (76.1%) than the split squat (62.3%); gluteus medius 54.9% vs 46.2% (a
#   trend only); hamstrings-to-quadriceps ratios below 1, so all quadriceps
#   dominant; 6RM loads 70.9 kg split squat vs 57.3 kg RFESS. Set-up: step
#   length = leg length (ASIS to medial malleolus), step width 75% of hip
#   width, back knee lowered to the floor (a pad in the RFESS), knee bent to
#   ~100-110°; in the RFESS the TOES of the rear foot rested on a box of tibia
#   length, not the laces these models use.
# - DeForest BA, Cantrell GS, Schilling BK 2014, Int J Exerc Sci 7(4):302-310
#   — back squat vs rear-leg-elevated split squat vs split squat (50% of the
#   back squat load, rear foot on a 40 cm stand, top of the ankle supported):
#   only biceps femoris differed (higher in the RLESS than the split squat);
#   front-leg peak vertical force higher in the RLESS than the split squat.
# - Andersen V et al. 2014, Int J Sports Med 35(14):1196-1202, doi
#   10.1055/s-0034-1382016 — Bulgarian squat vs squat at 6RM: biceps femoris
#   63-77% and external oblique higher, rectus femoris 16-21% lower, vasti
#   similar.
# - McCurdy K et al. 2010, J Sport Rehabil 19(1):57-70, doi
#   10.1123/jsr.19.1.57 — modified single-leg squat (rear foot elevated) vs
#   two-leg squat at the same relative load: more gluteus medius and hamstring
#   EMG, less quadriceps.
# - McCurdy K 2017, Strength Cond J 39(6):93-97, doi
#   10.1519/SSC.0000000000000319 — RFESS technique: top of the rear foot on the
#   support, ankle plantar-flexed (toe-tip contact is an error); support from
#   ~15 cm to knee height, near knee height recommended; feet about hip width;
#   near-vertical torso (forward lean not recommended with a bar on the
#   shoulders); lead-foot weight mid-foot or near the heel; bar tracks
#   vertically; lead knee tracks the foot, about over the toe line; errors
#   include excessive lean, knee valgus, lateral pelvic tilt, the ankle/tibia
#   on the pad and feet in line; the Smith machine reduces frontal-plane
#   muscle activation. The top-of-foot support takes most of the load off the
#   trail leg, which still adds some support; dumbbells lower the centre of
#   mass and can make the lift steadier; with a free bar and heavy loads, work
#   inside a squat rack with spotters (the high centre of mass makes torso
#   sway hard to recover).
# - McCurdy K, Walker J, Kelly C, Polinski M 2021, J Strength Cond Res
#   35(5):1201-1207, doi 10.1519/JSC.0000000000004035 — hip thrust vs RFESS
#   at 80% 1RM in trained women: in the RFESS the gluteus maximus, vastus
#   lateralis and medial and lateral hamstrings were all most active in the
#   bottom third of the hip range of motion.
# - Mackey ER, Riemann BL 2021, Int J Exerc Sci 14(1):533-543, doi
#   10.70252/CIYT8956 — high-bar Bulgarian split squat (35% 1RM) vs back squat
#   (70% 1RM): both hip dominant by joint moments; in the Bulgarian the knee
#   moment impulse was below the ankle's (the reverse of the back squat), and
#   the knee's peak displacement was smaller than in the back squat.
# - Aygun-Polat E et al. 2025, BMC Sports Sci Med Rehabil 17(1):251, doi
#   10.1186/s13102-025-01306-z — trunk flexion in the Bulgarian split squat
#   raised gluteus maximus, biceps femoris and rectus femoris activation.
# - Farrokhi S et al. 2008, J Orthop Sports Phys Ther 38(7):403-409, doi
#   10.2519/jospt.2008.2634 — forward trunk in the lunge raised hip extensor
#   impulse and gluteus maximus and biceps femoris EMG of the lead leg.
# - Escamilla RF et al. 2025, J Funct Morphol Kinesiol 10(1):42, doi
#   10.3390/jfmk10010042 — dumbbell (12RM) forward lunges with and without a
#   stride (without = feet stationary, a split squat), long step (front shin
#   about vertical at the bottom) vs short step (knee 8-10 cm past the toes).
#   Main effects: the long step drew more vasti, hamstring, gastrocnemius and
#   gluteus maximus activity on the descent and more adductor longus on the
#   ascent. Without a stride, long step: vasti 62-63% MVIC, hamstrings 21-23%
#   and gastrocnemius 20% on the ascent, adductor longus and gluteus medius
#   21% on the descent; gluteus maximus ~48% on the ascent without a stride
#   (both step lengths together). The short step without a stride drew more
#   vasti on the ascent (75-76%). The paper's high gluteus medius conclusion
#   comes from the stride conditions; without a stride it was 15-21% MVIC.
# - Escamilla RF et al. 2008, J Orthop Sports Phys Ther 38(11):681-690, doi
#   10.2519/jospt.2008.2694 — patellofemoral force and stress rise with knee
#   flexion and are higher with a short step than a long step at 70-90°.
# - Stastny P et al. 2015, J Strength Cond Res 29(11):3177-3187, doi
#   10.1519/JSC.0000000000000976 — split squats with one dumbbell (5RM):
#   gluteus medius above 40% MVIC in the lowering phase in resistance-trained
#   lifters (46% with the dumbbell in the opposite hand; 27% in untrained
#   lifters); vasti mostly under 45% MVIC; biceps femoris the lowest of the
#   muscles measured.
# - Wu HW et al. 2020, J Sport Rehabil 29(2):200-205, doi 10.1123/jsr.2018-0182
#   — lunges loaded by barbell, dumbbells or vest: no difference in muscle
#   activation between the devices. Measured thigh and lower-leg muscles only
#   (quadriceps, hamstrings, tibialis anterior, gastrocnemius), not the glutes;
#   the abstract does not say how the loads were matched.
# - Schütz P et al. 2014, J Appl Biomech 30(3):373-380, doi
#   10.1123/jab.2013-0175 — barbell split squats: step length and front shin
#   angle change the front knee and hip ranges and moments and the rear leg's.
# - Fry AC, Smith JC, Schilling BK 2003, J Strength Cond Res 17(4):629-633 —
#   stopping the knees at the toes cut knee torque but raised hip torque and
#   trunk lean; some forward knee travel is appropriate.
# - Powers CM 2010, J Orthop Sports Phys Ther 40(2):42-51, doi
#   10.2519/jospt.2010.3337 — poor hip, pelvis and trunk control affects knee
#   mechanics (review).
# - Glassbrook DJ et al. 2017, J Strength Cond Res 31(9):2618-2634, doi
#   10.1519/JSC.0000000000002007 — high-bar back squats keep a more upright
#   torso and more quadriceps; low-bar squats lean further forward.
# - Caterisano A et al. 2002, J Strength Cond Res 16(3):428-432 — gluteus
#   maximus share of the concentric EMG rose with squat depth (16.9% partial,
#   28.0% parallel, 35.4% full).
# - Kubo K, Ikebukuro T, Yata H 2019, Eur J Appl Physiol 119(9):1933-1942, doi
#   10.1007/s00421-019-04181-y — full squat training grew the gluteus maximus
#   and adductors more than half squats; knee extensors similarly.
# - Schwanbeck S, Chilibeck PD, Binsted G 2009, J Strength Cond Res
#   23(9):2588-2591, doi 10.1519/JSC.0b013e3181b1b181 — free squat drew 43%
#   more EMG averaged over the muscles than the Smith machine squat, with
#   gastrocnemius 34%, biceps femoris 26% and vastus medialis 49% higher.
# - Anderson K, Behm DG 2005, Can J Appl Physiol 30(1):33-45, doi
#   10.1139/h05-103 — trunk and soleus activity lowest on the Smith squat.
# - Liao K et al. 2023, PeerJ 11:e15863, doi 10.7717/peerj.15863 — free-weight
#   vs Smith machine Bulgarian split squat load-velocity profiles (no EMG):
#   cited only to note that no Smith Bulgarian EMG study was found.
# - ExRx.net, exrx.net/WeightExercises/Quadriceps/ BBSplitSquat, DBSplitSquat,
#   SMSplitSquat, BBSingleLegSplitSquat and SMSingleLegSplitSquat, read
#   through Internet Archive copies (web.archive.org, 2021-2026 snapshots)
#   because exrx.net blocks automated fetches: filed under the quadriceps,
#   target quadriceps; synergists gluteus maximus, adductor magnus, soleus;
#   dynamic stabilisers hamstrings, gastrocnemius; torso upright; knees point
#   the same way as the feet; rear heel may stay up; rear knee almost touches
#   the floor; feet further apart emphasise the gluteus maximus. Smith Split
#   Squat: bar at upper-chest height, disengage it by rotating the bar back;
#   front foot further forward emphasises the gluteus maximus, closer under
#   the bar the quadriceps. Smith Single Leg Split Squat: bench behind the
#   bar, keep the front foot flat.
# - StrengthLog, Bulgarian Split Squat guide (quadriceps, glutes, adductors;
#   knee-height bench about one long step behind).
# No EMG study was found for the front-foot-elevated split squat or for Smith
# machine split squats; their rows are ranked from the closest studied lifts
# (the flat split squat plus the squat-depth studies; the free-weight
# versions plus the Smith squat studies) and kept modest (see the notes).

from common_300_350 import *

NAMES = ["Barbell Split Squat", "Dumbbell Split Squat", "Smith Machine Split Squat",
         "Front-Foot-Elevated Split Squat", "Rear-Foot-Elevated Split Squat",
         "Barbell Bulgarian Split Squat", "Smith Machine Bulgarian Split Squat"]


def leg_glows(name, glute_dx=0.03):
    """The front (left) thigh's quadriceps, then the glutes behind the hip
    (the lifter faces screen-left, so behind is to the right)."""
    return [glow(name, ["thigh_L", "patella_L"], A, 0.55, rx=0.12, ry=0.06),
            glow(name, ["pelvis", "thigh_L"], SOFT, 0.30, rx=0.07, ry=0.06, dx=glute_dx)]


# ---------------------------------------------------------------- shared cues

TORSO_DB = ("Torso Position",
            "The torso stays tall, shoulders over the hips.",
            "Upright, the load stays over the front leg, where the quadriceps and glutes share the work. A deliberate forward lean adds work for the glutes and hamstrings, as lunge and Bulgarian split squat studies with the trunk tipped forward have shown, but folding over at the bottom also asks the lower back to hold the trunk and is harder to balance on a split stance.",
            "The chest folding forward over the front thigh at the bottom of the rep without meaning to.",
            "Keep the chest up and the shoulders stacked over the hips from the top of the rep to the bottom.")
TORSO_BAR = ("Torso Position",
             "The torso stays tall under the bar.",
             "Upright, the bar stays over the middle of the stance and the legs do the work. Leaning forward with a bar on the back lengthens the lever on the lower back and makes the load hard to balance on a narrow split stance.",
             "The chest tipping forward at the bottom, taking the bar out in front of the hips.",
             "Brace, keep the chest up and the shoulders over the hips, and let the bar travel straight down and up.")
TORSO_SMITH = ("Torso Position",
               "The hips stay under the fixed bar, the torso close to upright.",
               "The bar can only move straight up and down, so leaning forward means the hips slide back behind it and the chest folds toward the thigh, shifting work from the front knee to the hips and lower back.",
               "The hips sliding back behind the bar and the chest folding forward under it at the bottom.",
               "Keep the hips under the bar and the chest up, and sink straight down along the bar's track.")
KNEE = ("Knee Tracking",
        "The front knee travels in line with the front foot.",
        "Some forward knee travel is normal and loads the quadriceps. A knee that caves inward often shows the hip losing control of the thigh, so the knee takes the load at an angle.",
        "The front knee caving inward toward the back leg at the bottom or on the way up.",
        "Keep the front knee pointing over the middle toes, in line with the foot, all the way down and up.")
DEPTH_FLAT = ("Depth",
              "Each rep sinks straight down until the back knee is just off the floor.",
              "Lowering until the front thigh is about parallel takes the front leg's quadriceps and glutes through a long range. Letting the hips drift forward instead of down shortens the rep and leaves the back knee high.",
              "Stopping halfway, the hips drifting forward instead of sinking, so the back knee stays well off the floor.",
              "Lower the back knee straight down until it is just above the floor and the front thigh is about parallel, then drive up through the front foot.")
DEPTH_BSS = ("Depth",
             "Sink straight down until the back knee is a hand's width off the floor.",
             "In the rear-foot-elevated split squat the glutes, hamstrings and quadriceps are most active in the bottom third of the rep, so stopping short skips the part that works them hardest. With the back foot up, the front leg also carries more of the load than in a flat split squat.",
             "Stopping halfway, the hips drifting forward instead of down, so the back knee stays high.",
             "Lower the back knee straight toward the floor until the front thigh is about parallel, then drive up through the whole front foot.")
# The Smith lifts sink straight down the bar's track: the rails keep the hips
# from drifting forward, so their depth mistake is only stopping high.
DEPTH_SMITH = ("Depth",
               "Each rep sinks straight down the bar's track until the back knee is just off the floor.",
               "Lowering until the front thigh is about parallel takes the front leg's quadriceps and glutes through a long range. The rails fix the bar's path, so how far you lower is the main thing left to control.",
               "Stopping halfway down the track, the hips high and the back knee well off the floor.",
               "Lower the back knee straight down until it is just above the floor and the front thigh is about parallel, then drive up through the front foot.")
DEPTH_BSS_SMITH = ("Depth",
                   "Sink straight down the bar's track until the back knee is a hand's width off the floor.",
                   DEPTH_BSS[2],
                   "Stopping halfway down the track, the hips high and the back knee well off the floor.",
                   DEPTH_BSS[4])
HEEL = ("Front Foot",
        "The whole front foot stays planted.",
        "Pressure through the heel and mid-foot keeps you balanced over the front leg so the quadriceps and glutes can drive the rep. Forward knee travel is fine; a heel that lifts tips the load onto the toes.",
        "The front heel peeling off the floor as the knee drives forward, usually from a stance that is too short.",
        "Set a long enough stance, keep the front heel down and push the floor away through the heel and mid-foot.")
GRIP = ("Load Position",
        "The dumbbells hang straight down at your sides.",
        "Hanging at arm's length beside the hips, the weights keep the centre of mass low, which steadies the split stance and lets the torso stay upright while the front leg does the work. In lunges, barbell and dumbbell loading have drawn similar thigh and calf muscle activity.",
        "The dumbbells swinging forward in front of the thighs at the bottom instead of hanging at the sides.",
        "Hold the dumbbells with the palms facing in, arms long and shoulders down, and let them travel straight down and up beside the hips.")
BAR = ("Bar Position",
       "The bar sits high across the upper traps.",
       "A high bar keeps the torso upright over the split stance, which suits this quadriceps-led lift; in back squats a lower bar brings more forward lean.",
       "The bar sliding down onto the back of the shoulders, the chest tipping forward to balance it.",
       "Set the bar across the upper traps just below the neck, hands wider than the shoulders, and keep the chest tall under it.")
BAR_SMITH = ("Bar Position",
             "The bar rests high on the upper traps and runs on a fixed track.",
             "The rails hold the bar's line, so the body has to stay stacked under it. With the bar high on the traps the torso can stay upright while the legs do the work.",
             "Setting the bar low on the back of the shoulders, so the chest tips forward and the hips slide back under the fixed bar.",
             "Rest the bar across the upper traps, hands wider than the shoulders, brace, then turn the bar to unhook it.")
REAR = ("Rear Foot",
        "The laces of the back foot rest on the bench.",
        "With the top of the foot on the bench and the ankle pointed, the back foot has a stable contact. The back leg steadies you and takes only a small share of the load, so the front leg does most of the work. Perching on the tips of the toes with the ankle bent makes that support less stable.",
        "Perching the back foot on the tips of the toes on the bench, the ankle bent and the heel up.",
        "Rest the laces flat on a bench about knee height, ankle pointed, and let the back leg steady you while the front leg does the work.")

# Split squats (flat): quadriceps first, gluteus maximus close behind (Mausehund
# 2019 peaks: vastus lateralis ~95-101% > gluteus maximus 71-79% MVIC;
# Escamilla 2025 without a stride: vasti 62-63% > gluteus maximus ~48%). The
# hamstrings and gluteus medius follow about level: Mausehund biceps femoris
# 62% > gluteus medius 46%, Escamilla hamstrings 21-23% vs gluteus medius 21%,
# Stastny gluteus medius >40% with the biceps femoris lowest. No split squat
# study measured the adductor magnus, so the adductors sit with the
# stabilisers (Escamilla: adductor longus ~21%).
ACT_FLAT = [("Quadriceps", P, HI, 0.86), ("Gluteus Maximus", S, MOD, 0.62),
            ("Hamstrings", S, MOD, 0.40), ("Gluteus Medius", S, MOD, 0.40)]
# Rear foot up: hamstrings rise (Mausehund 62 -> 76% MVIC; DeForest, Andersen,
# McCurdy 2010), gluteus medius a little higher (Mausehund 46 -> 55%, a trend;
# McCurdy 2010).
ACT_RFE = [("Quadriceps", P, HI, 0.86), ("Gluteus Maximus", S, MOD, 0.64),
           ("Hamstrings", S, MOD, 0.48), ("Gluteus Medius", S, MOD, 0.44)]

# ---------------------------------------------------------------- flat split squats

ex(name="Barbell Split Squat", var="barbellSplitSquat",
   # Front leg on the left, back leg on the right. The heel label sits low on
   # the left between the front knee and the shoe (short, so it ends before
   # the shin); the torso label stays short enough to clear the face at the
   # bottom (head at 0.45, 0.32).
   overrides={"bar": (0.14, "trailing"), "torso": (0.32, "leading"), "knee": (0.50, "leading"),
              "depth": (0.50, "trailing"), "heel": (0.80, "leading")},
   annotations=[
       ("bar", "Bar high on the traps", "support_TrapeziusUpper_L"),
       ("torso", "Stay tall", "chest"),
       ("knee", "Knee tracks toes", "patella_L"),
       ("depth", "Back knee down", "patella_R"),
       ("heel", "Heel down", "foot_L"),
   ],
   cues={"bar": BAR, "torso": TORSO_BAR, "knee": KNEE, "depth": DEPTH_FLAT, "heel": HEEL},
   activation=ACT_FLAT,
   stabilisers=["adductors", "erector spinae", "calves", "core"],
   comparison=("TORSO TIPS FORWARD", "Chest up, bar over mid-stance", "Chest tips forward under the bar",
               "Staying tall keeps the bar over the middle of the stance, so the front leg's quadriceps and glutes drive the rep.",
               "Tipping forward takes the bar out in front of the hips, lengthening the lever on the lower back and making the narrow stance hard to balance."),
   glows=leg_glows("Barbell Split Squat"))

SETUP["Barbell Split Squat"] = [
    "Set the bar in a rack at upper-chest height and take it high across your upper traps.",
    "Grip it wider than your shoulders and step back from the rack.",
    "Step one foot a long stride forward, feet hip-width apart.",
    "Rise onto the ball of the back foot and brace, chest tall.",
]

ex(name="Dumbbell Split Squat", var="dumbbellSplitSquat",
   # As the barbell split squat; the near (left) hand hangs by the hip, so the
   # load label sits on the right above the back-knee label, kept to 18
   # characters so its left end clears the near shoulder and upper arm
   # (u 0.51-0.56).
   overrides={"grip": (0.32, "trailing"), "torso": (0.32, "leading"), "knee": (0.50, "leading"),
              "depth": (0.50, "trailing"), "heel": (0.80, "leading")},
   annotations=[
       ("grip", "Dumbbells at sides", "hand_L"),
       ("torso", "Stay tall", "chest"),
       ("knee", "Knee tracks toes", "patella_L"),
       ("depth", "Back knee down", "patella_R"),
       ("heel", "Heel down", "foot_L"),
   ],
   cues={"grip": GRIP, "torso": TORSO_DB, "knee": KNEE, "depth": DEPTH_FLAT, "heel": HEEL},
   activation=ACT_FLAT,
   stabilisers=["adductors", "calves", "forearms", "core"],
   comparison=("FRONT KNEE CAVING IN", "Knee in line with the foot", "Front knee collapses inward",
               "With the knee over the middle toes, the front leg's quadriceps and glutes drive the rep straight up.",
               "When the front knee caves in, the hip is often losing control of the thigh and the knee takes the load at an angle."),
   glows=leg_glows("Dumbbell Split Squat"))

SETUP["Dumbbell Split Squat"] = [
    "Hold a dumbbell in each hand at your sides, palms facing in.",
    "Step one foot a long stride forward, feet hip-width apart.",
    "Rise onto the ball of the back foot.",
    "Stand tall with your shoulders over your hips.",
]

ex(name="Smith Machine Split Squat", var="smithMachineSplitSquat",
   # Framed three-quarter (yaw -1.0): the plates and rails fill the upper
   # right, the front shin sits further right than side-on, so the stance
   # label fits low on the left. The torso label names the chest its dot
   # sits on (20 characters, ending at u 0.39, clear of the head at 0.47).
   overrides={"bar": (0.14, "trailing"), "torso": (0.32, "leading"), "knee": (0.50, "leading"),
              "depth": (0.50, "trailing"), "stance": (0.80, "leading")},
   annotations=[
       ("bar", "Bar high on the traps", "support_TrapeziusUpper_L"),
       ("torso", "Chest up, hips under", "chest"),
       ("knee", "Knee tracks toes", "patella_L"),
       ("depth", "Back knee down", "patella_R"),
       ("stance", "Long stance", "foot_L"),
   ],
   cues={
       "bar": BAR_SMITH, "torso": TORSO_SMITH, "knee": KNEE, "depth": DEPTH_SMITH,
       "stance": ("Stance",
                  "The feet split so the bar runs over the middle of the stance.",
                  "The Smith bar only moves straight up and down, so where the front foot sits decides how the work is shared: closer under the bar, the knee travels further forward and the quadriceps work harder; further ahead, the glutes and hamstrings do more. Forward knee travel is fine; the problem is a foot so close that the heel cannot stay down.",
                  "Setting the front foot so close under the bar that the front heel peels up as the knee drives forward at the bottom.",
                  "Step the front foot far enough ahead of the bar that the whole foot stays flat at the bottom, the back foot behind it, hip-width apart, so the bar runs over the middle of the stance."),
   },
   # A step below the free split squat: the free squat drew more EMG than
   # the Smith squat, the biceps femoris 26% more (Schwanbeck 2009), and the
   # Smith machine cuts frontal-plane stabilising work (McCurdy 2017).
   activation=[("Quadriceps", P, HI, 0.82), ("Gluteus Maximus", S, MOD, 0.58),
               ("Gluteus Medius", S, LOW, 0.34), ("Hamstrings", S, LOW, 0.32)],
   stabilisers=["adductors", "calves", "core"],
   comparison=("FRONT FOOT TOO CLOSE", "Foot ahead of the bar, heel down", "Foot under the bar, heel lifts",
               "With the front foot ahead of the bar, the whole foot stays planted and the fixed bar travels over the middle of the stance.",
               "Tucked under the fixed bar, the front knee has to travel well forward and the heel peels up, tipping the load onto the toes."),
   glows=leg_glows("Smith Machine Split Squat"))

SETUP["Smith Machine Split Squat"] = [
    "Set the Smith bar at upper-chest height and step under it.",
    "Rest it high across your upper traps, hands wider than your shoulders.",
    "Split your feet a long stride apart, the bar over the middle of your stance.",
    "Rise onto the ball of the back foot, then turn the bar to unhook it.",
]

ex(name="Front-Foot-Elevated Split Squat", var="frontFootElevatedSplitSquat",
   # As the dumbbell split squat (the load label kept to 18 characters so it
   # clears the near arm); at the bottom the front knee reaches 0.18 on the
   # left, so the heel label is kept to nine characters.
   overrides={"grip": (0.32, "trailing"), "torso": (0.32, "leading"), "knee": (0.50, "leading"),
              "depth": (0.50, "trailing"), "step": (0.80, "leading")},
   annotations=[
       ("grip", "Dumbbells at sides", "hand_L"),
       ("torso", "Stay tall", "chest"),
       ("knee", "Knee tracks toes", "patella_L"),
       ("depth", "Back knee down", "patella_R"),
       ("step", "Heel down", "foot_L"),
   ],
   cues={
       "grip": GRIP, "torso": TORSO_DB, "knee": KNEE,
       "depth": ("Depth",
                 "The step lets the back knee sink almost to the floor.",
                 "Raising the front foot adds range: the front hip and knee bend further than in a flat split squat. In squat studies, going deeper brought the glutes in more, and full squat training built more glute and adductor muscle than half squats.",
                 "Stopping at flat split squat depth, the hips high and the back knee well off the floor.",
                 "Sink until the back knee is just above the floor and the front thigh is just below parallel, then drive up through the whole front foot. If your knees are sensitive, build up to the depth gradually."),
       "step": ("Front Foot on the Step",
                "The whole front foot stays flat on the step.",
                "With the heel on the step, the extra depth comes from the hip and knee and the load goes through the heel and mid-foot. At this depth the knee travels well forward, to about over the toes, which is expected as long as the heel stays down.",
                "The front heel lifting off the step as the knee drives forward at the bottom.",
                "Place the whole front foot on the step, keep the heel down and push through the heel and mid-foot to stand."),
   },
   # No study of this variation: the flat split squat's ranks with the
   # gluteus maximus raised for the extra depth (Caterisano 2002, bilateral
   # squats: only the gluteus maximus share rose with depth; the biceps
   # femoris and vasti shares did not change).
   activation=[("Quadriceps", P, HI, 0.86), ("Gluteus Maximus", S, MOD, 0.66),
               ("Hamstrings", S, MOD, 0.40), ("Gluteus Medius", S, MOD, 0.40)],
   stabilisers=["adductors", "calves", "forearms", "core"],
   comparison=("STOPPING SHORT", "Back knee almost to the floor", "Hips stop high, back knee up",
               "Using the range the step adds takes the front hip and knee deeper, the range where squat studies found the glutes working harder.",
               "Stopping at flat split squat depth wastes the step: the front leg never reaches the deeper range the variation is for."),
   glows=leg_glows("Front-Foot-Elevated Split Squat"))

SETUP["Front-Foot-Elevated Split Squat"] = [
    "Place a low step, about 10 cm high, in front of you.",
    "Hold a dumbbell in each hand at your sides, palms facing in.",
    "Put your whole front foot on the step, a long stride ahead of the back foot.",
    "Rise onto the ball of the back foot, feet hip-width apart.",
]

# ---------------------------------------------------------------- rear foot elevated

ex(name="Rear-Foot-Elevated Split Squat", var="rearFootElevatedSplitSquat",
   # The back foot lies on the bench on the right; its label sits just below
   # it (0.64 on screen), under the bench-foot ghost, which rises ~15 cm above
   # the bench and crossed the label at 0.48. The back-knee label goes below
   # it on the lowest row (0.747 on screen), a short, nearly level leader to
   # the back kneecap at the bottom. The torso label is kept short to clear
   # the face at the bottom (head at 0.37, 0.34).
   overrides={"grip": (0.14, "trailing"), "torso": (0.32, "leading"), "knee": (0.50, "leading"),
              "depth": (0.80, "trailing"), "rear": (0.68, "trailing")},
   annotations=[
       ("grip", "Dumbbells at sides", "hand_L"),
       ("torso", "Stay tall", "chest"),
       ("knee", "Knee tracks toes", "patella_L"),
       ("depth", "Back knee down", "patella_R"),
       ("rear", "Laces on bench", "foot_R"),
   ],
   cues={"grip": GRIP, "torso": TORSO_DB, "knee": KNEE, "depth": DEPTH_BSS, "rear": REAR},
   activation=ACT_RFE,
   stabilisers=["adductors", "calves", "forearms", "core"],
   comparison=("FRONT KNEE CAVING IN", "Knee in line with the foot", "Front knee collapses inward",
               "With the knee in line with the foot, the front leg's quadriceps and glutes drive the rep while the hip holds the thigh steady.",
               "On one working leg the hip has to keep the knee in line; when it caves in, the knee takes the load at an angle."),
   glows=leg_glows("Rear-Foot-Elevated Split Squat"))

SETUP["Rear-Foot-Elevated Split Squat"] = [
    "Hold a dumbbell in each hand at your sides, palms facing in.",
    "Stand a long stride in front of a knee-height bench.",
    "Reach one foot back and rest its laces on the bench.",
    "Set your front foot flat, hip-width from the back foot.",
]

ex(name="Barbell Bulgarian Split Squat", var="barbellBulgarianSplitSquat",
   # Three-quarter (yaw -1.0): the near plate fills the upper right, the head
   # comes down to 0.33, 0.35, so the torso and knee labels stay short; as on
   # the dumbbell version the bench-foot label sits just below the foot (0.64
   # on screen, clear of its ghost) and the back-knee label on the lowest row
   # below it, its leader short and nearly level to the back kneecap at the
   # bottom (not across the plate).
   overrides={"bar": (0.14, "trailing"), "torso": (0.32, "leading"), "knee": (0.50, "leading"),
              "depth": (0.80, "trailing"), "rear": (0.68, "trailing")},
   annotations=[
       ("bar", "Bar high on the traps", "support_TrapeziusUpper_L"),
       ("torso", "Stay tall", "chest"),
       ("knee", "Knee tracks toes", "patella_L"),
       ("depth", "Back knee down", "patella_R"),
       ("rear", "Laces on bench", "foot_R"),
   ],
   cues={"bar": BAR, "torso": TORSO_BAR, "knee": KNEE, "depth": DEPTH_BSS, "rear": REAR},
   activation=ACT_RFE,
   stabilisers=["erector spinae", "adductors", "calves", "core"],
   comparison=("TORSO TIPS FORWARD", "Tall, bar straight down", "Chest folds toward the thigh",
               "Staying tall lets the bar travel straight down and up, so the front leg does the lifting under a load the trunk can hold.",
               "Leaning forward with a bar on the back is hard to control on one leg and loads the lower back; technique guides advise against it with a loaded bar."),
   glows=leg_glows("Barbell Bulgarian Split Squat"))

SETUP["Barbell Bulgarian Split Squat"] = [
    "Put a knee-height bench in a rack, safety bars just under the bar's lowest point.",
    "Take the bar high across your upper traps, hands wider than your shoulders.",
    "Stand a long stride in front of the bench and rest the laces of your back foot on it.",
    "Set your front foot flat, feet hip-width apart, and brace.",
]

ex(name="Smith Machine Bulgarian Split Squat", var="smithMachineBulgarianSplitSquat",
   # As the barbell Bulgarian (bench-foot label just below the foot, the
   # back-knee label on the lowest row below it); the head stays at u 0.39
   # all clip, so the torso label is the short Stay tall, which names the
   # chest its dot sits on.
   overrides={"bar": (0.14, "trailing"), "torso": (0.32, "leading"), "knee": (0.50, "leading"),
              "depth": (0.80, "trailing"), "rear": (0.68, "trailing")},
   annotations=[
       ("bar", "Bar high on the traps", "support_TrapeziusUpper_L"),
       ("torso", "Stay tall", "chest"),
       ("knee", "Knee tracks toes", "patella_L"),
       ("depth", "Back knee down", "patella_R"),
       ("rear", "Laces on bench", "foot_R"),
   ],
   cues={"bar": BAR_SMITH, "torso": TORSO_SMITH, "knee": KNEE, "depth": DEPTH_BSS_SMITH, "rear": REAR},
   # The free-weight Bulgarian's ranks a step lower on the Smith machine: the
   # hamstrings by about the Smith squat's biceps femoris drop (Schwanbeck
   # 2009: 26%), partly offset by this model's steadier 12-14° lean; the
   # gluteus medius lower as the rails take over side-to-side balance
   # (McCurdy 2017).
   activation=[("Quadriceps", P, HI, 0.84), ("Gluteus Maximus", S, MOD, 0.62),
               ("Hamstrings", S, MOD, 0.42), ("Gluteus Medius", S, LOW, 0.34)],
   stabilisers=["adductors", "calves", "core"],
   comparison=("STOPPING SHORT", "Back knee toward the floor", "Hips stop halfway down",
               "Sinking until the front thigh is about parallel takes the front leg through a long range while the rails keep the bar steady.",
               "Half reps skip the bottom third of the rep, where the glutes, hamstrings and quadriceps work hardest in this lift."),
   glows=leg_glows("Smith Machine Bulgarian Split Squat"))

SETUP["Smith Machine Bulgarian Split Squat"] = [
    "Set the Smith bar at upper-chest height, a knee-height bench a short step behind it.",
    "Rest the bar high across your upper traps, hands wider than your shoulders.",
    "Stand a long stride in front of the bench and rest the laces of your back foot on it.",
    "Set your front foot flat, then turn the bar to unhook it.",
]

if __name__ == "__main__":
    probs = validate(["Barbell Split Squat", "Dumbbell Split Squat", "Smith Machine Split Squat", "Front-Foot-Elevated Split Squat", "Rear-Foot-Elevated Split Squat", "Barbell Bulgarian Split Squat", "Smith Machine Bulgarian Split Squat"]); print("\n".join(probs) or "OK")
