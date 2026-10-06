# Trainer content for the 401-500 folder, third round (445-474, 2026-10-05),
# family: sidebend. Four standing oblique lifts from the builder's exports:
# 458 Cable Side Bend (Abs/CableSideBend), 459 Dumbbell Side Bend
# (Abs/DumbbellSideBend), 460 Reverse Cable Wood Chop
# (Abs/ReverseCableWoodChop) and 461 Cable Rotation (Abs/CableRotation).
# Same format as spec.py on top of common_1_50.py; spec_500.py imports this
# module and gen.py reads SPEC / SETUP. notes_500_sidebend.md maps the copy's
# claims to the sources below and records the model facts.
#
# What the models show, measured on the rigs with Blender's Python + pxr
# (SCRATCH/sidebend/dump.py writes every joint's world matrix and every
# equipment prim's bounds per frame; bones.py splits each trunk bone's turn
# from the start of the clip into flexion, side bend and twist; lines.py
# gives the yaw of the shoulder, hip and ankle lines, knees, elbows, heels;
# eq.py the equipment), the briefs (SCRATCH/r3/briefs, briefs_legs),
# tiers.txt, joints.json and the trainer stills at 0/1/2/3/5 s. The app's
# Y-up space, the lifter facing +z, their left +x. All four clips are 7.96 s
# with two identical reps of 4 s on one body (torso, neck to pelvis, 0.59 m).
# - Cable Side Bend: right side to a dual-pulley cable station (GYM_M29), the
#   right-hand carriage at the bottom of its track (pulley ~20 cm off the
#   floor), 44 cm outside the right ankle and level with the feet; a stirrup
#   handle in the RIGHT hand, arm straight (elbow 172 deg), hanging beside
#   the thigh; the LEFT hand behind the head (wrist ~10 cm behind and ~14 cm
#   left of the head joint, elbow 64 deg, pointing out to the side above
#   shoulder height). Ankles 24 cm apart, toes out 8 deg, knees 171-173 deg.
#   Each rep leans toward the pulley over 0-1.25 s: the chest bone side-bends
#   24 deg (lumbar 12, thoracic 12; the neck-over-pelvis line 16 deg), the
#   hand drops 11 cm (wrist 0.91 -> 0.80 m; the handle's grip 0.82 -> 0.70 m,
#   from the upper thigh to about halfway down it: hip joint 0.91, knee
#   0.47 m); held to
#   ~1.6 s; back through upright at ~2.35 s and on to 12 deg the other way
#   (line 8 deg) at 2.75-3.25 s; upright again at 4 s. No forward lean and no
#   twist (both components under 0.1 deg); the pelvis neither tilts nor turns
#   and shifts only ~2 cm away from the lean. The stack is lifted ~10 cm at
#   the start, ~4 cm at the bottom of the lean and ~12 cm at the far lean.
#   Paint: external and internal obliques bright; the forearm muscles,
#   erector spinae, rectus abdominis, the three trapezius parts and rhomboid
#   major dim.
# - Dumbbell Side Bend: the same body, stance, hold of the left hand and
#   timing, a dumbbell (HG_WeightR) in the RIGHT hand, held lengthwise front
#   to back, palm facing the thigh, arm straight (171 deg). The lean toward
#   the dumbbell reaches 26 deg at the chest bone (lumbar 13, thoracic 13;
#   line 18 deg) at 1.25 s, the dumbbell's centre 0.82 -> 0.70 m along the
#   outside of the right thigh; the far lean only 9 deg (line 6 deg). Same
#   still pelvis. Paint as the cable side bend.
# - Reverse Cable Wood Chop: right side to the same station, the right-hand
#   pulley at the bottom (~20 cm up), ~1 m to the right of the lifter; a rope
#   (HG_Rope*) held in both hands, arms straight (171 deg) all clip. Start
#   (and 3.5-4 s): a shallow squat (knees 125 deg, thighs ~30 deg off
#   vertical, pelvis 0.81 m against 0.91 m standing), ankles 51 cm
#   apart, the trunk 13 deg forward and 25 deg toward the pulley, the
#   shoulders turned 58 deg and the hips 30 deg toward it, the hands beside
#   the right hip (0.85 m, ~45 cm right of the midline), the left heel ~3 cm
#   up. The chop, 0-1.5 s: the legs straighten (knees L 171, R 149 deg; the
#   pelvis 9 cm higher), the shoulders turn to 50 deg the other way (108 deg
#   in all) and the hips to 28 deg (58 deg in all), the hands sweep up in
#   front of the chest to ~35 cm above and ~31 cm left of the shoulders
#   (1.77 m), the trunk upright; the right heel lifts ~6 cm over ~0.63-0.85 s,
#   as the hands pass the chest, and the right foot turns ~32 deg on its ball
#   over ~0.75-1.25 s (the left heel, ~3 cm up at the start with that foot
#   turned 8 deg toward the pulley, is down by 0.65 s). Held 1.5-2.0 s, lowered by
#   3.5 s, both reps low right to high left. The stack rises ~40 cm. Paint:
#   obliques bright; anterior deltoid, gluteus maximus, medius and minimus
#   and rectus abdominis dim.
# - Cable Rotation: right side to the same station, the right-hand pulley
#   set at ~1.16 m (about the bottom of the chest: the lower pectoral
#   attachment sits at 1.20 m), ~1 m out; a rope in both hands, the hands
#   ~17 cm apart at 1.30 m (12 cm below the shoulder joints), ~51 cm in front of
#   them, elbows 152 deg (softly bent), fixed straight in front of the chest
#   all clip (the arms never move against the chest). Ankles 32 cm apart,
#   toes out 8 deg, knees 163-166 deg, both heels down. Start: the shoulders
#   turned 36 deg and the hips 12 deg toward the pulley; over 0-1.5 s the
#   shoulders turn to 44 deg the other way (80 deg in all) and the hips to
#   14 deg (26 deg in all); held to 2.0 s; back by 3.5 s; both reps to the
#   left. The trunk leans 5-7 deg forward and tilts no more than 5 deg to
#   either side. The stack rises ~39 cm. Paint: obliques, anterior and
#   lateral deltoid bright; nothing dim.
#
# How they differ from the library: the Cable Wood Chop chops from a high
# pulley down across the body; the Russian Twist sits and turns a ball; the
# Side Plank holds the body up sideways on a forearm; the Suitcase Carry
# walks with a dumbbell in one hand and resists the side bend. The two side
# bends move into and out of the bend the carry resists; the reverse chop
# goes the other way from the library's chop, low to high out of a squat;
# the cable rotation turns level at chest height with the arms held still.
#
# Sources (abstracts read on Europe PMC; ExRx on the Wayback Machine since the
# live site returns 403; details and what each supports are in the notes):
# - ExRx.net (Wayback Machine): Cable Side Bend (CBSideBend, snapshot
#   2019-07-20) and Dumbbell Side Bend (DBSideBend, 2018-08-10): side to a low
#   pulley, the stirrup in the near hand, arm straight; lift by bending
#   sideways away from the pulley, lower by leaning toward it; the dumbbell
#   held with the arm straight at the side, bend to the opposite side until a
#   slight stretch is felt; target obliques, synergists quadratus lumborum,
#   psoas major, iliocostalis lumborum and thoracis, stabilisers upper and
#   middle trapezius, levator scapulae, gluteus medius and minimus. Cable
#   Twist (CBTwist, 2019-08-21): a shoulder-height pulley, both hands, arms
#   horizontal and straight, rotate to the opposite side; the comment says
#   much of the turn comes from the hips; target obliques, stabilisers
#   include rectus abdominis, erector spinae, the lateral and posterior
#   deltoid. Cable Down-Up Twist (CBDownUpTwist, 2019-09-15): a low pulley,
#   arms straight, the stirrup pulled diagonally up around the shoulders by
#   rotating the torso and raising the arms, the near heel raised; target
#   obliques, stabilisers include the anterior deltoid, gluteus maximus and
#   quadriceps. Obliques (muscle page, 2026-02-02): rotation right is the
#   left external with the right internal oblique, rotation left the reverse;
#   lateral flexion is both obliques of the same side; attachments ribs 5-12,
#   iliac crest, inguinal ligament, pubis, linea alba. Quadratus Lumborum
#   (2025-06-07): lateral flexion to its own side; from the iliac crest to
#   the 12th rib and upper four lumbar transverse processes.
# - StrengthLog exercise pages (read 2026-10-05): Dumbbell Side Bend (feet
#   shoulder-width, the other hand on the hip or by the head, lower the
#   dumbbell along the leg, keep the upper body in the same plane without
#   leaning forward or back, pause at a comfortable depth, no momentum);
#   Cable Machine Wood Chop (Low to High) (the handle as low as possible,
#   sideways to the anchor, almost straight arms, a sweeping chop diagonally
#   upward, a controlled return; obliques primary, abs secondary); Horizontal
#   Wood Chop with Cable (about shoulder height, almost straight arms, a
#   sweeping horizontal movement, a controlled return; trains the rotating
#   function of the obliques).
# - Bodybuilding.com, Standing cable low-to-high twist (Wayback 2023-01-06):
#   the lowest pulley, side to the cable, squat down and grab the handle with
#   both hands, arms fully extended; pull it up and across until the arms
#   are fully extended above the head, pivoting the back foot and
#   straightening the legs; return slowly and under control.
# - Andersson EA, Grundstrom H, Thorstensson A 2002, Spine 27(6):E152-E160,
#   doi:10.1097/00007632-200203150-00014, PMID 11884920 - fine-wire EMG of
#   eight trunk muscles in sitting and standing trunk rotations: the highest
#   activity on the side turned toward in maximal twists against shoulder
#   resistance, except the external oblique (the opposite side); rectus
#   abdominis little activated in all rotations.
# - Andersson EA, Oddsson LI, Grundstrom H, Nilsson J, Thorstensson A 1996,
#   Clin Biomech 11(7):392-400, doi:10.1016/0268-0033(96)00033-2, PMID
#   11415651 - fine-wire EMG: quadratus lumborum and the deep lateral erector
#   spinae were most active in a side-lying trunk lift toward their own side.
# - McGill SM 1991, J Orthop Res 9(1):91-103, doi:10.1002/jor.1100090112,
#   PMID 1824571 - maximal axial twisting efforts: external oblique 52%,
#   internal oblique 55%, rectus abdominis 22% of maximum; the latissimus
#   dorsi and external oblique strongly involved through the twist.
# No EMG study giving activation levels for these four lifts was found (one
# surface EMG study, Vasudevan et al. 2016, PMID 27403454, timed only the
# order of muscle onsets in a cable wood chop), so every
# fraction is a judgement call anchored on the library's nearest lifts (Side
# Plank obliques 0.78, Suitcase Carry, Cable Wood Chop 0.78, Russian Twist
# 0.76). Activation follows the paint: bright rows primary, dim rows
# secondary; dim muscles that would overflow the one-line legend are named
# with the stabilisers, as in the cablecrunch and calfstand families.
from common_1_50 import *


