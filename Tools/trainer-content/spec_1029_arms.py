# Trainer content for the model-only exercises of 2026-10-29, family "arms":
# the three cable arm lifts that shipped with a model but no coaching —
# Lying Cable Curl (Biceps/LyingCableCurl), Cable Reverse Curl
# (Biceps/CableReverseCurl) and Bent-Over Cable Overhead Triceps Extension
# (Triceps/BentOverCableOverheadTricepsExtension). Same format as spec.py on
# top of common_1_50.py; spec_1029.py imports this module and gen.py reads
# SPEC / SETUP. notes_1029_arms.md maps every claim in the copy to the
# sources below or to a model measurement.
#
# What the models show, measured from the rigs with Blender's Python + pxr
# (scratch scripts in the round folder: brief.py, summ.py, props.py,
# nearhand.py and palm.py, plus trainer_shot.py, which renders the app's own
# trainer camera — framer.py's projection at 382x655 — so the stills match
# what the viewport shows). Frame: Y up, the lifter faces +z, their left is
# +x, metres. Elbow = upper-arm-to-forearm inner angle (180 straight). All
# three clips run 7.96 s at 24 fps and hold two identical reps, one every
# 4.0 s. Shoulder joints are 0.39 m apart in all three.
# - Lying Cable Curl (yaw -1.3, side-on from the lifter's left; the body
#   lies across the frame in a thin band, v 0.44-0.54, head right at u 0.80,
#   feet left at u 0.20). The lifter lies face up on the floor, pelvis 0.13 m
#   up, knees bent to 82 degrees with the feet flat and the ankle joints
#   0.30 m apart, facing away from a low pulley that sits beyond the feet
#   (the stack at z 1.54, the exit pulley at z 1.33, 0.12 m off the floor);
#   the cable runs along the floor past the legs to a straight bar
#   (GYM_Cable_Handle, a 0.17 m grip between two stirrup ends) held in both
#   hands, wrists 0.42-0.47 m apart (a little wider than the shoulders).
#   The grip is underhand: the hand bone's local x axis points the same way
#   as in the library's supinated Cable Curl (-x for the left hand) and
#   opposite to the pronated Reverse Curl (palm.py).
#   Bottom (0, 4 s): elbows 133 degrees, the hands 0.47 m down the body from
#   the shoulders, level with the hips. Top (1.75, 5.67 s): elbows 62
#   degrees, the hands 0.30 m closer to the shoulders and only 0.09 m
#   higher - the bar travels along the body, not up over it. The upper arms
#   never leave the floor: their pitch stays between -4 and 0 degrees all
#   clip, so the whole range comes from the elbows. Nothing else moves: the
#   pelvis, trunk, knees and feet hold one position frame to frame.
#   Paint: both biceps heads and the brachialis bright; brachioradialis and
#   the nine forearm muscles (wrist and finger flexors and extensors,
#   palmaris longus) dim.
# - Cable Reverse Curl (yaw -1.4, side-on from the lifter's left; the body
#   fills u 0.36-0.60, head at v 0.18, feet at v 0.80). Standing tall and
#   still: trunk 0 degrees from vertical, knees 174-176 degrees, ankle
#   joints 0.30 m apart, facing a low pulley ahead (the stack at z 0.85, the
#   cable down and forward from the hands). Both hands on the same straight
#   bar, wrists 0.44-0.48 m apart. The grip is overhand: the hand bone's
#   local x axis matches the library's Reverse Curl (palm.py).
#   Bottom (0, 3.75 s): elbows 150 degrees, the bar in front of the thighs
#   at 0.94 m. Top (1.75, 5.75 s): elbows 49 degrees, the bar at 1.33 m,
#   about navel height - it rises 0.39 m. The upper arms hang at -83 to -85
#   degrees from horizontal the whole clip (pinned at the sides, never
#   swinging forward), and the trunk never leans: pelvis height and trunk
#   angle are constant to the frame.
#   Paint: both biceps heads, the brachialis, the brachioradialis and all
#   nine forearm muscles bright; nothing dim.
# - Bent-Over Cable Overhead Triceps Extension (yaw -0.6, three-quarter from
#   the lifter's left; the body fills u 0.18-0.79, the hands high at v
#   0.24-0.31). The lifter hinges forward under a high pulley: trunk 82
#   degrees from vertical (almost horizontal), pelvis 0.84 m up, split
#   stance with the left foot forward (knee 136, hip 71 degrees) and the
#   right leg back (knee 166 degrees), ankle joints 0.71 m apart. Both hands
#   on a straight bar, wrists 0.35-0.38 m apart, the cable running up and
#   forward to the pulley.
#   Bottom (0, 4 s): elbows 65 degrees, the hands beside the head. Top
#   (1.3-2.0 s, held): elbows 172 degrees - the arms lock out level with the
#   trunk, the hands 0.39 m further forward and 0.09 m lower than at the
#   bottom. The upper arms sit at +15 degrees above horizontal and do not
#   move by even a degree across the clip; the legs, pelvis and trunk hold
#   their angles frame to frame, so the elbows are the only joint working.
#   Paint: all three triceps heads bright; nothing else lit.
# How they differ from the library: the Cable Curl and Bayesian Cable Curl
# are standing supinated curls, the Reverse Curl a standing EZ-bar pronated
# curl (its model paints the biceps and brachialis dim, this one bright,
# which is why the ranks differ), the Reverse Preacher Curl a seated
# pronated curl over a pad; the Overhead Cable Triceps Extension and
# Dumbbell Overhead Triceps Extension are done standing upright with the
# arms by the ears, and the Skull Crusher lying on a bench. The lying curl
# is the only lift in the library that curls with the upper arms resting on
# the floor, and the bent-over extension the only one that holds the arms
# overhead by hinging the trunk down to them.
#
# Sources (what each is used for is in notes_1029_arms.md):
# - Pinto RS, Gomes N, Radaelli R, Botton CE, Brown LE, Bottaro M 2012, J
#   Strength Cond Res 26(8):2140-2145, doi 10.1519/JSC.0b013e31823a3b15,
#   PMID 22027847 (abstract read 2026-10-29): 40 young men, 10 weeks, 2
#   days a week of elbow flexion; full range raised the 1RM 25.7% against
#   16.0% for a partial range, and muscle thickness rose in both (9.65% vs
#   7.83%).
# - Coratella G, Tornatore G, Longo S, Toninelli N, Padovan R, Esposito F,
#   Ce E 2023, Sports 11(3):64, doi 10.3390/sports11030064, PMID 36976950
#   (abstract read 2026-10-29): ten competitive bodybuilders, bilateral
#   biceps curls at 8RM; in the lifting phase the supinated grip drew 19%
#   more biceps excitation than the pronated grip and 12% more than the
#   neutral grip, and 5-6% more brachioradialis excitation.
# - Maeo S, Wu Y, Huang M, Sakurai H, Kusagawa Y, Sugiyama T, Kanehisa H,
#   Isaka T 2023, Eur J Sport Sci 23(7):1240-1250, doi
#   10.1080/17461391.2022.2100279, PMID 35819335 (abstract read 2026-10-29):
#   21 adults trained cable elbow extensions (90-0 degrees) with one arm
#   overhead and the other by the side, 70% 1RM, 5 sets of 10, twice a week
#   for 12 weeks; the overhead arm grew more - long head +28.5% vs +19.6%,
#   lateral and medial heads +14.6% vs +10.5%, whole triceps +19.9% vs
#   +13.9% - although its absolute loads were 34-39% lower.
# - Oliveira LF, Matta TT, Alves DS, Garcia MAC, Vieira TMM 2009, J Sports
#   Sci Med 8(1):24-29, PMID 24150552: the standing and incline dumbbell
#   curls loaded the biceps across the whole range, the preacher curl only
#   near extension. Carried over from notes_1_50_curls.md (2026-09-29),
#   where the full text was read; used only for the library fractions this
#   family keeps, never for a new numeric claim.
# - ExRx.net Barbell Reverse Curl and StrengthLog's forearm-extensor page,
#   as quoted in notes_1_50_forearm.md (2026-09-29): the pronated grip
#   shifts work toward the brachioradialis and the wrist extensors hold the
#   wrist steady; both treat the biceps as still working.

