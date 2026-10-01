# Trainer content for the 1-50 redo (2026-09-29), family: curls. Five new
# exercises from the HIKSEMI drive's "1-100 🟢" folder: 42 Dumbbell Curl,
# 44 Incline Dumbbell Curl, 45 Preacher Curl, 46 Cable Curl and 47 Bayesian
# Cable Curl (models Biceps/<Name>.usdc). Same format as spec.py;
# spec_1_50.py imports this module and gen.py reads SPEC / SETUP.
#
# What each model shows, from the briefs (briefs_1_50/<Resource>.md), the
# trainer stills at 0/1/2/3/5 s, the highlight tiers and the rig and
# equipment read from the USD (Blender's Python + pxr; the app's Y-up space,
# the lifter facing +z; torso, neck to pelvis, 0.592 m; one body shared by
# all five). Every clip is two identical 4 s reps: ~1.25 s up, the top held
# ~0.6 s (1.25-1.9 s), ~2 s down, a short rest at the bottom. "Load" below is
# the weight's or cable's turning effect on the elbow (the handle's lever arm
# about the elbow across the line of pull, from the handle prim's centre to
# the pulley exit), as a share of its peak in that clip.
# - Dumbbell Curl (DumbbellCurl): standing tall, feet parallel ~0.28 m apart,
#   knees straight (179°), trunk 4° back and still. A plate-loaded dumbbell
#   in each hand, handles side to side: palms facing forward with the arms
#   hanging, turned up toward the shoulders at the top (underhand for the
#   whole rep, no turn). Both arms curl together; elbows 180° (fully
#   straight) -> 68°; the elbows stay put (within 1 cm), upper arms 7°
#   forward and 15° out from the trunk. The top stops with the forearms ~30°
#   above level, the dumbbells in front of the chest (~8 cm below the
#   shoulders, ~0.33 m in front). Wrists straight (0-4°). Load: 0.25 of peak
#   at the bottom, peak with the forearms level, 0.81 at the top. Framed at
#   yaw -0.4 (front, the left arm on the right of the screen), like the
#   Biceps Curl. It is the gated Biceps Curl's motion almost exactly (same
#   timing, grip and elbow path); the Biceps Curl model stops at 172° and
#   60° with the trunk upright. It differs from the Alternating Dumbbell Curl
#   (palms in at the start, turned up on the way, one arm at a time).
# - Incline Dumbbell Curl (InclineDumbbellCurl): seated on an incline bench
#   (EX_44 seat and back pad; the pad slopes 65° from the floor, 0.38 m
#   wide, its top edge level with the shoulders, no head rest), trunk 25°
#   back from vertical against it, feet flat in front (knees ~114°). Two
#   dumbbells, palms forward with the arms hanging, turned up at the top.
#   The upper arms hang straight down (vertical) beside the pad, so they sit
#   25° behind the line of the trunk (shoulder extended) and stay there
#   (elbows fixed within 1 cm); elbows 172° -> 60°, the forearms ~29° above
#   level at the top, the dumbbells in front of the chest. Load: 0.19 of peak
#   at the bottom, peak with the forearms level, 0.84 at the top. Framed at
#   yaw -0.9 from the front-left: the feet on the left, the near (left) arm
#   hanging on the right beside the pad; the far arm hangs behind the trunk
#   at the bottom.
# - Preacher Curl (PreacherCurl): an EZ bar with plates on a preacher bench
#   with two separate arm pads (EX_45), one under each upper arm, their tops
#   sloping 35° from the floor on a post and cross brace. Seated upright
#   (trunk 0°, no chest pad; knees ~116°, hips ~111°, feet flat ~0.44 m
#   apart). The upper arms lie 45° below horizontal over the pads, touching
#   them near the elbows, the armpits just above their top edges. Underhand
#   on the bar's inner angled grips, hands ~0.52 m apart (the shoulder joints
#   are 0.40 m apart), palms turned ~40° in from fully up. Both arms curl
#   together, elbows 164° -> 66° (forearms from 32° below level to 68°
#   above; the bar near the chin at the top). Load: 0.90 of peak at the
#   bottom, peak with the forearms level, 0.17 at the top. Framed at yaw -0.8
#   from the front-left: the near (left) arm and plate on the right.
# - Cable Curl (CableCurl): standing between two cable columns (EX_46) whose
#   low pulleys sit ~0.94 m in front of the ankles, 0.62 m either side of
#   the midline, ~13 cm off the floor. A D-handle in each hand, underhand
#   (palms forward with the arms hanging, up at the top); both arms curl
#   together, elbows 172° -> 60°, upper arms 3° forward and 15° out, fixed.
#   Trunk leaning 10° back all rep and still, knees straight, feet parallel
#   ~0.28 m apart. The cables run forward, down and out to the pulleys, ~36°
#   below horizontal at the start, ~53° at the top; the stacks stay 4-5 cm
#   off their rests at the bottom. Load: at the bottom the cable runs above
#   the forearm's line and tips the hands forward (-0.47 of peak: it does
#   not resist the curl there, down to ~150°); peak from ~100° to the top,
#   0.98 at the top. The cables' pull on the shoulders is forward at the
#   bottom and down and back at the top. Framed from the left side (yaw
#   -1.4), facing screen-left, the cables running off the left edge.
# - Bayesian Cable Curl (BayesianCableCurl): standing tall with the back to
#   one cable column (EX_47) behind and to the left, its low pulley ~0.8 m
#   behind the heels and 0.62 m left of centre, ~13 cm off the floor. Feet
#   parallel ~0.28 m apart, knees straight, trunk upright and still. Only the
#   LEFT arm works: a D-handle underhand (palm forward with the arm drawn
#   back, up toward the shoulder at the top); the left upper arm is held 23°
#   behind the trunk (shoulder extended) all rep; elbow 172° -> 45°, the
#   hand finishing in front of the left chest. The right arm hangs at the
#   side, empty, palm in. The cable runs back and down to the pulley; the
#   stack stays ~2 cm off its rest at the bottom. Load: 0.45 of peak with the
#   arm almost straight behind (a dumbbell curl's is 0.25 there), peak at
#   ~110-130°, 0.45 at the top. Framed from the left (yaw -1.2), facing
#   screen-left; the column is off to the right behind the lifter.
#
# Highlight tiers (highlight_tiers.json): in all five the biceps (long and
# short heads) are bright = PRIMARY; the brachialis, brachioradialis and the
# wrist and finger flexors and extensors (FCR, PL, FDS, FDP, ECRL, ECRB,
# ECU, ED) dim = SECONDARY. The forearm muscles go in one "Forearms" row: the
# legend lists the secondaries on one line, and "Forearm Flexors" plus a
# separate extensor row would run past the viewport's width. Only the biceps
# value differs by source (Parpa 2025 for the Bayesian); the brachialis (0.66)
# and forearms (0.30) are one house value for all five, and the
# brachioradialis 0.44 in all but the preacher curl, which keeps the app's
# preacher value (0.38; Barbell/Dumbbell Preacher 0.36, Cable Preacher 0.38):
# no study here compares these curls with each other for those muscles.
#
# Sources (abstracts read on Europe PMC, 2026-09-29; full texts where noted,
# re-checked 2026-09-30; details in notes_1_50_curls.md):
# - Oliveira LF, Matta TT, Alves DS, Garcia MAC, Vieira TMM 2009, J Sports
#   Sci Med 8(1):24-29, PMID 24150552 (full text PMC3737788) — 22 men in
#   strength training for at least a year: biceps long-head EMG in the
#   standing (DBC), incline (IDC) and preacher (DPC) dumbbell curls; the DBC
#   and IDC loaded the biceps through the whole range (up to 95% of max RMS
#   in the final phase), the DPC only near extension (80% at the start); the
#   IDC's shoulder hyperextension "stretches the long head of biceps brachii
#   muscle beyond its optimal length, leading to an inefficient actin-myosin
#   coupling", and the IDC and DBC gave "similar patterns of biceps brachii
#   activation for the whole range of motion" (so no activation advantage is
#   claimed for the incline).
# - Coratella G, Tornatore G, Longo S, Toninelli N, Padovan R, Esposito F,
#   Cè E 2023, Sports 11(3):64, doi:10.3390/sports11030064, PMID 36976950
#   (full text PMC10054060) — ten bodybuilders, standing bilateral curls at
#   8RM on a cable tower (a 42.5 cm bar for the supinated and pronated grips,
#   a rope for the neutral grip, the arms parallel to the trunk):
#   lifting-phase biceps excitation greater supinated than pronated (+19%) or
#   neutral (+12%); brachioradialis also greater supinated (+5%, +6%);
#   anterior deltoid greater with the pronated and neutral grips.
# - Coratella G, Tornatore G, Longo S, Esposito F, Cè E 2023, J Funct Morphol
#   Kinesiol 8(1):13, doi:10.3390/jfmk8010013, PMID 36810497 (full text
#   PMC9944112) — ten bodybuilders, straight vs EZ barbell, the arms flexed
#   forward (~30°) or not: the straight bar gave +1.8% biceps excitation over
#   the EZ bar (arms still, lifting phase); "The anterior deltoid was more
#   excited when flexing vs. not flexing the arms", and biceps excitation in
#   the lifting phase also rose with the arms flexed (+17.7% straight bar,
#   +20.3% EZ bar), so the copy never says the biceps drop out.
# - Marcolin G, Panizzolo FA, Petrone N et al. 2018, PeerJ 6:e5165,
#   doi:10.7717/peerj.5165, PMID 30013836 — twelve participants at 65% 1RM:
#   EZ-bar curls drew more biceps and brachioradialis activity than dumbbell
#   curls; the difference between straight and EZ bars was small, "a matter
#   of subjective comfort".
# - Pinto RS, Gomes N, Radaelli R, Botton CE, Brown LE, Bottaro M 2012, J
#   Strength Cond Res 26(8):2140-2145, doi:10.1519/JSC.0b013e31823a3b15,
#   PMID 22027847 — 40 young men with no resistance training experience,
#   bilateral barbell preacher curl, full range (0-130°) vs partial (50-100°),
#   10 weeks, 1RM tested over the full range: full range raised the 1RM more
#   (25.7% vs 16.0%); muscle thickness rose in both (hence "in new lifters"
#   and no muscle claim).
# - Pedrosa GF et al. 2023, Sports 11(2):39, doi:10.3390/sports11020039,
#   PMID 36828324 — 19 untrained young women, seated dumbbell preacher curl,
#   one arm each: the initial range (0-68°) gave a larger 1RM gain and more
#   distal biceps CSA than the final range (68-135°); CSA at 50% and summed
#   CSA similar.
# - Sato S et al. 2021, Front Physiol 12:734509, doi:10.3389/fphys.2021.734509,
#   PMID 34616309 — 32 non-resistance-trained young adults, one-arm dumbbell
#   curls on a preacher bench (45° shoulder flexion): 0-50° built more
#   strength and muscle thickness than 80-130°.
# - Nunes JP et al. 2020, Int J Environ Res Public Health 17(16):5859,
#   doi:10.3390/ijerph17165859, PMID 32823490 — cable preacher curl (torque
#   highest with the elbows flexed) vs barbell preacher curl (highest near
#   extension): similar biceps growth (7% vs 8%); the barbell group gained
#   more strength only at 20° of flexion.
# - Attarieh P, Nunes JP, Khani S et al. 2025, Eur J Sport Sci 25(4):e12279,
#   doi:10.1002/ejsc.12279, PMID 40082069 — one-arm cable curls, preacher vs
#   Bayesian, resistance profiles matched: similar biceps and brachialis
#   growth and strength.
# - Larsen S, Sandvik Kristiansen B, Østerås Sandberg N et al. 2026, Front
#   Physiol 17:1750722, doi:10.3389/fphys.2026.1750722, PMID 41988507 —
#   cable curls with the shoulder neutral or fully extended, profiles and
#   range matched: no meaningful difference in elbow-flexor growth.
# - Parpa K, Vasiliou A, Michaelides M et al. 2025, Muscles 4(4):45,
#   doi:10.3390/muscles4040045, PMID 41133617 — eleven volunteers at 80% of
#   each lift's 1RM: the dumbbell curl drew more biceps EMG than the
#   Bayesian cable curl (111% vs 93% MVC).
# - Kleiber T, Kunz L, Disselhorst-Klug C 2015, Front Physiol 6:215,
#   doi:10.3389/fphys.2015.00215, PMID 26300781 — the brachioradialis took a
#   larger share only with the hand pronated.
# - Boland MR, Spigelman T, Uhl TL 2008, J Hand Surg Am 33(10):1853-1859,
#   doi:10.1016/j.jhsa.2008.07.019, PMID 19084189 — the brachioradialis is
#   active in elbow flexion whatever the forearm position.
# - Mogk JPM, Keir PJ 2003, Ergonomics 46(9):956-975,
#   doi:10.1080/0014013031000107595, PMID 12775491 — gripping works the
#   forearm flexors and extensors (extensor activity generally larger at low
#   to mid grip forces); a flexed wrist cut maximum grip force by 40-50%.
# - Signorile JF, Rendos NK, Heredia Vargas HH et al. 2017, J Strength Cond
#   Res 31(2):313-322, doi:10.1519/JSC.0000000000001493, PMID 28129277 —
#   biceps curl on a cable machine vs a selectorised machine: more pectoralis
#   major and anterior deltoid activity on the cable (the external obliques
#   differed only in the chest and overhead presses, not the curl).
# - Young S, Porcari JP, Camic C, Kovacs A, Foster C 2014, ACE ProSource
#   (August), ACE-sponsored, not peer-reviewed — of eight curls (cable,
#   barbell, concentration, chin-up, EZ wide and narrow, incline, preacher;
#   no standing dumbbell curl), the incline and preacher curls drew
#   significantly less brachioradialis activity than the narrow-grip EZ curl;
#   no other brachioradialis comparison is reported.
# - ExRx.net exercise pages (live site returns 403; read from the Wayback
#   Machine, snapshots of 2022-05-18 and 2022-08-15): Dumbbell Curl
#   (WeightExercises/Biceps/DBCurl) stabilisers Deltoid, Anterior; Trapezius,
#   Upper; Trapezius, Middle; Levator Scapulae; Wrist Flexors. Dumbbell
#   Incline Curl (DBInclineCurl) stabilisers Deltoid, Anterior; Wrist Flexors.
# - Basmajian JV, Latif A 1957, J Bone Joint Surg Am 39-A(5):1106-1118,
#   doi:10.2106/00004623-195739050-00011, PMID 13475410 — the classic
#   fine-wire EMG study of the elbow flexors: the brachialis flexes the elbow
#   whatever the forearm position (read through secondary summaries; used
#   only for the brachialis's secondary row).
# - Date S, Kurumadani H, Nakashima Y et al. 2021, Front Physiol 12:809422,
#   doi:10.3389/fphys.2021.809422, PMID 35002781 — six men, unloaded elbow
#   flexion, surface vs fine-wire EMG: the brachialis has a different EMG
#   pattern from the biceps' long and short heads (activation row only).
# - Sands WA, Wurth JJ, Hewit JK 2012, NSCA Basics of Strength and
#   Conditioning Manual, p. 46 (EZ-Bar Curl; PDF read 2026-09-29): supinated
#   grip about shoulder-width, stand erect with the feet hip-width apart,
#   elbows completely extended at the start, slow controlled return; keep
#   the elbows at the sides, avoid rolling the shoulders forward, avoid
#   momentum.
# - StrengthLog exercise guides (fetched 2026-09-29): Dumbbell Curl (keep the
#   upper arms at your sides or slightly forward; forward movement shifts
#   load to the front delts; keep the wrists straight; if you start to
#   swing, remove weight), Incline Dumbbell Curl (arms hang straight down;
#   the biceps work at longer lengths because they start on the shoulder
#   blade), Barbell Preacher Curl (the top of the pad under the armpits,
#   feet flat, wrists straight, no swinging), Cable Curl (bar on the low
#   pulley, take a step back, keep the upper arm still or slightly
#   forward), Bayesian Curl (low pulley, back to the machine, arm extended
#   behind, upper arm stationary; it also has the torso leaning slightly
#   forward, which this model does not do).
from common_1_50 import *