def ov(final):
    """Pre-squeeze override row for an on-screen row (spec_500.row() maps
    0.14-0.86 to 0.16-0.80)."""
    return round(0.14 + (final - 0.16) * (0.86 - 0.14) / (0.80 - 0.16), 4)


def lit(name, u, v, rx, ry, kind=A, opacity=0.55, anchor=("spine",)):
    """A glow centred on the lit muscles at (u, v), the mean centre of the
    painted pixels in the five trainer stills (SCRATCH/sidebend/orange.py),
    written as a nudge from the probed `anchor` joints like the other
    families' glows."""
    cu, cv = mean(name, list(anchor))
    return glow(name, list(anchor), kind, opacity, rx, ry, round(u - cu, 3), round(v - cv, 3))


# Side bends: obliques bright (PRIMARY); the forearm muscles, erector
# spinae, rectus abdominis, trapezius and rhomboid major dim. ExRx makes the
# obliques the target of both side bends, with the quadratus lumborum and
# the iliocostalis (the erector spinae's lateral column) as synergists and
# the upper and middle trapezius as stabilisers. No EMG of a side bend was
# found: Obliques 0.78 (the library's Side Plank, which holds the trunk up
# against a sideways bend), Erector Spinae 0.45, Trapezius 0.40 and Forearms
# 0.38 (under the library's Suitcase Carry, 0.50 / 0.44 / 0.55 for its
# forearm flexors, which holds a heavier dumbbell for a whole walk). All
# judgement calls. The rectus abdominis and rhomboids, also dim, go with the
# stabilisers: a fourth secondary name would overflow the one-line legend,
# and neither is listed by ExRx for these lifts. The quadratus lumborum has
# no mesh on the rig and is named with the stabilisers too.
SIDE_BEND = [("Obliques", P, HI, 0.78), ("Erector Spinae", S, MOD, 0.45), ("Trapezius", S, MOD, 0.40),
             ("Forearms", S, LOW, 0.38)]
