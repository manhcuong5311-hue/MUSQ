# Trainer content for the 30-leg set (2026-09-28), family "single": the
# heel-elevated and cyclist squats (a bar on the back, heels on wedges) and the
# pistol and assisted pistol squats (one leg). Same format as spec.py, on top
# of common_legs30.py; spec_legs30.py collects it with the other families.
#
# What each model shows, from the briefs (briefs_legs30/*.md: joint angles and
# positions every 0.5 s), the rig, the wedge meshes and the framing stills.
# All four do two reps in 8 s with the same timing: ~1.0 s down, a ~0.75 s
# hold at the bottom (deepest at 1.38 s), ~1.75 s up, ~0.35 s at the top. The
# rig's torso (neck to pelvis) is 0.59 m, thigh 0.44 m, shin 0.40 m, hip
# joints 0.18 m apart. None of the four stands fully up between reps: the top
# of the heel-elevated squat stops at knee 139 deg, the cyclist squat at
# 135 deg and both pistols at 156 deg (hips 153-161 deg), so the copy never
# asks for a lockout.
# - Heel-Elevated Squat (yaw -1.0): barbell high on the upper traps (bar
#   centre level with the neck joint and ~6 cm behind it), hands ~0.78 m apart
#   (~20 cm outside each shoulder joint), elbows bent and pointing down. Two
#   separate wedges, one per foot, each a slab ~20 cm wide and ~36 cm long
#   tilted ~12 deg: its top ~9 cm high at the heel end, ~2 cm at the toe end.
#   The whole foot rests on the wedge, pitched ~12 deg toe-down, the ankle
#   ~4 cm higher than on the flat floor. Ankles 0.42 m apart (shoulder width;
#   the shoulder joints are 0.39 m apart), toes out ~14 deg each. Depth: knees
#   51 deg, hips (trunk-thigh) 73 deg, the thighs about parallel (the hip
#   joint ~5 cm above the knee joint), shins 48 deg forward with the knees
#   ~30 cm ahead of the ankles. The knees go straight forward: at the bottom
#   they are 0.40 m apart over ankles 0.42 m apart (each within 1 cm of its
#   ankle side to side), so with the toes turned 14 deg out each knee sits
#   ~8 cm inside the line of its toes; they never cave further in. The bar
#   ends over mid-foot (z 0.14 at the bottom). Trunk 5 deg forward at the
#   top, 25 deg at the bottom; the hips sink 46 cm and move ~13 cm back.
#   Heels stay on the wedges all clip.
# - Cyclist Squat (yaw -1.0): the same bar, grip and wedges, but a narrow
#   stance: ankles 0.21 m apart (about hip width), toes out ~7 deg each, the
#   two wedges almost touching (4 cm apart). Depth: knees 49 deg, hips 85 deg,
#   thighs about parallel (10 deg below horizontal toward the knee, the hip
#   joint ~8 cm above the knee joint: not below parallel), shins 50 deg
#   forward (knees ~31 cm ahead of the ankles), knees ~3 cm outside the
#   ankles (0.27 m apart at the bottom), in line with the 7 deg toe-out.
#   Trunk 5 deg at the top, 15 deg at the bottom: more upright than the
#   heel-elevated squat (25 deg) at the same depth; the bar moves ~3 cm back
#   from the top to the bottom (~7 cm forward on the heel-elevated squat) and
#   ends over the heels (z 0.04, ankle 0.08, mid-foot ~0.15), further back
#   than a balanced squat, so the copy makes no mid-foot claim for it.
# - Pistol Squat (yaw -1.2, the lifter's left side to the camera, facing
#   screen-left): bodyweight, no equipment. The LEFT leg stands for both reps
#   (left foot flat, toes out ~5 deg, the ankle never leaves the floor); the
#   pelvis sits ~4 cm to the inside of the standing ankle, the trunk never
#   tilts sideways. The RIGHT leg is the free leg: knee straight (174 deg) all
#   clip, toes pulled up; at the top it rests forward, ankle ~27 cm ahead of
#   the standing ankle and the heel just off the floor, and it rises as the
#   hips sink until it is about level with the hips at the bottom (ankle
#   ~0.43 m high, ~0.78 m ahead). Both arms straight out in front, hands a
#   ~12 cm below the shoulders at the top and ~30 cm below them (44 cm ahead,
#   ~34 deg below horizontal) at the bottom, pointing toward the free foot,
#   ~0.4 m apart. Standing knee 156 deg at the
#   top, 45 deg at the bottom, hip 79 deg, the hip joint ~14 cm above the knee
#   joint (the back of the thigh on the calf), the shin 65 deg forward with
#   the knee ~36 cm ahead of the ankle, i.e. well past the toes, and ~3 cm
#   outside it. Trunk 8 deg forward at the top, 30 deg at the bottom. The
#   pelvis drops 51 cm and ends ~6 cm behind the standing ankle joint, over
#   the heel; even the shoulders stay ~13 cm behind the knee.
# - Assisted Pistol Squat (yaw -1.6, side-on from the left): exactly the same
#   legs, trunk and timing as the pistol. A crossbar at ~1.2 m (about chest
#   height at the top, above the shoulders at the bottom) runs across in front
#   of the lifter, fixed at its left end (x 0.42) to an upright off to the
#   lifter's left (x 0.34-0.41, z 0.61-0.68);
#   both hands hold it ~0.44 m apart, 0.48-0.53 m ahead of the standing ankle. The
#   elbows stay bent all clip: 122-127 deg at the top, 90-98 deg on the way
#   down and 106-113 deg at the bottom, the shoulders ending ~27 cm below the
#   hands. The model's pose is identical to the free pistol, so its knee,
#   free leg and depth never change with the help.
#
# Sources (each checked; notes_legs30_single.md maps the claims to them):
# - Charlton JM, Hammond CA, Cochrane CK, Hatfield GL, Hunt MA 2017, J Strength
#   Cond Res 31(6):1678-1687, doi 10.1519/JSC.0000000000001655 — 14 trained
#   men, minimally loaded back squats barefoot vs heels on a 2.5 cm block: less
#   forward trunk flexion at peak knee flexion and lower peak external hip
#   moments with the block; no difference in trunk-pelvis angle and no
#   difference in peak or RMS muscle activity.
# - Sato K, Fortenbaugh D, Hydock DS 2012, J Strength Cond Res 26(1):28-33,
#   doi 10.1519/JSC.0b013e318218dd64 — back squat at 60% 1RM in weightlifting
#   vs running shoes: foot segment angle 3.5 deg greater and trunk lean 22 mm
#   less in weightlifting shoes; thigh depth not different.
# - Legg HS, Glaister M, Cleather DJ, Goodwin JE 2017, J Sports Sci
#   35(5):508-515, doi 10.1080/02640414.2016.1175652 — weightlifting shoes
#   (raised heel) vs athletic shoes: less peak ankle flexion and more knee flexion
#   loaded and unloaded; a more upright trunk and greater knee moment when
#   unloaded.
# - Cai J et al. 2026, J Strength Cond Res (ahead of print), doi
#   10.1519/JSC.0000000000005639 — 30 men with restricted ankle dorsiflexion,
#   loaded squats with heels raised 0-5 cm: more elevation reduced peak ankle
#   dorsiflexion and forward trunk inclination, increased peak knee and hip
#   flexion and the peak knee moment (hip and ankle moments unchanged), and
#   lowered modelled L3-L5 stress; selected muscle activities and
#   co-contraction rose (which muscles: abstract only); the authors note too
#   much elevation may raise knee extensor demand.
# - Ghasemi M, Emami M, Mohammadi Yaghoubi U 2026, Sports Biomech
#   25(7):1022-1038, doi 10.1080/14763141.2026.2619893 — meta-analysis of 14
#   studies: heel elevation increased ankle (MD 4.33 deg, only above 2.5 cm or
#   5 deg) and knee (MD 4.94 deg) range during squats; pooled hip and trunk
#   range not changed; a meta-regression linked higher heels with less hip
#   (beta -0.028) and trunk (beta -0.067) range. Its ankle result runs against Legg and Cai
#   (less peak dorsiflexion), so it is cited for knee, hip and trunk only.
# - Bozkurt O et al. 2026 (online 7 Jan 2026), Front Physiol 16:1727141, doi
#   10.3389/fphys.2025.1727141 — front and back squats at 70% 1RM with flat,
#   heel-elevated (5 cm blocks) and forefoot-elevated feet: vastus lateralis
#   and medialis higher flat and heel-elevated than forefoot-elevated; heel
#   elevation increased dorsiflexion range. Used only to say heel elevation
#   has not shown a clear quadriceps EMG gain.
# - Larsen S, Kristiansen E, Helms E, van den Tillaar R 2021, Front Sports Act
#   Living 3:719013, doi 10.3389/fspor.2021.719013 — 3RM back squats, narrow
#   stance 0.7x and wide 1.7x acromion width: the hip gave over 50% of the
#   total moment at the sticking-region events in every condition; the
#   high-bar narrow stance gave the knee a bigger share than the other three
#   at the bottom of the lift (v0); at vmin both high-bar stances exceeded
#   the low-bar ones, and contributions were similar at vmax1/dmax1; with
#   more vastus lateralis (post-sticking)
#   and less gluteus maximus (pre-sticking) activity.
# - Lahti J, Hegyi A, Vigotsky AD, Ahtiainen JP 2019, Scand J Med Sci Sports
#   29(1):44-54, doi 10.1111/sms.13305 — back squats to femur parallel, narrow
#   (1x trochanter width) vs wide (1.5x): more knee flexion narrow; higher
#   hip-to-knee extension moment ratios wide.
# - Paoli A, Marcolin G, Petrone N 2009, J Strength Cond Res 23(1):246-250,
#   doi 10.1519/JSC.0b013e3181876811 — three stance widths: only the gluteus
#   maximus changed, higher at the widest stance.
# - McCaw ST, Melrose DR 1999, Med Sci Sports Exerc 31(3):428-436, doi
#   10.1097/00005768-199903000-00012 — narrow (75% shoulder width) to wide
#   (140%) parallel squats: quadriceps activity changed with load only, not
#   stance; stance affected the adductor longus and gluteus maximus.
# - Lee CXY, Crossman AJ, Kedgley AE 2026, PLoS One 21(8):e0354893, doi
#   10.1371/journal.pone.0354893 — narrow stance: 3.7 deg more peak knee
#   flexion; a wide stance raised peak and cumulative vastus medialis
#   activation; no combination of bar position and stance consistently
#   favoured any muscle.
# - Fry AC, Smith JC, Schilling BK 2003, J Strength Cond Res 17(4):629-633,
#   doi 10.1519/1533-4287(2003)017<0629:EOKPOH>2.0.CO;2 —
#   double-leg parallel squat: blocking the knees from passing the toes cut
#   knee torque but moved load to the hips and lower back; the knees moving
#   slightly past the toes is appropriate. Not evidence for the much longer
#   knee travel of a pistol, which is mechanics.
# - Macrum E, Bell DR, Boling M, Lewek M, Padua D 2012, J Sport Rehabil
#   21(2):144-150, doi 10.1123/jsr.21.2.144 — a 12 deg forefoot wedge that
#   limits ankle dorsiflexion: more knee valgus and medial knee displacement,
#   less quadriceps and more soleus activity in the double-leg squat.
# - Kim SH, Kwon OY, Park KN, Jeon IC, Weon JH 2015, J Hum Kinet 45:59-69,
#   doi 10.1515/hukin-2015-0007 — ankle dorsiflexion (knee bent) and hip
#   flexion range predicted squat depth in men.
# - Caterisano A et al. 2002, J Strength Cond Res 16(3):428-432, doi
#   10.1519/1533-4287(2002)016<0428:TEOBSD>2.0.CO;2 — gluteus maximus
#   share of the concentric EMG rose with squat depth (partial, parallel,
#   full).
# - Kubo K, Ikebukuro T, Yata H 2019, Eur J Appl Physiol 119(9):1933-1942, doi
#   10.1007/s00421-019-04181-y — 10 weeks of full squats grew the gluteus
#   maximus and adductors more than half squats; knee extensors grew about the
#   same in both.
# - Powers CM 2010, J Orthop Sports Phys Ther 40(2):42-51, doi
#   10.2519/jospt.2010.3337 — poor hip, pelvis and trunk control can affect
#   knee mechanics (review).
# - Mausehund L, Skard AE, Krosshaug T 2019, J Strength Cond Res 33(Suppl
#   1):S85-S94, doi 10.1519/JSC.0000000000002617 — barbell single-leg squat vs
#   split squat and rear-foot-elevated split squat at 6-8RM to failure: no
#   difference in vastus lateralis or gluteus maximus peaks; gluteus medius
#   highest in the single-leg squat (81.9% MVIC vs 54.9% and 46.2%);
#   hamstrings-to-quadriceps ratio 0.63 (quadriceps dominant). How its
#   single-leg squat was set up (box, free-leg position) could not be read
#   (abstract only).
# - Boudreau SN et al. 2009, J Sport Rehabil 18(1):91-103, doi
#   10.1123/jsr.18.1.91 — rectus femoris, gluteus maximus and stance-side
#   gluteus medius rose from step-up-and-over to lunge to single-leg squat.
# - DiStefano LJ, Blackburn JT, Marshall SW, Padua DA 2009, J Orthop Sports
#   Phys Ther 39(7):532-540, doi 10.2519/jospt.2009.2796 — of 12 exercises, the
#   single-limb squat and single-limb deadlift drew the most gluteus maximus.
# - Khuu A, Loverro KL, Lewis CL 2022, J Athl Train 57(2):170-176, doi
#   10.4085/1062-6050-0019.21 — single-leg squats as low as possible with the
#   free leg in front (like a pistol squat), in the middle or behind: gluteal
#   activity on the descent greater with it in front (and middle) than behind;
#   tensor fasciae latae greatest in front; raw EMG, not %MVIC.
# - Monajati A, Larumbe-Zabala E, Goss-Sampson M, Naclerio F 2019, J Hum
#   Kinet 67:73-83, doi 10.2478/hukin-2018-0073 — single-leg squat on a 30 cm
#   bench to ~60 deg knee flexion, free leg off the floor: more biceps
#   femoris, semitendinosus and vastus medialis activity than the double-leg
#   squat.
# - StrengthLog, Pistol Squat guide (strengthlog.com/pistol-squat): primary
#   quadriceps and glutes, secondary hamstrings; free leg straight and off the
#   ground, arms forward for balance, chest up, lower as far as you can with
#   control, press through the heel. It does not mention hip flexors, ankle
#   mobility, supports or boxes.
# - McCurdy K 2017, Strength Cond J 39(6):93-97, doi 10.1519/SSC.0000000000000319
#   — a technique column on the rear-foot-elevated split squat (not an EMG
#   study) noting the Smith machine reduces frontal-plane muscle activation;
#   used only as an analogy for the assisted pistol's gluteus medius.
# No EMG or kinematic study was found for the cyclist squat by name, for the
# pistol squat as such (only single-leg squats set up in various ways, one
# with the free leg in front) or for any hand-assisted single-leg squat; their
# rows are ranked from the closest studied lifts and kept modest (see the
# notes). ExRx could not be checked this time (the Internet Archive was
# offline and exrx.net blocks automated fetches), so it is not cited.

