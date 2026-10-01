# Trainer content for the 30-leg set (2026-09-28), family "machine": the belt
# squat, pendulum squat and V-squat from the HIKSEMI drive's "300-350/27_9"
# folder. Same format as spec.py, on top of common_legs30.py; spec_legs30.py
# collects this family with the others.
#
# What each model shows, from the rig (joint positions and angles every 0.5 s,
# equipment bounds and mesh points from the USD, briefs_legs30/*.md) and the
# framing stills. All three do two reps in 8 s with both legs working together
# (no leg switch): about 1 s down, a 0.75-0.8 s hold at the bottom, about
# 1.75 s up. The rig's torso (neck to pelvis) is 0.59 m, its shoulder joints
# 0.39 m apart; none of the three rigs has toe joints.
# - Belt Squat (BeltSquat, yaw -1.5: side-on from the lifter's left, the
#   lifter facing screen-left, the front upright, its handles and the weight
#   trolley's plates ahead of the lifter on the left of the screen, the deck
#   running back to the right; re-framed from -0.8, three-quarter from the
#   front-left, where the trolley's plates and sleeve and the front-right
#   upright hid the knees and feet). The lifter stands on a raised deck
#   (tread 0.30 m up) with a padded belt round the hips (from hip-joint height
#   to ~20 cm above it); the cable clips to the front of the belt and runs
#   down between the feet through a slot in the deck (at the top it slants
#   ~12° forward from the slot to the clip, ~15 cm ahead of the ankles; at
#   the bottom it hangs nearly straight), under it to a pulley and up over a head pulley to a weight trolley on the upright in
#   front of the lifter, which rises and falls with the hips (0.52 m of
#   travel). Ankles 0.42 m apart (about shoulder width), toes turned out 12°,
#   the ankles in line front to back with the cable slot. The hands grip two
#   fixed handles on the front upright, 1.44 m up: at the top ~28 cm below and
#   ~19 cm in front of the shoulder joints (elbows 80°), at the bottom the arms
#   reach up to them (hands ~11 cm above the shoulders); nothing shows the
#   arms pulling. The hips sink 46 cm almost straight down (5 cm back): knees
#   161° -> 54°, hips 163° -> 87°, trunk 5° -> 25° forward. The knees travel
#   far forward (shins 59° from vertical, the knee ~34 cm ahead of the ankle)
#   while the thighs stop ~20° above parallel (hip joint ~15 cm above the knee
#   joint). The feet stay flat throughout (the foot bone's angle never
#   changes). Knees 161° at the top: not locked.
# - Pendulum Squat (PendulumSquat, yaw -1.3: side-on from the lifter's left,
#   facing screen-left, the machine and its plates behind on the right). The
#   shoulders sit under the pads of a carriage that swings about an axle
#   ~1.9 m up and ~1.2 m behind the heels; the back rests on its pad and the
#   hands hold handles fixed to it in front of the chest (elbows 73°
#   throughout). The footplate slopes ~10° down toward the toes (top surface
#   0.33 m at the heel end, 0.19 m at the toe end), so the heels sit higher
#   than the toes. Ankles 0.46 m apart, toes out 13°. Going down, the hips
#   travel 45 cm down and 40 cm back along the carriage's arc; the knees first
#   move forward (shins 33° at 0.5 s, the knee 22 cm ahead of the ankle), then
#   back as the hips swing behind (shins 14° at the bottom). Bottom: knees 78°,
#   hips 66°, the thighs parallel (-1°), trunk 24° forward (0° at the top).
#   Knees 167° at the top.
# - V-Squat (VSquat, yaw -1.3: side-on from the left, facing screen-left, the
#   machine behind on the right). Shoulders under the pads, back on the pad,
#   hands on handles fixed to the carriage in front of the shoulders (elbows
#   73°). The carriage pivots about a low axle (0.3 m up) ~2 m behind the
#   heels. The footplate slopes ~8° up toward the toes (0.24 m at the heel
#   end, 0.35 m at the toe end). At the top the feet sit ~42 cm ahead of the
#   hips, the knees 14 cm behind the ankles (shins 21° back from vertical),
#   the trunk vertical and the knees at 161° (not locked). Going down the hips
#   drop 34 cm and come 12 cm forward and the shoulders travel 35 cm down and
#   23 cm forward. Bottom: knees 71°, hips 78°, the thighs parallel (-1°), the
#   shins 20° forward (knee 14 cm ahead of the ankle), trunk 12° forward.
#   Ankles 0.46 m apart, toes out 11°.
#
# Sources (each checked; notes_legs30_machine.md maps the claims to them):
# - Evans TW, McLester CN, Howard JS, McLester JR, Calloway JP 2019, J Strength
#   Cond Res 33(Suppl 1):S52-S59, doi 10.1519/JSC.0000000000002052 — 31 men
#   and women, 5RM machine belt squat vs back squat: vastus medialis, vastus
#   lateralis and rectus femoris did not differ; gluteus maximus lower in the
#   belt squat (left 0.69 vs 0.84, right 0.71 vs 0.86).
# - Joseph L, Reilly J, Sweezey K, Waugh R, Carlson LA, Lawrence MA 2020,
#   J Hum Kinet 72:223-228, doi 10.2478/hukin-2019-0126 — 10 trained lifters,
#   3x5 at 100% bodyweight, pivoting-lever belt squat machine vs parallel back
#   squat: lumbar erector impulse 45.4% and peak 52.0% lower in the belt
#   squat; gluteus maximus 35.2% / 32.1% and gluteus medius 54.1% / 55.2%
#   lower; rectus abdominis and external oblique lower; quadriceps, adductors,
#   medial gastrocnemius and tibialis anterior not different; integrated
#   biceps femoris not different (peak 12.2% lower). Method: ankles aligned
#   with the belt attachment point (manufacturer's instruction); hands only
#   hovering over or resting lightly on the handle bar, not used to assist.
#   Its discussion notes that Gulick's machine let the load slide along a
#   fixed rod while its own and Evans's rotated about a pivot, and that
#   fixed-track resistance lowers activation (Schwanbeck 2009).
# - Gulick DT, Fagnani JA, Gulick CN 2015, Isokinetics Exerc Sci 23(2):
#   101-108, doi 10.3233/IES-150570 — 13 participants, 8RM, hip belt squat
#   machine (SquatMax-MD, load sliding on a fixed rod), with and without a
#   band, vs back squat: no significant
#   difference in quadriceps, biceps femoris, adductor, abductor, gluteus
#   maximus or gastrocnemius activity; the belt unloads the shoulders and
#   spine.
# - Layer JS, Grenz C, Hinshaw TJ, Smith DT, Barrett SF, Dai B 2018, J Strength
#   Cond Res 32(12):3301-3309, doi 10.1519/JSC.0000000000002854 — 16 men and
#   10 women, maximal isometric belt and back squats at 4 depths, peak values
#   interpolated to a 45° thigh angle: higher peak force, ankle and knee
#   moments and lower low-back moments in the belt squat; hip moments not
#   different. The larger moments partly reflect the larger total force.
#   None of the three EMG studies above used a cable and weight-stack belt
#   squat like the model's (Evans and Joseph: pivoting lever; Gulick: fixed
#   rod).
# - Clark DR, Lambert MI, Hunter AM 2019, J Strength Cond Res 33(Suppl 1):
#   S60-S69, doi 10.1519/JSC.0000000000002144 — hack squat vs back squat at
#   the same relative loads: trunk muscle activation higher in the back squat
#   for all muscles and phases but one; the hack squat's 1RM higher, credited
#   to the supported trunk.
# - Erdag D, Yavuz HU 2020, in: Aliev RA et al. (eds) ICSCCW-2019, Advances in
#   Intelligent Systems and Computing 1095:859-865, Springer, doi
#   10.1007/978-3-030-35249-3_114 — 14 men, 60% 1RM: erector spinae and
#   semitendinosus EMG lower in the hack squat than in front, back, sumo and
#   Zercher squats (conference paper; cited only for the direction).
# - Bryanton MA, Kennedy MD, Carey JP, Chiu LZ 2012, J Strength Cond Res
#   26(10):2820-2828, doi 10.1519/JSC.0b013e31826791a7 — 10 strength-trained
#   women: knee extensor relative muscular effort (joint moment over the
#   maximum torque at that angle, not EMG) rose with squat depth (not with
#   load); hip extensor effort rose with both.
# - Caterisano A, Moss RF, Pellinger TK, Woodruff K, Lewis VC, Booth W,
#   Khadra T 2002, J Strength Cond Res 16(3):428-432, doi
#   10.1519/1533-4287(2002)016<0428:TEOBSD>2.0.CO;2 — gluteus
#   maximus share of concentric EMG rose with depth (16.9 / 28.0 / 35.4%
#   partial / parallel / full); vasti and biceps femoris shares unchanged.
# - Kubo K, Ikebukuro T, Yata H 2019, Eur J Appl Physiol 119(9):1933-1942, doi
#   10.1007/s00421-019-04181-y — full squat training grew the adductors and
#   gluteus maximus more than half squats; knee extensors grew similarly.
# - Schoenfeld BJ, Grgic J 2020, SAGE Open Med 8:2050312120901559, doi
#   10.1177/2050312120901559 — systematic review: full range of motion favours
#   lower-body hypertrophy over partial range.
# - Kongsgaard M et al. 2006, Clin Biomech 21(7):748-754, doi
#   10.1016/j.clinbiomech.2006.03.004 — single-leg eccentric squats on a 25°
#   decline board: higher knee extensor EMG and patellar tendon strain than on
#   a flat surface; hamstring and calf EMG unchanged.
# - Richards J, Selfe J, Sinclair J, May K, Thomas G 2016, J Hum Kinet
#   52:125-138, doi 10.1515/hukin-2015-0200 — 18 adults, bodyweight two-leg
#   (double-limb) squats on declines of 0-25°: the peak knee moment rose
#   significantly already at 10° (1.65 at 0° to 2.23 at 10°,
#   p<0.001) and the ankle moment fell as the decline steepened.
# - Zwerver J, Bredeweg SW, Hof AL 2007, Br J Sports Med 41(4):264-268, doi
#   10.1136/bjsm.2006.032482 — single-leg decline squats: knee moment ~40%
#   higher at declines of 15° and steeper; hip and ankle moments lower.
# - Fry AC, Smith JC, Schilling BK 2003, J Strength Cond Res 17(4):629-633,
#   doi 10.1519/1533-4287(2003)017<0629:EOKPOH>2.0.CO;2 — 7 men, parallel
#   barbell squats: stopping the knees at the toes cut knee torque and raised
#   hip torque and trunk lean; appropriate loading may require the knees to
#   move slightly past the toes (backs letting the knees move past the toes;
#   the model's much larger forward travel is the model's, not Fry's).
# - Powers CM 2010, J Orthop Sports Phys Ther 40(2):42-51, doi
#   10.2519/jospt.2010.3337 — poor hip control affects knee mechanics
#   (review).
# - ExRx.net, read through Internet Archive copies (exrx.net blocks automated
#   fetches): Cable Belt Squat (Quadriceps/CBSquatBelt, snapshot 2020-09-22):
#   belt on, cable clipped to the front of the belt, feet shoulder width or
#   wider to each side of the cable, hands on the pole for balance; knees the
#   same way as the feet, feet flat, weight through forefoot and heel,
#   thighs just past parallel; target quadriceps, synergists gluteus maximus,
#   adductor magnus, soleus, dynamic stabilisers hamstrings, gastrocnemius.
#   Weighted Belt Squat (Quadriceps/WtSquat, 2023-05-30): the same execution
#   and muscles. Lever V-Squat (Quadriceps/LVVSquat, 2021-01-28): shoulders
#   under the pads, back against the back pad, feet shoulder or hip width;
#   knees the same way as the feet; descend until the knees or hips are near
#   complete flexion; if hip flexibility runs out the pelvis pulls away from
#   the back pad, so only lower just short of that; do not let the heels rise,
#   push with heel and forefoot; feet slightly forward emphasise the gluteus
#   maximus, slightly back the quadriceps; same muscles as above. Sled Hack
#   Squat (Quadriceps/SLHackSquat, 2024-12-01) and Lever Hack Squat
#   (LVHackSquatPL, 2019-10-19): the same pad, heel and foot-height notes.
# - StrengthLog, Belt Squat guide (quads, glutes, adductors; normal squat
#   stance; as deep as possible with good technique) and Pendulum Squat guide
#   (quads, glutes, adductors; feet about hip width; back pressed against the
#   backrest; thighs parallel or slightly lower; push through the heels).
# No EMG study of the pendulum squat or the V-squat was found (PubMed / Europe
# PMC searches for both names, 2026-09-28). Their rows are ranked from the
# closest studied lifts (the hack squat, machine and free squats, the depth
# studies) and match the library's Hack Squat; see the notes.