from common_1_50 import *

NAMES = ["Lying Cable Curl", "Cable Reverse Curl", "Bent-Over Cable Overhead Triceps Extension"]


def arm_glows(name, rx=0.09, ry=0.07, dx=0.0, dy=0.0):
    """One glow over each upper arm, where the lit flexors or extensors sit."""
    return [glow(name, ["upper_arm_L", "forearm_L"], A, 0.55, rx=rx, ry=ry, dx=dx, dy=dy),
            glow(name, ["upper_arm_R", "forearm_R"], A, 0.55, rx=rx, ry=ry, dx=dx, dy=dy)]


# ------------------------------------------------------------ lying curl

ex(name="Lying Cable Curl", var="lyingCableCurl",
   # Side-on, the body in a band at v 0.44-0.54 across the whole width, so
   # every row is free except the middle: two short pills above (rows 0.14
   # left and right, 20-23 characters, 0.17 apart) and two below on the
   # left, where the legs and the floor leave the frame empty. The hands run
   # u 0.48-0.68 at v 0.46-0.49, so the curl pill sits on the right at 0.32,
   # clear of them; the feet are far left (u 0.20-0.22), so the base pill's
   # leader stays short.
   overrides={"stretch": (0.14, "leading"), "upperarm": (0.14, "trailing"),
              "curl": (0.32, "trailing"), "trunk": (0.68, "leading"), "base": (0.86, "leading")},
   annotations=[
       ("upperarm", "Upper arms stay down", "upper_arm_L"),
       ("stretch", "Arms long at the bottom", "forearm_L"),
       ("curl", "Bar travels to the chest", "hand_L"),
       ("trunk", "Ribs and hips on the floor", "spine"),
       ("base", "Feet flat, knees bent", "foot_L"),
   ],
   cues={
       "upperarm": ("Upper Arm Position",
                    "The backs of your upper arms rest on the floor beside your ribs and stay there; only the forearms move.",
                    "Lying down pins the upper arms for you, so the elbow is the only joint that can work. In the model their angle changes by less than four degrees across both reps while the elbows close from 133 degrees to 62. The moment an elbow drags back along the floor, the shoulder starts lifting the bar and the curl gets shorter.",
                    "Sliding the elbows back toward the shoulders to help the bar up.",
                    "Set the backs of your arms on the floor, elbows a little wider than your ribs, and keep them still for the whole set."),
       "stretch": ("Bottom of the Curl",
                   "At the bottom the elbows open to about 133 degrees, with the bar down by your hips and the cable still pulling.",
                   "The cable keeps tension at the bottom, where a dumbbell would rest. Training the elbow flexors over a full range beat a partial range in a ten-week study: the 1RM rose 25.7% against 16.0%, and muscle thickness rose in both groups.",
                   "Stopping the bar halfway down and bouncing straight back up.",
                   "Let the bar travel until your arms are long and you feel the biceps stretch, pause, then curl without a bounce."),
       "curl": ("Top of the Curl",
                "The bar travels about 30 cm along your body and finishes near your chest, hands a little wider than your shoulders.",
                "Because the arms are flat, the bar moves along the body rather than up over it: in the model the hands come 30 cm closer to the shoulders but rise only 9 cm. That keeps the pull in line with the forearms all the way to the top, where the elbows close to about 62 degrees.",
                "Pulling the bar up toward the face, so the forearms point at the ceiling and the work stops.",
                "Curl the bar along your body to your chest, squeeze, and lower it on the same line."),
       "trunk": ("Trunk",
                 "The ribs, back and hips stay down on the floor the whole set.",
                 "Lying down is what takes the body out of the lift: with the back flat there is nothing to swing. In the model the pelvis and trunk hold one position frame to frame. Pushing the hips up turns the curl into a pull from the whole body and lets the cable win at the bottom.",
                 "Bridging the hips off the floor to drag the bar up on the last reps.",
                 "Keep your ribs down and your hips on the floor; if you cannot, the weight is too heavy."),
       "base": ("Base",
                "Knees bent to about 82 degrees with the feet flat on the floor, hip-width apart.",
                "The cable pulls you toward the machine, so the bent legs and flat feet are what hold your position. The model keeps its ankle joints 0.30 m apart and its knees at one angle for both reps.",
                "Legs straight out or feet lifting, so the cable drags the body along the floor.",
                "Plant both feet flat, hip-width apart, with the knees bent, and press them down as you curl."),
   },
   # The paint leads with the elbow flexors: both biceps heads and the
   # brachialis bright, brachioradialis and the nine forearm muscles dim.
   # Fractions are the library's supinated cable curl (Biceps Brachii 0.84,
   # Brachialis 0.66, Brachioradialis 0.44, Forearms 0.30 - Oliveira 2009
   # and the 2026-09-29 curl family), kept because this is the same grip and
   # the same elbow range; the brachialis row is primary here because this
   # model paints it bright, where the standing cable curl paints it dim.
   activation=[("Biceps Brachii", P, HI, 0.84), ("Brachialis", P, MOD, 0.66),
               ("Brachioradialis", S, MOD, 0.44), ("Forearms", S, LOW, 0.30)],
   stabilisers=["anterior deltoid", "core"],
   comparison=("ELBOWS DRAGGING BACK", "Upper arms flat, elbows still", "Elbows slide back along the floor",
               "With the arms resting on the floor the elbow is the only joint working, so the bar travels along the body on one line.",
               "Sliding the elbows back hands part of the lift to the shoulder and cuts the range short at both ends."),
   glows=arm_glows("Lying Cable Curl", rx=0.10, ry=0.05))

