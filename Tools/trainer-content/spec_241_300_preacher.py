# Trainer content for batch 241-300 (2026-09-27), family: preacher-style and
# machine curls. Source exports 241, 242, 250, 260 and 263 from the HIKSEMI
# drive's "241-300" folder (SourceExports/241-300). Same format as spec.py;
# spec_241_300.py imports this module and gen.py reads SPEC / SETUP.
#
# What each model shows, from the briefs, the framing shots and the rig
# (joints sampled over the clip in skeleton space, which is Y-up with the
# lifter facing +z; the bench, machine, bar, cable and stack transforms read
# from the USD; torso length, neck to pelvis, 0.592 m; one body shared by all
# five). Note: wrist.py labels the palm in Z-up terms, but these stages are
# Y-up, so its "backward" is up, "down" is backward, "forward" is down and
# "up" is forward; the grips below were read with that corrected and checked
# against the shots.
# - Single-Arm Machine Curl (241): the plate-stack, preacher-style curl
#   machine of the Machine Biceps Curl (Q191_CurlMachine). Seated (knees
#   ~111°, hips ~101°, feet flat ~0.38 m apart), trunk 12° forward, chest to
#   the pad. The upper arms sit 55° below horizontal (35° off vertical),
#   resting on a short arm pad (top ~39°) just above the elbows. Only the
#   LEFT arm works: underhand on the lever's straight handle, the hand
#   straight in front of the left shoulder; elbow 162° to 62° (forearm from
#   37° below horizontal to 62° above), two reps; the left elbow sits level
#   with the lever's side pivot (elbow 0.907 m up, hub centre 0.905 m,
#   within 0.5 cm fore-aft). The whole lever (one prim with a two-grip
#   handle) turns and the stack rises ~25 cm. The right upper arm rests on
#   the pad, elbow ~102°, the empty fist raised ~23° above horizontal, palm
#   facing in, in the path of the lever's right grip, which passes through
#   it at ~1.0 s and ~2.7 s (model defect). Wrist ~10° extended (knuckles in
#   line with the forearm), fingers closed round the handle.
# - Cable Preacher Curl (242): a preacher bench (pad top ~30°, flatter than
#   the upper arms, which touch it near the elbows) set square in front of a
#   dual cable station; seated (knees ~124°, hips ~110°, feet flat), trunk
#   12° forward, chest to the pad, upper arms 44-46° below horizontal over
#   it, armpits at the top edge. A straight cable bar, underhand, hands
#   ~0.47 m apart (about shoulder-width). The cable runs from a swivel under
#   the middle of the bar down and forward to the station's low pulley,
#   ~0.9 m in front of the elbows at floor level, 56-64° below horizontal.
#   Both arms curl together, elbows 164° to 63° (forearms from 28° below
#   horizontal to 73° above, the bar near the chin), two reps; the selected
#   plates rise ~0.5 m. The cable's turning effect on the elbows (the cable
#   mesh's line through the bar's cable mount, from the rig) is ~0.5 of its
#   peak at the bottom (elbows 164°), peaks with the elbows at ~100-120° and
#   is still ~0.73 of peak at the top (63°); a free weight on the same bench
#   would be ~0.9 at the bottom, peak with the forearms level and fall to
#   ~0.3 at the top. Seen from the front-right (yaw +1.1): the right arm is
#   the near one, on the left of the screen.
# - Preacher Hammer Curl (250): the body of the Dumbbell Preacher Curl on a
#   preacher bench whose pad top slopes ~30° (the Dumbbell Preacher Curl's
#   is ~45°). Seated (knees ~124°, hips ~110°), trunk 12° forward, chest to
#   the pad, the LEFT upper arm 45° below horizontal over the pad, touching
#   it near the elbow, armpit at the top edge. One dumbbell in the left hand,
#   neutral grip (palm facing in, thumb up) for the whole clip; elbow 162° to
#   62° (forearm from 27° below horizontal to 72° above), two reps. Wrist 4-8°
#   extended. The right arm is empty: its elbow sits just past the pad's
#   right edge and the forearm passes through the pad's front corner, the
#   fist hanging below it (elbow ~104°, wrist bent ~45°; model defect).
# - Reverse Preacher Curl (260): same body; pad top ~38°, the upper arms 45°
#   below horizontal over it. An EZ bar with plates, overhand on its angled
#   grips, hands ~0.39 m apart: the palms face down at the bottom and
#   forward at the top, turned ~23° in from fully palm-down by the bar's
#   angle. Both arms curl together, elbows 162° to 62° (forearms 27° below
#   horizontal to 72° above), two reps. Wrists 8-9° extended (knuckles in
#   line with the forearms). Re-framed at yaw -0.8, zoom 1.0, offset
#   (-0.02, 0.123, 0.02) (it was -1.1, where the near plate covered the
#   whole head at every peak): the near plate now sweeps from over the
#   lower chest and left elbow at the bottom to right of the face at the
#   top, overlapping only the back of the head.
# - Barbell Preacher Curl (263): same body; pad top ~29°, the upper arms 45°
#   below horizontal over it. An Olympic barbell with plates, underhand,
#   hands ~0.42 m apart (shoulder-width). Both arms curl together, elbows
#   162° to 62°, forearms 27° below horizontal to 71° above, two reps; wrists
#   9-12° extended. Re-framed at yaw -0.8, zoom 0.602 (it was -1.1, where the
#   near plate hid the left hand at the bottom and rose past the head at the
#   top): the near plate now sits right of the chest at the bottom and right
#   of the head at the top, the lifter drawn smaller, like the Barbell Curl.
#
# Framing: the machine (-1.0), hammer (-1.1), reverse and barbell (-0.8)
# curls are seen from the front-left, the working (left) arm on the right of
# the frame reaching left over the pad (the reverse and barbell curls nearer
# the front);
# the cable preacher (+1.1) from the front-right,
# the cable station in front of the lifter and out of frame to the right
# (only its base and the cable show), the right arm nearest. Labels are
# pinned with `overrides` so no leader crosses the head or a pill covers a
# moving hand.
#
# Sources:
# - Oliveira LF, Matta TT, Alves DS, Garcia MAC, Vieira TMM 2009, J Sports
#   Sci Med 8(1):24-29 — on the dumbbell preacher curl biceps activity is
#   high only for a short range near extension (up to 80% of maximum RMS at
#   the start) and falls as the elbow flexes and the load torque drops;
#   standing and incline curls load it through the whole range.
# - Pedrosa GF et al. 2023, Sports 11(2):39 (doi 10.3390/sports11020039) —
#   untrained women, preacher-style arm curl: training the initial range
#   (0-68°) gave a larger 1RM gain and more biceps CSA at 70% of humerus
#   length than the final range (68-135°).
# - Sato S et al. 2021, Front Physiol 12:734509 (doi
#   10.3389/fphys.2021.734509) — preacher curls over 0-50° built more
#   strength and elbow-flexor thickness than over 80-130°.
# - Pinto RS et al. 2012, J Strength Cond Res 26(8):2140-2145 (doi
#   10.1519/JSC.0b013e31823a3b15) — full-range elbow-flexor training raised
#   the 1RM more than partial range (25.7% vs 16.0%).
# - Nunes JP et al. 2020, Int J Environ Res Public Health 17(16):5859 (doi
#   10.3390/ijerph17165859) — cable preacher curl (more torque with the
#   elbows flexed) vs barbell preacher curl (more torque with the elbows
#   extended), 10 weeks: similar biceps growth (7% vs 8%); the barbell group
#   gained more strength only at 20° of flexion.
# - Coratella G, Tornatore G, Longo S, Toninelli N, Padovan R, Esposito F,
#   Cè E 2023, Sports 11(3):64 (doi 10.3390/sports11030064) — ten
#   bodybuilders, standing cable curls at each grip's 8RM (bar for
#   supinated and pronated, rope for neutral): in the lifting phase biceps
#   excitation greater supinated than pronated (+19%) or neutral (+12%);
#   brachioradialis also a little greater supinated (+5% vs pronated, +6% vs
#   neutral, no difference between those two); anterior deltoid greater with
#   the pronated and neutral grips. The brachialis, not measured, is called
#   the most powerful elbow flexor, and it does not insert on the radius, so
#   it takes no part in supination.
# - Kleiber T, Kunz L, Disselhorst-Klug C 2015, Front Physiol 6:215 (doi
#   10.3389/fphys.2015.00215) — slow unloaded elbow flexions: brachioradialis
#   activity significantly greater with the hand pronated than neutral or
#   supinated, biceps activity constant across hand positions.
# - Boland MR, Spigelman T, Uhl TL 2008, J Hand Surg Am 33(10):1853-1859
#   (doi 10.1016/j.jhsa.2008.07.019) — fine-wire EMG, loads 0-67 N: no
#   difference in brachioradialis activation during elbow flexion between
#   neutral, pronated and supinated forearms; it is most active in elbow
#   flexion whatever the forearm's position, acting as a consistent elbow
#   stabiliser.
# - Date S, Kurumadani H, Nakashima Y, Ishii Y, Ueda A, Kurauchi K,
#   Sunagawa T 2021, Front Physiol 12:809422 (doi
#   10.3389/fphys.2021.809422) — brachialis EMG patterns during elbow flexion
#   were similar in supination, neutral and pronation, the biceps' were not
#   (the brachialis inserts on the ulna, the biceps on the radius).
# - Kohn S, Smart RR, Jakobi JM 2018, Physiol Rep 6:e13560 (doi
#   10.14814/phy2.13560) — isometric elbow-flexion force at 110° ~214 N
#   supinated, ~244 N neutral, ~114 N pronated (eleven men); supinated and
#   neutral both greater than pronated and not different from each other.
# - Coratella G, Tornatore G, Longo S, Esposito F, Cè E 2023, J Funct
#   Morphol Kinesiol 8(1):13 (doi 10.3390/jfmk8010013) — flexing the arms
#   forward during barbell curls raised anterior deltoid excitation.
# - Young S, Porcari JP, Camic C, Kovacs A, Foster C 2014, ACE ProSource
#   (August), ACE-sponsored EMG study, not peer-reviewed: the anterior
#   deltoid and brachioradialis can take part of the load off the biceps;
#   the braced concentration curl isolated the biceps best; the preacher
#   curl had the lowest biceps activity of the eight curls and, with the
#   incline curl, less brachioradialis than the narrow-grip EZ curl; the
#   anterior deltoid was lower than on the barbell curl only for the
#   incline curl, concentration curl and chin-up (not the preacher curl).
# - ExRx.net (instructions and muscle lists read on Wayback snapshots and
#   the pages' search-index text; the site blocks direct fetches): Lever
#   Preacher Curl (plate loaded) (LVPreacherCurlH; back of the arms on the
#   pad, armpit near its top, elbows aligned near the lever's fulcrum, lower
#   until the arms are fully extended; if no resistance is felt early in
#   the rep, set the seat so the back of the arm lies flush on the pad;
#   target brachialis, synergists biceps and brachioradialis, stabilisers
#   wrist flexors); Cable Preacher Curl (shoulder-width underhand grip,
#   raise the bar toward the shoulders, lower until the arms are fully
#   extended, the plates in use should not touch the rest of the stack at
#   the bottom; target brachialis, synergists biceps and brachioradialis);
#   Barbell Preacher Curl and Barbell Reverse Preacher Curl (raise until the
#   forearms are vertical, lower until the arms are fully extended, seat set
#   so the armpit rests near the top of the pad, back of the upper arm on
#   the pad); Lever Hammer Preacher Curl (a lever machine, not a dumbbell:
#   handles thumb side up; target brachioradialis, synergists brachialis and
#   biceps, stabilisers include the anterior deltoid, upper and middle
#   trapezius, levator scapulae and the flexor and extensor carpi radialis);
#   Barbell Reverse Curl (target brachioradialis, synergists brachialis and
#   biceps, stabilisers include the wrist extensors).
# - StrengthLog exercise guides: Barbell Preacher Curl (pad under the
#   armpits, body still and upper arms pressed to the pad, feet flat, stop
#   short of full extension if it is uncomfortable, keep the wrists straight
#   since bent wrists take needless load), Hammer Curl (keep the grip
#   neutral, it is easy to start twisting the wrists without thinking; the
#   grip puts the brachioradialis in a stronger position; lists the biceps
#   as primary), Reverse Barbell Curl (overhand, about shoulder-width; lists
#   the biceps as primary), EZ Curl (the angled grip can be kinder to the
#   wrists and elbows), Machine Biceps Curl (upper arms on the pad, elbows in
#   line with the machine's joint, stop just before the weights hit the
#   stack). StrengthLog, The 13 Best Machine Exercises (machine curl: locks
#   the upper arm in place and makes it almost impossible to use the
#   shoulders or swing the back). StrengthLog, How to Train Your Forearm
#   Extensors (reverse curls shift some of the work from the biceps onto the
#   brachioradialis and recruit the wrist extensors, especially the extensor
#   carpi radialis longus and brevis, to stabilise).
from common_241_300 import *

