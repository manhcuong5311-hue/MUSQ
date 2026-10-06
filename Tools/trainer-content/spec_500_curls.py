# Trainer content for the 401-500 folder (2026-10-04), family: curls. Five
# biceps curls from the builder's 255-267 set: 255 Strict Curl
# (Biceps/StrictCurl), 256 21s Curl (Biceps/Curl21s), 257 EZ-Bar 21s
# (Biceps/EZBar21s), 258 Waiter Curl (Biceps/WaiterCurl) and 267 Seated
# Dumbbell Curl (Biceps/SeatedDumbbellCurl). Same format as spec.py on top of
# common_1_50.py; spec_500.py imports this module and gen.py reads SPEC /
# SETUP. notes_500_curls.md maps the copy's claims to the sources below and
# records the model facts.
#
# What the models show, from the briefs (SCRATCH/briefs/<Resource>.md), the
# trainer stills at 0/1/2/3/5 s (SCRATCH/stills), tiers30.json, joints.json
# and the rigs, equipment and skinned bodies read from the USD with Blender's
# Python + pxr (SCRATCH/curls/: rig.py reader, strict.py, reps.py,
# detail21.py, ezbar.py, waiter.py, seated.py, palm.py, lever.py, dist.py;
# the app's Y-up space, the lifter facing +z, their left +x; one body, torso
# neck-to-pelvis 0.592 m). "Load" is the weight's lever arm about the elbow
# (the horizontal distance from the elbow joint to the bar's or dumbbell's
# centre) as a share of its peak in that clip. Both arms move together and
# identically in all five (left and right elbow angles equal to 0.1°).
# - Strict Curl (7.96 s, two 4 s reps: still to ~0.3 s, curl to the top by
#   1.25 s, held to ~1.6 s, lowered by ~3.4 s, still to 4 s). A straight
#   barbell, underhand, wrist joints 0.44 m apart (shoulders 0.39 m), palms
#   fully up; wrists straight (0°). The lifter stands with the back to a wall
#   board (Q191_StrictWall, 1.1 m wide, 2 m tall, its face at z -0.162)
#   carrying a 46 cm wide pad from 0.67 to 1.57 m up, its face at
#   z -0.135. Skinned body: the seat of the shorts and the glutes on the pad
#   (0.2-0.9 cm into it), the upper back on it (0.2 cm), the back of the head
#   level with the pad's face but above its top (3 cm in front of the board),
#   the heels 14.5 cm in front of the pad's face (17 cm from the board at
#   floor level). The triceps stay 3-5 cm off the pad (the arms are not
#   pressed to the wall). Trunk 5° back and still, knees 174-176°. Elbows
#   175° -> 50°: the upper arms 13° in front of the trunk at the bottom, 6°
#   mid-curl, 16° at the top (the elbows move within 5 cm); at the top the
#   forearms point ~60° above level and the bar sits in front of the upper
#   chest, ~5 cm below shoulder height. Load: 0.40 of peak at the bottom,
#   peak at ~110°, 0.49 at the top. Framed at yaw -1.0 from the front-left,
#   the wall behind on the right.
# - 21s Curl (43.96 s, one set of 21 reps without a rest). A straight
#   barbell, the same grip as the Strict Curl (wrist joints 0.44 m apart,
#   palms fully up), standing tall (trunk 0°, knees 174-176°, ankles 0.30 m
#   apart). Reps 1-7, 0-14 s: arms straight (176°) to forearms just above
#   level (90°; the forearms 8° above level), each 2 s (0.75 s up, 0.13 s
#   pause, 1.0 s down, 0.12 s at straight). 14-15 s: one curl up to level.
#   Reps 8-14, 15-29 s: level (90°) to the top (52°, the forearms 53° above
#   level) and back to level, each 2 s (~0.7 s up, 0.17 s pause, ~0.95 s
#   down, 0.17 s at level); the bar never goes below level. 29-30 s: lowered
#   to straight arms. Reps 15-21, 30-44 s: full reps, straight (176°) to the
#   top (52°), each 2 s (0.83 s up, 0.13 s pause, 0.92 s down, 0.12 s at
#   straight). So the bottom half comes first, then the top half, then full
#   reps, the standard order. Upper arms 5-15° in front of the trunk, the
#   elbows within 5 cm. Load: 0.31 of peak with straight arms, peak at
#   ~95-100° (just before level), 0.60 at the top: the bottom-half reps run
#   from the lightest point to the heaviest, the top-half reps from the
#   heaviest to 0.60. Framed at yaw -0.9 from the front-left.
# - EZ-Bar 21s (43.96 s): the same scheme, phases and timing to the frame
#   (bottom-half tops at 90.1°, top-half tops 52.2°, straight 173.6°), with
#   an EZ bar (Q191_EZBar): the hands on the outer angled grips (the second
#   bend from the middle, x +-0.15-0.24 m), wrist joints 0.39 m apart (the
#   shoulders' width), the palms turned ~23° in from fully up (the grip
#   segments angle ~21° in plan). Load: 0.30 of peak straight, peak at ~95°,
#   0.62 at the top. Framed at yaw -0.4, nearly front-on.
# - Waiter Curl (7.96 s, two 4 s reps: still to 0.17 s, up by 1.25 s, held
#   to ~1.75 s, lowered by 3.38 s). One dumbbell stood on end (0.45 m tall,
#   plates 0.20 m across), both palms flat under its top plate, one hand
#   each side of the handle, fingers pointing in and forward, not wrapped
#   round it; the wrist joints 0.27 m apart. The dumbbell stays vertical all
#   rep (the hands' pitch is constant): the wrists are bent toward the palm
#   42° at the bottom and back 42° at the top to keep the plate level.
#   Elbows 150° -> 66°: the arms never straighten (forearms 50° below level
#   at the bottom, 39° above at the top); the dumbbell rises 35 cm, from in
#   front of the hips (its top plate at ~1.0 m) to chest height (hands
#   1.32 m, shoulders 1.43 m). Upper arms 9-17° forward, elbows within 4 cm.
#   Trunk upright and still, knees 174-176°. The dumbbell's centre sits
#   ~6 cm ahead of the wrists, so the load stays high all rep: 0.67 of peak
#   at the bottom, peak at ~105°, 0.81 at the top. Framed at yaw -0.5.
# - Seated Dumbbell Curl (7.96 s, two 4 s reps: still to 0.3 s, up by
#   1.38 s, held to ~1.9 s, lowered by ~3.5 s). Seated on an adjustable
#   bench (GYM_Bench_ROOT), seat top 0.47 m up, the back pad set nearly
#   upright (its face 11° from vertical, 0.33 m wide, up to 1.29 m); the
#   trunk leans 17° back with the upper back and the seat of the shorts on
#   the pad (touching), the head above the pad. Feet flat ~0.47 m in front of
#   the hips, knees 120°. A dumbbell in each hand; BOTH arms curl together
#   (not alternating). The palms face in with the arms hanging (hands beside
#   the seat, outside the pad), turn up through the middle of the curl
#   (between ~120° and ~70° of elbow, 0.75-1.12 s), finish turned up toward
#   the shoulders (~17° short of fully up) and turn back in on the way down
#   (2.25-2.75 s). Elbows 170° -> 54°. The upper arms hang 7° in front of
#   vertical, i.e. 10° behind the line of the leaning trunk, 13° out to the
#   sides at the bottom, 10° forward and 7° out at the top (elbows within
#   3 cm). Load: 0.29 of peak at the bottom, peak at ~100°, 0.70 at the top.
#   Framed at yaw -0.6 from the front-left.
# - Highlight tiers (tiers30.json), the same on all five: bright =
#   BicepsBrachii_LongHead, BicepsBrachii_ShortHead, Brachialis -> PRIMARY
#   "Biceps Brachii" and "Brachialis"; dim = Brachioradialis and the wrist
#   and finger flexors and extensors (ECRB, ECRL, ECU, ED, FCR, FDP, FDS,
#   PL) -> SECONDARY "Brachioradialis" and one "Forearms" row, as the 1-50
#   curls and the Machine Preacher Curl group them (the legend's secondary
#   line stays "BRACHIORADIALIS · FOREARMS").
#
# How they differ from the library: the Barbell Curl, Biceps Curl, Dumbbell
# Curl and Alternating Dumbbell Curl are free-standing, full-range curls; the
# Incline Dumbbell Curl leans the trunk 25° back on a 65° pad; the Preacher,
# Spider and Drag curls fix or move the upper arms. Here the Strict Curl is
# the Barbell Curl against a wall that pins the glutes and upper back; the two
# 21s split one long set into bottom-half, top-half and full reps; the Waiter
# Curl holds one dumbbell upright on open palms and never straightens the
# arms; the Seated Dumbbell Curl sits back on a near-upright pad, both arms
# together, palms turning up from facing in.
#
# Sources (abstracts read on Europe PMC 2026-10-04, full texts where noted;
# details and quotes in notes_500_curls.md):
# - MCCS Miramar, Strict Curl Competition rules (miramar.usmc-mccs.org,
#   fetched 2026-10-04): glutes and upper back pressed against the wall and
#   kept there for the whole lift; heels no more than 12 inches from the
#   wall; underhand grip, width by comfort; the upper arms may move.
# - Dale P, Strict Curl, FitnessVolt (2022-05-26, updated 2024-08-11): the
#   same rules (upper back and butt on the wall up and down, heels within
#   12 inches, feet stationary); curl the bar to the chin.
# - Williams B, How to Do Strict Curls, Men's Health (2024-07-16, read via
#   its AOL syndication): stand against a wall, three points of contact
#   (shoulder blades squeezed, shoulders driven into the wall, butt on the
#   wall), move only at the elbows, pause at the top; the wall stops the
#   swing. It also presses the backs of the arms to the wall, which this
#   model does not do.
# - DiGiovanni K, Biceps 21s, Set For Set (2023-10-15, updated 2026-01-13,
#   fact-checked by K Yovino): 7 partial reps from the bottom to about 90°,
#   7 from 90° to the top, 7 full reps, no rest between them; most lifters
#   need a lighter weight than their 8-12 rep curl weight; elbows pinned,
#   wrists neutral; leaning back and leg drive mean the weight is too heavy.
# - Nobbe J, 21s workout, Garage Gym Reviews (updated 2024-01-12): seven
#   bottom-half reps stopping at a 90° elbow, seven top-half, seven complete;
#   start with light weights.
# - Saini V, Waiter Curl, FitnessVolt (2022-05-29, updated 2024-08-11): one
#   dumbbell stood on end, hands flat under the top plate, one each side of
#   the handle, palms up, fingers not wrapped round it; elbows pinned; curl
#   to chest height; arms not extended at the bottom (that eases tension
#   off the biceps); the top of the dumbbell faces straight up throughout.
#   Its long-head claim is uncited and not used.
# - ExRx.net (read on the Wayback Machine, 2023 snapshots; the live site
#   returns 403): Barbell Curl (shoulder-width underhand grip, elbows to the
#   sides, raise until the forearms are vertical, lower until fully
#   extended; target biceps brachii; synergists brachialis, brachioradialis;
#   stabilisers anterior deltoid, upper and middle trapezius, levator
#   scapulae, wrist flexors) and Dumbbell Curl (start palms in, rotate the
#   forearm as the dumbbell rises until the palm faces the shoulder; may be
#   done simultaneous; the same muscle lists). The Dumbbell Seated Curl
#   page is behind ExRx's paywall in every snapshot and was not read.
# - Pinto RS, Gomes N, Radaelli R, Botton CE, Brown LE, Bottaro M 2012,
#   J Strength Cond Res 26(8):2140-2145, doi:10.1519/JSC.0b013e31823a3b15,
#   PMID 22027847 (full text read) - 40 young men with no resistance
#   training experience, bilateral preacher curl, full range (0-130° of
#   flexion) vs partial (50-100°), 10 weeks: 1RM +25.7% vs +16.0%, elbow
#   flexor thickness +9.7% vs +7.8% (both significant, not different).
# - Sato S, Yoshida R, Kiyono R, Yahata K, Yasaka K, Nunes JP, Nosaka K,
#   Nakamura M 2021, Front Physiol 12:734509, doi:10.3389/fphys.2021.734509,
#   PMID 34616309 (full text PMC8489980 read) - 32 non-resistance-trained
#   young adults, one-arm dumbbell preacher curls (45° shoulder flexion)
#   over 0-50° (extended) or 80-130° (flexed) of flexion, 5 weeks: strength
#   rose only after the extended range; muscle thickness +8.9% vs +3.4%.
# - Pedrosa GF, Simoes MG, Figueiredo MOC, Lacerda LT, Schoenfeld BJ,
#   Lima FV, Chagas MH, Diniz RCR 2023, Sports 11(2):39,
#   doi:10.3390/sports11020039, PMID 36828324 - 19 untrained young women,
#   seated dumbbell preacher curl, one arm over 0-68° and the other over
#   68-135°, 8 weeks: the initial range gave a larger 1RM gain and more
#   distal biceps growth; mid-biceps and summed growth similar.
# - Havers T, Wagner N, Held S, Geisler S, Wiewelhove T 2025, Eur J Sport
#   Sci 25(12):e70087, doi:10.1002/ejsc.70087, PMID 41247250 - 13 trained
#   lifters, one-arm preacher curls over 0-70° or 0-140°, 8 weeks: similar
#   mid-arm growth, trivial-small advantage at 70% for the partial range,
#   negligibly greater strength with the full range.
# - Schoenfeld BJ, Grgic J 2020, SAGE Open Med 8:2050312120901559,
#   doi:10.1177/2050312120901559, PMID 32030125 - systematic review: for the
#   upper limbs the evidence on range of motion is limited and conflicting.
# - Coratella G, Tornatore G, Longo S, Toninelli N, Padovan R, Esposito F,
#   Ce E 2023, Sports 11(3):64, doi:10.3390/sports11030064, PMID 36976950 -
#   ten competitive bodybuilders, bilateral curls at 8RM (full text
#   PMC10054060 read): biceps excitation greater supinated than pronated
#   (+19%) or neutral (+12%) on the way up; brachioradialis +5-6%
#   supinated; anterior deltoid greater pronated and neutral; "biceps
#   brachii is a supinator".
# - Coratella G, Tornatore G, Longo S, Esposito F, Ce E 2023, J Funct
#   Morphol Kinesiol 8(1):13, doi:10.3390/jfmk8010013, PMID 36810497 - ten
#   competitive bodybuilders (full text PMC9944112 read): straight vs EZ
#   bar, arms still or flexing forward: +1.8% biceps with the straight bar
#   (arms still, lifting phase); "the anterior deltoid was markedly more
#   excited when flexing vs. not flexing the arms";
#   biceps excitation in the lifting phase also rose with the arms flexing
#   (+17.7% straight, +20.3% EZ), so the copy never says the biceps drop out.
# - Marcolin G, Panizzolo FA, Petrone N, Moro T, Grigoletto D, Piccolo D,
#   Paoli A 2018, PeerJ 6:e5165, doi:10.7717/peerj.5165, PMID 30013836 -
#   twelve participants at 65% 1RM: EZ-bar curls drew more biceps and
#   brachioradialis than dumbbell curls; straight vs EZ "a matter of
#   subjective comfort".
# - Kawakami Y, Nakazawa K, Fujimoto T, Nozaki D, Miyashita M, Fukunaga T
#   1994, Eur J Appl Physiol 68(2):139-147, doi:10.1007/BF00244027, PMID
#   8194543 - MRI, four men: brachialis 47%, biceps 34%, brachioradialis 19%
#   of maximal elbow-flexor torque (a capacity estimate; activation rows
#   only).
# - Boland MR, Spigelman T, Uhl TL 2008, J Hand Surg Am 33(10):1853-1859,
#   doi:10.1016/j.jhsa.2008.07.019, PMID 19084189 - fine-wire EMG: the
#   brachioradialis is active in elbow flexion whatever the forearm position.
# - Mogk JPM, Keir PJ 2003, Ergonomics 46(9):956-975,
#   doi:10.1080/0014013031000107595, PMID 12775491 - gripping works the
#   forearm flexors and extensors; a flexed wrist cut maximum grip force by
#   40-50%.
# - Schoenfeld BJ, Ogborn DI, Krieger JW 2015, Sports Med 45(4):577-585,
#   doi:10.1007/s40279-015-0304-0, PMID 25601394 - in sets to failure,
#   repetition durations of 0.5-8 s built similar muscle.
# - Schoenfeld BJ, Ogborn DI, Vigotsky AD, Franchi MV, Krieger JW 2017,
#   J Strength Cond Res 31(9):2599-2608, doi:10.1519/JSC.0000000000001983,
#   PMID 28486337 - 15 studies: eccentric-only training grew muscle a little
#   more than concentric-only (10.0% vs 6.8%, not significant).
# No EMG study of a strict (wall) curl, 21s, a waiter curl or a back-supported
# seated dumbbell curl was found (Europe PMC searches 2026-10-04): every
# fraction below follows the library's nearest lift and the paint, and is a
# judgement call (see the notes).
from common_1_50 import *


