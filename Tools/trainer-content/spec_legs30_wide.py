# Trainer content for the 30-leg set (2026-09-28), family "wide": the lateral
# lunge and Cossack squat, which shift from side to side, and three wide or
# goblet-loaded squats. Same format as spec.py, on top of common_legs30.py;
# spec_legs30.py collects this family with the others.
#
# What each model shows, from the motion briefs (briefs_legs30/: joint angles,
# positions and trunk lean every 0.5 s; Y up, the lifter faces +z, their left
# is +x), the app's stills with the final framing, and joints.json. Knee angle
# is the thigh-shin inner angle (180 straight); hip is the trunk-thigh inner
# angle; thigh angle is below horizontal at the knee (+ = hip above knee, i.e.
# above parallel). Rig shoulder joints are 0.39 m apart, torso (neck to
# pelvis) 0.59 m, thigh 0.44 m, shin 0.40 m. All five do two reps in 8 s.
# - Lateral Lunge (yaw -0.3, near front-on; the lifter's left is screen
#   right): bodyweight, hands clasped in front of the chest (elbows ~47°,
#   hands ~0.23 m in front of the body) all clip. Starts with the ankles
#   0.32 m apart, knees 170°, feet pointing straight ahead (0° toe-out, both
#   reps). Rep 1 the LEFT foot lifts ~3 cm and steps out 0.42 m (ankles
#   0.74 m apart), 0.46-1.71 s; the hips travel 0.54 m to that side, 0.29 m
#   back and 0.33 m down. The step lands in a centred wide half squat: at
#   1.0 s the pelvis is midway between the ankles, both knees ~135° and the
#   trunk 5° forward; only then do the hips shift and hinge over the left
#   leg. The other knee is still 135° at 1.5 s and 148° at 2.5 s and is
#   straight (171°) only at the bottom, 1.75-2.38 s. Bottom (1.75-2.38 s, deepest ~2.0 s): stepping knee
#   87°, stepping hip 49°, thigh 17° above parallel, shin 19° forward, the
#   kneecap 13 cm ahead of the ankle and straight over the foot side to side
#   (no inward drift); the other leg straight (knee 171°), its foot flat and
#   pointing ahead. Trunk 58° forward at the bottom (5° at mid-descent, 36°
#   at 1.5 s): a deep hip hinge, the head coming down to about hip height of
#   a standing lifter. Rises and steps back to the start 2.42-3.62 s, holds
#   the top to 4.4 s; rep 2 mirrors it to the RIGHT (deepest 5.92 s). The
#   stepping (bent) leg therefore changes between reps: the cues name
#   `_bent` / `_straight`. Both knees are ~135° in the centred half squat
#   (1.0 s: L 136 / R 134; 3.0 s: L 135 / R 133), where the trail knee is
#   marginally the more bent, so the app's more-bent-knee rule
#   (BodyFrame.bentSide) and probe.py hand the `_bent` role to the trail leg
#   there: in rep 1 it goes R (top) -> L (0.5 s) -> R (~1.0 s) -> L (1.5 s)
#   -> R (~3.0 s), mirrored in rep 2 (see the notes; a shared fix).
# - Cossack Squat (yaw -0.3): bodyweight, hands clasped at the chest as the
#   lateral lunge. A fixed, very wide stance: ankles 1.0 m apart (about 2.6x
#   the shoulder-joint width), toes turned out 20°, knees 170° at the top.
#   Rep 1 sinks over the LEFT leg 0.50-1.33 s, holds the bottom 1.38-2.25 s,
#   rises 2.29-3.46 s, holds the top to 4.46 s; rep 2 goes RIGHT (deepest
#   ~5.6 s). Bottom: bent knee 46°, bent hip 71°, thigh 5° past parallel
#   (knee above the hip joint), shin 36° forward, the kneecap 21 cm ahead of
#   and 16 cm outside the ankle (following the turned-out foot); the heel
#   stays down. The hips drop 0.47 m, travel 0.41 m to the side and 0.20 m
#   back. The other leg stays straight (knee 171°) and its foot turns up
#   onto the heel, toes pointing up (the still; its ankle moves 7 cm back).
#   Trunk 0° at the top to 16° at the bottom. The bent hip (71° inner, ~109°
#   of flexion) bends no further than in the sumo squats here (78-81°); only
#   the knee goes unusually deep.
# - Dumbbell Sumo Squat (yaw -0.5): ankles 0.78 m apart (2x the
#   shoulder-joint width), toes turned out 35°. One dumbbell held upright by
#   both hands at arm's length (elbows ~158°), hanging between the legs 18 cm
#   in front of the ankle line at the top and 6 cm at the bottom; its lower
#   end ~0.24 m off the floor at the bottom. Down 0.50-1.42 s, a 0.75 s pause
#   at the bottom (1.46-2.21 s), up 2.25-3.17 s, 1.25 s at the top; the same
#   for rep 2. Bottom: knees 72°, hips 81°, thighs parallel (0°), shins 17°
#   forward, the kneecaps 11 cm ahead of and 8 cm outside the ankles (a 36°
#   line, the toes' 35°); heels down. Hips drop 0.41 m and move 0.12 m back.
#   Trunk 4° at the top, 18° at the bottom, about the shins' angle.
# - Barbell Sumo Squat (yaw -0.8): the dumbbell sumo squat's legs and tempo
#   exactly (knees 72°, hips 78°, thighs parallel). A 2.06 m bar ~6 cm
#   behind the neck joint at its height (high on the upper traps), hands
#   0.78 m apart (about 0.2 m outside each shoulder joint), elbows bent ~45°
#   and pointing down. Trunk 4° -> 22°; the bar moves 6 cm forward from the
#   top to the bottom as the trunk tips.
# - Kettlebell Goblet Squat (yaw -0.5): ankles 0.42 m apart (about shoulder
#   width), toes out 12°. The kettlebell held by the sides of the handle,
#   bell down, against the chest (bell centre ~22 cm in front of and 23 cm
#   below the neck joint), elbows bent ~50° and pointing down. Same tempo as
#   the sumo squats (0.75 s pause at the bottom). Bottom: knees 56°, hips 91°,
#   thighs 13° above parallel (hip joint ~10 cm above the knee joint), shins
#   47° forward with the kneecaps 29 cm ahead of the ankles (well past the
#   toes) and 6 cm outside them; heels down. Hips drop 0.46 m, 0.11 m back.
#   Trunk 4° -> 14°, clearly more upright than the shins.
#
# Sources (each checked against its abstract, full text or archived page;
# notes_legs30_wide.md maps the claims to them):
# - Riemann B, Congleton A, Ward R, Davies GJ 2013, J Sports Med Phys Fitness
#   53(2):130-138 — forward vs lateral lunges at self-selected and 60%
#   height step lengths in 32 young adults: forward lunges placed the
#   greatest demands on the hip extensors; lateral lunges prompted greater
#   ankle flexion and greater ankle and knee extensor contributions.
# - Flanagan SP, Wang MY, Greendale GA, Azen SP, Salem GJ 2004, J Strength
#   Cond Res 18(3):599-605, doi 10.1519/1533-4287(2004)18<599:BAOLAF>2.0.CO;2
#   — older adults: the forward lunge targeted the hip extensors, the lateral
#   lunge the ankle plantar flexors; knee differences less consistent.
# - DiStefano LJ, Blackburn JT, Marshall SW, Padua DA 2009, J Orthop Sports
#   Phys Ther 39(7):532-540, doi 10.2519/jospt.2009.2796 — gluteal EMG in 12
#   exercises; the lateral (sideways) lunge values, gluteus maximus 41 +/- 20%
#   and gluteus medius 39 +/- 19% MVIC (bodyweight), read from the table of
#   Macadam P, Cronin J, Contreras B 2015, Int J Sports Phys Ther
#   10(5):573-591 (PMC4595911), which also lists Bouillon 2012's lateral lunge
#   (gluteus maximus 12%, medius 13% MVIC, a different normalisation).
# - Delmore RJ, Laudner KG, Torry MR 2014, J Sport Rehabil 23(2):79-87, doi
#   10.1123/jsr.2012-0046 — adductor longus EMG in six exercises; the
#   authors' overall ranking is side-lying adduction > ball squeezes > side
#   lunges > standing adduction on a Swiss ball > rotational squats > sumo
#   squats, but it is descriptive: only side-lying adduction (over all) and
#   ball squeezes (over rotational squats, sumo squats and Swiss-ball
#   adduction; average activation over side lunges) differed significantly;
#   all other peak comparisons P > .08.
# - Escamilla RF et al. 2008, Clin Biomech 23(8):1026-1037, doi
#   10.1016/j.clinbiomech.2008.05.002 — patellofemoral force and stress
#   higher in the side lunge than the forward lunge at 80-90° knee angles
#   (knee flexion, 0° = straight); the authors advise 0-50° over 60-90° to
#   limit patellofemoral stress. Escamilla R et al. 2022, Int J Sports Phys
#   Ther 17(2):174-184, doi 10.26603/001c.31876 — bodyweight: side lunge
#   higher than forward lunge between 40° and 100° knee angles.
# - McCaw ST, Melrose DR 1999, Med Sci Sports Exerc 31(3):428-436, doi
#   10.1097/00005768-199903000-00012 — narrow, shoulder-width and wide
#   (140%) parallel squats: stance width did not isolate parts of the
#   quadriceps but changed adductor longus and gluteus maximus activity.
# - Paoli A, Marcolin G, Petrone N 2009, J Strength Cond Res 23(1):246-250,
#   doi 10.1519/JSC.0b013e3181876811 — back squats at three widths: only the
#   gluteus maximus differed, higher at the widest stance; the adductor
#   magnus and the other thigh muscles did not.
# - Pereira GR et al. 2010, J Strength Cond Res 24(10):2749-2754, doi
#   10.1519/JSC.0b013e3181c6a139 — parallel squat with the hips turned out
#   30° or 50°: more hip adductor activity at 60-90° knee flexion than with
#   the hips neutral; both adductors and rectus femoris most active at
#   60-90°.
# - Escamilla RF, Fleisig GS, Lowry TM, Barrentine SW, Andrews JR 2001, Med
#   Sci Sports Exerc 33(6):984-998, doi 10.1097/00005768-200106000-00019 —
#   powerlifters: wide stance thighs more horizontal, shanks more vertical,
#   no difference in trunk position; greater knee and hip moments than the
#   narrow stance.
# - Escamilla RF et al. 2001, Med Sci Sports Exerc 33(9):1552-1566, doi
#   10.1097/00005768-200109000-00020 — no difference in muscle activity or
#   knee forces between feet straight and turned out 30°; narrow stance
#   more gastrocnemius than wide.
# - Lorenzetti S et al. 2018, BMC Sports Sci Med Rehabil 10:14, doi
#   10.1186/s13102-018-0103-7 (erratum: BMC Sports Sci Med Rehabil 12:7,
#   2020, doi 10.1186/s13102-020-0160-6) — stance width and foot angle change hip and
#   knee moments; large moments in the extreme positions, narrow with 42°
#   toe-out and wide with 0°, where special care is advised.
# - Lahti J, Hegyi A, Vigotsky AD, Ahtiainen JP 2019, Scand J Med Sci Sports
#   29(1):44-54, doi 10.1111/sms.13305 — wide stance: higher hip-to-knee
#   extensor moment ratios and knee adduction moments than narrow.
# - Hopkins JE, Hopkins CE, Chiu LZF 2024, J Biomech 177:112391, doi
#   10.1016/j.jbiomech.2024.112391 — hip extensor and lateral rotator
#   moments rise with stance width; the hip adductor moment does not change.
# - Sinclair J et al. 2022, Sports (Basel) 10(9):136, doi
#   10.3390/sports10090136 — modelled muscle forces: narrow stance more
#   quadriceps force, wide stance more posterior-chain force.
# - Lee CXY, Crossman AJ, Kedgley AE 2026, PLoS One 21(8):e0354893, doi
#   10.1371/journal.pone.0354893 — seven muscles; a wide stance raised
#   vastus medialis activity; no effect of stance on the rectus femoris,
#   gastrocnemius or gluteus maximus; overall no squat combination was
#   consistently favoured.
# - Demers E, Pendenza J, Radevich V, Preuss R 2018, Int J Exerc Sci
#   11(1):764-775, doi 10.70252/BWZE8275 (PMC6033510) — narrower stances needed more ankle dorsiflexion; lifters
#   with limited dorsiflexion may benefit from a wider stance.
# - Collins KS, Klawitter LA, Waldera RW, Mahoney SJ, Christensen BK 2021,
#   J Strength Cond Res 35(10):2661-2668, doi 10.1519/JSC.0000000000004094
#   — goblet squat vs landmine squat at 30% body mass: the goblet squat drew
#   more vastus medialis and lateralis activity and more vertical force.
# - Gullett JC, Tillman MD, Gutierrez GM, Chow JW 2009, J Strength Cond Res
#   23(1):284-292, doi 10.1519/JSC.0b013e31818546bb — front vs back squat:
#   bar position did not change muscle activity; the front squat had lower
#   knee compressive forces and extensor moments.
# - Caterisano A et al. 2002, J Strength Cond Res 16(3):428-432 — gluteus
#   maximus share of the concentric EMG rose with squat depth (16.9%
#   partial, 28.0% parallel, 35.4% full; n = 10, share of four muscles'
#   summed EMG).
# - Contreras B, Vigotsky AD, Schoenfeld BJ, Beardsley C, Cronin J 2016,
#   J Appl Biomech 32(1):16-22, doi 10.1123/jab.2015-0113 — upper and lower
#   gluteus maximus, biceps femoris and vastus lateralis EMG did not differ
#   between parallel, full and front squats (13 trained women): conflicting
#   evidence on glute EMG and depth, so the copy does not claim it.
# - Kubo K, Ikebukuro T, Yata H 2019, Eur J Appl Physiol 119(9):1933-1942,
#   doi 10.1007/s00421-019-04181-y — full squat training grew the gluteus
#   maximus and adductors more than half squats.
# - Macrum E, Bell DR, Boling M, Lewek M, Padua D 2012, J Sport Rehabil
#   21(2):144-150, doi 10.1123/jsr.21.2.144 — restricting ankle dorsiflexion
#   (12° forefoot wedge) in a squat increased knee valgus and medial knee
#   displacement and decreased quadriceps activation.
# - Myer GD et al. 2014, Strength Cond J 36(6):4-27, doi
#   10.1519/SSC.0000000000000103 — back squat assessment: trunk as upright as
#   possible, a guideline of the trunk parallel to the shins; excessive
#   trunk flexion or rounding a deficit; knee valgus linked to hip abductor
#   and external rotator weakness and restricted dorsiflexion; heels lifting
#   suboptimal (smaller base of support, compensations up the chain).
# - Farrokhi S et al. 2008, J Orthop Sports Phys Ther 38(7):403-409, doi
#   10.2519/jospt.2008.2634 — forward trunk in the forward lunge raised hip extensor
#   impulse and gluteus maximus and biceps femoris EMG.
# - Fry AC, Smith JC, Schilling BK 2003, J Strength Cond Res 17(4):629-633 —
#   stopping the knees at the toes cut knee torque but raised hip torque and
#   trunk lean; some forward knee travel is appropriate.
# - Powers CM 2010, J Orthop Sports Phys Ther 40(2):42-51, doi
#   10.2519/jospt.2010.3337 — hip, pelvis and trunk control affects knee
#   mechanics (review).
# - Glassbrook DJ et al. 2017, J Strength Cond Res 31(9):2618-2634, doi
#   10.1519/JSC.0000000000002007 — high-bar back squats keep a more upright
#   torso than low-bar.
# - Neumann DA 2010, J Orthop Sports Phys Ther 40(2):82-94, doi
#   10.2519/jospt.2010.3025, and Benn ML, Pizzari T, Rath L, Tucker K,
#   Semciw AI 2018, Clin Anat 31(4):535-543, doi 10.1002/ca.23068 — the
#   adductor magnus acts as a hip extensor (both its portions most active in
#   extension MVICs).
# - ExRx.net (read through Internet Archive copies, 2020-2024 snapshots, as
#   exrx.net blocks automated fetches): Dumbbell Alternating Side Lunge and
#   Barbell Side Lunge (target quadriceps; synergists gluteus maximus,
#   adductor magnus of the lead leg, adductors of the extended leg, soleus;
#   dynamic stabilisers hamstrings, gastrocnemius; stabilisers include the
#   gluteus medius; land on the heel then forefoot; keep the torso upright;
#   the lead knee points the same way as the foot; flexible adductors allow
#   a fuller range), Barbell Side Split Squat (the side-to-side squat with
#   the other leg only slightly bent: same muscles; a wider stance
#   emphasises the gluteus maximus), Smith Wide Squat (feet wide, pointing
#   out 30-45°, thighs just past parallel, knees the same way as the feet,
#   weight through forefoot and heel; target quadriceps, synergists gluteus
#   maximus, adductor magnus, soleus) and Kettlebell Front Squat.
# - ACE Exercise Library: Side Lunge (feet parallel facing forward, step to
#   the side with the weight over the heels, push the hips back, knee over
#   the second toe, the other leg near full extension, both heels flat) and
#   Goblet Squat (weight held vertically in front of the chest, elbows close
#   to the ribs, back straight, hips below knee level).
# - StrengthLog, Cossack Squat guide (feet wide, sink deeply to one side with
#   the other leg straight, the bent leg's foot flat, point the extended
#   leg's toes up, push through the heel).
# No EMG study of the Cossack squat, of dumbbell or barbell sumo squats as
# such, or of the kettlebell goblet squat was found; their rows are ranked
# from the closest studied lifts (side lunges and side split squats; wide
# stance back squats; the goblet squat with a dumbbell-type load and front
# squats) and kept modest (see the notes).

