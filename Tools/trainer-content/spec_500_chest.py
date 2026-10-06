# Trainer content for the 401-500 folder (2026-10-04), family: chest. Five
# bodyweight, belt and landmine presses from the builder's 127-136 set: 132
# Decline Push-Up (Chest/DeclinePushUp), 136 Plyometric Push-Up
# (Chest/PlyometricPushUp), 129 Chest Dip (Chest/ChestDip), 130 Weighted
# Chest Dip (Chest/WeightedChestDip) and 127 Landmine Chest Press
# (Chest/LandmineChestPress). Same format as spec.py on top of
# common_1_50.py; spec_500.py imports this module and gen.py reads SPEC /
# SETUP. notes_500_chest.md maps the copy's claims to the sources below and
# records the model facts.
#
# What the models show, from the briefs (SCRATCH/briefs, SCRATCH/briefs_legs),
# the trainer stills (SCRATCH/stills/<slug>_t*.png), tiers30.json,
# joints.json and the rigs, equipment and skinned meshes read from the USD
# with Blender's Python + pxr (SCRATCH/chest/rig.py, measure.py, pushup.py,
# plyo.py, dip.py, wdip.py, land.py, land2.py, misc.py; the app's Y-up space,
# the lifter facing +z, their left +x). Every clip is 7.96 s with two reps.
# - Decline Push-Up: the toes rest on top of a bench (top 43 cm above the
#   floor, 40 cm deep), the shoe soles 12-14 cm in from its near edge; hands
#   on the floor just outside the shoulders (inner edges 0.56 m apart, the
#   outer shoulders 0.57 m), fingers forward, wrists under the shoulder
#   joints (4 cm toward the feet). The body stays straight (178° at the
#   hips); it slopes 5° head-down at the top and 14° at the bottom (the
#   shoulder-ankle line). Elbows 172° -> 78°, the upper arms ~49° out from
#   the trunk at the bottom; the chest stops 18 cm and the face 19 cm above
#   the floor. Still to 0.67 s, down 1.3 s, a 0.5 s pause at the bottom
#   (2.0-2.5 s), up ~1 s, the top held to 4.7 s, then again.
# - Plyometric Push-Up: an ordinary floor push-up (same hands; the body 15°
#   above level at the top). Still to 0.25 s, a controlled descent to 78° at
#   1.08 s (chest 12 cm off the floor), ~0.1 s at the bottom, an explosive
#   push to straight arms by 1.46 s; the hands leave the floor from ~1.46 to
#   ~1.83 s, the palms at most 5.2 cm up (1.67 s), the shoulders 7 cm and the
#   pelvis 4 cm higher than at the top; the toes stay down and the body stays
#   straight (178°). No clap. It lands with the elbows ~158° and sinks to
#   102° (2.33 s, chest 21 cm off the floor), presses back up slowly to
#   straight arms by 3.33 s and waits to 4.25 s; the second rep repeats it
#   (bottom 5.08 s, flight ~5.46-5.83 s, landing dip 6.33 s). Elbows ~37°
#   out from the trunk at the bottom.
# - Chest Dip: parallel bars 0.60 m apart (centres; the outer shoulders
#   0.57 m), 1.23 m up; neutral grip (palms facing in). Top: elbows 175°,
#   trunk 12° forward. Lowers ~1.5 s (0.4-1.9 s) to elbows 76° with the
#   trunk 33° forward, the shoulder joints 0.8 cm below the elbows (the
#   upper arms 2° past level), the shoulders extended ~59° behind the trunk;
#   holds 0.5 s, presses in 0.9 s, holds the top ~1 s. The elbows stay over
#   the hands (x 0.30 against 0.30), so from the front the forearms stay
#   upright; seen from the side they go back. Knees bent 110°, the feet
#   behind and side by side, thighs about vertical (hips 163-166°). The
#   pelvis drops 21 cm, the shoulders 28 cm.
# - Weighted Chest Dip: the same arms and trunk to the frame; the hips a
#   little straighter (170-176°), the feet higher behind. A dip belt with two
#   chains (S50_DipBeltChain, _R, 36 cm) and a 34 cm plate (BeltPlate) hanging
#   4-9 cm in front of the thighs, its top 21 cm below the belt; the plate
#   moves with the hips, no extra swing.
# - Landmine Chest Press: standing, the left foot a step ahead (ankles 43 cm
#   apart front to back, 36 cm side to side), knees soft (~160°), trunk 15°
#   forward (18° at the top). Both hands on a crossbar handle (20 cm,
#   S50_LandmineHandle with two grips) at the bar's free end, hands 16 cm
#   apart, palms forward and slightly in; the bar's other end in a base on
#   the floor 2.0-2.4 m ahead. Start: the handle at upper-chest height (the
#   hands level with the upper pecs, just in front of them), elbows 60°,
#   pointing down by the sides. Press 0.3-1.25 s up and forward along the
#   arc (the handle rises 36 cm and moves 31 cm forward, ~49° above level),
#   elbows to 162° (not locked), the elbows drawing in toward the midline,
#   the hands finishing about face height; held to ~1.6 s; lowered over
#   ~1.8 s; rests at the chest to 4.3 s. At lockout the arms sit ~131° from
#   the trunk, about where a 40° incline bench press finishes.
# - Highlight tiers (tiers30.json): pectoralis major (clavicular, sternal,
#   abdominal), anterior deltoid and the three triceps heads bright on all
#   five; the Plyometric Push-Up also lights rectus abdominis and the
#   external and internal obliques dim.
#
# How they differ from the library: the Push-Up, Incline, Wide-Grip,
# Diamond, Archer and Medicine Ball Push-Ups keep the feet on the floor and
# press without leaving it; here the decline raises the feet on a bench and
# the plyometric push-up throws the hands off the floor and catches. The
# Bench Dip (hands on a bench, feet on the floor) and Assisted Dip (kneeling
# on a counterweighted pad, trunk upright) are triceps dips; the two chest
# dips hang free on parallel bars, leaning forward, one with a belt and
# plate. The Single-Arm, Half-Kneeling and standing Landmine (shoulder)
# Presses press one arm from the shoulder; the Landmine Chest Press drives a
# two-hand handle from the chest. Cue sets: body line, hands, elbows, depth,
# head (decline); drive, landing, body, hands, countermovement (plyometric);
# lean, depth, elbows, shoulders, legs (dip); belt, lean, depth, lockout,
# legs (weighted dip); grip, start, path, trunk, stance (landmine).
#
# Sources (read 2026-10-04; abstracts on Europe PMC / PubMed, full texts
# where marked; details in notes_500_chest.md):
# - ExRx.net (Wayback Machine; the live site returns 403): Decline Push-up
#   BWDeclinePushup (snapshot 2025-08-20), Push-up BWPushup (2025-02-10),
#   Clap Push-up ClapPushUp (2025-04-05), Chest Dip BWChestDip (2025-04-22),
#   Weighted Chest Dip WtChestDip (2024-12-26), Triceps Dip BWTriDip
#   (2024-12-28), Weight Training Tips, Dip Bar Width (2021 snapshot):
#   set-ups, execution, muscles; decline push-up: filed under the upper
#   chest, target the clavicular pec with the sternal pec, front delt and
#   triceps as synergists; lower elevations target the sternal head with
#   the clavicular head as a synergist, very high ones may not involve the
#   sternal head; stabilisers serratus anterior, rectus abdominis, obliques,
#   quadriceps; range cut short if the grip is too wide or the neck is
#   protracted, pull the head back slightly for a full descent; clap
#   push-up: lower and push up as fast as possible, put the hands back where
#   they started and catch the body, keep hips and waist straight, begin
#   with easier exercises, pivot off the knees if too hard; chest dip: wide
#   bar, hips and knees bent, the elbows allowed to flare to the sides,
#   lower until a slight stretch in the chest or shoulders, added weight on
#   a dip belt around the waist, target sternal pec, synergists front delt,
#   triceps, clavicular pec, pectoralis minor, rhomboids, latissimus,
#   stabiliser lower trapezius; triceps dip: shoulder-width bar, hips
#   straight; dip bar width: hands no wider than the elbows at a right angle
#   (not used in the copy: it limits grip width and does not ask for the
#   elbows over the hands).
# - StrengthLog, Bar Dip (strengthlog.com/bar-dip, fetched 2026-10-04):
#   lower until the shoulder is below the elbow or as deep as comfortable
#   (in competition a rep often counts once the shoulder passes below the
#   elbow); shoulders down and back, not shrugged (shrugging is less
#   efficient and stresses the shoulder); elbows go backward, not out;
#   common mistakes include half reps, swinging the body for momentum and
#   flaring the elbows out to the sides; add weight with a belt; chest,
#   front delt and triceps the primary muscles. StrengthLog, Landmine Press
#   (fetched 2026-10-04): one or both hands, the bar resting on the chest,
#   press to lockout; front delt primary, triceps and chest secondary.
# - Wurm B, VanderZanden TL, Spadavecchia M, Durocher J, Bickham C,
#   Petushek EJ, Ebben WP 2010, ISBS Conference Proceedings 28 (full text,
#   ojs.ub.uni-konstanz.de/cpa/article/view/4457), the conference report of
#   Ebben WP et al. 2011, J Strength Cond Res 25(10):2891-2894,
#   doi:10.1519/JSC.0b013e31820c8587, PMID 21873902 - 23 adults, peak
#   vertical force on the hands as a share of body mass (Table 1): feet on a
#   60.96 cm box 0.74, on a 30.48 cm box 0.70, regular 0.64, hands on a
#   30.48 cm box 0.55, knees 0.49, hands on a 60.96 cm box 0.41.
# - Suprak DN, Dawes J, Stephenson MD 2011, J Strength Cond Res
#   25(2):497-503, doi:10.1519/JSC.0b013e3181bde2cf, PMID 20179649 - 28
#   trained men held static push-up positions on a force plate: the hands
#   supported less body mass in the up than in the down position.
# - Lin YC, Chiang TL, Chan SH, Lin KF, Hsu CH 2026, BMC Sports Sci Med
#   Rehabil 18:139, doi:10.1186/s13102-026-01582-3, PMID 41673781 (full text
#   PMC13005487) - 19 trained men, stable and suspension push-ups at body
#   angles +30, +15, 0, -15 and -30° (shoulder-ankle line against the
#   ground; minus = shoulders below the ankles), %MVIC (Table 1): stable
#   +15° pec (electrode on the sternocostal fibres) 39.2, front delt 44.3,
#   triceps 32.0; 0° 40.8 / 49.1 / 34.5; -15° 35.8 / 55.5 / 37.8; -30° 27.2 /
#   59.5 / 41.4. On the stable surface the front delt and triceps were
#   significantly higher at -15° than at +15°; the pec (angle main effect,
#   surfaces pooled) did not differ between those two angles, was lower at
#   -15° than at 0° and lowest at -30°. The clavicular head was not
#   recorded.
# - Marcolin G, Petrone N, Moro T, Battaglia G, Bianco A, Paoli A 2015,
#   J Athl Train 50(11):1126-1132, doi:10.4085/1062-6050-50.9.09, PMID
#   26488636 (abstract; the PMC full text is not open) - eight volunteers,
#   five push-up variants (standard, wide, narrow, forward, backward):
#   abdominal and back muscle activity highest in the forward and backward
#   variants, which the authors advise using carefully with low back pain.
# - Freeman S, Karpowicz A, Gray J, McGill S 2006, Med Sci Sports Exerc
#   38(3):570-577, doi:10.1249/01.mss.0000189317.08635.1b, PMID 16540847 -
#   more dynamic push-ups (ballistic, with hand movement) required more
#   muscle activation (abdominal wall included) and higher spine load.
# - Garcia-Masso X, Colado JC, Gonzalez LM, Salva P, Alves J, Tella V,
#   Triplett NT 2011, J Strength Cond Res 25(7):2040-2047,
#   doi:10.1519/JSC.0b013e3181e4f7ce, PMID 21701289 - three plyometric
#   push-ups: pectoralis, triceps, external oblique and front delt activity
#   differed between them (values not in the abstract); used only for the
#   activation comment.
# - Dhahbi W, Chaouachi A, Dhahbi AB, Cochrane J, Cheze L, Burnett A,
#   Chamari K 2017, Int J Sports Physiol Perform 12(2):190-197,
#   doi:10.1123/ijspp.2016-0063, PMID 27193045 - 37 soldiers: countermovement
#   plyometric push-ups produced higher peak force and rate of force
#   development at take-off than squat push-ups started from a still bottom
#   position.
# - Moore LH, Tankovich MJ, Riemann BL, Davies GJ 2012, Int J Exerc Sci
#   5(4):334-343, doi:10.70252/ILNL1678, PMID 27182390 (full text PMC4738879)
#   - clap push-ups: the elbows met the floor bent 29.9 +- 9.4° and bent a
#   further 20.8 +- 7.8° on landing.
# - Garcia-Carrillo E, Ramirez-Campillo R, Thapa RK, Afonso J, Granacher U,
#   Izquierdo M 2023, Sports Med Open 9:93, doi:10.1186/s40798-023-00631-2,
#   PMID 37833510 - 35 studies reviewed, 30 meta-analysed, healthy youth and
#   young adults: upper-body plyometric training improved maximal strength
#   (small effect) and medicine-ball throws (moderate) over controls; low or
#   very low certainty.
# - McKenzie A, Crowley-McHattan Z, Meir R, Whitting J, Volschenk W 2022,
#   Int J Environ Res Public Health 19(20):13211, doi:10.3390/ijerph192013211,
#   PMID 36293792 (full text PMC9603242) - 13 men, bench, bar and ring dips:
#   the bar dip raised peak pec, front delt, triceps, upper trapezius,
#   serratus and latissimus activity over the bench dip; in the bar dip the
#   forward lean supplies part of the depth, so less of it comes from
#   shoulder extension; peak shoulder extension 88% of the lifters' maximal
#   range, the dip's most vulnerable position; added load, fatigue or a wide
#   grip may markedly raise the risk of pec injury.
# - McKenzie A et al. 2022, Int J Environ Res Public Health 19(21):14390,
#   doi:10.3390/ijerph192114390, PMID 36361276 (full text PMC9659300) -
#   15 men, bar dips to exhaustion, non-fatigued: peak trunk lean
#   37.3 +- 9.8° (18.5° at the start), peak elbow flexion 114.6° (an inner
#   angle of ~65°), 76% of their maximal passive shoulder extension.
# - Carek PJ, Hawkins A 1998, Med Sci Sports Exerc 30(3):335-338,
#   doi:10.1097/00005768-199803000-00001, PMID 9526877 - a pectoralis major
#   rupture during weighted parallel bar dips (case report).
# - Trebs AA, Brandenburg JP, Pitney WA 2010, J Strength Cond Res
#   24(7):1925-1930, doi:10.1519/JSC.0b013e3181ddfae7, PMID 20512064 -
#   clavicular pec activity higher at 44° and 56° than flat; front delt
#   higher at 28, 44 and 56° than flat.
# - Rodriguez-Ridao D, Antequera-Vique JA, Martin-Fuentes I, Muyor JM 2020,
#   Int J Environ Res Public Health 17(19):7339, doi:10.3390/ijerph17197339,
#   PMID 33049982 - upper pec greatest at a 30° bench, front delt at 60°,
#   triceps similar at all angles.
# - Lauver JD, Cayot TE, Scheuermann BW 2016, Eur J Sport Sci 16(3):309-316,
#   doi:10.1080/17461391.2015.1022605, PMID 25799093 - upper pec higher at
#   30° and 45° than flat in part of the press.
# - Lehman GJ 2005, J Strength Cond Res 19(3):587-591,
#   doi:10.1519/R-15024.1, PMID 16095407 - moving from wide to narrower
#   bench press grips increased triceps activity.
# The fractions are judgement calls anchored on the library's push-up and
# dip values (no EMG in %MVIC exists for any of these five as the models do
# them); each is explained in a comment and in the notes.
from common_1_50 import *