# ---------------------------------------------------------------- shared text

FULL_RANGE = "in new lifters, full-range curl training has built more strength than mid-range partial reps"

GRIP_WHY = ("In trained lifters, curls with the palms turned up have worked the biceps harder than palm-in or "
            "palm-down curls. Curling the wrists in moves the weight with the wrists instead of the elbows, and a "
            "bent wrist grips far more weakly.")

def act(biceps, brachioradialis=0.44):
    """Biceps from the sources per exercise; the brachialis and forearm values
    are one house value for all five (no source separates them), and the
    brachioradialis one value except on the preacher curl (see the notes)."""
    return [("Biceps Brachii", P, HI, biceps), ("Brachialis", S, MOD, 0.66),
            ("Brachioradialis", S, MOD if brachioradialis >= 0.40 else LOW, brachioradialis),
            ("Forearms", S, LOW, 0.30)]


def arm_glows(name, near, far=None, rx=0.06, ry=0.07):
    """The biceps (mid upper arm, shoulder to elbow) of each working arm at
    full strength, and softer, the brachialis and brachioradialis at the near
    elbow."""
    g = [glow(name, [f"upper_arm_{near}", f"forearm_{near}"], A, 0.55, rx, ry)]
    if far:
        g.append(glow(name, [f"upper_arm_{far}", f"forearm_{far}"], A, 0.55, rx, ry))
    g.append(glow(name, [f"forearm_{near}"], SOFT, 0.28, rx * 0.75, ry * 0.75))
    return g