from common_legs30 import *

NAMES = ["Heel-Elevated Squat", "Cyclist Squat", "Pistol Squat", "Assisted Pistol Squat"]


def squat_glows(name):
    """Both thighs' quadriceps, then the glutes behind the hips (the lifter
    faces screen-left, so behind is to the right)."""
    return [glow(name, ["thigh_L", "patella_L", "thigh_R", "patella_R"], A, 0.55, rx=0.15, ry=0.07),
            glow(name, ["pelvis"], SOFT, 0.30, rx=0.07, ry=0.06, dx=0.05)]


def pistol_glows(name):
    """The standing (left) thigh, then its glute behind the hip."""
    return [glow(name, ["thigh_L", "patella_L"], A, 0.55, rx=0.13, ry=0.07),
            glow(name, ["pelvis", "thigh_L"], SOFT, 0.30, rx=0.07, ry=0.06, dx=0.04)]


# ---------------------------------------------------------------- shared cues

BAR = ("Bar Position",
       "The bar sits high across the upper traps.",
       "A high bar lets the torso stay upright over the raised heels, which suits a squat built around the knees.",
       "The bar sliding down onto the back of the shoulders, the chest tipping forward to balance it.",
       "Set the bar across the upper traps just below the neck, hands wider than the shoulders, and keep the chest tall under it.")