from common_legs30 import *

NAMES = ["Belt Squat", "Pendulum Squat", "V-Squat"]


BOTTOM = (1, 2, 5, 6)  # joints.json samples at 1, 2, 5 and 6 s: at or near the bottom


def low_glow(name, joints, kind=A, opacity=0.55, rx=0.12, ry=0.08, dx=0.0, dy=0.0):
    """glow() centred on the joints' mean over the bottom samples only: the
    hips travel 34-46 cm on these machines, so the all-clip mean floats off
    the thigh at both ends; the glow sits where the rep pauses."""
    pts = [J[name][j][i] for j in joints for i in BOTTOM]
    cx = sum(u for u, _ in pts) / len(pts) + dx
    cy = sum(v for _, v in pts) / len(pts) + dy
    return (kind, opacity, rx, ry, round(min(max(cx, 0.05), 0.95), 3), round(min(max(cy, 0.05), 0.95), 3))


def side_glows(name):
    """Side-on machines (lifter facing screen-left): the near (left) thigh's
    quadriceps, then the glutes behind the hip, to the right."""
    return [low_glow(name, ["thigh_L", "patella_L"], A, 0.55, rx=0.13, ry=0.05),
            low_glow(name, ["pelvis", "thigh_L"], SOFT, 0.28, rx=0.06, ry=0.05, dx=0.03)]