def ov(final):
    """Pre-squeeze override row for an on-screen row (spec_500.row() maps
    0.14-0.86 to 0.16-0.80)."""
    return round(0.14 + (final - 0.16) * (0.86 - 0.14) / (0.80 - 0.16), 4)


def chest_glows(name, pec=0.58, delt=0.50, tri=0.40, dx=0.0, dy=0.0):
    """The working muscles: both pecs, the near front delt and the near
    triceps, from the probed anchors."""
    return [glow(name, ["support_PectoralisMajor_Sternal_L", "support_PectoralisMajor_Sternal_R",
                        "support_PectoralisMajor_Clavicular_L"], A, pec, 0.10, 0.06, dx, dy),
            glow(name, ["deltoid_arc_clavicle_2_L"], A, delt, 0.05, 0.04),
            glow(name, ["upper_arm_L", "forearm_L"], SOFT, tri, 0.06, 0.04)]


# ---------------------------------------------------------------- Decline Push-Up

N = "Decline Push-Up"
ex(name=N, var="declinePushUp",
   overrides={"depth": (ov(0.16), "trailing"), "head": (ov(0.24), "leading"),
              "body": (ov(0.24), "trailing"), "elbow": (ov(0.64), "trailing"),
              "hands": (ov(0.72), "leading")},
   annotations=[
       ("body", "Heels to head in one line", "pelvis"),
       ("hands", "Hands under the shoulders", "hand_L"),
       ("elbow", "Elbows ~45° from the body", "forearm_L"),
       ("depth", "Elbows past a right angle", "chest"),
       ("head", "Head in line", "head"),
   ],
   cues={
       "body": ("Body Line",
                "Heels, hips and head stay in one straight line.",
                "With your feet up, your hands carry more of your weight: at its peak, about 70% of body mass with the feet on a 30 cm box and 74% on a 61 cm box, against 64% on the floor. Held straight and braced, the body passes that load to the chest and arms in one piece.",
                "Letting the hips sag toward the floor as the arms tire.",
                "Squeeze your glutes and brace your abs so the body lowers and rises as one rigid piece."),
       "hands": ("Hand Position",
                 "The hands sit on the floor just outside the shoulders.",
                 "Under the shoulders, the hands push the body straight up off the floor. In an EMG study of five push-up hand placements, setting the hands forward (or back) drew the most abdominal and back-muscle activity, and the authors advise care with those variants if you have low back pain.",
                 "Walking the hands forward so they end up in front of the face at the bottom.",
                 "Place your hands a little wider than your shoulders, fingers forward, so your arms are close to vertical when they are straight."),
       "elbow": ("Elbow Angle",
                 "The elbows travel back at about 45° from the body.",
                 "Angled back about 45°, as this model's are (49° at the bottom), the elbows point toward your feet and the chest, front delts and triceps press together. ExRx files this push-up under the upper chest; in one EMG study, push-ups sloping 15° head-down worked the front delts and triceps harder than ones sloping 15° head-up, with mid-chest activity about the same.",
                 "Flaring the elbows straight out to the sides as the chest drops.",
                 "Let the elbows bend back at about 45° to the ribs, so they point toward your feet at the bottom."),
       "depth": ("Depth",
                 "Lower until the elbows pass a right angle.",
                 "In a force-plate study, the hands carried more of the body's weight in the bottom position of a push-up than in the top one, so short reps skip the most heavily loaded part of each rep.",
                 "Short reps that turn back with the elbows barely bent.",
                 "Lower until your elbows are bent past a right angle and your chest is about a hand's length from the floor, then press back to straight arms."),
       "head": ("Head Position",
                "The head stays in line with the body.",
                "Reaching for the floor with the head makes a rep look deeper while the chest stays high, and a neck poked forward cuts the push-up's range short.",
                "Dropping the head to touch the floor with the nose or chin.",
                "Keep your neck long and your eyes on the floor just ahead of your hands, from the top to the bottom."),
   },
   # Paint: pectoralis major (all three parts), front delt and triceps bright,
   # so all three are PRIMARY. No study measured this push-up at this
   # angle in %MVIC with the clavicular head: the values are the library
   # Push-Up's (pec 0.84, triceps 0.60, front delt 0.52) scaled by the
   # changes Lin 2026 measured on a stable surface between +15° (about a
   # floor push-up) and the model's head-down -5 to -14° (interpolated to
   # -10°: sternocostal pec x0.96, front delt x1.20, triceps x1.15). A
   # judgement call. ExRx names the clavicular pec the target, which is why
   # the library row reads UPPER PECTORALIS; no study recorded the
   # clavicular head here, so the copy only reports ExRx's filing and Lin's
   # measured muscles.
   activation=[("Pectoralis Major", P, HI, 0.80), ("Triceps Brachii", P, MOD, 0.69),
               ("Anterior Deltoid", P, MOD, 0.62)],
   stabilisers=["serratus anterior", "rectus abdominis", "obliques", "quadriceps"],
   comparison=("HIPS SAGGING", "Heels to head in one line", "Hips sink toward the floor",
               "Held straight, the body lowers and rises in one piece, so the chest and arms lift all of the extra weight the raised feet put on the hands.",
               "With the hips sagging, the lower back arches and the body bends at the hips, so part of each rep goes into the bend instead of the press."),
   glows=chest_glows(N))