WEDGE = ("Heel Wedge",
         "Both heels rest on the high end of the wedge, the whole foot supported.",
         "Tilting the foot lets the shin lean further forward before the ankle runs out of bend, so the knees can travel forward and the trunk stay more upright. Studies of heel wedges and weightlifting shoes found less forward lean and more knee bend with the heels raised, and higher heels put more demand on the knee extensors.",
         "The heels peeling off the wedge at the bottom, the weight rolling onto the toes.",
         "Stand with the whole foot on the wedge, heels on the high end, and push through the heels and mid-foot all the way down and up.")
KNEE_TRACK = ("Knee Tracking",
              "The knees travel forward over the feet, never caving inward.",
              "Knees that follow the feet take the load straight through the joint. A knee that caves in often shows the hips losing control of the thighs; in one study, limiting how far the ankle could bend made it cave more, and a wedge lets the shin lean further before the ankle runs out of bend.",
              "The knees caving in toward each other as you sink or drive up.",
              "Keep each knee pointing over the middle toes of its foot, all the way down and up.")
DEPTH_SQUAT = ("Depth",
               "Sit all the way down until the thighs are about parallel or lower.",
               "The wedge lets the hips sink between the heels while the chest stays up. In squat studies, going deeper brought the glutes in more, and full squat training built more glute and adductor muscle than half squats, with the quadriceps growing about the same.",
               "Stopping halfway, the hips well above the knees, to handle more weight.",
               "Sink until the thighs are at least parallel, hold the bottom for a moment under control, then drive up through the whole foot.")