# ---------------------------------------------------------------- belt squat

ex(name="Belt Squat", var="beltSquat",
   library=("QUADRICEPS", "BELT", "beginner"),
   # Side-on from the lifter's left (yaw -1.5), facing screen-left: the
   # upright, handles and plates fill the left of the screen, the lifter the
   # middle, open background and the deck the right. Nothing of the machine
   # crosses the legs now, so the dots use the near (left) side: the left
   # hand, the left knee and the left ankle for the flat foot, plus the
   # pelvis (under the belt) for depth. The cable label points at the right
   # ankle: side-on it sits behind the left ankle, where the cable drops
   # through the deck between the feet, so its dot lands on the cable just
   # above the deck instead of sharing the foot label's joint. The hands pill
   # sits top left above the handle posts, its right end clear of the face
   # at mid-descent (at 0.32 it covered the top of the head in the bottom
   # hold); the knee pill on the left over the upright and plates, level
   # with the knee at the bottom; depth, cable and foot pills down the right
   # over the background and the deck, behind the glutes and heels, so every
   # leader is short and none crosses the face (checked by drawing the pills
   # over the start, mid-descent, bottom and second-rep stills; at 0.68 the
   # cable pill came within a few pixels of the glutes at the bottom).
   overrides={"hands": (0.26, "leading"), "knee": (0.68, "leading"), "depth": (0.50, "trailing"),
              "cable": (0.72, "trailing"), "heel": (0.86, "trailing")},
   annotations=[
       ("hands", "Hands light on handles", "hand_L"),
       ("knee", "Knees track toes", "patella_L"),
       ("cable", "Over the cable", "foot_R"),
       ("depth", "Sink deep", "pelvis"),
       ("heel", "Whole foot flat", "foot_L"),
   ],
   cues={
       "cable": ("Stance Over the Cable",
                 "The feet sit either side of the cable, the ankles in line with it.",
                 "The cable runs down from the front of the belt between the feet. With the ankles in line with it, the load pulls straight down through the middle of the feet, so you stay balanced over the whole foot and the legs do the work.",
                 "Setting the feet ahead of the cable, so it pulls the hips back behind the heels as you sink.",
                 "Stand with the feet about shoulder-width, one either side of the cable, the ankles in line with where it runs down between the feet, and the toes turned out a little."),
       "hands": ("Hands on the Handles",
                 "The hands rest on the handles for balance, not to lift.",
                 "The weight hangs from the belt, so the handles are only there to steady you. Pulling on them to get out of the bottom takes some of the work off the legs. In one belt squat study, lifters kept their hands hovering over the handle or resting lightly on it, without pulling.",
                 "Hauling on the handles to pull yourself up out of the bottom.",
                 "Keep a light grip and let the legs drive the belt up; as you sink, the arms simply reach up to stay on the handles."),
       "knee": ("Knee Tracking",
                "The knees travel forward and out over the toes.",
                "With the load at the hips the trunk can stay fairly upright and the knees travel well forward, so the quadriceps do much of the work: in maximal held squats at the same thigh angle, belt squats produced larger knee and ankle moments and smaller low-back moments than back squats. Knees that cave inward take that load at an angle.",
                "The knees caving inward toward each other at the bottom or on the way up.",
                "Keep each knee pointing over the middle toes, in line with the foot, as you sink and as you stand."),
       "depth": ("Depth",
                 "Sink until the knees are deeply bent, the thighs still somewhat above parallel.",
                 "The belt keeps the load off the spine, so the back is less often what stops you going deeper. In one squat analysis, the knee extensors had to work closer to their maximum the deeper the squat, and full-depth training built more glute and adductor muscle than half squats.",
                 "Stopping with the knees bent to about a right angle, the thighs well above parallel.",
                 "Lower under control as deep as you can keep the heels down and the back flat, hold for a moment, then drive the belt up."),
       "heel": ("Whole Foot",
                "The whole foot stays flat on the platform.",
                "Pressure through the heel and the ball of the foot keeps you balanced under the belt while the knees travel forward. A heel that lifts tips the load onto the toes and the front of the knees.",
                "The heels peeling off the platform as the knees drive forward at the bottom.",
                "Keep the heels down and push the platform away through the heel and the ball of the foot."),
   },
   # The back squat's quadriceps (library Back Squat 0.90) held (Evans 2019,
   # Joseph 2020, Gulick 2015: no difference) and its gluteus maximus (0.62)
   # cut by about a quarter (Evans 2019: ~18% lower; Joseph 2020: 32-35%;
   # Gulick 2015: no difference). Erector spinae dropped from the panel:
   # about half the back squat's (Joseph 2020).
   activation=[("Quadriceps", P, HI, 0.88), ("Gluteus Maximus", S, MOD, 0.46)],
   stabilisers=["adductors", "hamstrings", "calves"],
   comparison=("STOPPING SHORT", "Deep squat, heels down", "Knees stop near a right angle",
               "Sinking deep with the heels down takes the knee extensors through the range where they work closest to their maximum, with the load hanging from the hips instead of the spine.",
               "Stopping with the knees at about a right angle leaves the deepest part of the range untrained."),
   # Glows as side_glows() (side-on now, facing screen-left): the near
   # thigh's quadriceps at the bottom (u 0.39-0.65 over the thigh from knee
   # to hip, on the model's own quadriceps highlight) and the glutes behind
   # the hip, at this entry's earlier opacity (0.26).
   glows=[low_glow("Belt Squat", ["thigh_L", "patella_L"], A, 0.55, rx=0.13, ry=0.05),
          low_glow("Belt Squat", ["pelvis", "thigh_L"], SOFT, 0.26, rx=0.06, ry=0.05, dx=0.03)])

