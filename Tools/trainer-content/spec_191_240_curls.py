# Trainer content for batch 191-240 (2026-09-26), family: biceps curls.
# Source exports 236, 238, 239 and 240 from the HIKSEMI drive's "190-240"
# folder (SourceExports/190-240). Same format as spec.py; spec_191_240.py
# imports this module and gen.py reads SPEC / SETUP.
#
# What each model shows, from the briefs, the framing shots and the rig
# (joints sampled over the clip; the dumbbells', bar's and lever's own
# transforms read from the USD; torso length, neck to pelvis, is 0.59 m):
# - Alternating Dumbbell Curl (236): standing tall, feet ~0.3 m apart, knees
#   ~174°, trunk upright and still. A dumbbell in each hand, hanging by the
#   sides with the palms facing the thighs (handles run front to back). The
#   LEFT arm curls first (0-4 s), then the right (4-8 s); the resting arm
#   hangs straight (~172°). The working forearm turns palm-up as it rises
#   (handle across the body by ~90° of elbow bend) and finishes at ~56° of
#   elbow bend, palm turned up toward the shoulder, the forearm still ~45°
#   short of vertical (wrist ~18 cm ahead of the elbow, 11 cm below the
#   shoulder). The elbow drifts forward only ~8° (upper arm 2-10° off the
#   trunk); no shrug, no lean. Both dumbbells stay in the hands for the whole
#   clip (keys to frame 192 since the 14:21 re-export).
# - Spider Curl (238): kneeling on the seat of an adjustable bench whose back
#   pad is set at ~42° (trunk 48° forward of vertical), chest and stomach on
#   the pad, shoulders just behind its top edge; knees ~132°, feet off the
#   floor behind the seat. Olympic barbell, underhand, hands ~0.42 m apart
#   (shoulder-width). The upper arms hang straight down (~89° below
#   horizontal) and do not move; elbows 170° to 53°, two reps. At the bottom
#   the bar hangs almost straight under the elbows (hands ~4 cm ahead); at
#   the top the forearms are still ~38° above horizontal, the bar ~20 cm in
#   front of the elbows, so the load on the elbows is light at the bottom
#   and heaviest from the middle of the curl to the top.
# - Dumbbell Preacher Curl (239): seated on a preacher bench (knees ~124°,
#   hips ~110°, feet flat ~0.38 m apart), trunk 12° forward, chest against
#   the back of the pad. The pad slopes ~45°; the LEFT upper arm lies on it
#   (45° below horizontal), armpit at the top edge. One dumbbell in the left
#   hand, palm up. Elbow 162° to 62°: the rep stops ~18° short of straight
#   and finishes with the forearm nearly upright (~72° above horizontal,
#   the dumbbell almost over the elbow). The right arm rests on the
#   pad, empty (elbow ~103°). Two reps.
# - Machine Biceps Curl (240): a plate-stack, preacher-style curl machine;
#   seated (knees ~111°, hips ~101°, feet flat), trunk 12° forward, chest to
#   the pad. The arm pad holds the upper arms ~35° off vertical (55° below
#   horizontal) and the elbows sit level with the lever's side pivots
#   (elbow and pivot hub both ~0.91 m up, within 1 cm fore-aft). A straight
#   handle bar with two grips ~0.4 m apart, taken underhand. Both arms curl
#   together, elbows 162° to 62°, two reps; the stack (one prim, all ten
#   plates) rises and falls and stays ~7 cm above the tower base at the
#   bottom of every rep.
#
# Framing: every yaw is negative (lifter's left side toward the camera). The
# alternating curl (-0.4) and both seated curls (-1.1, -1.0) show the left
# arm on the right of the frame; the spider curl (-2.0) is seen from behind
# on the left, left arm on the left of the frame. Labels are pinned with
# `overrides` so no leader crosses the body or a pill covers a moving hand.
#
# Sources:
# - Marcolin G et al. 2018, PeerJ 6:e5165 (doi 10.7717/peerj.5165) — the
#   alternate dumbbell curl starts semiprone and supinates by ~90° of elbow
#   flexion; its biceps and brachioradialis activity was a little lower than
#   the EZ-bar curl's (biceps also lower than the straight bar in the
#   lowering phase); the biceps is a strong supinator as well as a flexor.
# - Coratella G, Tornatore G, Longo S, Toninelli N, Padovan R, Esposito F,
#   Cè E 2023, Sports 11(3):64 (doi 10.3390/sports11030064) — ten
#   bodybuilders, standing cable curls at each grip's 8RM: in the lifting phase biceps
#   excitation greater with a supinated grip than neutral (+12%) or pronated
#   (+19%); the brachioradialis also highest supinated (+6% vs neutral, +5%
#   vs pronated); anterior deltoid higher with neutral and pronated grips.
# - Coratella G, Tornatore G, Longo S, Esposito F, Cè E 2023, J Funct
#   Morphol Kinesiol 8(1):13 (doi 10.3390/jfmk8010013) — flexing the arms
#   forward during barbell curls raised anterior deltoid excitation, and
#   raised biceps excitation in the lifting phase (+17.7% straight bar,
#   +20.3% EZ bar) while lowering it in the lowering phase.
# - Kleiber T, Kunz L, Disselhorst-Klug C 2015, Front Physiol 6:215 (doi
#   10.3389/fphys.2015.00215) — slow, unloaded single elbow flexions: the
#   brachioradialis takes over more of elbow flexion with the forearm
#   pronated; biceps activity did not differ between hand positions.
# - Oliveira LF et al. 2009, J Sports Sci Med 8(1):24-29 — standing and
#   incline dumbbell curls load the biceps through the whole range; on the
#   dumbbell preacher curl biceps activity peaks near full extension and
#   falls as the elbow flexes, because the load torque drops until the hand
#   crosses the elbow line.
# - Pedrosa GF et al. 2023, Sports 11(2):39 (doi 10.3390/sports11020039) —
#   untrained women, dumbbell preacher curl: the bottom range (0-68°) gave a
#   larger 1RM gain and more biceps CSA at 70% of humerus length than the
#   top range (68-135°); CSA at 50% and summed CSA were similar.
# - Sato S et al. 2021, Front Physiol 12:734509 (doi
#   10.3389/fphys.2021.734509) — untrained adults, dumbbell preacher curls
#   (45° shoulder flexion, supinated) over 0-50° of flexion built more
#   strength and more combined biceps and brachialis thickness than over
#   80-130°.
# - Pinto RS et al. 2012, J Strength Cond Res 26(8):2140-2145 (doi
#   10.1519/JSC.0b013e31823a3b15) — full-range (0-130°) elbow-flexor
#   training raised the 1RM more than partial range (50-100°).
# - Nunes JP et al. 2020, Int J Environ Res Public Health 17(16):5859 (doi
#   10.3390/ijerph17165859) — where the preacher curl's torque peaks (bar vs
#   cable) changed strength at long muscle lengths, not overall growth.
# - Young S, Porcari JP, Camic C, Kovacs A, Foster C 2014, ACE ProSource
#   (August), ACE-sponsored EMG study, not peer-reviewed. Other muscles such
#   as the anterior deltoid and brachioradialis can take part of the load
#   off the biceps, and swinging the arm forward calls in the anterior
#   deltoid. The braced concentration curl had the highest biceps activity
#   (about 97% MVC) and less anterior deltoid than the barbell curl. The
#   preacher curl had the lowest biceps activity of the eight curls (about
#   68% MVC, against about 77% for the barbell curl) and, with the incline
#   curl, less brachioradialis than the narrow-grip EZ curl.
# - Sands WA, Wurth JJ, Hewit JK 2012, NSCA Basics of Strength and
#   Conditioning Manual — EZ-bar curl coaching points: elbows at the sides,
#   no rolling the shoulders forward, no momentum, slow controlled return.
# - ExRx.net (instructions read from the pages' search-index text; the
#   evidence review confirmed them on web.archive.org snapshots): Dumbbell
#   Curl (elbows to the sides, raise one dumbbell and rotate the forearm
#   until it is vertical and the palm faces the shoulder, alternate; the
#   copy follows the model, which keeps the elbow at the side and so stops
#   with the forearm short of vertical); Barbell Prone Incline
#   Curl, also known as the barbell spider curl (prone on an incline bench,
#   shoulders near the top, knees can rest on the seat, shoulder-width
#   underhand grip, lower until the arms are fully extended; target
#   brachialis, synergists biceps and brachioradialis, stabilisers wrist
#   flexors, middle trapezius and rhomboids); Dumbbell and Lever Preacher
#   Curl (armpit near the top of the pad, back of the arm on it for the
#   whole movement, elbows aligned with the lever's fulcrum).
# - StrengthLog exercise guides: Dumbbell Curl (elbows moving forward puts
#   extra load on the front delts; keep the wrists straight, since bent
#   wrists take needless load), Spider Curl (upper arms vertical, do not let
#   them travel back or forwards), Dumbbell Preacher Curl, Machine Biceps
#   Curl (upper arms on the pad, elbows in line with the machine's joint,
#   stop just before the weights hit the stack).
# - NASM exercise library, Barbell Biceps Curl — common mistakes: swinging,
#   elbows drifting, partial range, uncontrolled lowering.
from common_191_240 import *