# ---------------------------------------------------------------- shared cues

PAD_BOTH = ("Arms on the Pad",
            "The armpits sit at the top of the pad and the backs of the arms stay on it.",
            "The pad holds the upper arms at about 45°, so bending the elbows is the only motion and the shoulders cannot help lift.",
            "The elbows and upper arms lifting off the pad as the bar comes up.",
            "Rest the armpits near the top edge, lay the backs of the upper arms flat along the pad and keep them there for the whole set.")

PAD_ONE = ("Arm on the Pad",
           "The armpit sits at the top of the pad and the back of the arm stays on it.",
           "The pad holds the upper arm at about 45°, so bending the elbow is the only motion and the shoulder cannot help lift.",
           "The elbow and upper arm lifting off the pad as the dumbbell comes up.",
           "Rest the armpit near the top edge, lay the back of the upper arm flat along the pad and keep it pressed there for the whole set.")

# Free-weight preacher curls: the load pulls hardest near the bottom.
RANGE_BOTH = ("Range of Motion",
              "The bottom half is where a preacher curl works hardest.",
              "With the upper arms on a 45° slope, the weight pulls hardest on the elbows in the bottom half and hardly at all once the forearms are upright; on preacher curls, training the bottom half has built more strength, and at least as much muscle, as training the top half.",
              "Stopping halfway down, so the arms never get near straight.",
              "Lower under control until the arms are almost straight, without letting the elbows snap straight, then curl again.")