SETUP["Belt Squat"] = [
    "Fasten the belt around your hips and step onto the platform.",
    "Clip the cable to the front of the belt.",
    "Set your feet shoulder-width, either side of the cable, ankles in line with where it runs down.",
    "Rest your hands on the handles and stand tall to lift the weight.",
]

# ---------------------------------------------------------------- pendulum squat

ex(name="Pendulum Squat", var="pendulumSquat",
   library=("QUADRICEPS", "MACHINE", "intermediate"),
   # Side-on, facing screen-left; the carriage and plates fill the right. The
   # tempo label sits top right, clear of the head (0.34-0.41, 0.17-0.34) and
   # the handles on the left; the pad and depth labels run down the right
   # to the back and hips, the knee and foot labels low on the left. The
   # knee label sits at shin height, below where the knee comes forward
   # (u 0.20-0.32 at v 0.58-0.66 at mid-descent); at 0.68 it covered the
   # knee (checked over the stills).
   overrides={"tempo": (0.14, "trailing"), "pad": (0.44, "trailing"), "knee": (0.74, "leading"),
              "depth": (0.68, "trailing"), "feet": (0.86, "leading")},
   annotations=[
       ("tempo", "Control down, pause", "chest"),
       ("pad", "Back on the pad", "spine"),
       ("knee", "Knees over toes", "patella_L"),
       ("depth", "Thighs to parallel", "pelvis"),
       ("feet", "Whole foot on the plate", "foot_L"),
   ],
   cues={
       "pad": ("Back on the Pad",
               "The back and hips stay against the pad as it swings.",
               "The pad carries the trunk along the machine's arc, so the legs can work hard with little demand on the lower back; hack squats, which support the trunk the same way, have drawn less trunk muscle activity than back squats. If the hips run out of room at the bottom, the pelvis tucks, peels away from the pad and the lower back rounds; machine guides advise stopping just short of that point.",
               "The hips and lower back peeling off the pad at the bottom to chase extra depth.",
               "Press the back and hips into the pad from the top of the rep to the bottom, and stop the descent before the pelvis starts to tuck under."),
       "feet": ("Feet on the Plate",
                "The whole foot stays flat on the angled plate.",
                "The plate sits higher at the heels than at the toes, which lets the knees travel forward and keeps the quadriceps working; in two-leg squats on decline boards, even a 10° slope raised the load on the knee extensors and lowered it at the ankle. Pushing through both the heel and the ball of the foot keeps the load spread across the foot.",
                "The heels lifting off the plate at the bottom, the weight rolling onto the toes.",
                "Set the feet about shoulder-width in the middle of the plate, toes turned out a little, and push through the whole foot."),
       "knee": ("Knee Tracking",
                "The knees follow the line of the toes.",
                "The carriage guides the trunk, not the knees. The knees travel forward early in the rep and back again as the hips swing down behind them; keeping each one over the middle toes keeps the load straight through the joint the whole way.",
                "The knees caving inward as you drive up from the bottom.",
                "Keep the knees pointing out over the middle toes on the way down and on the way up."),
       "depth": ("Depth",
                 "The hips swing down and back until the thighs are about parallel.",
                 "Much of the depth comes from the hips travelling back along the arc. In one squat analysis, the knee extensors had to work closer to their maximum the deeper the squat, and training through a full range built more lower-body muscle than partial reps.",
                 "Stopping partway down the arc, the hips still high and the knees pushed far forward.",
                 "Ride the pad down and back until the thighs are about parallel to the floor or a little lower, as far as the back stays on the pad."),
       "tempo": ("Tempo",
                 "Lower under control and pause briefly at the bottom.",
                 "The swinging carriage builds momentum on the way down. A controlled descent and a short pause make the legs start each rep from a standstill instead of rebounding out of the bottom on the machine's swing.",
                 "Dropping fast and bouncing straight back up out of the bottom.",
                 "Take about a second to lower, hold the bottom for a moment with the back on the pad, then drive up through the whole foot."),
   },
   # No pendulum squat EMG study found: the library's Hack Squat (quadriceps
   # 0.89, gluteus maximus 0.44) with the gluteus maximus a little higher for
   # this model's deep hip bend (hips 66°; Caterisano 2002, Kubo 2019) and the
   # quadriceps a little lower to match the other supported machines here.
   activation=[("Quadriceps", P, HI, 0.88), ("Gluteus Maximus", S, MOD, 0.48)],
   stabilisers=["adductors", "hamstrings", "calves"],
   comparison=("HIPS OFF THE PAD", "Back and hips on the pad", "Hips peel off at the bottom",
               "With the back and hips on the pad, the machine carries the trunk along its arc and the legs do the lifting.",
               "When the pelvis tucks off the pad at the bottom, the lower back rounds under the load; stop the descent just before that point."),
   glows=side_glows("Pendulum Squat"))