def ov(final):
    """Pre-squeeze override row for an on-screen row (spec_500.row() maps
    0.14-0.86 to 0.16-0.80)."""
    return round(0.14 + (final - 0.16) * (0.86 - 0.14) / (0.80 - 0.16), 4)


# ---------------------------------------------------------------- shared text

FULL_RANGE = "in new lifters, full-range curl training has built more strength than mid-range partial reps"

PALMS_UP = ("In trained lifters, curls with the palms turned up have worked the biceps harder than palm-in or "
            "palm-down curls")


def act(biceps, brachioradialis):
    """Paint: biceps and brachialis bright (PRIMARY), brachioradialis and the
    forearm muscles dim (SECONDARY). The biceps and brachioradialis follow
    the library's nearest lift (Barbell Curl 0.90 / 0.52; the 1-50 Dumbbell
    Curl 0.86 / 0.44; the Alternating Dumbbell Curl 0.84 for a curl that
    turns the palms up from facing in); the brachialis takes the house value
    for a bright brachialis (Machine Preacher Curl 0.72) and the forearms the
    1-50 curls' house value (0.30). Judgement calls: no EMG of these five
    lifts exists."""
    return [("Biceps Brachii", P, HI, biceps), ("Brachialis", P, HI, 0.72),
            ("Brachioradialis", S, MOD if brachioradialis >= 0.40 else LOW, brachioradialis),
            ("Forearms", S, LOW, 0.30)]