FOOT_SL = ("Standing Foot",
           "The whole standing foot stays flat, heel down.",
           "In a pistol the knee travels far past the toes, so the ankle has to bend a long way. A heel that stays down keeps you balanced over the middle of the foot. How far the ankle can bend is one of the things that limits squat depth.",
           "The standing heel lifting as the knee drives forward, tipping the weight onto the toes.",
           "Keep the heel down and push through the whole foot. If it will not stay down, work at a shallower depth or stand the heel on a thin plate while your ankle mobility improves.")
KNEE_SL = ("Knee Tracking",
           "The standing knee stays in line with the foot.",
           "On one leg the hip muscles, the gluteus medius above all, have to hold the thigh in line; single-leg squats draw more gluteus medius work than split squats. Knee travel well past the toes is expected here as long as the knee stays over the foot.",
           "The standing knee caving inward toward the free leg at the bottom or on the way up.",
           "Keep the knee pointing over the middle toes, all the way down and up, with the hips level.")
FREE_SL = ("Free Leg",
           "The free leg stays straight and off the floor, out in front.",
           "The free leg has to clear the floor at the bottom, which takes hip flexor strength and hamstring flexibility. With the free leg in front, single-leg squats also drew more glute work on the way down than with it held behind.",
           "The free leg sagging until the heel drags on the floor at the bottom.",
           "Lock the free knee, pull the toes up and keep lifting the leg as you sink, so it ends about level with the hips.")