# ---------------------------------------------------------------- dumbbell curl

ex(name="Dumbbell Curl", var="dumbbellCurl",
   # Front-on (yaw -0.4): the dumbbells hang at rows ~0.44-0.54 out to the
   # screen edges at the bottom and sweep up to ~0.21-0.33 at the top, and
   # the hanging arms fill rows 0.25-0.47 at both sides, so the pills sit on
   # the top row (short, clear of the head) and below the dumbbells beside
   # the legs. Simulator QA 2026-09-30: "Straight arms" (near hand) sat
   # below "No body swing" (near hip), so its leader ran through that pill's
   # text; swapped, the hip's leader passes left of the hand's pill. The
   # shoulder pill sits above the elbow's (0.10, 0.124 after the squeeze):
   # in the shoulder fault's view (mistake sheet up, model raised) the far
   # dumbbell's plate and the ghost's far hand tip reached into it at 0.14;
   # at 0.10 the plate clears it by ~10 pt and the ghost by ~18 pt. The left
   # top has no button above it, and the mistake banner ends ~23 pt higher.
   overrides={"shoulder": (0.10, "leading"), "elbow": (0.14, "trailing"), "grip": (0.64, "leading"),
              "range": (0.64, "trailing"), "torso": (0.82, "trailing")},
   annotations=[
       ("shoulder", "Shoulders down", "upper_arm_R"),
       ("elbow", "Elbows at sides", "forearm_L"),
       ("grip", "Wrists straight", "hand_R"),
       ("torso", "No body swing", "thigh_L"),
       ("range", "Straight arms", "hand_L"),
   ],
   cues={
       "shoulder": ("Shoulder Position",
                    "The shoulders stay down and back while the arms curl.",
                    "Shrugging brings the upper traps into the lift, and rolling the shoulders forward carries the upper arms off their fixed place, so the curl stops being an elbow-only movement.",
                    "Shoulders shrugging up and rolling forward as the dumbbells reach the top.",
                    "Set the shoulders down and back before the first rep and keep them level and still to the top of every curl."),
       "elbow": ("Elbow Position",
                 "The elbows stay by your sides; only the forearms move.",
                 "With the upper arms still, bending the elbows is the only motion, so the elbow flexors lift the dumbbells. Letting the elbows drift forward brings the front deltoids in and turns the top of the curl into a front raise.",
                 "Elbows drifting forward and up as the dumbbells rise.",
                 "Keep the elbows close to the ribs and finish each curl with the dumbbells in front of the chest, palms facing the shoulders, the elbows still at your sides."),
       "grip": ("Grip and Wrists",
                "Palms forward from the start and turned up all the way, wrists straight.",
                GRIP_WHY,
                "Wrists curling in toward the forearms as the dumbbells reach the top.",
                "Hold the handles palms-forward with the arms hanging, keep the palms turned up as they rise, and keep the knuckles in line with the forearms from bottom to top."),
       "torso": ("Body Swing",
                 "The legs and back stay out of it.",
                 "Leaning back or pushing the hips forward borrows momentum from the hips and lower back to get the dumbbells moving, so the elbow flexors skip the heaviest part of the rep, with the forearms near level.",
                 "Leaning back and pushing the hips forward to swing the dumbbells up.",
                 "Stand tall and braced, curl in about a second, pause briefly at the top and take about two seconds to lower, so each rep starts from a still body."),
       "range": ("Range of Motion",
                 "Each rep starts from straight arms.",
                 "The first part of the curl is the lightest, so it is easy to cut short. Lowering until the arms are straight takes the elbow flexors through their whole range, and " + FULL_RANGE + ".",
                 "Short reps that turn round with the elbows still bent, the dumbbells never getting back to the thighs.",
                 "Lower under control until the arms hang straight by your sides, then curl again without bouncing."),
   },
   activation=act(0.86),
   stabilisers=["anterior deltoid", "upper trapezius", "core"],
   comparison=("ELBOWS DRIFTING FORWARD", "Elbows fixed at your sides", "Elbows swing forward and up",
               "With the elbows at the sides, the elbow flexors lift the dumbbells from straight arms to the top.",
               "When the elbows travel forward, the front deltoids join in and the top of the curl turns into a front raise."),
   glows=arm_glows("Dumbbell Curl", "L", "R", rx=0.06, ry=0.07))