def arm_glows(name, rx=0.06, ry=0.07):
    """Both biceps (mid upper arm) at full strength, and softer, the
    brachialis and brachioradialis at the near (left) elbow."""
    return [glow(name, ["upper_arm_L", "forearm_L"], A, 0.55, rx, ry),
            glow(name, ["upper_arm_R", "forearm_R"], A, 0.55, rx, ry),
            glow(name, ["forearm_L"], SOFT, 0.28, rx * 0.75, ry * 0.75)]


# ---------------------------------------------------------------- Strict Curl

N = "Strict Curl"
ex(name=N, var="strictCurl",
   overrides={"shoulders": (ov(0.12), "leading"), "elbows": (ov(0.17), "leading"),
              "range": (ov(0.66), "leading"), "hips": (ov(0.66), "trailing"), "knees": (ov(0.75), "trailing")},
   annotations=[
       ("shoulders", "Upper back on the wall", "upper_arm_R"),
       ("elbows", "Elbows by your sides", "forearm_R"),
       ("hips", "Glutes on the wall", "thigh_L"),
       ("knees", "Knees still, no dip", "patella_L"),
       ("range", "Lower to straight arms", "hand_R"),
   ],
   cues={
       "hips": ("Hip Position",
                "Your glutes stay against the wall pad from the first rep to the last.",
                "With the glutes and upper back pinned to the wall, the hips cannot drive forward and the trunk cannot rock, so the elbow flexors have to lift the bar. Strict-curl contests judge exactly that: both must stay on the wall through the whole lift.",
                "Pushing the hips off the wall and arching the lower back to heave the bar past the middle of the curl.",
                "Press your glutes into the pad, brace your midsection and keep your hips there while only your forearms move."),
       "shoulders": ("Upper Back",
                     "The upper back stays on the pad as the bar comes up.",
                     "Rolling the shoulders forward off the wall near the top lets the trunk finish the lift, the same shortcut the wall is there to stop.",
                     "The shoulders peeling off the wall and the chest folding toward the bar as it nears the top.",
                     "Keep your shoulder blades pressed into the pad and your chest up, and bring the bar to your upper chest, not your chest to the bar."),
       "elbows": ("Elbow Position",
                  "The elbows stay close to your sides; only the forearms swing up.",
                  "The wall stops the hips and back, but the shoulders can still help. Swinging the elbows forward turns the top of the curl into a front raise and brings the front deltoids in.",
                  "Elbows drifting forward and up as the bar passes halfway.",
                  "Keep your elbows just in front of your ribs from bottom to top, and finish with the bar in front of your upper chest."),
       "knees": ("Leg Drive",
                 "The knees stay almost straight and still; the legs play no part.",
                 "With the back on the wall the trunk cannot swing, but a quick dip and drive through the legs can still get the bar moving before the arms do, taking the start of the curl away from the elbow flexors.",
                 "Dipping at the knees and driving up through the legs to start each rep.",
                 "Keep your knees soft but still and your feet planted, and start every rep by bending your elbows."),
       "range": ("Range of Motion",
                 "Each rep runs from straight arms to the bar at your upper chest.",
                 "The bottom of the curl is its lightest part, so it is the easiest to cut short. Lowering to straight arms keeps the whole range of the curl in every rep, and " + FULL_RANGE + ".",
                 "Turning each rep round with the elbows still bent, the bar stopping well above the thighs.",
                 "Lower under control until your arms are straight and the bar hangs just in front of your thighs, then curl again without bouncing."),
   },
   # Paint: biceps and brachialis bright, brachioradialis and forearms dim.
   # Biceps 0.90 and brachioradialis 0.52 as the library's Barbell Curl (the
   # same straight bar, grip and elbow path; the wall only removes the
   # swing). Brachialis 0.72 and forearms 0.30 are the house values (see
   # act()). Judgement calls: no EMG of a wall curl exists.
   activation=act(0.90, 0.52),
   stabilisers=["anterior deltoid", "upper trapezius", "middle trapezius"],
   comparison=("HIPS OFF THE WALL", "Glutes and back stay on the wall", "Hips push out to heave the bar",
               "With the hips and upper back on the wall, the trunk cannot help, so the elbow flexors lift the bar the whole way.",
               "Driving the hips off the wall arches the lower back and lets the hips start the bar moving, the cheat the wall is there to stop."),
   glows=arm_glows(N, 0.05, 0.07))