from common_legs30 import *

NAMES = ["Lateral Lunge", "Cossack Squat", "Dumbbell Sumo Squat", "Barbell Sumo Squat", "Kettlebell Goblet Squat"]


def glows_for(name, soft_dy=0.02):
    """Both thighs' quadriceps, then a soft glow over the hips and inner
    thighs (glutes and adductors)."""
    return [glow(name, ["thigh_L", "patella_L", "thigh_R", "patella_R"], A, 0.55, rx=0.2, ry=0.07),
            glow(name, ["pelvis", "thigh_L", "thigh_R"], SOFT, 0.30, rx=0.1, ry=0.06, dy=soft_dy)]


# ---------------------------------------------------------------- shared cues

KNEE_SIDE = ("Knee Tracking",
             "The bent knee stays over the stepping foot.",
             "The foot points straight ahead and the knee bends in line with it, over the second toe. A knee that drifts in toward the other leg often shows the hip losing control of the thigh, so the knee takes the load at an angle.",
             "The bent knee caving in toward the straight leg as you sink or push back up.",
             "Keep the knee over the middle toes, the foot pointing ahead, all the way down and back up.")
KNEE_WIDE = ("Knee Tracking",
             "The knees push out over the turned-out toes.",
             "In a wide stance the knees have to travel out as well as forward to stay over the feet. Knees that cave in toward each other load the joint at an angle; in squats that inward drift is often linked to weak hip control or stiff ankles.",
             "The knees caving in toward each other as you sink or stand.",
             "Push the knees out in line with the toes all the way down and up, the weight through the whole foot.")