# ---------------------------------------------------------------- shared cues

TORSO_SEATED = ("Torso Position",
                "The chest stays against the pad.",
                "Rocking back uses the body's weight to start the lift and pulls the arms off the pad, so the elbow flexors skip the hardest part of the rep.",
                "Leaning back from the hips to swing the weight up, the arms coming off the pad with the chest.",
                "Sit tall with the chest against the back of the pad and keep the torso still; only the forearms move.")

# The machine's resistance profile is unknown, so its torso cue does not say
# where the rep is hardest.
TORSO_MACHINE = TORSO_SEATED[:2] + (
    "Rocking back uses the body's weight to start the lift and pulls the arms off the pad, so the body, not the elbow flexors, gets the handle moving.",
) + TORSO_SEATED[3:]

WRISTS_UNDERHAND = ("Grip and Wrists",
                    "An underhand grip, wrists straight.",
                    "With the palms turned up the biceps works in its strongest position. Curling the wrists in moves the handle with the wrists instead of the elbows and puts needless load on them.",
                    "Curling the wrists in toward the forearms at the top of each rep.",
                    "Hold the handles underhand about shoulder-width apart and keep the knuckles in line with the forearms from bottom to top.")


def curl_glows(name, other=None, rx=0.07, ry=0.07):
    """The working (left) biceps, mid upper arm between shoulder and elbow, at
    full strength; softer, the right biceps when both arms work, and the
    brachialis and brachioradialis at the left elbow."""
    g = [glow(name, ["upper_arm_L", "forearm_L"], A, 0.55, rx, ry)]
    if other == "both":
        g.append(glow(name, ["upper_arm_R", "forearm_R"], SOFT, 0.30, rx, ry))
    g.append(glow(name, ["forearm_L"], SOFT, 0.28, rx * 0.75, ry * 0.75))
    return g