TORSO_BOTH = ("Torso Position",
              "The chest stays against the pad.",
              "Rocking back uses the body's weight to start the lift and pulls the arms off the pad, so the elbow flexors skip the hardest part of the rep.",
              "Leaning back from the hips to swing the bar up, the arms coming off the pad with the chest.",
              "Sit tall with the chest against the back of the pad and keep the torso still; only the forearms move.")

SEAT_BOTH = ("Seat Height",
             "Set the seat before the first rep.",
             "At the right height the armpits rest over the top of the pad with the shoulders relaxed; too low, the shoulders hunch up to hook the arms over it.",
             "The seat set too low, so the shoulders ride up toward the ears to reach over the pad.",
             "Raise or lower the seat until the armpits rest near the top of the pad with the shoulders down, then plant both feet flat.")

SEAT_ONE = ("Seat Height",
            "Set the seat before the first rep.",
            "At the right height the armpit rests over the top of the pad with the shoulders relaxed; too low, the shoulders hunch up to hook the arm over it.",
            "The seat set too low, so the shoulders ride up toward the ears to reach over the pad.",
            "Raise or lower the seat until the armpit rests near the top of the pad with the shoulders down, then plant both feet flat.")


def arm_glows(name, near="L", far=None, rx=0.06, ry=0.05, elbow_first=False):
    """Glows on the working arm: the biceps (mid upper arm, between shoulder
    and elbow) and the brachialis and brachioradialis at the elbow, the
    first of them at full strength; softer, the other arm's biceps when both
    arms work. `elbow_first` leads with the elbow for the hammer and reverse
    grips, where the brachialis and brachioradialis carry more of the lift,
    and marks the other arm at its elbow too."""
    biceps = glow(name, [f"upper_arm_{near}", f"forearm_{near}"], A, 0.55, rx, ry)
    elbow = glow(name, [f"forearm_{near}"], SOFT, 0.30, rx * 0.8, ry * 0.8)
    if elbow_first:
        biceps = glow(name, [f"upper_arm_{near}", f"forearm_{near}"], SOFT, 0.30, rx * 0.9, ry * 0.9)
        elbow = glow(name, [f"forearm_{near}"], A, 0.55, rx, ry)
        g = [elbow, biceps]
    else:
        g = [biceps, elbow]
    if far:
        other = [f"forearm_{far}"] if elbow_first else [f"upper_arm_{far}", f"forearm_{far}"]
        g.append(glow(name, other, SOFT, 0.28, rx * 0.9, ry * 0.9))
    return g


