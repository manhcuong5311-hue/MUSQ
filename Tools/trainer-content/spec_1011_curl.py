# Trainer content for the Desktop "100-200" folder (2026-10-11), family:
# curl. The folder's one new exercise: 237 Concentration Curl
# (Biceps/ConcentrationCurl). Same format as spec.py on top of
# common_1_50.py; spec_1011.py imports this module and gen.py reads SPEC /
# SETUP. notes_1011_curl.md maps the copy's claims to the sources below and
# records the model facts.
#
# What the model shows, measured from the rig with Blender's Python + pxr
# (the lab's $LAB/r1011/curl/ in the session scratchpad: rig.py, a reader of
# joint transforms, equipment bounds and UsdSkel-skinned mesh points;
# reps.py, geo.py, contact.py, c2.py, palm.py, lever.py, top.py; proj.py and
# overlay.py for the trainer framing; ghost.py, a port of FaultGhost.solve),
# the motion brief ($LAB/r1011/briefs/ConcentrationCurl.md), tiers31_new.json
# and joints.json. The app's frame: Y up, the lifter faces +z, their left is
# +x. One body: neck to pelvis 0.584 m, upper arm 0.288 m, forearm 0.250 m,
# shoulder joints 0.39 m apart.
# - 7.96 s at 24 fps, two identical 4 s reps. Only the LEFT arm curls: elbow
#   140°, leaving it at ~0.3 s, within 1° of 48° from ~1.29 s to ~2.08 s,
#   back within 1° of 140° by ~3.58 s: up ~1.0 s, held ~0.8 s (within 0.3°
#   of 48° from 1.33 to 2.04 s), down ~1.5 s. The arm never straightens:
#   the bottom is 40° short of straight.
# - Seated on an adjustable bench set flat (both pads level, top 0.468 m up),
#   sitting across its width at the junction of the seat and back pads, the
#   hip joints 11 cm above the pad. Feet flat (heels and toes on the floor),
#   ankle joints 0.66 m apart (shoe inner edges 0.54 m), toes turned a little
#   out, knees 121°. The trunk leans 63° forward of vertical (the upper back
#   rounded over the lower), still to the millimetre all clip, the head in
#   line with it.
# - The left upper arm hangs almost straight down, 16° from vertical (the
#   elbow 8 cm behind and 2 cm inside the shoulder joint), still all clip
#   (elbow joint within 0.5 mm). The skinned triceps rests on the inner thigh
#   (vastus medialis and sartorius, 0.2-0.8 cm) just above the knee: the
#   elbow joint is 8.5 cm above and 8.6 cm inside the knee joint. The
#   dumbbell's handle runs side to side, gripped in the middle; the palm stays
#   within 10° of fully up (turned toward the biceps) and the wrist straight
#   (0°) all rep, so nothing turns. At the bottom the forearm points 65° below
#   level, down and forward, and the dumbbell hangs between the feet, 1.2 cm
#   inside the left lower leg at calf height. At the top the forearm is 26°
#   above level and the dumbbell sits under the chin (its nearest point 8 cm
#   from the head mesh, its top 3.5 cm below the chin's lowest point), its
#   centre 22 cm in front of and 13 cm below the shoulder joint.
# - The right hand is cupped over the right knee (the skinned hand touches
#   the vastus, sartorius and gastrocnemius round it), the right elbow
#   pointing out to the side (elbow 69°), still all clip.
# - Load (the dumbbell's lever arm about the elbow: horizontal distance from
#   the elbow joint to the handle's centre, as a share of its peak): 0.42 at
#   the bottom, peak as the forearm passes level (elbow 72-77°), 0.90 at the
#   top, where the hold is.
# - Paint (tiers31_new.json): bright BicepsBrachii_LongHead,
#   BicepsBrachii_ShortHead, Brachialis -> PRIMARY "Biceps Brachii" and
#   "Brachialis"; dim Brachioradialis and the wrist and finger flexors and
#   extensors (ECRB, ECRL, ECU, ED, FCR, FDP, FDS, PL) -> SECONDARY
#   "Brachioradialis" and one "Forearms" row, as the 500 curls group them.
# - Framed at yaw -1.2, zoom 1.03 from the front-left: the lifter faces the
#   left of the screen, the working arm on the near side.
#
# How it differs from the library: the Dumbbell Preacher Curl and the
# Single-Arm Machine Curl rest the arm on a sloped pad in front of an
# upright trunk; the Spider Curl hangs both arms from a chest pad; the
# Alternating Dumbbell Curl stands with the elbows at the sides. Here the
# lifter sits and leans forward, and the upper arm hangs almost straight
# down braced against the inner thigh, one arm, palm up all rep, from a bent
# elbow (140°) to the dumbbell under the chin.
#
# Sources (read 2026-10-11; details and quotes in notes_1011_curl.md):
# - Young S, Porcari JP, Camic C, Kovacs A, Foster C. ACE study reveals best
#   biceps exercises. ACE ProSource, August 2014 (ACE-sponsored, not peer
#   reviewed; PDF read, Figure 1 read off the chart). 16 volunteers (8 men, 8
#   women, 18-24, some weightlifting experience), 70% of 1RM, EMG normalised
#   to an isometric one-arm cable curl: the concentration curl drew
#   significantly more biceps activity (~97% MVC) than the other seven
#   exercises (cable curl ~81, chin-up ~80, barbell curl ~77, EZ curls ~75 and
#   ~72, incline ~71, preacher ~69); its anterior deltoid activity was
#   significantly lower than the barbell curl's; the authors' explanation:
#   "the humerus is pressed against the leg and does not allow the upper arm
#   to sway". https://www.acefitness.org/certifiednews/images/article/pdfs/ACE%20BicepsStudy.pdf
# - ExRx.net, Dumbbell Concentration Curl (Wayback snapshot 2022-10-05;
#   the live site returns 403): sit on bench, grasp the dumbbell between the
#   feet, back of the upper arm to the inner thigh, lean into the leg to
#   raise the elbow slightly; raise the dumbbell to the front of the
#   shoulder; lower until the arm is fully extended (the model stops 40°
#   short; the copy follows the model); continue with the opposite arm.
#   Target brachialis; synergists biceps brachii, brachioradialis;
#   stabilisers upper and middle trapezius, levator scapulae, obliques,
#   erector spinae, wrist flexors.
# - Polish A, Concentration Curl, BarBend (last updated 2024-11-27): knees
#   far apart, the triceps braced against the inner thigh and the upper arm
#   kept as close to perpendicular to the ground as possible; do not wedge
#   the elbow into the knee; hold the free hand out to counterbalance, or
#   grip the right knee or the bench (the model grips the knee); hold a
#   strong contraction for a beat at the top; stop the curl once the
#   triceps starts losing touch with the leg rather than muscling the
#   dumbbell up to the shoulder; lower with slow control to full extension
#   (the model stops 40° short; the copy follows the model); progress only
#   without unnecessary momentum, and a dumbbell that crashes down is too
#   heavy.
# - StrengthLog, Concentration Curl (strengthlog.com/concentration-curl):
#   sit on a bench, lean the elbow onto the inside of the leg, curl, lower;
#   primary biceps, secondary forearm flexors.
# - Coratella G, Tornatore G, Longo S, Toninelli N, Padovan R, Esposito F,
#   Ce E 2023, Sports 11(3):64, doi:10.3390/sports11030064, PMID 36976950
#   (as verified for the 500 curls): ten competitive bodybuilders, curls at
#   8RM: biceps excitation greater supinated than neutral (+12%) or pronated
#   (+19%) in the lifting phase; "biceps brachii is a supinator".
# - Schoenfeld BJ, Ogborn DI, Vigotsky AD, Franchi MV, Krieger JW 2017,
#   J Strength Cond Res 31(9):2599-2608, doi:10.1519/JSC.0000000000001983,
#   PMID 28486337: 15 studies; eccentric training grew muscle as much as
#   concentric or slightly more (10.0% vs 6.8%; effect size difference not
#   significant, p = 0.076).
# - Schoenfeld BJ, Ogborn DI, Krieger JW 2015, Sports Med 45(4):577-585,
#   doi:10.1007/s40279-015-0304-0, PMID 25601394: repetition durations of
#   0.5-8 s built similar muscle in sets to failure (8 studies).
# - StrengthLog, Dumbbell Curl (strengthlog.com/dumbbell-curl): keep the
#   wrists straight; bent, they can take an unnecessary load.
# - Mogk JPM, Keir PJ 2003, Ergonomics 46(9):956-975,
#   doi:10.1080/0014013031000107595, PMID 12775491: gripping works the
#   forearm flexors and extensors; a flexed wrist cut grip force 40-50%.
# - Kawakami Y, Nakazawa K, Fujimoto T, Nozaki D, Miyashita M, Fukunaga T
#   1994, Eur J Appl Physiol 68(2):139-147, doi:10.1007/BF00244027, PMID
#   8194543: MRI estimate, brachialis 47%, biceps 34%, brachioradialis 19% of
#   maximal elbow-flexor torque (a capacity estimate; activation rows only).
# - Boland MR, Spigelman T, Uhl TL 2008, J Hand Surg Am 33(10):1853-1859,
#   doi:10.1016/j.jhsa.2008.07.019, PMID 19084189: the brachioradialis is
#   active in elbow flexion whatever the forearm position.
# No peer-reviewed EMG study of the concentration curl's activation levels
# was found (Europe PMC, "concentration curl", 2026-10-11: the hits use it
# for wearables, a fat-grip study and a perceived-activation study without
# per-muscle values for it). Every fraction is a judgement call anchored on
# the ACE ranking and the library's curls (see the notes).
from common_1_50 import *