SETUP["Pendulum Squat"] = [
    "Stand on the plate with your back against the pad and your shoulders under the pads.",
    "Set your feet about shoulder-width in the middle of the plate, toes out a little.",
    "Hold the handles and stand tall to lift the carriage.",
    "Release the safety stop and brace.",
]

# ---------------------------------------------------------------- V-squat

ex(name="V-Squat", var="vSquat",
   library=("QUADRICEPS", "MACHINE", "intermediate"),
   # Side-on, facing screen-left, the machine on the right. The lifter
   # starts on the right half (hips at u 0.64) and ends on the left (knees
   # at 0.33), so the tempo label sits top left, above the hands, the pad
   # label on the right below the glutes at the start and right of them at
   # the bottom, the depth label below it, the knee label on the left above
   # the knees (at 0.62 it covered them at the bottom), the foot label low
   # on the left.
   overrides={"tempo": (0.14, "leading"), "pad": (0.56, "trailing"), "knee": (0.50, "leading"),
              "depth": (0.68, "trailing"), "feet": (0.86, "leading")},
   annotations=[
       ("tempo", "Control down, pause", "chest"),
       ("pad", "Back on the pad", "spine"),
       ("knee", "Knees track toes", "patella_L"),
       ("depth", "Thighs to parallel", "pelvis"),
       ("feet", "Feet flat, ahead of hips", "foot_L"),
   ],
   cues={
       "pad": ("Back on the Pad",
               "The back stays on the pad, the shoulders under the pads.",
               "The pads guide the trunk down and forward along the machine's path, so the legs do the work while the trunk is supported. When the hips run out of room at the bottom, the pelvis pulls away from the pad and the lower back rounds; technique guides advise lowering only to just short of that point.",
               "The hips and lower back coming away from the pad at the bottom of the rep.",
               "Keep the back and hips against the pad throughout and stop the descent before the pelvis starts to tuck under."),
       "feet": ("Foot Placement",
                "The feet sit ahead of the hips, flat on the plate.",
                "Where the feet sit on the plate shifts the work: slightly further forward tends to bring in more of the glutes, slightly further back more of the quadriceps. Either way, both the heel and the ball of the foot push, so the knees can travel forward without the heels lifting.",
                "The heels lifting off the plate as the knees drive forward at the bottom.",
                "Set the feet about shoulder-width in the middle of the plate, toes turned out a little, and push through the whole foot."),
       "knee": ("Knee Tracking",
                "The knees point the same way as the toes.",
                "The machine fixes the path of the trunk, not the knees. Keeping each knee over the middle toes keeps the load straight through the joint as the knees travel forward past the ankles at the bottom.",
                "The knees caving inward toward each other as you press up.",
                "Keep the knees pointing out over the middle toes all the way down and all the way up."),
       "depth": ("Depth",
                 "Sink until the thighs are about parallel to the floor.",
                 "With the trunk supported, the back is less often what stops you going deeper. In one squat analysis, the knee extensors had to work closer to their maximum the deeper the squat, and full-depth squat training built more glute and adductor muscle than half squats.",
                 "Stopping as the knees reach a right angle, the thighs still well above parallel.",
                 "Lower until the thighs are about parallel to the floor, or deeper while the back stays on the pad, then press the plate away."),
       "tempo": ("Tempo",
                 "Lower for about a second, pause, then press up.",
                 "A controlled descent and a short pause at the bottom make the legs start each rep from a standstill instead of bouncing off the bottom of the machine's travel.",
                 "Dropping into the bottom and rebounding straight back up.",
                 "Lower under control, hold the bottom briefly with the back on the pad, then press up through the whole foot, stopping just short of locking the knees."),
   },
   # No V-squat EMG study found: ranked as the library's Hack Squat
   # (quadriceps 0.89, gluteus maximus 0.44); ExRx Lever V-Squat: target
   # quadriceps, synergist gluteus maximus. Hips 78° at the bottom, less
   # bent than the pendulum's 66°, so the glutes a step below it.
   activation=[("Quadriceps", P, HI, 0.88), ("Gluteus Maximus", S, MOD, 0.45)],
   stabilisers=["adductors", "hamstrings", "calves"],
   comparison=("HEELS LIFTING", "Whole foot pushes the plate", "Heels rise off the plate",
               "With the heel and the ball of the foot both pushing, the knees travel forward while the load stays spread across the foot.",
               "When the heels lift, the load rolls onto the toes and the front of the knees and the feet lose their grip on the plate."),
   glows=side_glows("V-Squat"))

SETUP["V-Squat"] = [
    "Stand on the plate with your back against the pad and your shoulders under the pads.",
    "Set your feet about shoulder-width, well ahead of your hips, toes out a little.",
    "Hold the handles and stand tall to lift the carriage.",
    "Release the safety stop and brace.",
]

if __name__ == "__main__":
    probs = validate(NAMES) + validate_library(NAMES); print("\n".join(probs) or "OK")