# ---------------------------------------------------------------- single-arm machine curl

ex(name="Single-Arm Machine Curl", var="singleArmMachineCurl",
   # Seen from the front-left: the shoulder, chest and hips on the right
   # (short top label, clear of the head and, in the turned pad still, of the
   # ghost's shoulder); the hand and elbow of the working arm reach out to the
   # left over the pad, the free fist further left. The chest, spine and
   # pelvis all project onto the machine's front post here: the torso dot
   # marks where the chest meets the pad, seen from behind the pad (the
   # label says "against" so the dot on the pad reads that way; a chest
   # surface joint's leader would cross the working elbow), and the seat dot
   # sits on the right hip just left of the post. The torso label sits below
   # the rocked-back ghost's pelvis (~0.42 in the turned still).
   overrides={"pad": (0.14, "trailing"), "grip": (0.14, "leading"), "torso": (0.49, "trailing"),
              "range": (0.56, "leading"), "pivot": (0.68, "trailing")},
   annotations=[
       ("pad", "Arm on pad", "upper_arm_L"),
       ("range", "Lower to almost straight", "forearm_L"),
       ("grip", "Palm up, wrist straight", "hand_L"),
       ("torso", "Chest against the pad", "chest"),
       ("pivot", "Seat set, elbow at pivot", "thigh_R"),
   ],
   cues={
       "pad": ("Arm Position",
               "The back of the working arm stays on the pad.",
               "The pad fixes the upper arm, so bending the elbow is the only motion and the shoulder cannot help lift.",
               "The elbow lifting off the pad as the handle rises, so the shoulder helps finish the rep.",
               "Press the back of the arm into the pad and move only the forearm."),
       "range": ("Range of Motion",
                 "Each rep starts from an almost straight arm.",
                 "On preacher-style curls, training the lower, stretched part of the range has built more strength, and at least as much muscle, as training only the top part, so short reps at the top leave that part out.",
                 "Short reps that stop with the elbow well bent, the plates never lowering far.",
                 "Lower until the arm is almost straight, stopping before the weights touch down, then curl again without bouncing."),
       "grip": ("Grip and Wrist",
                "An underhand grip, wrist straight.",
                "With the palm turned up the biceps does more of the lifting than with other grips. Curling the wrist in moves the handle with the wrist instead of the elbow and puts needless load on it.",
                "Curling the wrist in toward the forearm at the top of each rep.",
                "Hold the handle palm-up and keep the knuckles in line with the forearm from bottom to top."),
       "torso": ("Torso Position",
                 "The chest stays against the pad.",
                 "Rocking back uses the body's weight to start the lift and pulls the arm off the pad, so the body, not the elbow flexors, gets the handle moving.",
                 "Leaning back from the hips to swing the handle up, the working arm coming off the pad with the chest.",
                 "Sit tall with the chest against the pad and the free arm resting on it; keep the torso still so only the working forearm moves."),
       "pivot": ("Seat and Pivot",
                 "The working elbow lines up with the machine's pivot.",
                 "With the elbow on the lever's axis, the handle travels the same arc as the forearm, so the resistance stays square to it through the whole rep.",
                 "The seat set too low, so the elbow sits below the pivot and the handle drags along the hand.",
                 "Adjust the seat until the back of the arm rests on the pad and the elbow sits level with the pivot on that side."),
   },
   activation=[("Biceps Brachii", P, HI, 0.84), ("Brachialis", S, MOD, 0.66), ("Brachioradialis", S, LOW, 0.38)],
   stabilisers=["forearm flexors", "rotator cuff", "core"],
   comparison=("SEAT SET TOO LOW", "Elbow level with the pivot", "Elbow sits below the pivot",
               "With the elbow on the lever's axis, the handle follows the forearm's arc and the resistance stays square to it from bottom to top.",
               "With the seat too low the elbow sits under the pivot, so the handle and forearm travel different arcs and the handle drags along the hand."),
   glows=arm_glows("Single-Arm Machine Curl", rx=0.06, ry=0.05))