def ov(final):
    """Pre-squeeze override row for an on-screen row (spec_1011.row() maps
    0.14-0.86 to 0.16-0.80)."""
    return round(0.14 + (final - 0.16) * (0.86 - 0.14) / (0.80 - 0.16), 4)


N = "Concentration Curl"
ex(name=N, var="concentrationCurl",
   # Front-left at yaw -1.2: the lifter faces left, folded over the thighs;
   # the dumbbell sweeps the left of the frame from under the near knee
   # (bottom) to under the chin (top), so no pill sits on the left between
   # ~0.30 and ~0.64. The upper-arm pill sits above the head on the left,
   # the trunk pill above the back on the right (below the eye button), the
   # two elbow pills on the right over the static bench, the wrist pill at
   # the bottom left below the dumbbell's lowest point.
   overrides={"elbow": (ov(0.12), "leading"), "torso": (ov(0.19), "trailing"),
              "top": (ov(0.53), "trailing"), "lower": (ov(0.63), "trailing"),
              "wrist": (ov(0.78), "leading")},
   annotations=[
       ("elbow", "Upper arm on inner thigh", "upper_arm_L"),
       ("torso", "Chest stays forward", "spine"),
       ("top", "Pause at the top", "forearm_L"),
       ("lower", "Lower slowly", "forearm_L"),
       ("wrist", "Wrist straight", "hand_L"),
   ],
   cues={
       "elbow": ("Arm on the Thigh",
                 "The back of your upper arm rests on your inner thigh, just above the knee, and stays there.",
                 "Pressed against the leg, the upper arm cannot sway, so bending the elbow is the only motion. In one study of eight biceps exercises, this curl drew the most biceps activity, with less front-shoulder activity than the barbell curl; the researchers suggested the pinned upper arm was the reason.",
                 "The elbow lifting off the thigh and swinging forward as the dumbbell rises, so the shoulder helps lift it.",
                 "Press the back of your upper arm into your inner thigh, let it hang almost straight down and move only your forearm."),
       "torso": ("Trunk Position",
                 "Your chest stays leaning well forward over your thighs; only your forearm moves.",
                 "Sitting up or rocking back as you curl swings the dumbbell up with your trunk and pulls the arm off the thigh, so your trunk does part of the work through the middle of the curl, where the dumbbell pulls hardest. Needing to rock is a sign the weight is too heavy.",
                 "Sitting up and rocking the trunk back to heave the dumbbell past the middle of the curl.",
                 "Lean forward over your thighs, brace your free hand on your right knee and keep your chest still from the first rep to the last."),
       "top": ("Top of the Curl",
               "Curl until the dumbbell is just under your chin, then hold it there for a moment.",
               "With the upper arm hanging down, the dumbbell pulls hardest as the forearm passes level and still at about nine-tenths of that at the top, so the last part of the curl is still hard work; stopping at level leaves it out.",
               "Turning each rep round with the forearm at or just below level, well short of the top.",
               "Curl toward the front of your shoulder until the dumbbell is just under your chin, your upper arm still on your thigh, pause for a beat, then lower."),
       "lower": ("Lowering",
                 "Lower the dumbbell more slowly than you lifted it.",
                 "The lowering half trains the biceps as well: in a review of training studies, lowering-only work built as much muscle as lifting-only work, or slightly more. With sets taken to failure, rep durations from half a second to eight seconds built similar muscle, so lower under control rather than to a slow count.",
                 "Letting the dumbbell drop so the arm snaps straight at the bottom.",
                 "Take about a second to curl up and about one and a half to lower, stopping with your elbow still bent and the dumbbell just inside your left lower leg."),
       "wrist": ("Grip and Wrist",
                 "Your forearm stays turned palm-up from bottom to top, the wrist straight.",
                 "The biceps both bends the elbow and turns the palm up, and in competitive bodybuilders it has worked harder in palm-up curls than in palm-in or palm-down ones. Letting the wrist curl in draws the dumbbell back toward the elbow, so the top of the rep gets easier, and a bent wrist can take an unnecessary load.",
                 "Curling the wrist in toward the forearm as the dumbbell nears the top.",
                 "Hold the handle firmly in the middle, palm up, and keep your knuckles in line with your forearm from the bottom to the top."),
   },
   # Paint: biceps and brachialis bright (PRIMARY), brachioradialis and the
   # forearm muscles dim (SECONDARY). Biceps 0.92, a step above the
   # library's Barbell Curl (0.90), on the ACE ranking (concentration curl
   # ~97% MVC, significantly above the barbell curl's ~77%; not peer
   # reviewed). Brachialis 0.72, the house value for a bright brachialis
   # (Machine Preacher Curl, the 500 curls; ExRx lists it as the target,
   # with no EMG). Brachioradialis 0.44 as the 1-50 Dumbbell Curl (a palm-up
   # dumbbell curl; Boland 2008), Forearms 0.30 as the library's curls (they
   # grip the dumbbell; Mogk and Keir 2003). Judgement calls.
   activation=[("Biceps Brachii", P, HI, 0.92), ("Brachialis", P, HI, 0.72),
               ("Brachioradialis", S, MOD, 0.44), ("Forearms", S, LOW, 0.30)],
   stabilisers=["erector spinae", "obliques", "upper trapezius", "middle trapezius"],
   comparison=("ELBOW OFF THE THIGH", "Upper arm pinned to the thigh", "Elbow swings forward off it",
               "The thigh holds the upper arm in place, so the dumbbell rises only as the elbow bends and the elbow flexors do the lifting.",
               "When the elbow comes off the thigh and swings forward, the shoulder starts to help lift and the curl loses the brace that makes it strict."),
   glows=[glow(N, ["upper_arm_L", "forearm_L"], A, 0.55, 0.05, 0.07),
          glow(N, ["forearm_L"], SOFT, 0.28, 0.04, 0.05)])

SETUP[N] = [
    "Sit on a flat bench, feet flat and wider than your shoulders.",
    "Pick up a dumbbell in your left hand, palm facing forward.",
    "Lean forward and rest the back of your upper arm on your inner thigh, just above the knee.",
    "Brace your right hand on your right knee, the dumbbell hanging just inside your left lower leg.",
    "Do every rep with the left arm, then switch sides.",
]