SETUP[N] = [
    "Kneel on the floor with a knee-high bench behind you.",
    "Place your hands on the floor a little wider than your shoulders.",
    "Set your toes on the bench one foot at a time, legs straight.",
    "Straighten your arms so your body forms one line from heels to head.",
]

# ---------------------------------------------------------------- Plyometric Push-Up

N = "Plyometric Push-Up"
ex(name=N, var="plyometricPushUp",
   overrides={"depth": (ov(0.24), "leading"), "body": (ov(0.32), "trailing"),
              "hands": (ov(0.64), "leading"), "land": (ov(0.64), "trailing"),
              "drive": (ov(0.72), "trailing")},
   annotations=[
       ("drive", "Hands leave the floor", "hand_L"),
       ("land", "Land on soft elbows", "forearm_L"),
       ("body", "Body rigid, hips level", "pelvis"),
       ("hands", "Hands land in place", "hand_R"),
       ("depth", "Dip low, push at once", "chest"),
   ],
   cues={
       "drive": ("Explosive Push",
                 "Push hard enough for the hands to leave the floor.",
                 "Pushing as fast as you can from the bottom makes the push-up a power exercise; in a review of 30 studies, upper-body plyometric training improved medicine-ball throws and strength over controls, though the certainty of that evidence was low or very low. In this model the hands lift about 5 cm.",
                 "Pushing at ordinary speed so the hands never leave the floor.",
                 "From the bottom, drive the floor away as fast as you can until your hands lift off, then bring them straight back down."),
       "land": ("Landing",
                "Catch yourself on bent elbows and sink.",
                "Landing on soft elbows lets the muscles brake the fall. In a lab study of clap push-ups, lifters met the floor with the elbows bent about 30° and let them bend about 20° more; this model bends from about 160° to about 100° before pressing back up.",
                "Landing on straight, locked arms.",
                "Let your hands meet the floor with the elbows slightly bent, sink under control, then press back to straight arms before the next rep."),
       "body": ("Body Line",
                "The body stays rigid from the push to the catch.",
                "The abs and obliques hold the trunk straight while the arms throw it up and catch it; in an EMG study, ballistic push-ups needed more muscle activity, and loaded the spine more, than ordinary ones.",
                "Letting the hips sag as you land, so the lower back takes the jolt.",
                "Brace your abs and squeeze your glutes before you push, and keep heels, hips and head in line through the flight and the landing."),
       "hands": ("Hand Position",
                 "The hands come back down where they took off.",
                 "Landing on the same spots, just outside and under the shoulders, puts the arms under the body to catch it, as ExRx's clap push-up has you do. Hands that land further forward meet the floor ahead of the shoulders, with less of the arm under the load.",
                 "Hands landing further forward, out in front of the face.",
                 "Set your hands a little wider than your shoulders, fingers forward, and aim to land each hand on the spot it left."),
       "depth": ("Countermovement",
                 "Lower to a deep bend, then reverse at once.",
                 "Dropping into the bottom and pushing straight away gets more out of each push: in a force-plate study, plyometric push-ups started with a quick drop produced more peak force, and a faster rise in force, than ones pushed from a still start at the bottom.",
                 "A shallow dip before the push, the elbows barely bent.",
                 "Lower under control until your elbows pass a right angle, then push off the moment you reach the bottom."),
   },
   # Paint: pec, front delt and triceps bright (PRIMARY); rectus abdominis
   # and the obliques dim (SECONDARY). No %MVIC values were found for this
   # push-up: Freeman 2006 found ballistic push-ups needed more muscle
   # activation than ordinary ones and Garcia-Masso 2011 measured pec,
   # triceps, front delt and external oblique activity in three
   # plyometric push-ups (values not in the abstract). Pec 0.88 a little
   # above the library Push-Up's 0.84, triceps 0.70 and front delt 0.60
   # likewise above its 0.60 and 0.52, the abs LOW secondary rows (ExRx and
   # the library list them as stabilisers of push-ups; dim paint). A
   # judgement call.
   activation=[("Pectoralis Major", P, HI, 0.88), ("Triceps Brachii", P, HI, 0.70),
               ("Anterior Deltoid", P, MOD, 0.60), ("Rectus Abdominis", S, LOW, 0.32),
               ("Obliques", S, LOW, 0.28)],
   stabilisers=["serratus anterior", "gluteus maximus", "quadriceps"],
   comparison=("STIFF-ARM LANDING", "Soft elbows absorb the landing", "Arms locked as the hands land",
               "Landing on bent elbows and sinking lets the chest, shoulders and triceps brake the drop before the next push.",
               "Locked arms stop the body at the joints, so the landing jolts the elbows and shoulders instead of being absorbed by the muscles."),
   glows=chest_glows(N) + [glow(N, ["spine", "pelvis"], SOFT, 0.25, 0.07, 0.03)])