SETUP["Dumbbell Curl"] = [
    "Hold a dumbbell in each hand, palms facing forward.",
    "Stand tall, feet hip-width, arms straight by your sides.",
    "Draw your shoulders down and back, elbows by your ribs.",
    "Curl both dumbbells together, palms turned up.",
]

# ---------------------------------------------------------------- incline dumbbell curl

ex(name="Incline Dumbbell Curl", var="inclineDumbbellCurl",
   # From the front-left (yaw -0.9): the head top right, the trunk on the
   # pad across the middle, the thighs and feet to the left, the near arm
   # hanging beside the pad on the right. The dumbbells come up in front of
   # the chest at rows ~0.29-0.40, so the left labels sit above them or at
   # the thighs' height, the right ones below the hanging dumbbell.
   # Simulator QA 2026-09-30: "Almost straight" pointed at the near hand, and
   # from ~0.5 s to ~3.2 s its leader crossed the one from "Elbows point to
   # the floor" (the hand rises left of the elbow); both now meet at the near
   # elbow, the joint the cue is about.
   overrides={"shoulder": (0.14, "leading"), "back": (0.23, "leading"), "grip": (0.47, "leading"),
              "range": (0.70, "trailing"), "arms": (0.86, "trailing")},
   annotations=[
       ("back", "Back on the pad", "spine"),
       ("arms", "Elbows point to the floor", "forearm_L"),
       ("shoulder", "Shoulders back", "upper_arm_R"),
       ("grip", "Flat wrists", "hand_R"),
       ("range", "Almost straight", "forearm_L"),
   ],
   cues={
       "back": ("Bench and Back",
                "An incline bench, the back flat on the pad.",
                "Leaning back with the arms hanging extends the shoulders, which stretches the biceps' long head, the head that starts above the shoulder joint. That is what sets the incline curl apart; a bench set upright, or sitting up off it, leaves the arms in line with the body as in an ordinary seated curl.",
                "The bench set too upright, or sitting up off it, so the arms hang in line with the body instead of behind it.",
                "Set the back pad to about 65°, sit back with the hips at the back of the seat, and keep the back on the pad from the first rep to the last."),
       "arms": ("Upper Arm Position",
                "The upper arms hang straight down and stay there.",
                "Hanging from a reclined trunk, the upper arms sit behind the body, where the long head is stretched. Letting the elbows swing forward as the dumbbells rise gives that position up and brings the front deltoids into the lift.",
                "Elbows swinging forward as the dumbbells rise, the upper arms ending in front of the body.",
                "Let the arms hang straight down from the shoulders, elbows pointing at the floor, and move only the forearms."),
       "shoulder": ("Shoulder Position",
                    "The shoulders stay back against the pad.",
                    "Rolling the shoulders forward off the pad carries the upper arms forward with them, so they stop hanging behind the body and the long head loses its stretch.",
                    "Shoulders rolling forward off the pad as the dumbbells reach the top.",
                    "Keep the shoulder blades against the pad, chest up, and let only the forearms move."),
       "grip": ("Grip and Wrists",
                "Palms forward at the bottom and turned up all the way, wrists straight.",
                GRIP_WHY,
                "Wrists curling in toward the forearms as the dumbbells reach the top.",
                "Hold the handles palms-forward with the arms hanging, keep the palms turned up as they rise, and keep the knuckles in line with the forearms."),
       "range": ("Range of Motion",
                 "Each rep starts with the arms almost straight.",
                 "The bottom of the incline curl is where the long head is longest and the dumbbells pull least on the elbows, so it is easy to cut short. Lowering until the arms are almost straight works the elbow flexors through nearly their whole range, and " + FULL_RANGE + ".",
                 "Turning each rep round halfway down, the elbows still well bent.",
                 "Lower under control until the arms are almost straight below the shoulders, then curl again without bouncing."),
   },
   activation=act(0.86),
   stabilisers=["anterior deltoid"],
   comparison=("ELBOWS SWINGING FORWARD", "Arms hang behind the body", "Elbows swing forward",
               "With the upper arms hanging straight down from a reclined trunk, the biceps curl the dumbbells from their stretched position behind the body.",
               "When the elbows swing forward, the arms leave the stretched position behind the body and the front deltoids help lift."),
   glows=arm_glows("Incline Dumbbell Curl", "L", rx=0.05, ry=0.07))