SETUP["Single-Arm Machine Curl"] = [
    "Set the seat so your working elbow lines up with the pivot.",
    "Sit with your chest to the pad, the back of the working arm on it.",
    "Take the handle underhand in one hand; rest the other arm on the pad.",
    "Start with the working arm almost straight.",
]

# ---------------------------------------------------------------- cable preacher curl

ex(name="Cable Preacher Curl", var="cablePreacherCurl",
   # Seen from the front-right, the lifter facing right: the back, chest
   # and near shoulder on the left, the near elbow's label below them; the
   # hands, bar and cable on the right, the grip label below the bar's
   # lowest point so no pill covers a hand at the bottom. The pad label is
   # short so it ends clear of the back of the head and, in the turned pad
   # still, of the ghost's near shoulder.
   overrides={"pad": (0.14, "leading"), "top": (0.14, "trailing"), "grip": (0.56, "trailing"),
              "torso": (0.50, "leading"), "range": (0.68, "leading")},
   annotations=[
       ("pad", "Arms on pad", "upper_arm_R"),
       ("range", "Lower to almost straight", "forearm_R"),
       ("top", "Curl all the way up", "hand_L"),
       ("grip", "Underhand, wrists straight", "hand_R"),
       ("torso", "Chest on the pad", "chest"),
   ],
   cues={
       "pad": PAD_BOTH,
       "range": ("Range of Motion",
                 "Every rep starts from almost straight arms.",
                 "Lowering until the arms are almost straight works the elbow flexors through nearly their whole range, and full-range curl training has built more strength than partial reps.",
                 "Short reps that stop with the elbows still well bent at the bottom.",
                 "Lower under control until the arms are almost straight, keeping the plates off the stack, then curl again without bouncing."),
       "top": ("Top of the Curl",
               "Each rep finishes with the forearms near upright.",
               "With the cable running down to a low pulley in front, the pull on the elbows stays heavy all the way to the top, where a barbell on the same bench goes light. Stopping halfway gives up the part of the rep that sets the cable apart.",
               "Stopping each rep halfway up, the forearms still well short of upright.",
               "Curl until the forearms are close to upright and the bar is near the chin, pause briefly, then lower under control."),
       "grip": ("Grip and Wrists",
                "An underhand grip about shoulder-width apart, wrists straight.",
                "With the palms turned up the biceps does more of the lifting than with other grips. Curling the wrists in moves the bar with the wrists instead of the elbows and puts needless load on them.",
                "Curling the wrists in toward the forearms at the top of each rep.",
                "Hold the bar underhand with the hands about shoulder-width apart and keep the knuckles in line with the forearms from bottom to top."),
       "torso": ("Torso Position",
                 "The chest stays against the pad.",
                 "Rocking back uses the body's weight to start the lift and pulls the arms off the pad, so the elbow flexors skip part of the work.",
                 "Leaning back from the hips to pull the bar up, the arms coming off the pad with the chest.",
                 "Sit tall with the chest against the back of the pad and keep the torso still; only the forearms move."),
   },
   activation=[("Biceps Brachii", P, HI, 0.84), ("Brachialis", S, MOD, 0.66), ("Brachioradialis", S, LOW, 0.38)],
   stabilisers=["forearm flexors", "rotator cuff", "core"],
   comparison=("STOPPING SHORT AT THE TOP", "Forearms near upright at the top", "Reps stop halfway up",
               "The low cable keeps pulling hard to the top of the curl, so finishing each rep near upright trains the range a barbell on this bench leaves light.",
               "Stopping halfway gives up the top of the curl, where the cable still pulls hard, and turns it into a half rep."),
   glows=arm_glows("Cable Preacher Curl", near="R", far="L", rx=0.06, ry=0.05))