SETUP[N] = [
    "Stand with your back to the wall, heels about 15 cm out from it.",
    "Press your glutes and upper back into the wall pad, head upright.",
    "Hold the bar underhand, hands just wider than your shoulders.",
    "Let it hang at arm's length in front of your thighs, knees almost straight.",
]

# ---------------------------------------------------------------- 21s Curl

N = "21s Curl"
ex(name=N, var="curl21s",
   overrides={"elbows": (ov(0.12), "leading"), "top": (ov(0.17), "leading"), "bottom": (ov(0.66), "leading"),
              "full": (ov(0.63), "trailing"), "torso": (ov(0.72), "trailing")},
   annotations=[
       ("bottom", "1-7: bottom half", "hand_R"),
       ("top", "8-14: top half", "hand_R"),
       ("full", "15-21: full reps", "forearm_L"),
       ("elbows", "Elbows at your sides", "forearm_R"),
       ("torso", "No leaning back", "thigh_L"),
   ],
   cues={
       "bottom": ("Reps 1 to 7",
                  "The first seven reps run from straight arms up to forearms level.",
                  "This is the stretched half of the curl: the bar is lightest with the arms straight and heaviest as the forearms reach level. In new lifters on preacher curls, training the lower part of the range has built more strength than training the upper part, and at least as much muscle.",
                  "Turning the first seven round with the elbows still bent, so the arms never straighten at the bottom.",
                  "Lower until your arms are straight each time, then curl only until your forearms are level, a right angle at the elbow, and lower again."),
       "top": ("Reps 8 to 14",
               "The middle seven start with the forearms level and finish at the top.",
               "Starting each rep from level, where the bar pulls hardest on the elbows, keeps the elbow flexors loaded through the upper half with no rest at the bottom. In preacher-curl studies of new lifters, upper-range reps on their own built less than the lower range, so they are one part of the set, not the whole of it.",
               "Letting the bar sink below level between the middle seven, turning them into rests or full reps.",
               "After the seventh rep, curl up to level and work between level and the top of your chest, stopping at level each time instead of lowering further."),
       "full": ("Reps 15 to 21",
                "The last seven are full curls, from straight arms to the top.",
                "Full reps finish the set through the whole range of the curl, and " + FULL_RANGE + ".",
                "Cutting the last seven short at the top as the arms tire, the bar stopping around level.",
                "Lower all the way to straight arms after the middle seven, then curl from straight arms to the top of your chest seven times without a rest."),
       "elbows": ("Elbow Position",
                  "The elbows stay at your sides for all 21 reps.",
                  "With the upper arms still, the elbow flexors do the lifting in every part of the set. Swinging the elbows forward brings the front deltoids in and turns the top of each rep into a front raise.",
                  "Elbows drifting forward to reach the top of the middle seven.",
                  "Keep your elbows close to your ribs and a little in front of them, and let only your forearms move."),
       "torso": ("Body Swing",
                 "Stand still for the whole set; if you have to lean back, the bar is too heavy.",
                 "Twenty-one reps without a rest take a lighter bar than a normal set of curls. Leaning back or driving with the hips to finish the last reps hands the work to the hips and lower back.",
                 "Leaning back and pushing the hips forward to swing up the last full reps.",
                 "Pick a bar you can curl 21 times standing tall, knees soft and midsection braced, with no rest between the three parts."),
   },
   # Paint as the Strict Curl. Biceps 0.90 and brachioradialis 0.52 as the
   # library's Barbell Curl (same bar and grip); the 21s change the range per
   # rep and take a lighter bar, and no EMG of them exists. Judgement calls.
   activation=act(0.90, 0.52),
   stabilisers=["anterior deltoid", "upper trapezius", "core"],
   comparison=("LEANING BACK", "Body still for all 21 reps", "Trunk sways back to finish",
               "With the body still, the elbow flexors lift the bar through every part of the set, the last full reps included.",
               "Leaning back hands the end of the set to the hips and lower back, a sign the bar is too heavy for 21 reps."),
   glows=arm_glows(N, 0.05, 0.07))