SETUP["Incline Dumbbell Curl"] = [
    "Set the back pad of an incline bench to about 65°.",
    "Sit back, back and shoulders on the pad, feet flat.",
    "Hold a dumbbell in each hand, palms facing forward.",
    "Let your arms hang straight down, behind your body.",
]

# ---------------------------------------------------------------- preacher curl (EZ bar)

ex(name="Preacher Curl", var="preacherCurl",
   # From the front-left (yaw -0.8): the near plate sweeps the right side
   # from the chest (bottom) to beside the head (top), the far plate the left
   # from rows ~0.40-0.52 to ~0.19-0.30, and the bar crosses the frame at
   # the top, so the labels sit at the top left above the far plate and low
   # beside the legs. Simulator QA 2026-09-30: "Arms on pads" sat at 0.36,
   # in the far plate's sweep (over ~55% of the pill at 0.5-0.6 s and
   # 2.8-3.2 s), and its leader to the far elbow crossed both leaders to the
   # far hand; it now sits low left (0.80, above the far shoe), so the three
   # left leaders fan out without crossing. Grip and range swapped rows: with
   # the mistake sheet up the model rises, and at the top the far plate went
   # under a pill at 0.14, where the range fault (shown at the bottom) now
   # sits.
   overrides={"range": (0.14, "leading"), "grip": (0.62, "leading"), "pad": (0.80, "leading"),
              "torso": (0.72, "trailing"), "seat": (0.86, "trailing")},
   annotations=[
       ("pad", "Arms on pads", "forearm_R"),
       ("range", "Almost straight", "hand_R"),
       ("grip", "Wrists straight", "hand_R"),
       ("torso", "No rocking back", "thigh_L"),
       ("seat", "Seat set", "foot_L"),
   ],
   cues={
       "pad": ("Arms on the Pads",
               "The backs of the upper arms stay on the pads.",
               "The pads hold the upper arms at about 45° in front of the body, so bending the elbows is the only motion and the shoulders cannot help lift.",
               "Elbows and upper arms lifting off the pads as the bar comes up.",
               "Rest the backs of the arms on the pads with the armpits just over their top edges, and keep the elbows down on them for the whole set."),
       "range": ("Range of Motion",
                 "The bottom half is where a preacher curl works hardest.",
                 "With the upper arms on a slope, the bar pulls hardest on the elbows from almost straight to level forearms and hardly at all once they are near upright; in new lifters on preacher curls, training the lower range has built more strength, and at least as much muscle, as training the upper range.",
                 "Stopping halfway down, so the arms never get near straight.",
                 "Lower under control until the arms are almost straight, without letting the elbows snap straight, then curl again."),
       "grip": ("EZ Bar Grip",
                "Hands on the angled grips, wrists straight.",
                "The angled grips turn the palms partly in from fully up. Next to a straight bar the difference in biceps activity has been small, so the choice of bar is largely a matter of comfort. Curling the wrists in moves the bar with the wrists instead of the elbows, and a bent wrist grips far more weakly.",
                "Curling the wrists in toward the forearms at the top of each rep.",
                "Take the inner angled grips underhand, about shoulder-width apart, thumbs around the bar, and keep the knuckles in line with the forearms from bottom to top."),
       "torso": ("Torso Position",
                 "Sit tall; the torso stays still.",
                 "Rocking back uses the body's weight to start the lift and pulls the arms off the pads, so the elbow flexors skip the hardest part of the rep at the bottom.",
                 "Leaning back from the hips to heave the bar up, the arms coming off the pads.",
                 "Sit tall with the feet flat, brace the core and keep the torso upright and still; only the forearms move."),
       "seat": ("Seat Height",
                "Set the seat before the first rep.",
                "At the right height the backs of the arms lie on the pads with the shoulders relaxed; too low, the shoulders hunch up to hook the arms over them.",
                "The seat set too low, the shoulders riding up toward the ears to reach over the pads.",
                "Raise or lower the seat until the armpits sit just over the tops of the pads with the shoulders down, then plant both feet flat."),
   },
   activation=act(0.84, brachioradialis=0.38),
   stabilisers=["anterior deltoid", "core"],
   comparison=("STOPPING SHORT AT THE BOTTOM", "Lower to almost straight", "Reps stop halfway down",
               "Lowering until the arms are almost straight trains the bottom half, where the preacher curl loads the biceps most.",
               "Stopping halfway keeps every rep in the top half, where the bar moves in over the elbows and the load on the biceps falls away."),
   glows=arm_glows("Preacher Curl", "L", "R", rx=0.05, ry=0.05))

