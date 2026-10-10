# Trainer content for the Desktop "1-100" folder (2026-10-10), family: female.
# The female model's new lifts: Hack Squat (Stances) (Legs/FemaleHackSquat
# Standard/High/Low/Wide/Narrow), Pendulum Squat (Stances)
# (Legs/FemalePendulumSquat<Stance>) and Cable Knee-Drive Kickback (Legs/CableStepDown).
# Same format as spec.py on top of common_1_50.py; spec_1010.py imports this
# module and gen.py reads SPEC / SETUP. notes_1010_female.md maps the copy's
# claims to the sources below and records the model facts.
#
# The stance sets are one exercise each: the trainer opens on the Standard
# stance and its picker swaps the model. Labels, ghosts and the activation
# rows here are authored once, on the Standard model (the exercise-level
# activation is what recovery counts; per-stance lists are handled
# separately), and every line of copy was checked against all five stances.
#
# What the models show, measured from the rigs with Blender's Python + pxr
# ($LAB/femwork/dump.py in the session scratchpad: every joint every frame
# and the equipment's boxes; an.py and cmp.py for angles; ghost.py, a port of
# FaultGhost.solve), the motion briefs (briefs_1010/), tiers.txt, joints.json
# and the trainer stills at 0/1/2/3/5 s. One female body (neck to pelvis
# 0.50 m, hip joints 18 cm apart, shoulder joints 39 cm apart). The hack and
# pendulum rigs face -x (their left is +z); the kickback faces +z.
# - Hack Squat (Stances), 5.96 s, one rep: the knees go 140° -> 150° by
#   0.5 s (the sled lifts off its stops), the safety handle swings open by
#   1.0 s, top held to ~1.7 s, down by 3.0 s (~1.3 s), bottom held 3.0-3.5 s,
#   up by 5.0 s (~1.4 s), the safety swings back by ~5.5-6 s and the sled
#   settles. Back on the pad tipped 17° back the whole rep; hands on the
#   handles by the shoulders; the hips travel 44 cm down (5 cm back) in every
#   stance. Standard: ankles 27 cm apart, toes out 9°, top knees 150°,
#   bottom knees 73° with the hip joints 4.7 cm below the knees, each knee
#   5 cm outside its ankle and 6 cm behind the toes. The plate tilts ~20° up
#   toward the toes; heels flat all clip in every stance. The other stances:
#   High (feet 9 cm further up the plate): top 154°, bottom knees 80°, hips
#   98°, hip joints 9 cm below the knees. Low (8 cm lower): top 152°, bottom
#   knees 70°, hips 108°, hips level with the knees, the knee 1.7 cm past the
#   toes. Wide (ankles 48 cm, toes out 16°): bottom 76°, knees 1.8 cm
#   outside the ankles. Narrow (18 cm, toes out 4°): bottom 73°, 4.4 cm.
#   Paint (Standard): the four quadriceps and all three glutes bright, the
#   three hamstrings dim.
# - Pendulum Squat (Stances), 7.96 s, two 4 s reps: top 0-0.4 s (knees
#   155°), down by 1.75 s (~1.35 s), bottom held to ~2.1 s, up by 3.75 s
#   (~1.6 s). Shoulders under the pads, back on the pad, hands on handles in
#   front of the shoulders. The pad tips the trunk from ~20° back at the top
#   to 30-38° at the bottom while the hips travel down and toward the plate
#   (Standard: 29 cm down, 28 cm forward). The plate rises ~35° toward the
#   toes; heels flat all clip. Standard: ankles 27 cm apart, toes out 9°,
#   bottom knees 67°, hips 112°, the hip joints 13 cm below the knees, each
#   knee 5.4 cm outside its ankle. Across the stances the bottom knee is
#   65-87° (High 65°, hips 22 cm below the knees; Low 87°, hips 3.6 cm above
#   them, thighs about level), the knees 3-6 cm outside the ankles and 9-17
#   cm behind the toes. Paint (Standard): the four quadriceps bright; the
#   glutes and hamstrings dim.
# - Cable Knee-Drive Kickback, 7.96 s, two 4 s reps: the right foot stands on a round
#   plate 6.5 cm high (knee 160° all clip), trunk 32° forward, hands on the
#   cable tower at ~1.3 m, the pelvis still, level and square to the tower
#   all clip. An ankle cuff on the LEFT ankle runs to the low pulley in front
#   (~0.6 m up). The left leg starts with the knee up in front (hip 81°, knee
#   90°, thigh 68° forward of vertical), pushes back over ~1.4 s to hip 170°,
#   knee 170° (thigh 36° behind vertical) at 1.83-2.17 s, returns over ~1.4 s
#   and rests in front 3.6-4.4 s; the foot never touches the floor or plate.
#   Despite the name, the motion is a standing cable kickback from a knee
#   drive. Paint: the three glutes bright, the three hamstrings dim.
#
# How they differ from the library: its Hack Squat and Pendulum Squat are the
# male model in one stance (feet higher on the pendulum's heel-high plate,
# which slopes the other way); its Cable Glute Kickback starts with the leg
# straight. Activation follows the paint (bright = primary, dim =
# secondary) with no exception.
#
# Sources (abstracts read on Europe PMC 2026-10-10; ExRx through the Wayback
# Machine, the live site returns 403; StrengthLog read live; details and what
# each supports in the notes):
# - ExRx.net Sled Hack Squat (WeightExercises/Quadriceps/SLHackSquat, snapshot
#   2026-07-17): lie on the back pad, shoulders under the shoulder pad, extend
#   hips and knees, release the dock levers; re-engage the support lever in
#   the extended position before dismounting; if the pelvis pulls away from
#   the back pad near the bottom, lower only to just short of that; knees the
#   same way as the feet; heels down, push with heel and forefoot; feet
#   slightly high emphasise the gluteus maximus, slightly low the quadriceps;
#   target quadriceps; synergists gluteus maximus, adductor magnus, soleus;
#   dynamic stabilisers hamstrings, gastrocnemius.
# - ExRx.net Cable Standing Hip Extension (GluteusMaximus/
#   CBStandingHipExtension, snapshot 2025-04-20): ankle cuff on a low pulley,
#   hold a bar with both hands, pull the cable back by extending the hip;
#   target gluteus maximus, synergists hamstrings, stabilisers erector
#   spinae, obliques, quadratus lumborum, gluteus medius and minimus.
# - StrengthLog, Hack Squat (strengthlog.com/hack-squat): feet about
#   shoulder-width, extend the legs and disengage the locks, squat as deep as
#   you can with good form; high feet more glute, low feet more quad and calf
#   activity, little difference with width or toe angle; less core activity
#   than a free squat. Pendulum Squat (strengthlog.com/pendulum-squat): back
#   pressed against the backrest throughout, release the safety latch, lower
#   until the thighs are parallel or slightly lower, push through the heels;
#   primary muscles quads, glutes, adductors.
# - Da Silva EM, Brentano MA, Cadore EL, De Almeida AP, Kruel LF 2008, J
#   Strength Cond Res 22(4):1059-1065, doi:10.1519/JSC.0b013e3181739445, PMID
#   18545207 - 14 women, leg press with high and low foot placement: low feet
#   more rectus femoris and vastus lateralis activity at high effort, high
#   feet more gluteus maximus.
# - Escamilla RF, Fleisig GS, Zheng N et al. 2001, Med Sci Sports Exerc
#   33(9):1552-1566, doi:10.1097/00005768-200109000-00020, PMID 11528346 - 10
#   men, squat and high/low foot leg press, wide/narrow stance, feet straight
#   or turned out 30°: no difference in muscle activity or knee forces between
#   the foot angles; the wide-stance high-foot press drew more hamstrings
#   activity than the narrow one.
# - McCaw ST, Melrose DR 1999, Med Sci Sports Exerc 31(3):428-436,
#   doi:10.1097/00005768-199903000-00012, PMID 10188748 - 9 men, parallel
#   squat at 75%, 100% and 140% of shoulder width: stance width did not
#   isolate any part of the quadriceps but did change the medial thigh
#   (adductor longus) and buttock (gluteus maximus) activity.
# - Paoli A, Marcolin G, Petrone N 2009, J Strength Cond Res 23(1):246-250,
#   doi:10.1519/JSC.0b013e3181876811, PMID 19130646 - 6 lifters, three
#   widths: only the gluteus maximus changed (higher with the widest stance).
# - Clark DR, Lambert MI, Hunter AM 2019, J Strength Cond Res 33(Suppl 1):
#   S60-S69, doi:10.1519/JSC.0000000000002144, PMID 28704312 - 10 men, hack
#   squat vs back squat at the same relative loads: trunk muscle activation
#   higher in the back squat for all muscles and phases but one.
# - Bryanton MA, Kennedy MD, Carey JP, Chiu LZ 2012, J Strength Cond Res
#   26(10):2820-2828, doi:10.1519/JSC.0b013e31826791a7, PMID 22797000 - 10
#   strength-trained women: knee extensor relative muscular effort rose with
#   squat depth, not with load (joint moments, not EMG).
# - Caterisano A, Moss RF, Pellinger TK et al. 2002, J Strength Cond Res
#   16(3):428-432, PMID 12173958 - the gluteus maximus share of EMG rose with
#   squat depth; the vasti and biceps femoris shares did not change.
# - Schoenfeld BJ, Grgic J 2020, SAGE Open Med 8:2050312120901559,
#   doi:10.1177/2050312120901559, PMID 32030125 - systematic review: full range
#   of motion favours lower-body hypertrophy over partial range.
# - Stien N, Saeterbakken AH, Andersen V 2021, J Sports Sci Med 20(1):56-61,
#   doi:10.52082/jssm.2021.56, PMID 33707987 (PMC7919354, full text) - 15
#   trained men at 6RM: a standing kickback machine (hip 90° -> 180°) drew
#   gluteus maximus EMG no different from the leg press and more biceps
#   femoris.
# No EMG study of a pendulum squat, of these foot placements on a hack squat
# machine, or of a cable kickback from a knee drive was found, so every
# fraction below is a judgement call anchored on the library's nearest lift;
# the notes say which.
from common_1_50 import *