SETUP[N] = [
    "Load a bar lighter than you would use for 8 to 12 curls.",
    "Hold it underhand, hands just wider than your shoulders.",
    "Stand tall, feet hip-width apart, arms straight.",
    "Do 7 bottom-half, 7 top-half and 7 full reps with no rest.",
]

# ---------------------------------------------------------------- EZ-Bar 21s

N = "EZ-Bar 21s"
ex(name=N, var="ezBar21s",
   overrides={"top": (ov(0.10), "leading"), "bottom": (ov(0.62), "leading"), "full": (ov(0.71), "leading"),
              "grip": (ov(0.63), "trailing"), "elbows": (ov(0.72), "trailing")},
   annotations=[
       ("grip", "Outer bends grip", "hand_L"),
       ("bottom", "1-7: lower half", "hand_R"),
       ("top", "8-14: upper half", "hand_R"),
       ("full", "15-21: all the way", "forearm_R"),
       ("elbows", "Elbows stay put", "forearm_L"),
   ],
   cues={
       "grip": ("Grip",
                "Hold the outer angled grips, hands about shoulder-width, palms turned slightly in.",
                "The bends hold the forearms about 20° short of fully palms-up. The EZ and straight bars differ little: one study measured slightly more biceps activity with the straight bar, another called the choice a matter of comfort.",
                "Wrists curling in toward the forearms as the bar nears the top.",
                "Take the second bend out from the middle on each side, palms facing up and a little in, and keep your knuckles in line with your forearms."),
       "bottom": ("Reps 1 to 7",
                  "Seven half reps from straight arms up to a right angle at the elbow.",
                  "These reps work the biceps at long lengths, from the lightest point of the curl to the heaviest. On preacher curls, new lifters have gained more strength from the lower part of the range than from the upper part, and at least as much muscle.",
                  "Never quite straightening the arms between the first seven, so every rep starts halfway up.",
                  "Let your arms straighten fully at the bottom of each rep and stop when your forearms reach level."),
       "top": ("Reps 8 to 14",
               "Seven half reps from forearms level to the top of the curl.",
               "Working from level up keeps the bar on the elbow flexors in their shortened half without a rest at the bottom. These reps add to the set rather than replace the lower half: on their own, upper-range preacher curls built less strength in new lifters.",
               "Dropping the bar below level to rest between the middle seven.",
               "Curl to level once, then go between level and the top of your chest, turning each rep round at level."),
       "full": ("Reps 15 to 21",
                "Seven full curls to finish, straight arms to the top.",
                "The last seven take the elbow flexors through the whole curl again, and " + FULL_RANGE + ".",
                "Stopping the last reps around level as the arms tire.",
                "Lower to straight arms after the middle seven, then curl all the way to your upper chest on each of the last seven."),
       "elbows": ("Elbow Position",
                  "The upper arms hang at your sides through all 21 reps.",
                  "Bending only at the elbows keeps the work on the elbow flexors. When the elbows travel forward, the front deltoids help lift the bar and the curl turns into part front raise.",
                  "Elbows swinging forward to reach the top as the set gets hard.",
                  "Hold your elbows close to your ribs, just in front of them, and move only your forearms in all three parts."),
   },
   # Paint as the Strict Curl. Biceps 0.88, a little under the straight
   # bar's 0.90 (Coratella 2023 JFMK: +1.8% biceps with the straight bar);
   # brachioradialis 0.52 as the straight bar (Marcolin 2018: small
   # straight-EZ differences). Judgement calls: no EMG of 21s exists.
   activation=act(0.88, 0.52),
   stabilisers=["anterior deltoid", "upper trapezius", "core"],
   comparison=("ELBOWS DRIFTING FORWARD", "Elbows fixed for all 21 reps", "Elbows swing forward late in the set",
               "With the elbows at your sides, the elbow flexors lift the bar through all three parts of the set.",
               "When the elbows travel forward as the set gets hard, the front deltoids join in at the top of each rep."),
   glows=arm_glows(N, 0.06, 0.07))