SETUP["Preacher Curl"] = [
    "Set the seat so your armpits sit just over the arm pads.",
    "Take an EZ bar underhand on its angled grips, about shoulder-width.",
    "Rest the backs of your upper arms on the pads, arms almost straight.",
    "Sit tall with both feet flat.",
]

# ---------------------------------------------------------------- cable curl (two low pulleys in front)

ex(name="Cable Curl", var="cableCurl",
   # Side-on from the left (yaw -1.4), facing screen-left: the cables run
   # from the hands down to the left edge, so the left half below them stays
   # empty; the back is clear on the right, where the short pills sit.
   # "Almost straight" (120 pt) sits at 0.52 after the squeeze, below the
   # buttocks' widest point (x 0.659 at 0.46), ~10 pt clear of them.
   overrides={"top": (0.14, "leading"), "grip": (0.23, "leading"), "elbow": (0.32, "trailing"),
              "range": (0.545, "trailing"), "torso": (0.64, "trailing")},
   annotations=[
       ("elbow", "Arms at sides", "forearm_L"),
       ("top", "Curl all the way up", "hand_L"),
       ("range", "Almost straight", "forearm_L"),
       ("grip", "Flat wrists", "hand_L"),
       ("torso", "No swinging", "pelvis"),
   ],
   cues={
       "top": ("Top of the Curl",
               "Each rep finishes with the handles in front of the chest.",
               "With the pulleys low and about a metre in front, the cables pull hardest from the middle of the curl all the way to the top. Stopping halfway gives up the part of the rep the cables load most.",
               "Stopping each rep halfway up, the forearms only just past level.",
               "Curl until the handles are in front of the chest, pause briefly, then lower under control."),
       "grip": ("Grip and Wrists",
                "An underhand grip, wrists straight.",
                GRIP_WHY,
                "Wrists curling in toward the forearms as the handles reach the top.",
                "Hold the handles palms-forward with the arms hanging, keep the palms turned up as they rise, and keep the knuckles in line with the forearms."),
       "elbow": ("Elbow Position",
                 "The elbows stay by your sides; only the forearms move.",
                 "With the upper arms still, bending the elbows is the only motion, so the elbow flexors move the handles. At the bottom the cables pull the arms toward the pulleys; letting the elbows drift forward brings the front deltoids in and turns the top of the curl into a front raise.",
                 "Elbows drifting forward and up as the handles rise.",
                 "Keep the elbows close to the ribs from the bottom to the top and curl without swinging them forward."),
       "torso": ("Body Position",
                 "A slight lean back, held still.",
                 "The cables pull the hands forward and down, and a small lean back keeps you balanced against them. Rocking further back or pushing the hips forward to heave the handles up borrows momentum from the hips and lower back, so the elbow flexors skip part of the work.",
                 "Rocking back and pushing the hips forward to swing the handles up.",
                 "Stand tall with the feet hip-width, lean back just enough to stay balanced against the cables and hold that position from the first rep to the last."),
       "range": ("Range of Motion",
                 "Each rep starts with the arms almost straight.",
                 "At the bottom the cables run forward from the hands, above the line of the forearms, so they pull the hands forward instead of resisting the first part of the curl, which is light and easy to cut short. Lowering until the arms are almost straight still takes the elbows through nearly their whole range.",
                 "Short reps that turn round with the elbows still bent, the handles never getting back to the thighs.",
                 "Lower under control until the arms are almost straight by your sides, the stacks still just off their rests, then curl again."),
   },
   activation=act(0.84),
   stabilisers=["anterior deltoid", "pectoralis major", "core"],
   comparison=("STOPPING SHORT AT THE TOP", "Handles to the chest", "Reps stop halfway up",
               "Curling the handles up to the chest trains the top of the curl, where the low cables in front still pull hard.",
               "Stopping halfway gives up the top of the curl, the part the cables load most, and turns each rep into a half rep."),
   glows=arm_glows("Cable Curl", "L", rx=0.05, ry=0.07))