# ---------------------------------------------------------------- heel-elevated

ex(name="Heel-Elevated Squat", var="heelElevatedSquat",
   library=("QUADRICEPS", "BARBELL", "intermediate"),
   # Three-quarter (yaw -1.0): the plates sweep the upper half of the frame
   # through the rep, so the bar label sits above them on the left, clear of
   # the head (u 0.38 at the top), and the other four go below them (screen
   # 0.58 and lower). The torso and depth labels are kept short so they end
   # before the knees and the glutes at the bottom. The knee label says only
   # what the model shows (review 2): its knees go straight forward over the
   # ankles, ~8 cm inside the line of its 14 deg turned-out toes, and never
   # cave; they do not track the toes.
   overrides={"bar": (0.14, "leading"), "torso": (0.635, "leading"), "depth": (0.66, "trailing"),
              "knee": (0.86, "leading"), "heels": (0.86, "trailing")},
   annotations=[
       ("bar", "Bar high on traps", "support_TrapeziusUpper_L"),
       ("torso", "Chest up", "chest"),
       ("depth", "Full depth", "pelvis"),
       ("knee", "No knee cave", "patella_R"),
       ("heels", "Heels on wedge", "foot_L"),
   ],
   cues={
       "bar": BAR,
       "torso": ("Torso Position",
                 "The chest stays up as the hips sink between the heels.",
                 "With the heels raised, the knees can move forward, so the hips sink more straight down and the trunk can stay more upright than in a flat-footed squat, as heel wedge and weightlifting shoe studies found. That keeps the bar over the middle of the foot.",
                 "The chest folding toward the knees at the bottom, the bar drifting out over the toes.",
                 "Brace before each rep, keep the chest up and let the hips sink straight down between the heels."),
       "depth": DEPTH_SQUAT,
       "knee": KNEE_TRACK,
       "heels": WEDGE,
   },
   # A deep high-bar back squat with the heels up. Heel elevation raised the
   # knee moment (Cai 2026; Legg 2017 unloaded) but did not change peak or
   # RMS EMG in Charlton 2017, so all three rows stay close to the Back
   # Squat's (0.90 / 0.62 / 0.45). The gluteus maximus only a touch lower:
   # Charlton found a lower peak hip moment with a 2.5 cm block but Cai
   # (loaded, 0-5 cm) found hip moments unchanged. The erector spinae a touch
   # lower for the more upright trunk, not further: the library's upright
   # Front Squat sits at 0.50 and Charlton saw no EMG change.
   activation=[("Quadriceps", P, HI, 0.90), ("Gluteus Maximus", S, MOD, 0.60),
               ("Erector Spinae", S, MOD, 0.43)],
   stabilisers=["adductors", "hamstrings", "calves", "core"],
   comparison=("TORSO TIPS FORWARD", "Chest up, hips straight down", "Chest folds toward the knees",
               "With the heels raised, the knees travel forward and the hips sink between the heels, so the chest stays up and the bar over mid-foot.",
               "Folding forward takes the bar out over the toes, lengthening the lever on the lower back and undoing what the wedge is for."),
   glows=squat_glows("Heel-Elevated Squat"))