SETUP[N] = [
    "Set up as for a push-up, hands a little wider than your shoulders.",
    "Tuck your toes, feet together, body in one straight line.",
    "Brace your abs and glutes before each rep.",
    "If you cannot yet push off from your toes, start from your knees.",
]

# ---------------------------------------------------------------- Chest Dip

N = "Chest Dip"
ex(name=N, var="chestDip",
   overrides={"lean": (ov(0.16), "trailing"), "shoulders": (ov(0.24), "trailing"),
              "depth": (ov(0.32), "trailing"), "elbow": (ov(0.40), "trailing"),
              "legs": (ov(0.72), "leading")},
   annotations=[
       ("lean", "Chest tips forward", "neck"),
       ("depth", "To elbow height", "forearm_L"),
       ("elbow", "Forearms upright", "hand_L"),
       ("shoulders", "Shoulders down", "upper_arm_L"),
       ("legs", "Knees bent, legs still", "patella_R"),
   ],
   cues={
       "lean": ("Trunk Angle",
                "The chest tips forward as you lower.",
                "Leaning forward lets you sink deep while the shoulder bends back less: in a lab study of bar dips, the lean supplied part of the depth that the shoulder would otherwise have to give. ExRx's chest dip bends at the hips and knees and targets the chest, where its triceps dip keeps the hips straight.",
                "Holding the trunk bolt upright all the way down, as in a triceps dip.",
                "Start with a slight forward lean and let it grow to about 30° at the bottom, then come back to the start lean as you press up."),
       "depth": ("Depth",
                 "Lower until the shoulders reach elbow height.",
                 "In competition a dip usually counts once the shoulders pass below the elbows; this model goes just past elbow height, the elbows bent to about 75°. Lifters in lab studies used most, but not all, of their shoulders' backward range at the bottom of a bar dip.",
                 "Half reps that turn back with the elbows barely bent.",
                 "Lower until your shoulders are level with your elbows, then press back up to straight arms."),
       "elbow": ("Elbow Path",
                 "The elbows stay over the bars.",
                 "With each elbow over its hand, the forearms stay upright and push straight down into the bars. StrengthLog's guide has the elbows travel backward, not out, and lists elbows flaring out to the sides among common dip mistakes.",
                 "Elbows splaying out wider than the hands as you sink.",
                 "Keep each elbow above its hand as you lower, the elbows travelling back with the bars, never out past them."),
       "shoulders": ("Shoulder Position",
                     "The shoulders stay down, away from the ears.",
                     "Shrugging lets the body hang from the shoulders at the bottom, which makes the dip less efficient and adds stress to the shoulder joint.",
                     "The shoulders shrugging up toward the ears as you sink.",
                     "Push the bars down and keep your neck long, shoulders down and back, from the top to the bottom."),
       "legs": ("Leg Position",
                "Knees bent, feet behind, legs quiet.",
                "Bent knees keep the feet clear of the floor under the bars, and quiet legs keep the press on the chest, shoulders and arms; StrengthLog lists swinging the body for momentum among common dip mistakes.",
                "Kicking the knees forward to swing up out of the bottom.",
                "Bend your knees so your feet trail behind you, and hold that shape for the whole set."),
   },
   # Paint: pec, front delt and triceps bright, all PRIMARY. No %MVIC
   # exists for the bar dip: McKenzie 2022 reported peak EMG in mV, the
   # bar dip higher than the bench dip for the pec, front delt and triceps
   # (triceps 1.04 vs 0.83 mV). Values from the library's dips moved up for
   # an unassisted, leaning dip: pec 0.84 (Assisted Dip 0.56; ExRx names the
   # sternal pec the target of the chest dip), triceps 0.82 (Assisted Dip
   # 0.84, Bench Dip 0.86), front delt 0.66 (Assisted 0.48). A judgement
   # call.
   activation=[("Pectoralis Major", P, HI, 0.84), ("Triceps Brachii", P, HI, 0.82),
               ("Anterior Deltoid", P, MOD, 0.66)],
   stabilisers=["pectoralis minor", "latissimus dorsi", "rhomboids", "lower trapezius"],
   comparison=("STAYING UPRIGHT", "Chest tips forward to ~30°", "Trunk stays upright",
               "With the trunk leaning, part of the depth comes from the lean, and the chest, front shoulders and triceps press together.",
               "Bolt upright, more of the depth has to come from the shoulders bending back, and the chest dip turns toward a triceps dip."),
   glows=chest_glows(N))