STANCE = ("Stance",
          "Feet wide, toes turned out.",
          "A wide stance with the toes out lets the knees travel out over the feet as the thighs reach parallel. Wide stances asked more of the hip extensors than narrow ones in squat studies, and drew more glute activity in some of them, while squatting wide with the toes pointing straight ahead produced some of the largest knee and hip moments measured in one study.",
          "Standing wide with the toes pointing straight ahead, so the knees cannot follow the feet.",
          "Set your feet well wider than your shoulders, toes turned out about 30 to 45 degrees, and keep the knees in line with them.")
DEPTH_WIDE = ("Depth",
              "Sink until the thighs are parallel to the floor.",
              "Lowering to parallel takes the quadriceps, glutes and inner thighs through a long range. The hip adductors were most active past 60 degrees of knee bend in one squat study, and full squat training built more glute and adductor muscle than half squats.",
              "Stopping at a quarter or half squat, the hips staying high.",
              "Sit straight down between your heels until your thighs are parallel to the floor, pause, then stand up through the whole foot.")

# ---------------------------------------------------------------- side to side

ex(name="Lateral Lunge", var="lateralLunge",
   library=("QUADRICEPS", "BODYWEIGHT", "beginner"),
   # The body swings across the screen: rep 1 to the right (the lifter's
   # left), rep 2 to the left, the head at v 0.47 and the knees at v 0.60-0.64
   # at the bottoms. So the labels keep to the two top rows and the bottom
   # row below the feet (v 0.71-0.72), clear of the moving body. The long
   # straight-leg label takes the top right (the head never rises above
   # v 0.28); the short Hips back label sits below it at the second row,
   # starting at u ~0.77, past the head and near shoulder at mid-descent
   # (head u 0.58-0.59, shoulder u 0.68 at v 0.32-0.36, 1.0 and 3.0 s).
   overrides={"torso": (0.14, "leading"), "trail": (0.14, "trailing"), "hips": (0.32, "trailing"),
              "knee": (0.86, "leading"), "heel": (0.86, "trailing")},
   annotations=[
       ("torso", "Back flat", "chest"),
       ("hips", "Hips back", "pelvis"),
       ("trail", "Other leg straight", "patella_straight"),
       ("knee", "Knee over toes", "patella_bent"),
       ("heel", "Heel down", "foot_bent"),
   ],
   cues={
       "hips": ("Hip Position",
                "Step out wide and sit the hips back over the stepping leg.",
                "Pushing the hips back as the knee bends brings the hip extensors into the rep. Studies comparing lunges found the lateral lunge already leans more on the ankle of the stepping leg than a forward lunge does, and one found more on the knee as well, so keeping the hips forward with the knee pushed ahead moves even more of the load onto the knee.",
                "Keeping the hips forward and the chest upright, so the stepping knee drives forward over the toes.",
                "Step out, then push your hips back toward the stepping heel as the knee bends, as if sitting onto a low stool behind you."),
       "torso": ("Back Position",
                 "The chest leans forward over the thigh with the back flat.",
                 "Sitting back means the trunk has to tip forward to keep you balanced over the stepping foot. That is fine while the lean comes from the hips and the back stays flat and braced; in forward lunges a forward lean added glute and hamstring work. Rounding moves the bend into the spine instead.",
                 "The upper back rounding and the head dropping toward the knee at the bottom.",
                 "Brace, keep the chest open and the back flat from hips to head, and lean only as far as you can without rounding."),
       "knee": KNEE_SIDE,
       "heel": ("Stepping Foot",
                "The whole stepping foot stays planted.",
                "You push back to the start through this foot, so it needs to stay flat for a stable base. When the heel lifts, the weight rolls onto the toes and the knee drives further forward.",
                "The stepping heel peeling off the floor at the bottom as the knee drives forward.",
                "Land the foot flat, keep the weight through the heel and mid-foot, and push off it to bring the feet back together."),
       "trail": ("Straight Leg",
                 "The other leg ends long, its foot flat.",
                 "Keeping the other knee straight puts your weight over the bent leg, which does the lifting, while the inner thigh of the straight leg lengthens. Bending both knees spreads the load between the legs and turns the rep into a lopsided squat.",
                 "Bending the straight leg and letting its foot slide in, the weight settling between the feet.",
                 "As your hips move over the bent leg, straighten the other knee; at the bottom it is straight, its foot flat and pointing ahead."),
   },
   # Quadriceps first: ExRx target; Riemann 2013 and Flanagan 2004 (the
   # lateral lunge more knee and ankle led than the forward lunge). Gluteus
   # maximus from DiStefano 2009 (41% MVIC) and this model's deep hinge
   # (hip 49°, trunk 58°; Farrokhi 2008, forward lunge). Adductors from
   # Delmore 2014 and ExRx; Delmore's ranking is descriptive: side lunges,
   # standing Swiss-ball adduction, rotational squats and sumo squats did not
   # differ significantly in peak adductor longus EMG; only side-lying
   # adduction and ball squeezes stood out. Erector spinae as a stabiliser:
   # ExRx lists it first, and the model hinges 58°. Gluteus medius close
   # behind the gluteus maximus, as DiStefano measured them (39% vs 41%
   # MVIC; Bouillon 2012 13% vs 12%); the small gap is for the hinge.
   activation=[("Quadriceps", P, HI, 0.76), ("Gluteus Maximus", S, MOD, 0.52),
               ("Gluteus Medius", S, MOD, 0.46), ("Adductors", S, MOD, 0.42)],
   stabilisers=["erector spinae", "hamstrings", "calves", "core"],
   comparison=("HIPS NOT SITTING BACK", "Hips back, knee over the foot", "Hips forward, knee drives ahead",
               "Sitting back toward the stepping heel shares the work between the hip and knee and keeps the whole foot planted.",
               "Keeping the hips forward pushes the knee ahead and the weight onto the toes, so the knee takes most of the load."),
   glows=glows_for("Lateral Lunge"))