# ---------------------------------------------------------------- alternating dumbbell curl

ex(name="Alternating Dumbbell Curl", var="alternatingDumbbellCurl",
   # Right side: the left elbow from the top row (a pill at 0.32 would cover
   # the left hand at the top of its curl; the short label keeps the leader
   # clear of the head), the hand and hips below it; the shoulder and range
   # cues point at the right arm from the left. No pill covers a glow.
   overrides={"shoulder": (0.14, "leading"), "elbow": (0.14, "trailing"), "turn": (0.56, "trailing"),
              "range": (0.60, "leading"), "torso": (0.74, "trailing")},
   annotations=[
       ("shoulder", "Shoulders down and back", "upper_arm_R"),
       ("elbow", "Elbow by your side", "forearm_L"),
       ("turn", "Turn the palm up", "hand_L"),
       ("range", "Lower to a straight arm", "hand_R"),
       ("torso", "Torso still, no swing", "pelvis"),
   ],
   cues={
       "shoulder": ("Shoulder Position",
                    "The shoulders stay set while the arms take turns.",
                    "Shrugging or rolling the shoulders forward lets the upper traps and front deltoids help lift the dumbbell, taking work away from the biceps and brachialis.",
                    "Shoulders shrugging up and rolling forward as each dumbbell comes up.",
                    "Draw the shoulders down and back before the first rep and keep them level and still for the whole set."),
       "elbow": ("Elbow Position",
                 "The working elbow stays by your side.",
                 "With the elbow fixed, bending it is the only motion, so the elbow flexors lift the weight. If the elbow drifts forward, the front deltoid joins in and the forearm reaches vertical early, where the dumbbell stops loading the elbow.",
                 "The working elbow drifting forward and up as the dumbbell rises, turning the top of the curl into a front raise.",
                 "Keep the elbow close to the ribs and curl until the dumbbell is in front of the shoulder, palm turned up toward it, without bringing the elbow forward."),
       "turn": ("Forearm Turn",
                "Start palm-in and turn the palm up as the dumbbell rises.",
                "The biceps turns the palm up as well as bending the elbow, and in trained lifters palm-up curls have worked it harder than palm-in or palm-down curls, so the turn finishes each rep where the biceps is strongest.",
                "Curling the wrist in toward the forearm at the top instead of turning the palm up.",
                "Turn the palm up as the dumbbell leaves the thigh, finish with it facing the shoulder, and keep the knuckles in line with the forearm."),
       "range": ("Range of Motion",
                 "Each curl starts from a straight arm.",
                 "Lowering all the way works the elbow flexors through their whole length, and full-range curl training has built more strength than partial reps.",
                 "Leaving the resting arm half-bent at the bottom and starting its next curl from there.",
                 "Lower each dumbbell until the arm hangs straight by your side, palm facing in, before the other arm starts."),
       "torso": ("Body Swing",
                 "The legs and back stay out of it.",
                 "Rocking the torso or pushing the hips forward borrows momentum from the hips and lower back, which skips the hardest part of each curl and loads the spine.",
                 "Leaning back and pushing the hips forward to swing each dumbbell up.",
                 "Stand tall with soft knees, brace the core and lower each dumbbell over two to three seconds so the next rep starts from a still body."),
   },
   activation=[("Biceps Brachii", P, HI, 0.84), ("Brachialis", S, MOD, 0.62), ("Brachioradialis", S, MOD, 0.46)],
   stabilisers=["anterior deltoid", "forearm flexors", "core"],
   comparison=("SWINGING THE DUMBBELL", "Torso still, elbow at the side", "Body swings each dumbbell up",
               "With the torso still and the elbow at the side, the biceps lifts each dumbbell through the whole range.",
               "Swinging uses the hips and lower back to start each rep, so the biceps skips the hardest part and the spine takes the strain."),
   glows=curl_glows("Alternating Dumbbell Curl", "both", rx=0.06, ry=0.07))