SETUP[N] = [
    "Stand between parallel bars set about shoulder width or a little wider.",
    "Grip the bars, palms facing in, and press up to straight arms.",
    "Bend your knees so your feet hang behind you.",
    "Lean your chest slightly forward, shoulders down.",
]

# ---------------------------------------------------------------- Weighted Chest Dip

N = "Weighted Chest Dip"
ex(name=N, var="weightedChestDip",
   overrides={"lean": (ov(0.16), "trailing"), "depth": (ov(0.24), "trailing"),
              "lockout": (ov(0.32), "trailing"), "belt": (ov(0.52), "leading"),
              "legs": (ov(0.40), "trailing")},
   annotations=[
       ("belt", "Belt low", "pelvis"),
       ("lean", "Lean in as you sink", "neck"),
       ("depth", "Shoulders to elbows", "upper_arm_L"),
       ("lockout", "Finish straight", "forearm_L"),
       ("legs", "Legs quiet", "foot_L"),
   ],
   cues={
       "belt": ("Belt Setup",
                "The belt sits low on the hips, the plate hanging in front.",
                "Hung from a belt, the plate loads the dip without anything in your hands, and hanging close in front of the thighs it stays out of the way of the bars and the legs.",
                "Hanging the plate on a long chain so it swings between the knees.",
                "Fasten the belt around your hips, hook the plate on a short chain and let it hang still in front of your thighs."),
       "lean": ("Trunk Angle",
                "Let the trunk lean forward as the plate goes down.",
                "The plate changes the load, not the movement: the lean grows from about 12° at the top to about 33° at the bottom, as in the bodyweight chest dip, so the lean shares the depth with the shoulders.",
                "Staying upright under the plate, so the shoulders must bend back further for the same depth.",
                "Lean slightly forward before the first rep and let the chest tip further forward as you sink."),
       "depth": ("Depth",
                 "Stop with the shoulders at elbow height.",
                 "The bottom, where the shoulders are bent furthest back, is the dip's most vulnerable position. A pectoralis major tear during weighted dips has been reported, and dip researchers caution that added load or fatigue may raise the risk of pec injury.",
                 "Sinking well below elbow height to chase a deeper stretch under the plate.",
                 "Lower under control until your shoulders reach elbow height, then press up; add weight only while that depth stays smooth."),
       "lockout": ("Lockout",
                   "Finish every rep on straight arms.",
                   "Pressing all the way to straight elbows completes the triceps' share of the dip and gives you a steady top position to reset the lean and the plate before the next rep.",
                   "Cutting the press short with the elbows still bent and sinking straight into the next rep.",
                   "Press until your arms are straight and your shoulders are down, pause for a moment, then start the next rep."),
       "legs": ("Leg Position",
                "Knees bent behind you, legs still.",
                "Quiet legs keep the plate hanging still; a kick out of the bottom sets it swinging, and a swinging plate pulls you around on the bars.",
                "Kicking the knees forward out of the bottom, the plate swinging with them.",
                "Bend your knees so your feet trail behind, thighs about vertical, and hold that shape through every rep."),
   },
   # Paint: pec, front delt and triceps bright, all PRIMARY. No EMG
   # exists for the weighted dip; the extra load raises each value over
   # the bodyweight Chest Dip (pec 0.84, triceps 0.82, front delt 0.66) to
   # 0.90, 0.88 and 0.72. A judgement call.
   activation=[("Pectoralis Major", P, HI, 0.90), ("Triceps Brachii", P, HI, 0.88),
               ("Anterior Deltoid", P, HI, 0.72)],
   stabilisers=["pectoralis minor", "latissimus dorsi", "lower trapezius", "core"],
   comparison=("SINKING TOO DEEP", "Shoulders stop at elbow height", "Shoulders sink below the elbows",
               "Stopping at elbow height keeps the loaded chest and shoulders working through the range the dip is built on.",
               "Sinking deeper under a plate takes the loaded shoulder further back toward the end of its range, where dip researchers see the most risk."),
   glows=chest_glows(N))