SETUP["Lateral Lunge"] = [
    "Stand tall with your feet about hip-width apart, toes pointing ahead.",
    "Clasp your hands in front of your chest.",
    "Brace your core and settle your weight into your heels.",
    "Keep both feet pointing ahead; each rep steps one foot wide to the side and back.",
]

ex(name="Cossack Squat", var="cossackSquat",
   library=("QUADRICEPS", "BODYWEIGHT", "intermediate"),
   # As the lateral lunge: the body swings from the right (rep 1) to the
   # left (rep 2) with the head at v 0.43 at the bottoms, and the feet stay at
   # u 0.26 and 0.77 (v 0.71-0.73), so the labels use the two top rows and
   # the bottom row below the feet. The long straight-leg label takes the
   # top right (the head never rises above v 0.28); the short Sit deep label
   # sits below it, starting at u ~0.83, clear of the head passing at
   # (0.63-0.68, 0.33-0.37) at 1.0 and 3.0 s.
   overrides={"torso": (0.14, "leading"), "trail": (0.14, "trailing"), "depth": (0.32, "trailing"),
              "knee": (0.86, "leading"), "heel": (0.86, "trailing")},
   annotations=[
       ("torso", "Chest up", "chest"),
       ("depth", "Sit deep", "pelvis"),
       ("trail", "Other leg straight", "patella_straight"),
       ("knee", "Knee over toes", "patella_bent"),
       ("heel", "Heel down", "foot_bent"),
   ],
   cues={
       "depth": ("Depth",
                 "Sit all the way down over the bent leg.",
                 "The Cossack squat is built for range: the working knee bends further than in most squats while the other leg lengthens. Training through a full squat built more glute and adductor muscle than half squats.",
                 "Stopping short of parallel, the hips staying above the bent knee.",
                 "Shift over one leg and sink until the thigh is at or just below parallel, as deep as the heel stays down and the back stays flat, then push back to the middle. Build the depth up over weeks; it takes flexible inner thighs."),
       "heel": ("Working Foot",
                "The heel of the bent leg stays down.",
                "At the bottom the knee travels well forward over the foot, which takes a lot of ankle bend. When the ankle runs out, the heel lifts and the weight tips onto the toes; in a squat study, limiting ankle bend also made the knees drift inward and the quadriceps work less.",
                "The heel of the bent leg lifting off the floor at the bottom.",
                "Keep the whole foot flat and push through the heel and mid-foot; go only as deep as the heel stays down."),
       "knee": ("Knee Tracking",
                "The bent knee follows the turned-out toes.",
                "With the toes turned out, the knee travels forward and out over them. A knee that drifts inward loads the joint at an angle and often shows the hip losing control of the thigh.",
                "The bent knee caving inward over the arch as you sink.",
                "Point the knee over the middle toes all the way down and back up."),
       "torso": ("Chest Position",
                 "The chest stays up, hands clasped in front of it.",
                 "An upright trunk keeps your weight over the working foot while the hips sink toward the heel. Folding forward shifts the weight onto the toes and asks the lower back to hold the trunk.",
                 "The chest folding forward over the bent knee and the back rounding at the bottom.",
                 "Keep the chest up and the back flat, hands clasped at the chest, with only a slight forward lean."),
       "trail": ("Straight Leg",
                 "The other leg stays straight, heel down and toes up.",
                 "Keeping the other knee straight puts your weight over the working leg while the inner thigh of the straight leg lengthens. Letting that foot roll onto its heel with the toes pointing up is the usual way to give the leg room to turn as you sink.",
                 "Bending the straight leg and sliding its foot in, the weight settling between the feet.",
                 "Keep the other knee straight, let that foot rest on its heel with the toes up, and sit your hips over the bent leg."),
   },
   # No Cossack EMG study: ranked from the side lunge and ExRx's Barbell
   # Side Split Squat (target quadriceps; gluteus maximus, lead-leg adductor
   # magnus and extended-leg adductors as synergists), with the gluteus
   # maximus and adductors a little higher than the lateral lunge for the
   # depth (thigh past parallel: Kubo 2019, with Caterisano 2002's EMG share
   # against Contreras 2016's null result, so kept small; the adductor
   # magnus as a hip extensor deep in the squat: Neumann 2010, Benn 2018).
   # Gluteus medius as the lateral lunge's (no step up: no depth data).
   activation=[("Quadriceps", P, HI, 0.78), ("Gluteus Maximus", S, MOD, 0.56),
               ("Adductors", S, MOD, 0.48), ("Gluteus Medius", S, MOD, 0.46)],
   stabilisers=["hamstrings", "calves", "core"],
   comparison=("HEEL LIFTING", "Whole foot flat, heel down", "Heel lifts, weight on the toes",
               "With the heel down you can sink deep over the working foot and push back up through the whole foot.",
               "When the ankle runs out of bend the heel lifts, the weight tips onto the toes and the knee takes more of the load."),
   glows=glows_for("Cossack Squat"))