SETUP["Lying Cable Curl"] = [
    "Set a straight bar on the lowest pulley and lie on your back on the floor in front of it, feet toward the machine.",
    "Bend your knees to about a right angle and plant both feet flat, hip-width apart.",
    "Take the bar in both hands underhand, a little wider than your shoulders, and rest the backs of your upper arms on the floor beside your ribs.",
    "Straighten your arms until the cable is tight and your hips are by your hands, ribs down, before the first rep.",
]

# ---------------------------------------------------------- reverse curl

ex(name="Cable Reverse Curl", var="cableReverseCurl",
   # Standing side-on, the body in a narrow column (u 0.36-0.60) with the
   # bar swinging up its front, so the elbow pill sits on the right, clear
   # of the head at u 0.57, and the rest on the left, clear of the hips,
   # knee and foot (u 0.55-0.59). The grip pill is kept to eleven characters
   # and put on the left beside the hands (u 0.36-0.49): on the right its
   # leader crossed the chest and the near arm to reach them.
   overrides={"elbow": (0.14, "trailing"), "grip": (0.32, "leading"),
              "range": (0.50, "leading"), "swing": (0.68, "leading"), "stance": (0.86, "leading")},
   annotations=[
       ("grip", "Knuckles up", "hand_L"),
       ("elbow", "Elbows at your sides", "upper_arm_L"),
       ("range", "Arms long at the bottom", "forearm_L"),
       ("swing", "No swing, stand tall", "spine"),
       ("stance", "Feet hip-width, knees soft", "foot_L"),
   ],
   cues={
       "grip": ("Grip and Wrists",
                "Both hands grip the bar overhand, knuckles up, hands a little wider than your shoulders.",
                "Turning the palms down is the whole point of this curl: it takes the biceps off its strongest line and leaves more of the job to the brachioradialis and the muscles on top of the forearm. In one study of bodybuilders the supinated grip drew 19% more biceps excitation than this pronated one, so expect to use less weight here than on a normal curl.",
                "Letting the wrists bend back under the bar so the knuckles drop.",
                "Keep a straight line from the knuckles through the back of the forearm and hold it from the first rep to the last."),
       "elbow": ("Elbow Position",
                 "The upper arms hang straight down at your sides and stay there.",
                 "In the model the upper arms sit within two degrees of straight down for the whole clip while the elbows close from 150 degrees to 49. Keeping them there means the bar is lifted by the elbow, not by the shoulder swinging it forward.",
                 "The elbows drifting forward as the bar rises, so the shoulders finish the curl.",
                 "Tuck your upper arms against your ribs and keep them pointing at the floor through the whole rep."),
       "range": ("Range of Motion",
                 "At the bottom the arms open to about 150 degrees, the bar in front of your thighs.",
                 "A full range built more strength than a partial one in a ten-week study of elbow flexion training (1RM up 25.7% against 16.0%). The cable keeps pulling at the bottom, so there is no resting point to stop at.",
                 "Cutting the bottom half off and pumping the bar over a short range.",
                 "Lower the bar until your arms are long and the cable is still tight, then curl it the whole way back up."),
       "swing": ("Body Position",
                 "The trunk stays upright and still: the bar rises about 39 cm, from the thighs to about navel height.",
                 "The model stands at zero degrees of lean, its pelvis at one height for both reps. With a pronated grip the weight feels heavy early, which is where people start rocking the body to get the bar moving; the rock gives the lift to the hips instead of the forearms.",
                 "Leaning back and throwing the hips forward to start the bar.",
                 "Stand tall with your ribs down, brace the trunk, and start each rep from a dead stop."),
       "stance": ("Stance",
                  "The feet stay flat, about hip-width apart, with the knees soft.",
                  "The cable pulls forward and down, so a square, still stance is what you curl against. The model keeps its ankle joints 0.30 m apart and its knees at about 175 degrees the whole set.",
                  "Shifting the weight onto the toes or stepping under the pull as the set gets hard.",
                  "Set your feet hip-width apart, weight through the middle of each foot, and leave them there."),
   },
   # Every muscle the rig can light on the arm is painted bright here
   # (biceps, brachialis, brachioradialis and the nine forearm muscles), so
   # every row is primary, following the forearm-lift rule in the
   # README (2026-10-24). The fractions are the library's standing Reverse
   # Curl, the same pronated grip and range: Brachioradialis 0.56, Wrist
   # Extensors 0.50, Forearm Flexors 0.45, Brachialis 0.66, Biceps Brachii
   # 0.68. They are kept in fraction order here; what changes against that
   # entry is the rank of the biceps and brachialis rows, which its model
   # paints dim and this one bright, matching Coratella 2023, where the
   # biceps still worked hard with the palms down.
   activation=[("Biceps Brachii", P, MOD, 0.68), ("Brachialis", P, MOD, 0.66),
               ("Brachioradialis", P, MOD, 0.56), ("Wrist Extensors", P, MOD, 0.50),
               ("Forearm Flexors", P, MOD, 0.45)],
   stabilisers=["anterior deltoid", "upper trapezius", "levator scapulae"],
   comparison=("ROCKING THE BAR UP", "Tall and still, elbows at the sides", "Hips swing forward to start the bar",
               "Standing still leaves the bar to the forearms, which is why this curl is done with less weight than a normal one.",
               "A hip swing throws the bar past the hardest part of the curl and loads the lower back instead."),
   glows=arm_glows("Cable Reverse Curl"))