SIDE_BEND_STAB = ["quadratus lumborum", "rectus abdominis", "rhomboids", "gluteus medius"]

# ---------------------------------------------------------------- Cable Side Bend

N = "Cable Side Bend"
ex(name=N, var="cableSideBend",
   # Three-quarter from the front right (yaw 0.4): the cable tower stands at
   # the left edge (u < 0.08), the cable runs from the right hand
   # (u ~0.25, v ~0.5) down to the pulley at the bottom left. The left elbow
   # points out to u ~0.77 at v ~0.2; the right side of the screen is free
   # below v ~0.3. The plane label sits top left over the head, the arm
   # label below it to the right shoulder, the tempo label bottom left (over
   # the tower's base, left of the right shin, under the cable) to the
   # handle hand; two short labels on the right reach the left shoulder and
   # hip.
   overrides={"plane": (ov(0.12), "leading"), "arm": (ov(0.20), "leading"), "tempo": (ov(0.84), "leading"),
              "range": (ov(0.36), "trailing"), "hips": (ov(0.52), "trailing")},
   annotations=[
       ("plane", "Bend sideways only", "head"),
       ("arm", "Arm hangs long", "upper_arm_R"),
       ("range", "Past upright", "upper_arm_L"),
       ("hips", "Hips still", "thigh_L"),
       ("tempo", "Lower slowly", "hand_R"),
   ],
   cues={
       "plane": ("Side Bend",
                 "Your trunk bends straight to the side, toward the pulley and back, without tipping forward or turning.",
                 "A sideways bend is the movement the obliques make on one side of your waist, and ExRx lists them as the target of this lift with the quadratus lumborum among the helpers. Tipping forward as you go down turns part of the rep into a forward bend instead.",
                 "Tipping your chest forward as you lean toward the pulley.",
                 "Keep your chest facing ahead and slide your right shoulder straight down toward the pulley, as if your back were against a wall."),
       "arm": ("Arm Position",
               "The arm holding the handle hangs straight down from your shoulder.",
               "ExRx sets the lift up with the arm straight, so the handle only rises as far as your waist lifts it. Bending the elbow or shrugging the shoulder raises the handle with your arm instead, and your side does less of the lifting.",
               "Curling the handle up with your elbow or shrugging your shoulder toward your ear.",
               "Let your arm hang long like a rope from your shoulder and keep the elbow straight on the way down and up."),
       "range": ("Range of Motion",
                 "Lean toward the pulley, then rise a little past upright toward the other side.",
                 "ExRx lifts the handle by bending sideways away from the pulley and lowers it by leaning toward it. Going a little past upright carries the far side of your waist through the end of its bend against the cable, which a stop at upright leaves out.",
                 "Stopping as soon as you are upright again.",
                 "Lean until the handle is about halfway down your thigh, then rise and keep going until your trunk tilts slightly away from the machine."),
       "hips": ("Hips Still",
                "Your hips stay level over your feet while your trunk bends.",
                "The obliques run from your lower ribs to the top of your pelvis, and the quadratus lumborum from the pelvis to the lowest rib and the lumbar spine, so the bend belongs between your ribs and your hips. Pushing your hips out to the side lets your legs take part of the movement, and your waist bends less.",
                "Pushing your hips out sideways, away from the pulley, as you lean toward it.",
                "Keep your weight even on both feet, your knees soft and your hips level; only your ribcage tilts."),
       "tempo": ("Tempo",
                 "Lean toward the pulley slowly; don't let the stack pull you down.",
                 "The cable pulls you toward the machine the whole time, so the way down is resisted as well as the way up. StrengthLog's dumbbell side bend guide asks for a controlled movement without momentum.",
                 "Dropping toward the pulley and bouncing straight back up.",
                 "Take a little over a second to lean toward the pulley, pause, then rise smoothly past upright."),
   },
   activation=SIDE_BEND,
   stabilisers=SIDE_BEND_STAB,
   comparison=("TIPPING FORWARD", "Trunk bends straight sideways", "Chest tips forward as you lean",
               "Bending straight to the side keeps the work on the side of your waist, where the obliques and quadratus lumborum pull.",
               "Tipping forward turns part of each rep into a forward bend, so less of it is the side bend the lift trains."),
   glows=[lit(N, 0.50, 0.40, 0.08, 0.06), lit(N, 0.555, 0.405, 0.04, 0.045, SOFT, 0.30)])