def ov(final):
    """Pre-squeeze override row for an on-screen row (spec_1010.row() maps
    0.14-0.86 to 0.16-0.80)."""
    return round(0.14 + (final - 0.16) * (0.86 - 0.14) / (0.80 - 0.16), 4)


# ---------------------------------------------------------------- Hack Squat (Stances)

N = "Hack Squat (Stances)"
ex(name=N, var="hackSquatStances",
   # Front-left three-quarter (yaw 0.6): the lifter sits in the middle
   # (head u 0.64, knees u 0.23-0.45 at v 0.58), the loaded plate and the
   # carriage ride down the right (u 0.7-0.95, v 0.45-0.65), the footplate
   # fills the bottom left. Labels sit at the top left, on the left above the
   # knees, and at 0.86 under the shoes and over the static base (the stance
   # picker shortens the viewport and the legend takes two rows below them).
   overrides={"pad": (ov(0.16), "leading"), "top": (ov(0.40), "leading"),
              "depth": (ov(0.50), "leading"), "feet": (ov(0.86), "leading"),
              "knees": (ov(0.86), "trailing")},
   annotations=[
       ("feet", "Feet flat on the plate", "toe_R"),
       ("pad", "Back on the pad", "chest"),
       ("knees", "Knees track out", "patella_L"),
       ("depth", "Thighs to level", "thigh_R"),
       ("top", "Soft knees at the top", "patella_R"),
   ],
   cues={
       "feet": ("Foot Placement",
                "Both feet stay flat on the plate, wherever the stance picker sets them.",
                "The picker moves the feet higher, lower, wider or narrower on the plate; the sled's path and timing stay the same. ExRx notes that feet set slightly high emphasise the gluteus maximus and slightly low the quadriceps, as a leg press study in women found, while in free-squat studies stance width changed glute and inner-thigh activity but did not single out any part of the quadriceps. In every stance here the heels stay down from top to bottom.",
                "The heels peeling off the plate at the bottom, the weight rolling onto the toes.",
                "Set your feet where the stance asks, toes turned out a little, and push through the heel and the ball of each foot on every rep."),
       "pad": ("Back Support",
               "The back, hips and shoulders stay against the pads from top to bottom.",
               "The pad carries the trunk: in one study the hack squat drew less trunk muscle activity than the back squat at the same relative loads. Here the back rests on the pad, tipped about 17 degrees back, while the hips travel about 44 cm down. ExRx warns that if the pelvis starts to pull away from the back pad near the bottom, you should stop the sled just short of that point.",
               "The hips peeling off the pad at the bottom and the lower back rounding to chase more depth.",
               "Press your back and hips into the pad and stop the descent before your pelvis starts to tuck away from it."),
       "knees": ("Knee Tracking",
                 "The knees bend out in line with the toes.",
                 "ExRx keeps the knees pointing the same way as the feet. The sled guides the trunk, not the knees, so this is still up to you. Here, at the bottom, each knee sits about 2 to 5 cm outside its ankle, in line with the slightly turned-out toes, in every stance.",
                 "The knees caving in toward each other at the bottom or as you drive up.",
                 "Keep each knee pointing over your middle toes on the way down and on the way up."),
       "depth": ("Depth",
                 "Lower until the thighs are about level with the floor or a little below.",
                 "StrengthLog squats as deep as you can with good form. Here the knees bend to between about 70 and 80 degrees, depending on the stance, the hips finish level with the knees or up to about 9 cm below them, and the bottom is held for about half a second. In one squat analysis the knee extensors worked closer to their maximum the deeper the squat, and full-range training has built more lower-body muscle than partial reps.",
                 "Stopping high, the knees bent only to about a right angle and the thighs still sloping down.",
                 "Lower under control until your thighs are about level or a little lower, pause briefly, then drive the sled back up."),
       "top": ("Top of the Rep",
               "Stand up to a soft knee, not a hard lockout.",
               "Here the knees open to about 150 to 155 degrees at the top, 25 to 30 degrees short of straight, and stay bent through the top hold, so the thighs keep holding the sled instead of resting it on locked joints. ExRx re-engages the support lever with the legs extended before you step off.",
               "Snapping the knees straight at the top of every rep.",
               "Drive up until your knees are still bent about 25 to 30 degrees, stop there, then start the next rep."),
   },
   # Paint (Standard): the quadriceps and all three glutes bright, the
   # hamstrings dim. Quadriceps 0.88 as the library's Hack Squat (0.89) and
   # Pendulum Squat (0.88); ExRx's target. Gluteus Maximus 0.50: bright, so
   # primary; ExRx's synergist; a step above the library's Hack Squat (0.44,
   # secondary there) for this model's thighs below level at the bottom
   # (Caterisano 2002: the gluteus maximus share rose with depth); the bright
   # gluteus medius and minimus are covered by that row and named in the
   # stabilisers (the house decision of the legs family). Hamstrings 0.25: dim,
   # so secondary; ExRx lists them as dynamic stabilisers. Judgement calls.
   activation=[("Quadriceps", P, HI, 0.88), ("Gluteus Maximus", P, MOD, 0.50), ("Hamstrings", S, LOW, 0.25)],
   stabilisers=["adductors", "gluteus medius", "calves"],
   comparison=("HIPS OFF THE PAD", "Back and hips on the pad", "Hips peel off at the bottom",
               "With the back and hips on the pad, the sled carries the trunk and the legs do the lifting.",
               "When the pelvis tucks away from the pad at the bottom, the lower back rounds under the load; stop just before that point."),
   glows=[glow(N, ["thigh_L", "patella_L"], A, 0.55, 0.06, 0.05, 0.0, 0.0),
          glow(N, ["thigh_R", "patella_R"], SOFT, 0.30, 0.05, 0.05, 0.0, 0.0)])