SETUP["Alternating Dumbbell Curl"] = [
    "Hold a dumbbell in each hand, palms facing your thighs.",
    "Stand tall, feet hip-width, arms straight by your sides.",
    "Shoulders down and back, elbows by your ribs.",
    "Curl one arm at a time, turning the palm up as it rises.",
]

# ---------------------------------------------------------------- spider curl

ex(name="Spider Curl", var="spiderCurl",
   # The figure is small and lies across the middle of the frame, head and
   # plate on the left: the back and shoulder cues go above it on the right;
   # the upper-arm cue sits above the plate with its leader down to the near
   # shoulder, and the grip and range cues sit below the plate on the near
   # hand and elbow (the far arm is hidden behind the torso and pad).
   overrides={"shoulder": (0.14, "trailing"), "pad": (0.30, "trailing"), "elbow": (0.22, "leading"),
              "grip": (0.56, "leading"), "range": (0.70, "leading")},
   annotations=[
       ("pad", "Chest stays on the pad", "spine"),
       ("shoulder", "Shoulders down", "scapula_R"),
       ("elbow", "Upper arms hang still", "upper_arm_L"),
       ("grip", "Wrists straight", "hand_L"),
       ("range", "Lower to straight arms", "forearm_L"),
   ],
   cues={
       "pad": ("Chest Support",
               "The incline pad holds the body still.",
               "With the chest pressed into the pad the torso cannot rock, so the elbow flexors have to lift the whole load; that bracing is what makes the spider curl strict.",
               "Lifting the chest and shoulders off the pad to heave the bar up.",
               "Kneel on the seat, keep the chest and stomach on the pad for every rep, and drop the weight if the bar only moves when the chest lifts."),
       "shoulder": ("Shoulder Position",
                    "The shoulders stay down, away from the ears.",
                    "Shrugging brings the upper traps into the lift and moves the shoulders off their fixed place over the pad, so the curl stops being an elbow-only movement.",
                    "Shoulders shrugging up toward the ears as the bar rises.",
                    "Let the shoulder blades settle down over the top of the pad and keep the neck long as you curl."),
       "elbow": ("Upper Arm Position",
                 "The upper arms hang straight down and stay there.",
                 "With the upper arms vertical, the bar hangs almost straight under the elbows at the bottom and swings out in front of them as it rises, so the curl gets harder as the bar rises, is heaviest with the forearms level and stays heavy to the top. Letting the elbows swing toward the head brings the front deltoids in and tips the bar back over the elbows, which takes the load off the elbow flexors.",
                 "The elbows drifting forward toward the head as the bar comes up.",
                 "Keep the elbows under the shoulders, move only the forearms, and curl until the elbows are fully bent."),
       "grip": ("Grip and Wrists",
                "An underhand grip at shoulder-width, wrists straight.",
                "A shoulder-width underhand grip keeps the forearms turned palm-up, the position in which the biceps works hardest. Curling the wrists in pulls the bar back toward the elbows, which eases the top of the rep and puts needless load on the wrists.",
                "Curling the wrists in toward the forearms at the top of each rep.",
                "Hold the bar with the hands about shoulder-width apart, thumbs around it, and keep the knuckles in line with the forearms from bottom to top."),
       "range": ("Range of Motion",
                 "Every rep starts from straight arms.",
                 "Lowering until the arms hang straight works the elbow flexors through their whole length, and full-range curl training has built more strength than partial reps.",
                 "Short reps that stop with the elbows still bent at the bottom.",
                 "Lower the bar under control until the arms hang straight below the shoulders, then curl again without bouncing."),
   },
   activation=[("Biceps Brachii", P, HI, 0.86), ("Brachialis", S, MOD, 0.66), ("Brachioradialis", S, MOD, 0.46)],
   stabilisers=["anterior deltoid", "forearm flexors", "middle trapezius", "rhomboids"],
   comparison=("ELBOWS DRIFTING FORWARD", "Upper arms hang straight down", "Elbows swing toward the head",
               "With the upper arms hanging still, the bar swings out in front of the elbows as it rises and stays there, so the biceps is loaded all the way to the top.",
               "When the elbows swing forward, the front deltoids help lift and the bar tips back over the elbows, taking the load off the elbow flexors at the top."),
   # Only the near (left) arm is visible from behind; the far arm is hidden.
   glows=curl_glows("Spider Curl", rx=0.05, ry=0.05))