SETUP["Cossack Squat"] = [
    "Stand with your feet about twice shoulder-width apart.",
    "Turn your toes out slightly.",
    "Clasp your hands in front of your chest.",
    "Brace your core, chest up, before shifting to one side.",
]

# ---------------------------------------------------------------- sumo squats

ex(name="Dumbbell Sumo Squat", var="dumbbellSumoSquat",
   library=("QUADS + GLUTES", "DUMBBELL", "beginner"),
   # Framed close (zoom 0.905): the arms reach u 0.28-0.72 down to v 0.45,
   # the knees push out to u 0.20 and 0.81 at v 0.64 and the shoes fill the
   # bottom row at both edges, so the labels keep to the three upper rows.
   # The long depth label takes the top right, above the near shoulder; the
   # right-hand labels below it are short enough to start past the upper arm
   # (u 0.72 at the start); the knee label sits level with the right knee's
   # path on the left.
   overrides={"torso": (0.14, "leading"), "depth": (0.14, "trailing"), "hold": (0.32, "trailing"),
              "knee": (0.50, "leading"), "stance": (0.50, "trailing")},
   annotations=[
       ("torso", "Chest up", "chest"),
       ("stance", "Toes out", "foot_L"),
       ("knee", "Knees out", "patella_R"),
       ("depth", "Thighs parallel", "pelvis"),
       ("hold", "Arms long", "hand_L"),
   ],
   cues={
       "hold": ("Dumbbell Position",
                "The dumbbell hangs straight down between the legs.",
                "Held at arm's length under the shoulders, the dumbbell rides straight down and up with the hips, so the legs do the lifting and the arms only hold it. If it drifts forward, it pulls the chest forward with it.",
                "The dumbbell swinging forward in front of the knees at the bottom.",
                "Hold one end of the dumbbell with both hands, arms long and shoulders down, and let it travel straight down between your legs."),
       "stance": STANCE,
       "knee": KNEE_WIDE,
       "depth": DEPTH_WIDE,
       "torso": ("Torso Position",
                 "The chest stays up, the back flat.",
                 "Keeping the trunk fairly upright, leaning only about as far as the shins, keeps the weight over the middle of the feet. Folding forward moves the weight toward the toes and more of the work onto the lower back.",
                 "The chest dropping forward and the back rounding at the bottom.",
                 "Brace, keep the chest up and let the trunk lean only slightly, about in line with the shins."),
   },
   # Quadriceps first (ExRx Smith Wide Squat target; McCaw 1999: stance does
   # not change the quadriceps EMG, only the load does; Lee 2026 found only
   # the vastus medialis changed, upward; Escamilla 2001 measured greater
   # knee extensor moments wide; Sinclair 2022's modelled forces, the one
   # source putting it lower wide, are outweighed). Level with the
   # dumbbell-loaded Goblet Squat (0.85) for the light load held in the
   # hands; the gluteus maximus a step below the barbell version for the
   # same reason, still above the Goblet Squat for the wide
   # stance (hip extensor moments: Escamilla 2001, Lahti 2019, Hopkins 2024,
   # Sinclair 2022; EMG mixed: Paoli 2009 higher only at the widest stance,
   # McCaw 1999 a load x stance interaction, Lee 2026 no change). Adductors moderate but not
   # high: Pereira 2010 and McCaw 1999 found more adductor activity with the
   # hips turned out or wide, but Paoli 2009 found no adductor magnus change,
   # Hopkins 2024 no change in the adductor moment, and Delmore 2014 ranked
   # sumo squats last of six adductor exercises.
   activation=[("Quadriceps", P, HI, 0.85), ("Gluteus Maximus", S, MOD, 0.58),
               ("Adductors", S, MOD, 0.44)],
   stabilisers=["hamstrings", "calves", "forearms", "core"],
   comparison=("STOPPING SHORT", "Thighs reach parallel", "Hips stop high",
               "Reaching parallel takes the hips and thighs through the bottom of the rep, the long range that built more glute and inner-thigh muscle in training.",
               "Quarter reps keep the hips high and skip the deepest part of the rep, the range the wide stance is there to reach."),
   glows=glows_for("Dumbbell Sumo Squat"))