SETUP["Heel-Elevated Squat"] = [
    "Set two heel wedges, or a slant board, in front of a squat rack.",
    "Take the bar high across your upper traps, hands wider than your shoulders, and step back.",
    "Stand with your heels on the high end of the wedges, feet about shoulder-width, toes slightly out.",
    "Brace, chest tall, before the first rep.",
]

# ---------------------------------------------------------------- cyclist

ex(name="Cyclist Squat", var="cyclistSquat",
   library=("QUADRICEPS", "BARBELL", "intermediate"),
   # As the heel-elevated squat, the plates sweep the upper half, so all five
   # labels sit below them (0.56 on screen and lower). The knees reach
   # u 0.19-0.29 at the bottom: the knee-travel label goes on the left just
   # above them (ends at u 0.29), the stance label on the lowest row below
   # them; the knee-tracking label on the right between the depth and wedge
   # labels, its leader running level to the near knee.
   overrides={"knee": (0.612, "leading"), "stance": (0.86, "leading"), "depth": (0.635, "trailing"),
              "track": (0.759, "trailing"), "heels": (0.86, "trailing")},
   annotations=[
       ("track", "Knees track toes", "patella_L"),
       ("knee", "Knees forward", "patella_R"),
       ("depth", "Full depth", "pelvis"),
       ("stance", "Feet close", "foot_R"),
       ("heels", "Heels on wedge", "foot_L"),
   ],
   cues={
       "stance": ("Narrow Stance",
                  "The feet sit close, about hip-width or narrower, toes nearly straight ahead.",
                  "A narrow stance lets the knees bend further and, in back squat studies, a high bar with a narrow stance gave the knees a bigger share of the work out of the bottom, with more vastus lateralis and less gluteus maximus activity, than the other bar and stance combinations. Wider stances brought the glutes in more.",
                  "Setting the feet out wide like a regular squat, which shares more of the work with the hips.",
                  "Place the feet about hip-width apart or closer, both heels on the wedge, toes pointing nearly straight ahead."),
       "knee": ("Knee Travel",
                "The knees drive well forward over the toes as the hips sink.",
                "Forward knee travel is the point of this squat: the raised heels let the shins lean far forward, so the hips drop straight down and the knees take a larger share of the work. Blocking the knees from moving past the toes shifts the load to the hips and lower back.",
                "Sitting the hips back and keeping the shins upright, so the chest tips forward and the squat turns hip-led.",
                "Let the knees travel forward over the toes while the hips sink straight down under the bar, chest up."),
       "track": KNEE_TRACK,
       "depth": ("Depth",
                 "Sink until the backs of the thighs nearly meet the calves.",
                 "Going all the way down takes the knees through their full range. In training studies, full squats built the glutes and adductors more than half squats, and the quadriceps about the same.",
                 "Stopping halfway, the hips well above the knees.",
                 "Sink under control until the thighs are at least parallel, the backs of the thighs close to the calves, hold the bottom for a moment, then drive up without bouncing. If your knees are sensitive, build up the depth gradually."),
       "heels": WEDGE,
   },
   # No study of the cyclist squat by name: ranked from the heel-elevated
   # squat. Quadriceps the same 0.90: stance did not change quadriceps
   # activity in McCaw 1999 or Paoli 2009, Lee 2026 found more vastus
   # medialis with a WIDE stance, and Larsen 2021's extra vastus lateralis
   # for the high-bar narrow stance was post-sticking only. Gluteus maximus
   # lower than the heel-elevated squat's 0.60 (Paoli 2009, McCaw 1999:
   # wider stances raise it; Larsen: less pre-sticking with a narrow stance).
   # Erector spinae only a touch lower for the more upright trunk (15 deg).
   activation=[("Quadriceps", P, HI, 0.90), ("Gluteus Maximus", S, MOD, 0.48),
               ("Erector Spinae", S, MOD, 0.41)],
   stabilisers=["adductors", "hamstrings", "calves", "core"],
   comparison=("HIPS SIT BACK", "Knees forward, hips straight down", "Hips back, shins upright",
               "Letting the knees travel over the toes keeps the hips under the bar and more of the work on the quadriceps.",
               "Sitting back with upright shins tips the chest forward and shifts more of the work to the hips and lower back, the opposite of what the wedge and narrow stance are for."),
   glows=squat_glows("Cyclist Squat"))