SETUP[N] = [
    "Load an EZ bar lighter than you would use for 8 to 12 curls.",
    "Hold the outer bends underhand, hands about shoulder-width.",
    "Stand tall, feet hip-width apart, arms straight.",
    "Do 7 lower-half, 7 upper-half and 7 full reps without resting.",
]

# ---------------------------------------------------------------- Waiter Curl

N = "Waiter Curl"
ex(name=N, var="waiterCurl",
   overrides={"upright": (ov(0.24), "leading"), "palms": (ov(0.64), "leading"), "torso": (ov(0.16), "trailing"),
              "elbows": (ov(0.40), "trailing"), "range": (ov(0.56), "trailing")},
   annotations=[
       ("palms", "Flat open palms", "hand_R"),
       ("upright", "Keep it upright", "hand_R"),
       ("elbows", "Elbows at sides", "forearm_L"),
       ("range", "Arms stay bent", "forearm_L"),
       ("torso", "Stand still", "head"),
   ],
   cues={
       "palms": ("Hand Position",
                 "Both palms sit flat under the top plate, one each side of the handle.",
                 "The dumbbell rests on open palms like a tray, so nothing is gripped: the fingers stay flat and the elbow flexors do the lifting.",
                 "Wrapping the fingers round the handle and squeezing it instead of letting the plate rest on the palms.",
                 "Stand the dumbbell on end, slide both hands flat under its top plate with the fingers pointing in, and lift it on open palms."),
       "upright": ("Dumbbell Angle",
                   "The dumbbell stays standing on end, its top plate level, all the way up and down.",
                   "Open palms only hold a dumbbell that stays level on them. Keeping it upright means the wrists bend back as the forearms rise and forward as they lower, while the elbows do the lifting.",
                   "Wrists curling in near the top, so the dumbbell tips back toward your face.",
                   "Let your wrists bend back as the dumbbell rises and forward as it lowers, keeping the top plate flat like a tray."),
       "elbows": ("Elbow Position",
                  "The elbows stay by your ribs while the dumbbell rises to chest height.",
                  "With the upper arms still, bending the elbows is the only motion, so the elbow flexors lift the dumbbell. Swinging the elbows forward lets the front deltoids help raise it.",
                  "Elbows drifting forward and up as the dumbbell nears the chest.",
                  "Keep your elbows close to your ribs, just in front of them, and finish with the dumbbell in front of your chest."),
       "range": ("Range of Motion",
                 "Each rep runs from arms still bent, forearms angled down, to the dumbbell at chest height.",
                 "In this version the arms never straighten. With the dumbbell held out in front of the hands, its pull on the elbows stays at two-thirds of its peak or more over this range; hanging the arms straight eases that tension off.",
                 "Lowering until the arms hang straight, the dumbbell dropping toward the thighs.",
                 "Stop each lowering with your elbows still bent and the dumbbell in front of your hips, then curl it back to chest height."),
       "torso": ("Body Swing",
                 "The body stays tall and still; only the forearms move.",
                 "Leaning back or pushing the hips forward borrows momentum to lift the dumbbell, so the elbow flexors skip the heaviest part of the rep.",
                 "Leaning back and pushing the hips forward to swing the dumbbell up.",
                 "Stand tall with soft knees and a braced midsection, curl in about a second, pause at the top and lower in about one and a half."),
   },
   # Paint as the Strict Curl. Biceps 0.86 and brachioradialis 0.44 as the
   # 1-50 Dumbbell Curl (palms up all rep). Forearms 0.30 (house): the
   # fingers do not grip, but the wrists hold the hands level against the
   # load all rep. Judgement calls: no EMG of a waiter curl exists.
   activation=act(0.86, 0.44),
   stabilisers=["anterior deltoid", "upper trapezius", "core"],
   comparison=("DUMBBELL TIPPING", "Plate level, wrists bend back", "Wrists curl in, dumbbell tips",
               "With the plate kept level, the dumbbell sits steady on open palms and the elbow flexors lift it from start to finish.",
               "When the wrists curl in, the dumbbell tips back toward the face and is no longer balanced on the open palms."),
   glows=arm_glows(N, 0.06, 0.07))