SETUP["Spider Curl"] = [
    "Set an incline bench to about 45°.",
    "Kneel on the seat, chest on the pad, shoulders just over the top.",
    "Take the barbell underhand, hands shoulder-width apart.",
    "Let your arms hang straight down.",
]

# ---------------------------------------------------------------- dumbbell preacher curl

ex(name="Dumbbell Preacher Curl", var="dumbbellPreacherCurl",
   # Side-on from the front-left: the shoulder, chest and hips are on the
   # right, the forearm and dumbbell reach out to the left over the pad. The
   # top-right label is short so its leader drops to the shoulder right of
   # the head; the chest label sits below the biceps glow.
   overrides={"pad": (0.14, "trailing"), "wrist": (0.14, "leading"), "torso": (0.44, "trailing"),
              "range": (0.50, "leading"), "seat": (0.62, "trailing")},
   annotations=[
       ("pad", "Arm on the pad", "upper_arm_L"),
       ("range", "Lower to almost straight", "forearm_L"),
       ("wrist", "Palm up, wrist straight", "hand_L"),
       ("torso", "Chest stays on the pad", "chest"),
       ("seat", "Seat set, feet flat", "pelvis"),
   ],
   cues={
       "pad": ("Arm on the Pad",
               "The armpit sits at the top of the pad and the back of the arm stays on it.",
               "The pad holds the upper arm at about 45°, so bending the elbow is the only motion and the shoulder cannot help lift.",
               "The elbow and upper arm lifting off the pad as the dumbbell comes up.",
               "Rest the armpit near the top edge, lay the back of the upper arm flat along the pad and keep it pressed there for the whole set."),
       "range": ("Range of Motion",
                 "The bottom half is where the preacher curl works hardest.",
                 "With the upper arm on a 45° slope, the dumbbell pulls hardest on the elbow in the bottom half and hardly at all once the forearm is upright, and biceps activity follows that; training the bottom half has built more strength, and at least as much muscle, as training the top half.",
                 "Stopping halfway down, so the arm never gets near straight.",
                 "Lower under control until the arm is almost straight, without letting the elbow snap straight, then curl again."),
       "wrist": ("Grip and Wrist",
                 "The palm faces up for the whole rep.",
                 "With the palm up the biceps works in its strongest position. Curling the wrist in pulls the dumbbell back toward the elbow, which eases the top of the rep and puts needless load on the wrist.",
                 "Curling the wrist in toward the forearm at the top of the rep.",
                 "Hold the dumbbell palm-up with a firm grip, knuckles in line with the forearm, from the bottom to the top."),
       "torso": TORSO_SEATED[:4] + ("Sit tall with the chest against the back of the pad and keep the torso still; only the working forearm moves.",),
       "seat": ("Seat Height",
                "Set the seat before the first rep.",
                "At the right height the armpit rests over the top of the pad with the shoulders relaxed; too low, the shoulders hunch up to hook the arm over it.",
                "The seat set too low, so the shoulders ride up toward the ears to reach over the pad.",
                "Raise or lower the seat until the armpit rests near the top of the pad with the shoulders down, then plant both feet flat."),
   },
   activation=[("Biceps Brachii", P, HI, 0.84), ("Brachialis", S, MOD, 0.68), ("Brachioradialis", S, LOW, 0.36)],
   stabilisers=["forearm flexors", "rotator cuff", "core"],
   comparison=("STOPPING SHORT AT THE BOTTOM", "Lower to almost straight", "Rep stops halfway down",
               "Lowering until the arm is almost straight trains the bottom half, where the preacher curl loads the biceps most.",
               "Stopping halfway keeps every rep in the top half, where the dumbbell moves in over the elbow and the load on the biceps falls away."),
   glows=curl_glows("Dumbbell Preacher Curl", rx=0.07, ry=0.05))