SETUP["Cyclist Squat"] = [
    "Set a heel wedge or slant board in front of a squat rack.",
    "Take the bar high across your upper traps, hands wider than your shoulders, and step back.",
    "Stand with your heels on the high end of the wedge, feet hip-width or closer, toes nearly straight.",
    "Brace, chest tall, before the first rep.",
]

# ---------------------------------------------------------------- pistols

ex(name="Pistol Squat", var="pistolSquat",
   library=("QUADRICEPS", "BODYWEIGHT", "advanced"),
   # Side-on from the left (yaw -1.2), the lifter facing screen-left: the arms
   # and free leg reach into the left half, the standing leg, hips and back
   # fill the right half from the top of the head down. So the arm label rides
   # the top row on the left, the depth label the top row on the right (ten
   # characters, starting right of the head at u 0.69), the knee label on the
   # left between the arms at the top and the hands at the bottom, the
   # free-leg label on the lowest row on the left, below the free foot, and
   # the heel label on the lowest row on the right, by the standing ankle.
   overrides={"reach": (0.14, "leading"), "knee": (0.466, "leading"), "free": (0.86, "leading"),
              "depth": (0.14, "trailing"), "foot": (0.86, "trailing")},
   annotations=[
       ("reach", "Arms reach forward", "hand_L"),
       ("depth", "Full depth", "pelvis"),
       ("knee", "Knee tracks toes", "patella_L"),
       ("foot", "Heel down", "foot_L"),
       ("free", "Free leg straight", "foot_R"),
   ],
   cues={
       "reach": ("Counterbalance",
                 "The arms reach forward as the hips sink back and down.",
                 "At the bottom of a pistol the hips sit back over the heel, so the arms, chest and free leg have to reach forward to keep the body's weight over the middle of the foot. A forward trunk lean is part of the lift here.",
                 "The arms dropping and the trunk rocking back at the bottom, so the weight falls behind the heel.",
                 "Reach both arms straight out in front, a little below shoulder height and lower toward the free foot as you sink, and let the chest lean forward toward the knee."),
       "depth": ("Depth",
                 "Sink until the back of the thigh rests on the calf.",
                 "The full pistol takes the standing hip, knee and ankle through their whole range on one leg, which is what makes it hard. Lowering under control and pausing at the bottom keeps the load on the muscles rather than a bounce.",
                 "Stopping halfway, with the hips well above the knee.",
                 "Lower under control until the thigh meets the calf, hold a moment, then drive up through the whole foot. Build the depth gradually, using a support or a box behind you until you own the bottom."),
       "knee": KNEE_SL,
       "foot": FOOT_SL,
       "free": FREE_SL,
   },
   # Single-leg squats: quadriceps first (Mausehund 2019: vastus lateralis no
   # different from the split squats, H:Q 0.63; Boudreau 2009: rectus femoris
   # highest of three; StrengthLog). Gluteus maximus close behind (DiStefano
   # 2009: the single-limb squat among the best; Khuu 2022: more with the
   # free leg in front; Mausehund: same as the split squats' 71-79% MVIC),
   # a little above the split squats' 0.62 for the deeper hip bend. Gluteus
   # medius high on one leg and level with the maximus (Mausehund 81.9% vs
   # 46.2% in the split squat and 71-79% for its gluteus maximus; DiStefano
   # 64% medius vs 59% maximus), a hair below it only for the pistol's
   # deeper hip bend (Caterisano's depth effect on the maximus).
   # Hamstrings moderate (Mausehund H:Q 0.63; Monajati 2019).
   activation=[("Quadriceps", P, HI, 0.90), ("Gluteus Maximus", S, MOD, 0.64),
               ("Gluteus Medius", S, MOD, 0.62), ("Hamstrings", S, MOD, 0.40)],
   stabilisers=["hip flexors", "adductors", "calves", "core"],
   comparison=("KNEE CAVING IN", "Knee in line with the foot", "Knee collapses inward",
               "With the knee over the middle toes, the hip muscles hold the thigh in line and the quadriceps and glutes drive the rep.",
               "On one leg the hip has to keep the knee in line; when it caves in, the knee takes the load at an angle."),
   glows=pistol_glows("Pistol Squat"))