SETUP[N] = [
    "Set a stirrup handle at the bottom of the cable track and stand with your right side to the machine, a short step away.",
    "Take the handle in your right hand, the one nearest the pulley, arm straight and the cable taut.",
    "Put your left hand behind your head with the elbow pointing out to the side.",
    "Stand tall, feet about hip-width and knees soft.",
    "Do every rep on this side, then turn round and work the other side with the handle in your left hand.",
]

# ---------------------------------------------------------------- Dumbbell Side Bend

N = "Dumbbell Side Bend"
ex(name=N, var="dumbbellSideBend",
   # Three-quarter from the front left (yaw -0.3): the dumbbell hangs at the
   # left of the screen (u ~0.12-0.33, v ~0.48-0.62), the left elbow points
   # out to u ~0.79 at v ~0.2, nothing else is in the frame. The free-hand
   # label sits top left above the head, its leader down to the hand behind
   # the head; the depth label bottom left, under the dumbbell and left of
   # the right shin, up to the dumbbell hand; three short labels on the
   # right reach the chest, the lower back and the left hip.
   overrides={"free": (ov(0.12), "leading"), "depth": (ov(0.76), "leading"),
              "twist": (ov(0.36), "trailing"), "tempo": (ov(0.44), "trailing"), "hips": (ov(0.52), "trailing")},
   annotations=[
       ("twist", "Chest square", "chest"),
       ("free", "Free hand behind head", "hand_L"),
       ("depth", "Full bend", "hand_R"),
       ("hips", "Hips level", "thigh_L"),
       ("tempo", "No swinging", "spine"),
   ],
   cues={
       "twist": ("No Twist",
                 "Your chest keeps facing forward as you bend toward the dumbbell.",
                 "StrengthLog asks you to keep your upper body in the same plane as you bend. Turning your chest toward the weight on the way down takes it out of that plane and mixes a twist into the rep, so less of it is the sideways bend you are training.",
                 "Turning your shoulders toward the dumbbell as you lower it.",
                 "Keep both shoulders facing forward and let your ribcage tilt straight down toward the weight."),
       "free": ("One Dumbbell",
                "One hand holds the dumbbell; the other rests behind your head.",
                "A weight in one hand pulls you sideways, so the other side of your waist has something to lift against. With a dumbbell in each hand the two pull against each other and largely cancel out, so the bend has much less to work against. ExRx and StrengthLog both do the side bend with one dumbbell.",
                "Holding a dumbbell in each hand.",
                "Hold one dumbbell at your side and rest your free hand lightly behind your head, elbow out, without pulling on your neck."),
       "depth": ("Range of Motion",
                 "Lower the dumbbell down the outside of your leg as far as you comfortably can, then rise a little past upright.",
                 "StrengthLog lowers the dumbbell along the leg to a comfortable depth and pauses there before rising. A short dip leaves most of the bend undone, and with it most of the distance the other side of your waist lifts the weight.",
                 "Dipping a few centimetres and coming straight back up.",
                 "Slide the dumbbell down your thigh as far as you comfortably can, pause, then rise and carry on until you lean slightly the other way."),
       "hips": ("Hips Level",
                "Your hips stay square and level over your feet.",
                "The obliques and the quadratus lumborum run between your lower ribs and the top of your pelvis, so the bend has to happen above your hips. Sliding your hips sideways lets the dumbbell sink without your waist bending as far.",
                "Pushing your hips out to the side, away from the dumbbell, as you lower it.",
                "Keep your weight even on both feet and your knees soft and still; only your trunk tilts."),
       "tempo": ("Tempo",
                 "Lower and lift the dumbbell under control.",
                 "StrengthLog warns against using momentum to lift the dumbbell. Bouncing out of the bottom throws the weight up instead of lifting it with the side of your waist.",
                 "Bouncing out of the bottom and swinging the dumbbell up.",
                 "Lower the dumbbell over a little more than a second, pause at the bottom, then lift it back up smoothly."),
   },
   activation=SIDE_BEND,
   stabilisers=SIDE_BEND_STAB,
   comparison=("A WEIGHT IN EACH HAND", "One dumbbell pulls you sideways", "Two dumbbells largely cancel",
               "With one dumbbell, the other side of your waist has to bend you back up against its pull.",
               "Two dumbbells largely cancel each other out, so the side bend has much less to lift against."),
   glows=[lit(N, 0.47, 0.40, 0.08, 0.06), lit(N, 0.53, 0.405, 0.04, 0.045, SOFT, 0.30)])