SETUP["Dumbbell Preacher Curl"] = [
    "Set the seat so your armpit rests at the top of the pad.",
    "Hold a dumbbell in one hand, palm up.",
    "Lay the back of that arm flat on the pad, the other arm resting beside it.",
    "Sit tall, chest to the pad, feet flat.",
]

# ---------------------------------------------------------------- machine biceps curl

ex(name="Machine Biceps Curl", var="machineBicepsCurl",
   # Seen from the front-left: the shoulder, elbow and hip cues on the
   # right (below the biceps glows, short top label clear of the head), the
   # hands (and the weight stack) on the left.
   overrides={"pad": (0.14, "trailing"), "grip": (0.14, "leading"), "pivot": (0.44, "trailing"),
              "torso": (0.62, "trailing"), "range": (0.56, "leading")},
   annotations=[
       ("pivot", "Elbows level with pivot", "forearm_L"),
       ("pad", "Arms on the pad", "upper_arm_L"),
       ("grip", "Underhand, wrists flat", "hand_L"),
       ("range", "Lower to almost straight", "hand_R"),
       ("torso", "Sit tall, no rocking", "pelvis"),
   ],
   cues={
       "pivot": ("Seat and Pivot",
                 "The elbows line up with the machine's pivot.",
                 "With the elbows on the lever's axis, the handle travels the same arc as the forearms, so the resistance stays square to them through the whole rep.",
                 "The seat set too low, so the elbows sit below the pivot and the handle drags along the forearms.",
                 "Adjust the seat until the backs of the arms rest on the pad and the elbows sit level with the pivot on each side."),
       "pad": ("Arm Position",
               "The backs of the upper arms stay on the pad.",
               "The pad fixes the upper arms, so bending the elbows is the only motion and the shoulders cannot help.",
               "The elbows lifting off the pad as the handle rises, so the shoulders help finish the rep.",
               "Press the backs of the arms into the pad and move only the forearms."),
       "grip": WRISTS_UNDERHAND,
       "range": ("Range of Motion",
                 "Each rep starts from almost straight arms.",
                 "On preacher-style curls, training the lower, stretched part of the range has built more strength, and at least as much muscle, as training only the top part, so short reps at the top leave that part out.",
                 "Short reps that stop with the elbows well bent, the plates never lowering far.",
                 "Lower until the arms are almost straight, stopping before the weight stack touches down, then curl again without bouncing."),
       "torso": TORSO_MACHINE,
   },
   activation=[("Biceps Brachii", P, HI, 0.84), ("Brachialis", S, MOD, 0.66), ("Brachioradialis", S, LOW, 0.38)],
   stabilisers=["forearm flexors", "rotator cuff", "core"],
   comparison=("ELBOWS LIFTING OFF THE PAD", "Arms flat on the pad", "Elbows lift as the handle rises",
               "With the backs of the arms on the pad, the elbow flexors move the handle through its whole arc.",
               "Lifting the elbows lets the shoulders help finish each rep and moves the elbows off the lever's pivot."),
   glows=curl_glows("Machine Biceps Curl", "both", rx=0.06, ry=0.05))

SETUP["Machine Biceps Curl"] = [
    "Set the seat so your elbows line up with the machine's pivot.",
    "Sit with your chest to the pad, backs of the arms flat on it.",
    "Take the handles underhand, hands shoulder-width apart.",
    "Start with the arms almost straight.",
]

if __name__ == "__main__":
    probs = validate(["Alternating Dumbbell Curl", "Spider Curl", "Dumbbell Preacher Curl", "Machine Biceps Curl"]); print("\n".join(probs) or "OK")