SETUP["Cable Preacher Curl"] = [
    "Set a preacher bench facing a low pulley, about a metre from it.",
    "Clip a straight bar to the cable.",
    "Sit with your armpits at the top of the pad, backs of the arms flat on it.",
    "Take the bar underhand, hands shoulder-width apart, arms almost straight.",
]

# ---------------------------------------------------------------- preacher hammer curl

ex(name="Preacher Hammer Curl", var="preacherHammerCurl",
   # As the Dumbbell Preacher Curl: shoulder, chest and hips on the right,
   # the forearm and dumbbell reaching out to the left over the pad; the
   # range label sits below the dumbbell's lowest point, the grip label one
   # notch above the top row, clear of the far plate at each peak. The torso
   # label sits below the rocked-back ghost's pelvis (~0.40 in the turned
   # still), and the seat label, below it, points at the near foot, so its
   # leader never crosses the torso label.
   overrides={"pad": (0.14, "trailing"), "grip": (0.10, "leading"), "torso": (0.62, "trailing"),
              "range": (0.62, "leading"), "seat": (0.74, "trailing")},
   annotations=[
       ("pad", "Arm on pad", "upper_arm_L"),
       ("range", "Lower to almost straight", "forearm_L"),
       ("grip", "Thumb up, wrist straight", "hand_L"),
       ("torso", "Chest stays on the pad", "chest"),
       ("seat", "Seat set, feet flat", "foot_L"),
   ],
   cues={
       "pad": PAD_ONE,
       "range": ("Range of Motion",
                 "The bottom half is where a dumbbell preacher curl works hardest.",
                 "With the upper arm on a 45° slope, the dumbbell pulls hardest on the elbow in the bottom half and hardly at all once the forearm is upright; on preacher curls, training the bottom half has built more strength, and at least as much muscle, as training the top half.",
                 "Stopping halfway down, so the arm never gets near straight.",
                 "Lower under control until the arm is almost straight, without letting the elbow snap straight, then curl again."),
       "grip": ("Neutral Grip",
                "Thumb up, palm facing in, wrist straight.",
                "The brachialis bends the elbow the same way whatever the grip, while the biceps works less with the palm turned in, so a larger share of the lift falls on the brachialis. Near the bottom the dumbbell sits out in front of the wrist and pulls the hand down toward the little finger.",
                "The wrist giving way near the bottom, the hand tipping down toward the little finger.",
                "Grip the middle of the handle with the thumb on top, keep the palm facing in without turning it up, and hold the wrist straight, the handle square to the forearm, from bottom to top."),
       "torso": ("Torso Position",
                 "The chest stays against the pad.",
                 "Rocking back uses the body's weight to start the lift and pulls the arm off the pad, so the elbow flexors skip the hardest part of the rep.",
                 "Leaning back from the hips to swing the weight up, the arm coming off the pad with the chest.",
                 "Sit tall with the chest against the back of the pad and keep the torso still; only the working forearm moves."),
       "seat": SEAT_ONE,
   },
   activation=[("Brachialis", P, HI, 0.76), ("Biceps Brachii", P, HI, 0.72), ("Brachioradialis", S, LOW, 0.38)],
   stabilisers=["extensor carpi radialis", "flexor carpi radialis", "rotator cuff"],
   comparison=("ARM LIFTING OFF THE PAD", "Arm stays on the pad", "Elbow lifts as the weight rises",
               "With the back of the arm on the pad, bending the elbow is the only motion, so the elbow flexors lift the dumbbell all the way up.",
               "Lifting the elbow off the pad lets the front of the shoulder help and tips the dumbbell back over the elbow, taking load off the elbow flexors at the top."),
   glows=arm_glows("Preacher Hammer Curl", rx=0.06, ry=0.05, elbow_first=True))