SETUP[N] = [
    "Fasten a dip belt low around your hips and hang a plate from its chain.",
    "Stand between the bars, grip them palms in and press up to straight arms.",
    "Let the plate hang still in front of your thighs, knees bent behind you.",
    "Lean slightly forward, shoulders down, before the first rep.",
]

# ---------------------------------------------------------------- Landmine Chest Press

N = "Landmine Chest Press"
ex(name=N, var="landmineChestPress",
   overrides={"grip": (ov(0.12), "leading"), "core": (ov(0.24), "trailing"),
              "path": (ov(0.66), "leading"), "elbow": (ov(0.74), "leading"),
              "stance": (ov(0.80), "leading")},
   annotations=[
       ("grip", "Wrists straight", "hand_R"),
       ("elbow", "Elbows low by the ribs", "forearm_R"),
       ("path", "Up the arc", "hand_R"),
       ("core", "Lean in", "neck"),
       ("stance", "Left foot a step ahead", "foot_L"),
   ],
   cues={
       "grip": ("Grip",
                "Both hands hold the crossbar handle, wrists straight.",
                "Straight wrists stack the hands behind the handle so the push runs straight up the forearms. The close two-hand grip also keeps the triceps busy: in a bench-press EMG study, narrower grips raised triceps activity.",
                "Letting the wrists bend back so the handle rolls toward the fingers.",
                "Wrap both hands around the handle's grips, palms facing forward, and keep the wrists straight from the chest to the top."),
       "elbow": ("Start Position",
                 "The handle starts at the upper chest, elbows low.",
                 "With the elbows down by the ribs, the forearms sit behind the handle, so the press starts along the bar's arc instead of out to the sides.",
                 "Starting with the elbows flared out to the sides at chest height.",
                 "Hold the handle just in front of your upper chest with your elbows pointing down, close to your sides."),
       "path": ("Press Path",
                "Press up and forward along the bar's arc.",
                "The handle climbs at about 50° here, and the arms finish about where they would at the top of a 40° incline bench press; in bench-press EMG studies, inclines of about 30-45° drew more upper-chest and front-delt activity than a flat bench.",
                "Stopping short with the elbows still well bent at the top.",
                "Drive the handle up and away until your arms are nearly straight in front of your face, then lower it back to your chest."),
       "core": ("Trunk Position",
                "Lean slightly into the bar, ribs down.",
                "A small forward lean, about 15° here, puts your body weight behind the press. Leaning back arches the lower back and lets the hips help push the handle up.",
                "Leaning back and arching the lower back to get the handle up.",
                "Brace your abs, keep your ribs down over your hips and hold the slight forward lean from the first rep to the last."),
       "stance": ("Stance",
                  "The left foot stands a step ahead of the right.",
                  "A split stance gives a long base front to back, so you can push forward into the bar without rocking back on your heels.",
                  "Standing with the feet side by side, so each press rocks you back.",
                  "Step your left foot ahead of the right, knees soft, weight through both feet."),
   },
   # Paint: pec (all three parts), front delt and triceps bright, all
   # PRIMARY. No EMG exists for the two-hand landmine press. The arc ends
   # near a 40° incline press: Trebs 2010 found the clavicular pec and the
   # front delt above a flat press at 44°, Rodriguez-Ridao 2020 the upper pec
   # greatest at 30°; the close handle raises the triceps (Lehman 2005).
   # Values from the library's Single-Arm Landmine Press (upper pec 0.78,
   # front delt 0.76, triceps 0.50), the triceps raised to 0.62 for the close
   # two-hand grip. A judgement call. StrengthLog lists the front delt first
   # for its landmine press; the pec just above it follows the library row,
   # and their order is part of the judgement call.
   activation=[("Pectoralis Major", P, HI, 0.78), ("Anterior Deltoid", P, HI, 0.76),
               ("Triceps Brachii", P, MOD, 0.62)],
   stabilisers=["serratus anterior", "core", "glutes", "rotator cuff"],
   comparison=("ELBOWS FLARED", "Elbows start low by the ribs", "Elbows flared out wide",
               "Starting with the elbows down puts the forearms behind the handle, so the press runs up the arc with the chest, shoulders and triceps together.",
               "Flared elbows start the press out to the sides, so the first part of the push runs across the arc instead of along it."),
   glows=chest_glows(N))

SETUP[N] = [
    "Load the free end of a landmine bar and fit a crossbar handle to it.",
    "Face the landmine with your left foot a step ahead, knees soft.",
    "Hold the handle in both hands at upper-chest height, elbows down.",
    "Lean slightly forward into the bar and brace your core.",
]