SETUP[N] = [
    "Hold one dumbbell in your right hand at your side, arm straight, palm facing your thigh.",
    "Rest your left hand behind your head, elbow out to the side.",
    "Stand with your feet about hip-width apart and your knees slightly bent.",
    "Finish the set on this side, then switch the dumbbell to your left hand.",
]

# ---------------------------------------------------------------- Reverse Cable Wood Chop

N = "Reverse Cable Wood Chop"
ex(name=N, var="reverseCableWoodChop",
   # Three-quarter from the front right (yaw 0.5): the pulley is off screen
   # at the bottom left and the cable sweeps from there up to the hands,
   # beside the right hip at the start (u ~0.2-0.28, v ~0.52) and up at the
   # top right at the top (u ~0.71-0.8, v ~0.15-0.25). Free space: the top
   # band (v < 0.18), the right side below v ~0.36 (lifter to u ~0.67) and a
   # small corner left of the right foot. Return label top left to the head;
   # three short labels on the right to the left shoulder, the chest and the
   # left knee; the pivot label bottom left to the right foot.
   overrides={"return": (ov(0.14), "leading"), "pivot": (ov(0.80), "leading"),
              "arms": (ov(0.40), "trailing"), "turn": (ov(0.50), "trailing"), "legs": (ov(0.64), "trailing")},
   annotations=[
       ("arms", "Arms long", "upper_arm_L"),
       ("turn", "Chest turns", "chest"),
       ("legs", "Legs drive up", "patella_L"),
       ("pivot", "Pivot", "foot_R"),
       ("return", "Slow on the way down", "head"),
   ],
   cues={
       "arms": ("Arm Position",
                "Your arms stay long from the low start to the high finish.",
                "Long arms keep the rope out at arm's length, so your legs and the turn of your trunk drive it up and across; StrengthLog's low-to-high chop keeps the arms almost straight. Bending the elbows turns the top of the chop into a pull with your arms.",
                "Bending your elbows and pulling the rope up toward your chest.",
                "Keep your elbows long and your hands in front of your chest as they sweep from your right hip to above your left shoulder."),
       "turn": ("Rotation",
                "Your chest turns with the rope, from angled toward the pulley to angled away from it.",
                "Turning your trunk to the left uses the right external oblique with the left internal oblique (ExRx), and in a study of maximal resisted trunk twists the external oblique was most active on the side opposite the turn. Raising the rope in front of you without turning leaves the lift to your shoulders.",
                "Swinging the rope up with your arms while your chest stays facing forward.",
                "Let your chest follow your hands until it faces well to the left of your feet at the top."),
       "legs": ("Leg Drive",
                "Start in a shallow squat and stand up as you chop.",
                "A guide to the standing low-to-high cable twist squats down to take the handle with straight arms, then straightens the legs as the handle comes up and across. Reaching down to the low rope with straight legs bends your back over instead and leaves your legs out of the lift.",
                "Reaching down to the rope with straight legs, your back bent over.",
                "Sit into a shallow squat with your chest up to take the rope beside your right hip, then drive up through your legs as your arms sweep up."),
       "pivot": ("Back Foot",
                 "Your right heel lifts as the rope rises past your chest, and the foot turns on its ball as you finish the chop.",
                 "The same guide pivots the back foot to reach the full range. Turning on the ball of the foot lets your hips follow your chest; with the foot fixed, your knee is left to take the twist.",
                 "Leaving your right foot pointing where it started, so your right knee caves in as you turn.",
                 "As your hands pass your chest, let your right heel come up and turn on the ball of the foot, the knee following the toes."),
       "return": ("Tempo",
                  "Lower the rope back to your hip as slowly as you raised it.",
                  "StrengthLog asks for a controlled return on the low-to-high chop. The stack pulls the rope back toward the low pulley, so letting it go drops you into the squat with your trunk twisting fast.",
                  "Letting the stack pull the rope down and twist you back into the squat.",
                  "Take about a second and a half to chop up, hold the top for a moment, then take about as long to sink back down."),
   },
   # Paint: obliques bright; anterior deltoid, gluteus maximus, medius and
   # minimus and rectus abdominis dim. No EMG of a reverse chop was found:
   # Obliques 0.78 as the library's Cable Wood Chop; Gluteus Maximus 0.45
   # (the hips extend out of the shallow squat and turn; ExRx stabiliser of
   # the down-up twist) and Anterior Deltoid 0.40 (the straight arms are
   # raised from beside the hip to above the shoulder against the cable; ExRx
   # stabiliser), both judgement calls. The rectus abdominis (dim) goes with
   # the stabilisers: Andersson 2002 found it little activated in trunk
   # rotations, and a third secondary name would overflow the legend; the
   # gluteus medius is named there too (ExRx synergist). The gluteus minimus,
   # also dim, is not named.
   activation=[("Obliques", P, HI, 0.78), ("Gluteus Maximus", S, MOD, 0.45), ("Anterior Deltoid", S, MOD, 0.40)],
   stabilisers=["rectus abdominis", "gluteus medius", "quadriceps", "erector spinae"],
   comparison=("LIFTING WITHOUT TURNING", "Chest turns with the rope", "Arms lift, chest stays square",
               "Turning your ribcage as the rope rises makes your trunk carry the load across.",
               "Raising the rope in front without turning hands the lift to your shoulders and arms."),
   glows=[lit(N, 0.46, 0.45, 0.08, 0.06), lit(N, 0.43, 0.47, 0.04, 0.04, SOFT, 0.30)])