SETUP["Preacher Hammer Curl"] = [
    "Set the seat so your armpit rests at the top of the pad.",
    "Hold a dumbbell in one hand, thumb up, palm facing in.",
    "Lay the back of that arm flat on the pad, the other arm resting beside it.",
    "Sit tall, chest to the pad, feet flat.",
]

# ---------------------------------------------------------------- reverse preacher curl

ex(name="Reverse Preacher Curl", var="reversePreacherCurl",
   # Framed at yaw -0.8, zoom 1.0. The near plate sweeps from px 157-213,
   # y 267-357 (over the lower chest and left elbow) at the bottom to px
   # 193-253, y 139-227 (right of the face) at the top; the far plate from
   # px 15-78, y 280-357 to 47-110, y 172-247. The wrist cue points at the
   # far (right) hand, which shows between the plates, its label one notch
   # above the top row. The pad label sits below the near plate's peak
   # (a top-row pill lay over it), its leader straight up to the shoulder;
   # the bar's sleeve end passes 1-3 px left of the pill mid-rep. The left
   # elbow sits behind the near plate at the bottom and the chest joint
   # lands on that plate or the pad's corner, so range points at the far
   # elbow (short, so its leader passes left of the near fist) and torso at
   # the left hip, the hinge the body rocks about.
   overrides={"pad": (0.34, "trailing"), "wrist": (0.10, "leading"), "torso": (0.62, "trailing"),
              "range": (0.56, "leading"), "seat": (0.74, "trailing")},
   annotations=[
       ("pad", "Arms on pad", "upper_arm_L"),
       ("range", "Almost straight", "forearm_R"),
       ("wrist", "Overhand, wrists straight", "hand_R"),
       ("torso", "No rocking back", "thigh_L"),
       ("seat", "Seat set, feet flat", "foot_L"),
   ],
   cues={
       "pad": PAD_BOTH,
       "range": RANGE_BOTH,
       "wrist": ("Grip and Wrists",
                 "An overhand grip on the EZ bar's angled grips, wrists straight.",
                 "With the palms down the biceps works less, so the brachioradialis and brachialis take a larger share of the lift, while the muscles on the back of the forearm hold the wrists straight. The angled grips turn the palms in slightly from fully palm-down, which can be easier on the wrists.",
                 "The wrists giving way near the bottom, the knuckles dropping toward the floor as the bar starts up.",
                 "Hold the angled grips overhand, hands about shoulder-width apart, and keep the knuckles in line with the forearms from bottom to top."),
       "torso": ("Torso Position",
                 "The chest stays against the pad.",
                 "A palm-down grip is much weaker than palm-up, so a bar that is too heavy gets rocked up; rocking back pulls the arms off the pad and skips the hardest part of the rep at the bottom.",
                 "Leaning back from the hips to heave the bar up, the arms coming off the pad with the chest.",
                 "Pick a bar you can curl with the torso still, sit tall with the chest against the pad and move only the forearms."),
       "seat": SEAT_BOTH,
   },
   activation=[("Brachioradialis", P, MOD, 0.56), ("Brachialis", P, MOD, 0.68), ("Biceps Brachii", S, MOD, 0.62)],
   stabilisers=["wrist extensors", "finger flexors", "rotator cuff"],
   comparison=("ROCKING BACK", "Torso still, chest on the pad", "Body rocks back to start the bar",
               "A bar light enough to curl with the torso still keeps the brachioradialis and brachialis working from the bottom of every rep.",
               "The palm-down grip is far weaker than palm-up, so an overloaded bar gets rocked up, the arms leave the pad and the bottom of the rep is skipped."),
   glows=arm_glows("Reverse Preacher Curl", far="R", rx=0.06, ry=0.05, elbow_first=True))