SETUP[N] = [
    "Pick a stance, then stand on the plate with your back against the pad and your shoulders under the shoulder pads.",
    "Set your feet where the stance puts them, toes turned out a little, and hold the handles by your shoulders.",
    "Straighten your legs a little to lift the sled off its stops, then swing the safety handles open.",
    "After the last rep, close the safety handles with your legs extended before lowering the sled onto the stops.",
]

# ---------------------------------------------------------------- Pendulum Squat (Stances)

N = "Pendulum Squat (Stances)"
ex(name=N, var="pendulumSquatStances",
   # Side-on from the lifter's left (yaw 0), facing screen-left: the beam
   # and pad swing over the top half (u 0.0-1.0, v 0.15-0.5), the lifter's
   # hips sweep u 0.5-0.7 at v 0.5-0.6, the plate sits at the bottom left.
   overrides={"tempo": (ov(0.20), "trailing"), "knees": (ov(0.44), "leading"),
              "pad": (ov(0.75), "trailing"), "depth": (ov(0.81), "trailing"),
              "feet": (ov(0.86), "leading")},
   annotations=[
       ("feet", "Whole foot on the plate", "toe_L"),
       ("pad", "Back on the pad", "spine"),
       ("knees", "Knees track out", "patella_L"),
       ("depth", "Thighs level or lower", "pelvis"),
       ("tempo", "Lower slowly, pause", "chest"),
   ],
   cues={
       "feet": ("Feet on the Plate",
                "The whole foot stays flat on the angled plate, wherever the stance picker sets it.",
                "The picker moves the feet higher, lower, wider or narrower on the plate, and how deep the knees bend changes with them: here the bottom knee angle runs from about 65 degrees with the feet high to about 87 with them low. StrengthLog pushes back up through the heels, and on the hack squat ExRx keeps the heels down, pushing with both heel and forefoot. In every stance here the heels stay flat on the plate, which rises toward the toes.",
                "The heels lifting off the plate at the bottom, the weight rolling onto the toes.",
                "Set your feet where the stance asks, toes turned out a little, and push through your whole foot from the bottom to the top."),
       "pad": ("Back on the Pad",
               "The back and hips stay against the pad as it swings.",
               "The pad carries the trunk along the machine's arc: here it tips you from about 20 degrees back at the top to between 30 and 38 at the bottom while the hips travel down and toward the plate. StrengthLog keeps the back pressed against the backrest throughout, and a supported hack squat has drawn less trunk muscle activity than a back squat. If the hips run out of room at the bottom, the pelvis tucks off the pad and the lower back rounds.",
               "The hips and lower back peeling off the pad at the bottom.",
               "Press your back and hips into the pad from the top to the bottom, and stop before your pelvis starts to tuck."),
       "knees": ("Knee Tracking",
                 "The knees bend out in line with the toes.",
                 "The carriage guides the trunk, not the knees. ExRx keeps the knees pointing the same way as the feet on the hack squat, and the same holds here: at the bottom each knee finishes about 3 to 6 cm outside its ankle, in line with the slightly turned-out toes, in every stance.",
                 "The knees caving in toward each other as you drive up from the bottom.",
                 "Keep each knee pointing over your middle toes on the way down and on the way up."),
       "depth": ("Depth",
                 "Ride the pad down until the thighs are level with the floor or lower.",
                 "StrengthLog lowers the pendulum squat until the thighs are parallel to the floor or slightly lower. In the standard stance here the knees bend to about 67 degrees and the hips finish about 13 cm below the knees; with the feet low the thighs only reach about level. In one squat analysis the knee extensors worked closer to their maximum the deeper the squat.",
                 "Stopping partway down the arc, the hips still high and the knees bent only to about a right angle.",
                 "Ride the pad down until your thighs are at least level with the floor, as far as your back stays on the pad."),
       "tempo": ("Tempo",
                 "Lower under control, pause briefly, then drive up.",
                 "StrengthLog has you lower yourself slowly, and the swinging carriage builds momentum on the way down. Here the descent takes about 1.4 seconds, the hips stay at the bottom for about half a second and the drive up takes about 1.6 seconds, so each drive up starts from a standstill instead of a rebound off the bottom.",
                 "Dropping fast and bouncing straight back up out of the bottom.",
                 "Take a little over a second to lower, hold the bottom for a moment with your back on the pad, then push up through your whole foot."),
   },
   # Paint (Standard): the quadriceps bright; the glutes and hamstrings dim.
   # Quadriceps 0.88 as the library's Pendulum Squat (no EMG of the pendulum
   # squat exists; StrengthLog calls it a quadriceps exercise). Gluteus
   # Maximus 0.40: dim, so secondary; below the library's 0.48 because this
   # model's hips close only to ~112° at the bottom (the library's to 66°;
   # Caterisano 2002, depth and gluteus maximus share). Hamstrings 0.20: dim,
   # secondary. The dim gluteus medius and minimus are covered by the Gluteus
   # Maximus row. Judgement calls.
   activation=[("Quadriceps", P, HI, 0.88), ("Gluteus Maximus", S, MOD, 0.40), ("Hamstrings", S, LOW, 0.20)],
   stabilisers=["adductors", "calves"],
   comparison=("STOPPING HIGH", "Thighs level or lower", "Stops partway down the arc",
               "Riding the pad down until the thighs are level or lower takes the knees through the deep range where the knee extensors work closest to their maximum.",
               "Stopping partway down leaves the deepest part of the range untrained."),
   glows=[glow(N, ["thigh_L", "patella_L"], A, 0.55, 0.07, 0.04, 0.0, 0.0),
          glow(N, ["pelvis", "thigh_L"], SOFT, 0.30, 0.04, 0.04, 0.0, 0.0)])