SETUP["Dumbbell Sumo Squat"] = [
    "Stand with your feet well wider than your shoulders, toes turned out.",
    "Hold one dumbbell upright by its top end with both hands.",
    "Let it hang at arm's length between your legs.",
    "Brace your core and lift your chest.",
]

ex(name="Barbell Sumo Squat", var="barbellSumoSquat",
   library=("QUADS + GLUTES", "BARBELL", "intermediate"),
   # Three-quarter (yaw -0.8): the plates sweep both edges from v 0.26 at the
   # top to v 0.52 at the bottom, so the bar and chest labels take the top
   # row above them; the depth label sits on the right at the fourth row,
   # clear of the right plate and outside the near knee (u 0.60, v 0.61);
   # the knee and stance labels take the bottom row, under the feet
   # (v 0.73-0.76).
   overrides={"bar": (0.14, "trailing"), "torso": (0.14, "leading"), "depth": (0.68, "trailing"),
              "knee": (0.86, "leading"), "stance": (0.86, "trailing")},
   annotations=[
       ("bar", "Bar high on the traps", "upper_arm_L"),
       ("torso", "Chest up", "chest"),
       ("depth", "Thighs parallel", "pelvis"),
       ("knee", "Knees out", "patella_R"),
       ("stance", "Toes out", "foot_L"),
   ],
   cues={
       "bar": ("Bar Position",
               "The bar sits high across the upper traps.",
               "A high bar sits over the middle of the feet and lets the trunk stay fairly upright; in back squats a lower bar brings more forward lean.",
               "The bar sliding down onto the back of the shoulders, the chest tipping forward to balance it.",
               "Set the bar across the upper traps just below the neck, hands wider than the shoulders and elbows pointing down, and keep the chest up."),
       "stance": STANCE,
       "knee": KNEE_WIDE,
       "depth": DEPTH_WIDE,
       "torso": ("Brace",
                 "Brace and keep the chest up under the bar.",
                 "With the bar on the back, a braced trunk passes the drive from the legs to the bar. Leaning only about as far as the shins keeps the bar over the middle of the feet; a chest that drops lengthens the lever on the lower back.",
                 "The chest dropping and the upper back rounding under the bar at the bottom.",
                 "Breathe into the belly and brace before each rep, then keep the chest up with the trunk leaning only about as far as the shins."),
   },
   # As the dumbbell version, higher for the heavier bar load the
   # wide-stance back squat studies used (McCaw 1999, Paoli 2009 loaded to
   # 60-75% and 70% 1RM): the quadriceps as the library's Back Squat (0.90;
   # stance did not change quadriceps EMG, Escamilla 2001 greater knee
   # extensor moments wide), the gluteus maximus a little above it (0.62)
   # for the wide stance's greater hip extensor moments. Erector spinae as the library's Back Squat (0.45):
   # a free bar on the back, the trunk leaning 22°, and stance width does not
   # change trunk position (Escamilla 2001).
   activation=[("Quadriceps", P, HI, 0.90), ("Gluteus Maximus", S, MOD, 0.64),
               ("Erector Spinae", S, MOD, 0.45), ("Adductors", S, MOD, 0.44)],
   stabilisers=["hamstrings", "calves", "core"],
   comparison=("KNEES CAVING IN", "Knees out over the toes", "Knees collapse inward",
               "With the knees over the turned-out toes, the load stays in line with the joint and the hips and thighs share the work.",
               "When the knees cave in over wide, turned-out feet, the knees take the bar's load at an angle."),
   glows=glows_for("Barbell Sumo Squat"))