SETUP["Reverse Preacher Curl"] = [
    "Set the seat so your armpits rest at the top of the pad.",
    "Take an EZ bar overhand on its angled grips, hands shoulder-width apart.",
    "Lay the backs of your arms flat on the pad.",
    "Sit tall, chest to the pad, feet flat.",
]

# ---------------------------------------------------------------- barbell preacher curl

ex(name="Barbell Preacher Curl", var="barbellPreacherCurl",
   # Framed at yaw -0.8, zoom 0.602 for the 2.2 m bar. The near plate sweeps
   # u 0.62-0.86, v 0.25-0.54 on the right (right of the chest at the bottom,
   # right of the head at the top) and the far plate u 0.08-0.37, v 0.33-0.53
   # on the left, so the labels stay above v 0.24 or below v 0.55. The chest
   # joint lands on the near plate's rim or the pad's corner and the pelvis
   # on the near plate at the bottom, so the torso label points at the upper
   # chest between the arms (its leader passes left of the head) and the seat
   # label at the near foot. Grip and range point at the far (right) arm,
   # which shows between the plates; the grip label, under the torso label,
   # is short so it ends left of the torso leader.
   overrides={"pad": (0.14, "trailing"), "torso": (0.14, "leading"), "grip": (0.23, "leading"),
              "range": (0.62, "leading"), "seat": (0.74, "trailing")},
   annotations=[
       ("pad", "Arms on the pad", "upper_arm_L"),
       ("range", "Arms almost straight", "forearm_R"),
       ("grip", "Wrists straight", "hand_R"),
       ("torso", "Chest on the pad", "support_PectoralisMajor_Clavicular_R"),
       ("seat", "Seat set, feet flat", "foot_L"),
   ],
   cues={
       "pad": PAD_BOTH,
       "range": RANGE_BOTH,
       "grip": ("Grip and Wrists",
                "An underhand grip at shoulder-width, wrists straight.",
                "A shoulder-width underhand grip keeps the forearms turned palm-up, the grip in which the biceps does the most work. Curling the wrists in pulls the bar back toward the elbows, which eases the top of the rep and puts needless load on the wrists.",
                "Curling the wrists in toward the forearms at the top of each rep.",
                "Hold the bar with the hands about shoulder-width apart, thumbs around it, and keep the knuckles in line with the forearms from bottom to top."),
       "torso": TORSO_BOTH,
       "seat": SEAT_BOTH,
   },
   activation=[("Biceps Brachii", P, HI, 0.84), ("Brachialis", S, MOD, 0.68), ("Brachioradialis", S, LOW, 0.36)],
   stabilisers=["forearm flexors", "rotator cuff", "core"],
   comparison=("STOPPING SHORT AT THE BOTTOM", "Lower to almost straight", "Reps stop halfway down",
               "Lowering until the arms are almost straight trains the bottom half, where the preacher curl loads the biceps most.",
               "Stopping halfway keeps every rep in the top half, where the bar moves in over the elbows and the load on the biceps falls away."),
   glows=arm_glows("Barbell Preacher Curl", far="R", rx=0.05, ry=0.04))

SETUP["Barbell Preacher Curl"] = [
    "Set the seat so your armpits rest at the top of the pad.",
    "Take the barbell underhand, hands shoulder-width apart.",
    "Lay the backs of your arms flat on the pad.",
    "Sit tall, chest to the pad, feet flat.",
]

if __name__ == "__main__":
    probs = validate(["Single-Arm Machine Curl", "Cable Preacher Curl", "Preacher Hammer Curl", "Reverse Preacher Curl", "Barbell Preacher Curl"]); print("\n".join(probs) or "OK")