SETUP[N] = [
    "Stand a dumbbell on end on a bench.",
    "Slide both palms flat under its top plate, one each side of the handle.",
    "Lift it and stand tall, feet hip-width, dumbbell in front of your hips.",
    "Keep your elbows at your sides, arms still bent.",
]

# ---------------------------------------------------------------- Seated Dumbbell Curl

N = "Seated Dumbbell Curl"
ex(name=N, var="seatedDumbbellCurl",
   overrides={"back": (ov(0.12), "leading"), "lower": (ov(0.195), "leading"), "palms": (ov(0.26), "leading"),
              "elbows": (ov(0.30), "trailing"), "range": (ov(0.69), "trailing")},
   annotations=[
       ("back", "Back on the pad", "upper_arm_R"),
       ("palms", "Palms turn up", "hand_R"),
       ("elbows", "Elbows down", "forearm_L"),
       ("range", "Arms almost straight", "hand_L"),
       ("lower", "Lower slowly", "forearm_R"),
   ],
   cues={
       "back": ("Back Support",
                "Sit back against the near-upright pad and stay there for the whole set.",
                "With the seat and pad holding the trunk, there is nothing to swing the dumbbells with as long as you stay on them, so the elbow flexors lift them from the first rep to the last.",
                "Rocking forward off the pad and back again to swing the dumbbells up.",
                "Sit with your hips at the back of the seat and your upper back on the pad, and keep both there on every rep."),
       "palms": ("Grip and Turn",
                 "The palms face in at the bottom and turn up as the dumbbells rise.",
                 "The biceps both bends the elbow and turns the palm up. " + PALMS_UP + ", so turning up as you lift and back in as you lower uses both of its jobs.",
                 "Wrists curling in toward the forearms at the top instead of the palms turning up.",
                 "Start with your palms facing in, turn them up as your forearms pass level and keep your knuckles in line with your forearms."),
       "elbows": ("Elbow Position",
                  "The upper arms hang straight down beside the pad and stay there.",
                  "With the upper arms still, bending the elbows is the only motion, so the elbow flexors lift the dumbbells. Letting the elbows drift forward brings the front deltoids in and turns the top of the curl into a front raise.",
                  "Elbows drifting forward and up as the dumbbells reach the top.",
                  "Keep your elbows hanging under your shoulders, just outside the pad, and finish with the dumbbells in front of your shoulders."),
       "range": ("Range of Motion",
                 "Each rep starts with the arms almost straight beside the seat.",
                 "The bottom of the curl is its lightest part, so it is the easiest to cut short. Lowering until the arms are almost straight works the elbow flexors through nearly all of their range, and " + FULL_RANGE + ".",
                 "Short reps that turn round with the elbows still well bent.",
                 "Lower until your arms are almost straight at your sides, then curl both dumbbells together again without a bounce."),
       "lower": ("Lowering Speed",
                 "Curl up in about a second and lower in about one and a half.",
                 "The lowering half works the elbow flexors too: in training studies, lowering-only work has built about as much muscle as lifting-only work. Reps lasting from half a second to about eight seconds have built similar muscle, so the aim is control, not a slow count.",
                 "Letting the dumbbells drop so the arms snap straight at the bottom.",
                 "Pause briefly at the top, then lower both dumbbells under control, turning the palms back in as they come down."),
   },
   # Paint as the Strict Curl. Biceps 0.84 as the library's Alternating
   # Dumbbell Curl (the same palms-in start turned up as the weight rises);
   # brachioradialis 0.44 as the 1-50 Dumbbell Curl. Judgement calls: no EMG
   # of a back-supported seated curl exists.
   activation=act(0.84, 0.44),
   stabilisers=["anterior deltoid", "upper trapezius", "middle trapezius"],
   comparison=("ROCKING OFF THE PAD", "Back on the pad, arms move alone", "Trunk rocks forward, then back",
               "With your back on the pad, the trunk stays still and the elbow flexors lift both dumbbells the whole way.",
               "Rocking off the pad swings the dumbbells up with the trunk, so the elbow flexors skip the heaviest part of the rep."),
   glows=arm_glows(N, 0.05, 0.07))

SETUP[N] = [
    "Set the bench back almost upright and sit at the back of the seat.",
    "Rest your upper back on the pad, feet flat in front of you.",
    "Hold a dumbbell in each hand at your sides, palms facing in.",
    "Curl both together, palms turning up as they rise.",
]