SETUP["Cable Curl"] = [
    "Attach a D-handle to the low pulley of each of two columns.",
    "Take a handle in each hand, palms facing forward.",
    "Step back about a metre until both stacks lift.",
    "Stand tall, feet hip-width, arms almost straight, leaning back slightly.",
]

# ---------------------------------------------------------------- bayesian cable curl

ex(name="Bayesian Cable Curl", var="bayesianCableCurl",
   # From the left (yaw -1.2), facing screen-left: the working arm is drawn
   # back to the right of the body at the bottom and comes across the chest
   # at the top; the cable runs off to the bottom right. The front of the
   # body on the left is clear from the chest down; the right half above the
   # cable is clear beside the back. Simulator QA 2026-09-30: in the shoulder
   # fault's view (mistake sheet up, model raised) the ghost's hand tip, in
   # front of the upper chest, sat on the right end of "Shoulder down" at
   # 0.14; at 0.10 (0.124 after the squeeze) it clears the pill by ~20 pt.
   overrides={"shoulder": (0.10, "leading"), "elbow": (0.14, "trailing"), "grip": (0.30, "leading"),
              "range": (0.30, "trailing"), "torso": (0.52, "leading")},
   annotations=[
       ("elbow", "Upper arm still", "upper_arm_L"),
       ("range", "Almost straight", "forearm_L"),
       ("grip", "Flat wrist", "hand_L"),
       ("shoulder", "Shoulder down", "clavicle_L"),
       ("torso", "Stand tall", "pelvis"),
   ],
   cues={
       "elbow": ("Upper Arm Position",
                 "The upper arm stays back, behind the body; only the forearm moves.",
                 "Holding the elbow behind the body keeps the shoulder extended, the position that makes this a Bayesian curl. Letting the elbow swing forward as the hand rises brings the front deltoid in and turns the top of the curl into a front raise.",
                 "The elbow swinging forward past the side of the body as the handle rises.",
                 "Keep the elbow just behind the ribs, pointing down and back, and curl until the hand is in front of the chest without moving the upper arm."),
       "range": ("Range of Motion",
                 "Each rep starts with the arm almost straight behind you.",
                 "With the cable behind, the pull on the elbow is already about half its peak with the arm almost straight, where a dumbbell curl is at its lightest, so the stretched part of the rep is loaded. Lowering all the way works the elbow flexors through nearly their whole range, and " + FULL_RANGE + ".",
                 "Short reps that turn round with the elbow still well bent, the hand never going back past the hip.",
                 "Let the cable draw the hand back until the arm is almost straight behind you, the stack still just off its rest, then curl again without bouncing."),
       "grip": ("Grip and Wrist",
                "An underhand grip, wrist straight.",
                "In trained lifters, curls with the palm turned up have worked the biceps harder than palm-in or palm-down curls. Curling the wrist in moves the handle with the wrist instead of the elbow, and a bent wrist grips far more weakly.",
                "The wrist curling in toward the forearm as the handle reaches the top.",
                "Hold the handle palm-forward with the arm drawn back, keep the palm turned up as it rises, and keep the knuckles in line with the forearm."),
       "shoulder": ("Shoulder Position",
                    "The working shoulder stays down and back.",
                    "Shrugging brings the upper traps into the lift, and rolling the working shoulder forward carries the upper arm off its fixed place behind the body.",
                    "The working shoulder rolling forward and shrugging up as the handle rises.",
                    "Set the shoulder down and back before the first rep, chest up, and keep it there as the hand comes forward."),
       "torso": ("Body Position",
                 "Stand tall; the body stays still.",
                 "With the pulley behind you, rocking the body forward drags the handle forward without bending the elbow, so the body, not the elbow flexors, moves part of the load.",
                 "Rocking forward from the hips as the handle comes up, the trunk tipping toward the hand.",
                 "Stand tall with the feet hip-width and the core braced, the free arm at your side, and keep the trunk still; only the forearm moves."),
   },
   activation=act(0.80),
   stabilisers=["anterior deltoid", "core"],
   comparison=("ELBOW SWINGING FORWARD", "Upper arm stays behind you", "Elbow swings forward",
               "With the elbow held behind the body, the elbow flexors curl the handle from the stretched position all the way to the top.",
               "When the elbow swings forward, the arm leaves the position behind the body, the front deltoid joins in and the top of the curl turns into a front raise."),
   glows=arm_glows("Bayesian Cable Curl", "L", rx=0.05, ry=0.07))

SETUP["Bayesian Cable Curl"] = [
    "Attach a D-handle to the low pulley and stand with your back to it.",
    "Take the handle in one hand, palm facing forward.",
    "Step forward until the arm is drawn back behind you and the stack lifts.",
    "Stand tall, feet hip-width, the free arm at your side.",
]

if __name__ == "__main__":
    probs = validate(["Dumbbell Curl", "Incline Dumbbell Curl", "Preacher Curl", "Cable Curl", "Bayesian Cable Curl"])
    print("\n".join(probs) or "OK")