SETUP[N] = [
    "Pick a stance, then step onto the plate with your back against the pad and your shoulders under the shoulder pads.",
    "Set your feet where the stance puts them, toes turned out a little.",
    "Hold the handles, stand up to take the weight and release the safety latch.",
    "Brace and keep your back pressed against the pad.",
]

# ---------------------------------------------------------------- Cable Knee-Drive Kickback

N = "Cable Knee-Drive Kickback"
ex(name=N, var="cableKneeDriveKickback",
   # Front-left three-quarter (yaw -1.0), the lifter facing the tower on the
   # left: hands on the upright at u 0.16-0.19, the trunk across u 0.35-0.55
   # at v 0.23-0.42, the cuffed left foot sweeping u 0.35-0.85 at v
   # 0.65-0.74, the standing foot and plate at u 0.42-0.5, v 0.75-0.8.
   overrides={"grip": (ov(0.16), "leading"), "torso": (ov(0.20), "trailing"),
              "hips": (ov(0.32), "trailing"), "kick": (ov(0.84), "trailing"),
              "stance": (ov(0.88), "leading")},
   annotations=[
       ("torso", "Lean forward, back still", "chest"),
       ("kick", "Push the foot back", "foot_L"),
       ("hips", "Hips square", "thigh_L"),
       ("stance", "Right foot on the plate", "toe_R"),
       ("grip", "Hold the tower", "hand_R"),
   ],
   cues={
       "torso": ("Torso Angle",
                 "Lean forward from the hips and hold the trunk still.",
                 "Here the trunk leans about 32 degrees forward, hands on the cable tower, and does not move while the leg travels. ExRx lists the erector spinae, obliques and quadratus lumborum as stabilisers for the standing cable hip extension: they hold the trunk still while the hip moves. Arching the lower back at the end of the kick lifts the leg higher, but that extra range comes from the spine, not the hip.",
                 "Arching the lower back to swing the leg higher behind you.",
                 "Hold the tower, lean forward about 30 degrees from your hips and keep your back still from the first rep to the last."),
       "kick": ("Range of Motion",
                "Start with the knee up in front, then push the foot back until the leg is nearly straight.",
                "ExRx attaches the cuff to a low pulley and pulls the cable back by extending the hip. Here each rep starts with the left knee up in front, the hip bent to about 80 degrees, and ends with the hip open to about 170 degrees and the knee nearly straight, the thigh about 36 degrees behind vertical. The leg pauses there for about a third of a second, then returns over about 1.4 seconds, as long as the push back took.",
                "Short kicks, the foot stopping under the hips with the knee still bent.",
                "Push your foot back until your leg is nearly straight behind you, pause, then bring the knee back up in front under control."),
       "hips": ("Hip Position",
                "The hips stay level and square to the tower.",
                "Here the pelvis stays level and faces the tower for the whole set while the left leg swings through about 90 degrees at the hip. If the working hip rolls open, the pelvis turns and the leg drifts out to the side, so the kick is no longer a straight hip extension. ExRx lists the gluteus medius and minimus among the stabilisers.",
                "The working hip rolling open and the leg drifting out to the side as it goes back.",
                "Keep both hip bones pointing at the tower and drive the foot straight back."),
       "stance": ("Standing Leg",
                  "The right foot stands flat on the plate with a slightly bent knee.",
                  "Here the right foot stays flat on a low plate, about 6.5 cm high, with the knee bent to about 160 degrees for the whole set, and the left foot swings past it without touching the floor. The standing leg only holds you steady; the work is in the moving hip.",
                  "Locking the standing knee straight as the working leg kicks back.",
                  "Stand on the plate with your whole right foot, keep a slight bend in that knee and let it hold still."),
       "grip": ("Support",
                "Both hands hold the tower to keep you steady.",
                "ExRx holds a bar with both hands for the standing cable hip extension. Here the hands rest on the tower's upright at about chest height, elbows bent, and the trunk stays still all set, so keeping your balance does not limit how hard the hip can work.",
                "Pulling on the tower to twist the body into each kick.",
                "Hold the upright with both hands, arms relaxed, and keep your shoulders square to the tower."),
   },
   # Paint: the three glutes bright, the three hamstrings dim. Gluteus Maximus
   # 0.84 as the library's Cable Glute Kickback (ExRx's target); the bright
   # gluteus medius and minimus are covered by that row and named in the
   # stabilisers with ExRx's (the house decision of the legs family).
   # Hamstrings 0.50: dim, so secondary; ExRx's synergist; the library's
   # kickback value; in Stien 2021 a standing kickback machine drew more
   # biceps femoris than the leg press. Judgement calls.
   activation=[("Gluteus Maximus", P, HI, 0.84), ("Hamstrings", S, MOD, 0.50)],
   stabilisers=["gluteus medius", "erector spinae", "obliques", "quadratus lumborum"],
   comparison=("BACK ARCHING", "Hip opens, back still", "Lower back arches to lift the leg",
               "Keeping the trunk still ends the kick where the hip runs out of range, so the glutes do the work.",
               "Arching the back lifts the leg higher, but the extra range comes from the spine, not the hip."),
   glows=[glow(N, ["pelvis", "thigh_L"], A, 0.55, 0.05, 0.04, 0.0, 0.0),
          glow(N, ["thigh_L", "patella_L"], SOFT, 0.30, 0.05, 0.05, 0.0, 0.0)])

SETUP[N] = [
    "Strap an ankle cuff to your left ankle and clip it to the low pulley.",
    "Stand on the plate with your right foot, facing the tower, and hold the upright with both hands.",
    "Lean forward from your hips about 30 degrees and keep a slight bend in your right knee.",
    "Bring your left knee up in front with the cable taut before the first rep.",
]