SETUP["Cable Reverse Curl"] = [
    "Clip a straight bar to the lowest pulley and stand facing the machine, a step back, so the cable is tight with your arms down.",
    "Take the bar overhand, knuckles up, hands a little wider than your shoulders.",
    "Stand tall with your feet hip-width apart, knees soft and ribs down, upper arms against your sides.",
    "Expect to use less weight than on an underhand curl; set the pin lighter than you think.",
]

# ------------------------------------------------- bent-over extension

ex(name="Bent-Over Cable Overhead Triceps Extension", var="bentOverCableOverheadTricepsExtension",
   # Three-quarter view of a hinged body: the arms reach forward across the
   # top of the frame (hands u 0.18-0.58 at v 0.24-0.31), the trunk runs
   # down to the right (pelvis u 0.70) and the legs to the bottom right
   # (lead knee u 0.69, feet v 0.68-0.73). So the two arm pills sit top
   # right, clear of the hands, the elbow and hinge pills on the left where
   # the frame is empty below the arms, and the stance pill bottom left:
   # on the right its top edge touched the lead shoe, which runs down to
   # v 0.81.
   overrides={"lockout": (0.14, "trailing"), "upperarm": (0.32, "trailing"),
              "elbow": (0.50, "leading"), "hinge": (0.68, "leading"), "stance": (0.86, "leading")},
   annotations=[
       ("lockout", "Straighten the elbows", "hand_L"),
       ("upperarm", "Upper arms fixed", "upper_arm_L"),
       ("elbow", "Elbows point forward", "forearm_L"),
       ("hinge", "Flat back, hips hinged", "pelvis"),
       ("stance", "Split stance, knee soft", "foot_L"),
   ],
   cues={
       "lockout": ("Lockout",
                   "Each rep finishes with the elbows straight, the arms in line with your trunk and the bar out past your head.",
                   "The model opens its elbows from 65 degrees to 172 and holds the lockout for about half a second before letting the bar back. Finishing the elbow is what loads the triceps hardest in this position, and the hold is what stops the set turning into a swing.",
                   "Stopping short of straight and rushing back into the next rep.",
                   "Push until your elbows are straight and your arms line up with your back, hold for a beat, then lower under control."),
       "upperarm": ("Upper Arm Position",
                    "The upper arms sit beside your head, angled slightly up, and do not move.",
                    "With the trunk hinged over, the arms end up overhead relative to the shoulder, which is the position that stretches the long head of the triceps. Over twelve weeks, cable elbow extensions trained with the arm overhead grew the triceps more than the same work with the arm by the side: the long head 28.5% against 19.6%, the whole muscle 19.9% against 13.9%, even though the overhead arm lifted 34-39% less. In the model the upper arms hold +15 degrees above horizontal without changing by a degree.",
                    "The upper arms dropping or swinging back as the bar comes down.",
                    "Lock your upper arms beside your ears and let only the forearms travel."),
       "elbow": ("Elbow Path",
                 "The elbows stay about shoulder-width and point forward, past your head.",
                 "The bar runs 39 cm forward and back on one line in the model, hands 0.35-0.38 m apart. Elbows that splay out move the forearms off that line and hand part of the job to the shoulders.",
                 "Elbows flaring out to the sides as the bar is pressed away.",
                 "Keep your elbows pointing forward and about shoulder-width, close enough that your arms brush past your head."),
       "hinge": ("Hinge and Back",
                 "The trunk is hinged to about horizontal, the back flat and still.",
                 "This is what puts the arms overhead without reaching overhead: the model keeps its trunk 82 degrees from vertical and its pelvis at one height, so the arms are the only thing that moves. A back that rounds or drops under the pull takes the stretch out of the position.",
                 "Rounding the back or letting the chest sink toward the floor as the cable pulls.",
                 "Hinge from the hips with a flat back until your trunk is about parallel to the floor, brace, and hold it for the set."),
       "stance": ("Stance",
                  "One foot forward and one back, about 0.7 m apart, the front knee soft.",
                  "The cable pulls you toward the machine, and a split stance resists that pull far better than a square one. The model keeps its lead knee at 136 degrees and its rear leg nearly straight for the whole clip.",
                  "Feet level and close together, so the body is tugged forward each rep.",
                  "Stagger your feet about a stride apart, bend the front knee a little and keep your weight even between them."),
   },
   # Only the three triceps heads are painted, so there is one row, at the
   # library's fraction for the standing Overhead Cable Triceps Extension
   # (0.88): the same cable extension, the same elbow range, the arms
   # overhead relative to the shoulder in both. Maeo 2023 supports the
   # position but measured growth, not activation, so it is not used for the
   # number.
   activation=[("Triceps Brachii", P, HI, 0.88)],
   stabilisers=["core", "erector spinae", "rotator cuff"],
   comparison=("UPPER ARMS DROPPING", "Upper arms fixed beside the head", "Upper arms swing down with the bar",
               "Holding the upper arms still keeps the triceps stretched over the shoulder and leaves the elbow to do the work.",
               "Letting them drop turns the lift into a pulldown and takes away the overhead position the exercise is for."),
   glows=arm_glows("Bent-Over Cable Overhead Triceps Extension", rx=0.08, ry=0.06))

SETUP["Bent-Over Cable Overhead Triceps Extension"] = [
    "Clip a straight bar to a high pulley and take it in both hands, palms down, hands about shoulder-width apart.",
    "Step back a stride and stagger your feet, front knee soft, so the cable is tight.",
    "Hinge from the hips with a flat back until your trunk is about parallel to the floor, the bar by the back of your head.",
    "Set your upper arms beside your ears pointing slightly up, brace your trunk, and keep them there for the set.",
]