SETUP["Barbell Sumo Squat"] = [
    "Set the bar in a rack at upper-chest height, safety bars just below your bottom position.",
    "Take it high across your upper traps, hands wider than your shoulders.",
    "Step back and set your feet well wider than your shoulders, toes turned out.",
    "Brace your core and lift your chest.",
]

# ---------------------------------------------------------------- goblet

ex(name="Kettlebell Goblet Squat", var="kettlebellGobletSquat",
   library=("QUADRICEPS", "KETTLEBELL", "beginner"),
   # Framed close and a little right of centre (zoom 0.883): the near arm
   # and hip fill the right edge from u 0.63 down to v 0.75, while the left
   # of the frame is clear to u 0.40 above the knees (the right knee comes
   # out to u 0.29 at v 0.70 at the bottom). So the kettlebell label takes
   # the top right and the other four stack down the left, the heel label
   # short enough to end before that knee.
   overrides={"torso": (0.14, "leading"), "hold": (0.14, "trailing"), "depth": (0.32, "leading"),
              "knee": (0.50, "leading"), "heel": (0.68, "leading")},
   annotations=[
       ("hold", "Bell at the chest", "hand_L"),
       ("torso", "Chest up", "chest"),
       ("knee", "Knees over toes", "patella_R"),
       ("depth", "About parallel", "pelvis"),
       ("heel", "Heels down", "foot_R"),
   ],
   cues={
       "hold": ("Kettlebell Position",
                "The kettlebell stays tucked against the chest.",
                "Held close in front of the chest, the load stays over the middle of the feet and helps you stay upright. The further it drifts down and away, the more it pulls the chest forward.",
                "The kettlebell sagging down and away from the chest at the bottom, pulling the chest forward.",
                "Hold the kettlebell by the sides of the handle, bell down, against your chest, with the elbows close to the ribs and pointing down."),
       "heel": ("Foot Pressure",
                "The heels stay down as the knees travel forward.",
                "In this squat the knees travel well forward, past the toes, so the hips can sink between the feet; that is fine while the heels stay down. A lifting heel tips the weight onto the toes, and in a squat study limiting ankle bend also made the knees drift inward and the quadriceps work less.",
                "The heels peeling off the floor at the bottom, the weight rolling onto the toes.",
                "Keep the whole foot flat and push through the heel and mid-foot; if the heels still lift, stand a little wider."),
       "knee": ("Knee Tracking",
                "The knees follow the toes.",
                "The knees travel forward and slightly out over the turned-out feet. Knees that cave in toward each other load the joint at an angle; in squats that inward drift is often linked to weak hip control or stiff ankles.",
                "The knees caving in toward each other as you sink or stand.",
                "Keep the knees over the middle toes all the way down and up."),
       "depth": ("Depth",
                 "Sink until the thighs are about parallel.",
                 "Lowering to about parallel takes the quadriceps and glutes through a long range, and training through a full squat built more glute muscle than half squats. The load in front helps you sit down between the heels with the chest up.",
                 "Stopping at a quarter or half squat, the hips staying high.",
                 "Sit down between your heels until your thighs are about parallel, deeper if the heels stay down and the back stays flat, pause, then stand up."),
       "torso": ("Torso Position",
                 "The chest stays tall behind the kettlebell.",
                 "With the load in front, a forward lean is costly: the further the chest tips, the further the kettlebell moves ahead of the feet and the harder the lower back has to work to hold it.",
                 "The chest dropping toward the knees and the back rounding at the bottom.",
                 "Keep the chest up behind the kettlebell and the back flat, with only a slight forward lean."),
   },
   # Quadriceps first (Collins 2021: the goblet squat drew more quadriceps
   # activity than the landmine squat; ExRx Kettlebell Front Squat), the
   # gluteus maximus moderate at about parallel. The adductors are a
   # stabiliser, as in the library's Goblet, Back and Front Squats (no goblet
   # study measured them; this stance is the Goblet Squat's). Close to the
   # library's Goblet Squat (0.85 / 0.52), with its Rectus Abdominis row
   # (0.32) in place of a core stabiliser, so the two goblet squats match.
   activation=[("Quadriceps", P, HI, 0.86), ("Gluteus Maximus", S, MOD, 0.50),
               ("Rectus Abdominis", S, LOW, 0.32)],
   stabilisers=["adductors", "upper back", "forearms"],
   comparison=("HEELS LIFTING", "Heels down, knees forward", "Heels rise, weight on the toes",
               "With the heels down, the knees can travel forward and the hips sink between the feet while the weight stays over the whole foot.",
               "When the heels lift, the weight tips onto the toes and the chest pitches forward to stay balanced."),
   glows=glows_for("Kettlebell Goblet Squat"))

SETUP["Kettlebell Goblet Squat"] = [
    "Hold a kettlebell by the sides of the handle, bell down, against your chest.",
    "Stand with your feet about shoulder-width apart, toes turned out slightly.",
    "Tuck your elbows in under the kettlebell.",
    "Brace your core and stand tall.",
]

if __name__ == "__main__":
    probs = validate(NAMES) + validate_library(NAMES)
    print("\n".join(probs) or "OK")