SETUP["Pistol Squat"] = [
    "Stand on one foot, the whole foot flat, toes pointing forward.",
    "Lift the other leg straight out in front, heel just off the floor.",
    "Reach both arms straight out in front, just below shoulder height.",
    "Brace your trunk before you start down.",
]

ex(name="Assisted Pistol Squat", var="assistedPistolSquat",
   library=("QUADRICEPS", "BODYWEIGHT", "intermediate"),
   # Side-on (yaw -1.6), the upright drawn down the left third (u 0.29-0.34)
   # with the hands on the crossbar at u 0.36-0.41, v 0.34-0.39. Laid out as
   # the pistol: the grip label on the top row on the left, above the hands.
   # The three left labels are 13 characters or fewer so their pills end
   # by u 0.29, clear of the upright (review 2).
   overrides={"hold": (0.14, "leading"), "knee": (0.466, "leading"), "free": (0.86, "leading"),
              "depth": (0.14, "trailing"), "foot": (0.86, "trailing")},
   annotations=[
       ("hold", "Light grip", "hand_L"),
       ("depth", "Full depth", "pelvis"),
       ("knee", "Knee in line", "patella_L"),
       ("foot", "Heel down", "foot_L"),
       ("free", "Free leg up", "foot_R"),
   ],
   cues={
       "hold": ("Support",
                "The hands hold the bar for balance and a little help while the leg does the lifting.",
                "Holding a support takes over some of the balance and lets you stay over the foot at depths you cannot yet control alone, so the standing leg still does the lifting. The less you pull, the closer the rep is to a free pistol.",
                "Pulling on the bar to get out of the bottom, so the arms do the lifting the leg should.",
                "Hold the bar only as hard as you need to stay balanced over the standing foot, and use less help as you get stronger."),
       "depth": ("Depth",
                 "Sink until the back of the thigh rests on the calf.",
                 "The support makes the full depth reachable before you can balance there alone, so the standing hip, knee and ankle train through their whole range from the start.",
                 "Stopping halfway, with the hips well above the knee.",
                 "Lower under control until the thigh meets the calf, hold a moment, then drive up through the whole foot, the arms steadying rather than pulling."),
       "knee": KNEE_SL,
       "foot": FOOT_SL,
       "free": FREE_SL,
   },
   # No study of a hand-assisted single-leg squat: the pistol's ranks a step
   # lower, as the hands take some of the weight and most of the side-to-side
   # balance. The gluteus medius drops most, by analogy only with McCurdy
   # 2017's note that the Smith machine cuts frontal-plane muscle work (a
   # technique column, not a measurement); scaled with the pistol's 0.62.
   activation=[("Quadriceps", P, HI, 0.84), ("Gluteus Maximus", S, MOD, 0.58),
               ("Gluteus Medius", S, MOD, 0.47), ("Hamstrings", S, LOW, 0.36)],
   stabilisers=["hip flexors", "forearms", "calves", "core"],
   comparison=("PULLING ON THE BAR", "Leg drives, hands steady", "Arms pull the body up",
               "Holding the bar only for balance keeps the standing leg doing the lifting while the bar steadies you.",
               "Hauling the body up and in toward the bar takes the work off the standing leg, out of the bottom where it most needs it."),
   glows=pistol_glows("Assisted Pistol Squat"))

SETUP["Assisted Pistol Squat"] = [
    "Face a fixed bar or handle at about chest height.",
    "Hold it with both hands and stand on one foot a little less than arm's length from it, elbows bent.",
    "Lift the other leg straight out in front, heel just off the floor.",
    "Brace your trunk before you start down.",
]

if __name__ == "__main__":
    print("\n".join(validate(NAMES) + validate_library(NAMES)) or "OK")