SETUP[N] = [
    "Clip a rope to the bottom of the cable track and stand with your right side to the machine, a long step away.",
    "Set your feet wider than your shoulders.",
    "Sit into a shallow squat, turn toward the pulley and take one end of the rope in each hand beside your right hip, arms straight.",
    "Chop up and across to above your left shoulder on every rep, then turn round to work the other side.",
]

# ---------------------------------------------------------------- Cable Rotation

N = "Cable Rotation"
ex(name=N, var="cableRotation",
   # Three-quarter from the front right (yaw 0.5): the lifter stands left of
   # centre (u ~0.2-0.55); the cable comes in from the left edge at v ~0.3
   # and runs to the hands, in front of the chest at the start (u ~0.23-0.36)
   # and out to the right at the end of the turn (u ~0.74-0.85, v ~0.24-0.36).
   # Free space: the right side below v ~0.4 and above v ~0.22, the top
   # left beside the head, the left side below v ~0.4. The posture and
   # hand-height labels sit top right, above the arms, to the head and the
   # left hand; the arm label on the right below the arms to the left elbow;
   # the turn label top left to the right shoulder, which swings round from
   # the pulley side; the tempo label bottom left to the right knee.
   overrides={"tall": (ov(0.14), "trailing"), "height": (ov(0.21), "trailing"), "arms": (ov(0.42), "trailing"),
              "turn": (ov(0.14), "leading"), "return": (ov(0.74), "leading")},
   annotations=[
       ("arms", "Arms long", "forearm_L"),
       ("height", "Hands chest high", "hand_L"),
       ("turn", "Turn fully", "upper_arm_R"),
       ("tall", "Stand tall", "head"),
       ("return", "Slow return", "patella_R"),
   ],
   cues={
       "arms": ("Arm Position",
                "Your arms stay long, elbows softly bent, with your hands in front of your breastbone.",
                "Held at arm's length, the rope pulls across your body far from your spine, so turning against it takes more from your trunk. StrengthLog's horizontal chop keeps the arms almost straight; pulling the rope in to your chest shortens that lever.",
                "Bending your elbows and pulling the rope in to your chest as you turn.",
                "Fix your hands in front of your chest at arm's length and let your trunk carry them round."),
       "height": ("Hand Height",
                  "Your hands travel level, at chest height, from start to finish.",
                  "With the pulley set near chest height, the rope pulls across your body rather than up or down it, so the turn is resisted all the way round. Holding your arms up in front against that pull is work for your shoulders; ExRx lists the deltoids among the stabilisers of its standing cable twists.",
                  "Letting your hands sink toward your waist as you turn.",
                  "Keep your hands level with your chest through the whole turn and back."),
       "turn": ("Rotation",
                "Turn your shoulders from angled toward the pulley to well past the middle, away from it.",
                "Turning to the left against the cable uses the right external oblique with the left internal oblique (ExRx). Your ribcage turns much further than your hips, which is the twist of the waist the obliques make; stopping as your hands reach the middle leaves out the end of the turn.",
                "Stopping the turn as soon as your hands reach the middle.",
                "Turn until your hands are out beyond your left hip, hold for a moment, then turn back."),
       "tall": ("Posture",
                "Stand tall as you turn, without leaning away from the cable.",
                "The obliques turn your ribcage around your spine. Leaning sideways away from the pulley lets your body weight drag the rope across and swaps part of the turn for a side bend.",
                "Leaning your shoulders away from the pulley as you turn.",
                "Keep your head over your hips and your shoulders level through the whole turn."),
       "return": ("Tempo",
                  "Let the rope back toward the pulley slowly.",
                  "StrengthLog asks for a controlled return on its horizontal chop. The cable pulls you back toward the start, so a slow return keeps your trunk working against it on the way back too.",
                  "Letting the stack whip you back to the start.",
                  "Turn away over about a second and a half, pause, then take about as long to turn back toward the pulley."),
   },
   # Paint: obliques, anterior and lateral deltoid bright; nothing dim. No
   # EMG of a standing cable rotation was found: Obliques 0.76 (the library's
   # Russian Twist, its other turning lift). The two deltoid heads are
   # painted bright, so they are primary rows, but they only hold the arms
   # up in front against the cable (ExRx lists the lateral and posterior
   # deltoid among the shoulder-height cable twist's stabilisers, the
   # anterior among the low-pulley down-up twist's), so they sit at the
   # bottom of the moderate band: Anterior Deltoid 0.45, Lateral Deltoid
   # 0.40. Judgement calls. The
   # rectus abdominis, erector spinae, gluteus medius and posterior deltoid
   # (ExRx stabilisers and synergists, unpainted) are named with the
   # stabilisers.
   activation=[("Obliques", P, HI, 0.76), ("Anterior Deltoid", P, MOD, 0.45), ("Lateral Deltoid", P, MOD, 0.40)],
   stabilisers=["rectus abdominis", "erector spinae", "gluteus medius", "posterior deltoid"],
   comparison=("ARMS PULLED IN", "Long arms, hands at chest height", "Elbows bend, rope comes to the chest",
               "Holding the rope at arm's length keeps it far from your spine, so your trunk turns against a longer lever.",
               "Pulling the rope in shortens the lever, and the turn asks less of your trunk."),
   glows=[lit(N, 0.39, 0.38, 0.07, 0.05), lit(N, 0.36, 0.26, 0.10, 0.03, SOFT, 0.30)])

SETUP[N] = [
    "Set the pulley at about the bottom of your chest, clip on a rope and stand with your right side to the machine, a long step away.",
    "Set your feet a little wider than hip-width, toes turned out a little, knees soft.",
    "Hold one end of the rope in each hand in front of your chest, arms long, and let the cable turn your shoulders toward the pulley.",
    "Do every rep turning to the left, then turn round and work the other side.",
]
