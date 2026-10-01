# Trainer content for the redone "190-280 🟢" folder (2026-09-30), family:
# machinecurl. One new exercise, 264 Machine Preacher Curl (model
# Biceps/MachinePreacherCurl). Same format as spec.py; spec_280.py imports
# this module and gen.py reads SPEC / SETUP. notes_280_machinecurl.md maps
# the copy's claims to the sources below and records the model facts.
#
# What the model shows, from the brief (SCRATCH/briefs22/new/
# MachinePreacherCurl.md), the trainer stills at 0/1/2/3/5 s, the highlight
# tiers (SCRATCH/highlight_tiers22.json), joints.json and the rig and
# machine read from the USD with Blender's Python + pxr (the app's Y-up
# space, the lifter facing +z, their left +x; one body shared with the other
# curls, torso neck to pelvis 0.592 m):
# - Equipment: Q191_CurlMachine, the plate-stack curl machine of the Machine
#   Biceps Curl and the Single-Arm Machine Curl, with its arm pad and pivots
#   set higher and further forward: pivot hubs (one each side, outside the
#   arms, x +-0.38) centred 0.939 m up (Machine Biceps Curl 0.907 m) and
#   3.9 cm further forward; the arm pad's top runs from 0.982 m at its back
#   edge to 0.904 m at its front, a 27° slope (Machine Biceps Curl 31°, 4-5
#   cm lower), 0.66 m wide, on a centre post. One lever (two side arms and a
#   straight handle with a grip each side of centre) turns about the hubs;
#   the stack (ten plates and a top plate, no pin or cable modelled) rises
#   25 cm, at a steady ~2.5 mm per degree of lever turn, and hangs 7 cm above
#   the tower base at the bottom. No cam or cable is drawn, so the copy makes
#   no claim about where the machine is heaviest.
# - Seat: seated upright on the machine's seat (0.51 m up), knees 111°, hips
#   101°, feet flat, ankles 0.38 m apart; trunk 12° forward and still all
#   clip, the chest against (in the model partly inside) the back of the pad.
# - Pad angle and upper arms: the upper arms slope 45° below horizontal (57°
#   of shoulder flexion from the trunk; the Machine Biceps Curl's slope 55°
#   below horizontal, i.e. steeper) and never move (shoulders fixed). The
#   backs of the upper arms lie along the whole pad (the skinned triceps
#   within 1.5 cm of its top from back edge to front), pressed ~2.5 cm into
#   its back half by the armpits; the humerus slopes 45°, steeper than the
#   27° pad, because the arm thins toward the elbow. The armpits sit over
#   the pad's top edge (shoulder joints 16 cm above it); the elbows sit at
#   its front edge (elbow z 0.008, pad front z 0.013).
# - Model artifact: the pad's back ~8 cm (z -0.165 to -0.08) sits inside
#   the lifter's lower chest and upper abs (skinned rectus abdominis,
#   obliques and lower pectoralis fill the pad's full 4 cm thickness there).
#   The copy's "chest to the pad" still holds; flagged for the user.
# - Grip: both hands underhand on the straight handle, palms up (facing the
#   shoulders at the top), hands 0.40 m apart straight in front of the
#   shoulders (shoulder joints 0.39 m apart), wrists straight (0°) all clip.
# - Elbows: both together, 162° (almost straight) to 62°, the forearms from
#   27° below horizontal to 72° above, the handle at about face height at the
#   top; the elbows stay on the lever's pivot axis (within 1 mm) all clip.
#   Two identical reps in 7.96 s: still to 0.3 s, up ~1.3 s (0.3-1.58 s), the
#   top held ~0.4 s (1.58-2.0 s), down ~1.75 s (2.0-3.75 s), ~0.5 s still at
#   the bottom, then again from 4.3 s.
# - Framing (yaw -1.0, zoom 1.032, the app's): from the front-left; the head
#   at (0.62, 0.19), the near (left) shoulder at (0.74, 0.26) on the right,
#   the arms reaching screen-left over the pad. The hands sweep from (0.26,
#   0.42) and (0.43, 0.41) at the bottom to (0.37, 0.25) and (0.54, 0.23) at
#   the top, the handle bar running out to u ~0.15 at the bottom and up to
#   v ~0.20 at the top; the near elbow at (0.59, 0.35), the near pivot hub at
#   ~(0.69, 0.34); the stack at the left edge (rising through v 0.43-0.78),
#   the machine's post down the left; legs below v ~0.45, the seat at the
#   right at v ~0.57-0.61.
# - Highlight tiers: the biceps (long and short heads) and the brachialis
#   bright = PRIMARY; the brachioradialis and the wrist and finger flexors
#   and extensors (ECRB, ECRL, ECU, ED, FCR, FDP, FDS, PL) dim = SECONDARY,
#   named "Brachioradialis" and one "Forearms" row, as in the 1-50 curls.
#
# How it differs from its neighbours in the library: the Machine Biceps
# Curl is the same machine, body, timing and elbow range with the pad and
# pivots lower and the upper arms steeper (55° below horizontal); the
# Single-Arm Machine Curl works the left arm only; the Preacher Curl (EZ
# bar), Barbell, Dumbbell and Cable Preacher Curls and the Preacher Hammer
# Curl are free weights or a cable on a preacher bench. The cue set here is
# its own: elbows on the pivots, arms kept down on the pad, palms up, the
# bottom of the rep with the plates still lifted, and a controlled two-second
# lowering (the comparison), in place of the torso and seat cues the others
# carry.
#
# Sources (abstracts read on PubMed 2026-09-30 unless noted; details and
# quotes in notes_280_machinecurl.md):
# - ExRx.net, Lever Preacher Curl (WeightExercises/Brachialis/LVPreacherCurl;
#   the live site returns 403, read on the Wayback Machine snapshot of
#   2023-12-04): sit on the curl machine with the backs of the arms on the
#   pad, underhand grip, elbows aligned with the lever's fulcrum; lower until
#   the arms are fully extended; seat set so the armpit rests near the top
#   of the pad, the back of the upper arm on the pad throughout. Target
#   brachialis; synergists biceps brachii, brachioradialis; stabiliser wrist
#   flexors.
# - StrengthLog, Machine Biceps Curl (strengthlog.com/machine-bicep-curl,
#   fetched 2026-09-30): upper arms on the padding, elbows in line with the
#   machine's joint; underhand grip about shoulder-width; the whole movement
#   at a controlled speed; stop just before the weights hit the stack.
#   StrengthLog, The Best Machine Exercises (strengthlog.com/
#   best-machine-exercises, fetched 2026-09-30): the machine curl locks the
#   upper arm in place and makes it almost impossible to use the shoulders
#   or swing the back.
# - Coratella G, Tornatore G, Longo S, Esposito F, Cè E 2023, J Funct Morphol
#   Kinesiol 8(1):13, doi:10.3390/jfmk8010013, PMID 36810497 — ten
#   competitive bodybuilders, standing barbell curls with the arms flexed
#   forward or not: the anterior deltoid's excitation differed with arm
#   flexion (higher when flexing, full text PMC9944112). The biceps was also
#   more excited in the lifting phase with the arms flexed (+17.7% straight
#   bar, +20.3% EZ bar), so the copy never says lifting the elbows takes
#   work off the biceps.
# - Coratella G, Tornatore G, Longo S, Toninelli N, Padovan R, Esposito F,
#   Cè E 2023, Sports 11(3):64, doi:10.3390/sports11030064, PMID 36976950 —
#   ten competitive bodybuilders, standing bilateral cable curls (a bar palms
#   up or down, a rope for neutral), 6-rep sets at the 8RM load: in the
#   lifting phase biceps excitation was greater with the supinated than the
#   pronated (+19%) or neutral (+12%) grip (no biceps difference in the
#   lowering phase); the grips need different anterior deltoid work to
#   stabilise the humeral head. The brachialis was not recorded ("only
#   detectable through wire electrodes").
# - Mogk JPM, Keir PJ 2003, Ergonomics 46(9):956-975,
#   doi:10.1080/0014013031000107595, PMID 12775491 — a flexed wrist cut
#   maximum grip force by 40-50%.
# - Pinto RS, Gomes N, Radaelli R, Botton CE, Brown LE, Bottaro M 2012, J
#   Strength Cond Res 26(8):2140-2145, doi:10.1519/JSC.0b013e31823a3b15,
#   PMID 22027847 — 40 young men with no resistance training experience
#   (full text), bilateral preacher curls, palms up (the 1RM tested with a
#   curling bar), 0-130° vs 50-100°, 10 weeks: 1RM +25.7% vs +16.0% (full
#   greater); elbow-flexor thickness rose in both (9.65% vs 7.83%).
# - Pedrosa GF, Simões MG, Figueiredo MOC, Lacerda LT, Schoenfeld BJ, Lima
#   FV, Chagas MH, Diniz RCR 2023, Sports 11(2):39,
#   doi:10.3390/sports11020039, PMID 36828324 — 19 untrained young women,
#   seated dumbbell preacher curl, one arm 0-68° (0° = straight), the other
#   68-135°: more 1RM gain and more distal biceps CSA (70% of humerus) with
#   the initial range; CSA at 50% and summed CSA similar.
# - Sato S, Yoshida R, Kiyono R, Yahata K, Yasaka K, Nunes JP, Nosaka K,
#   Nakamura M 2021, Front Physiol 12:734509, doi:10.3389/fphys.2021.734509,
#   PMID 34616309 — 32 non-resistance-trained young adults, one-arm curls on
#   a preacher bench: 0-50° raised torque and muscle thickness (8.9% vs
#   3.4%) more than 80-130°.
# - Schoenfeld BJ, Ogborn DI, Vigotsky AD, Franchi MV, Krieger JW 2017, J
#   Strength Cond Res 31(9):2599-2608, doi:10.1519/JSC.0000000000001983,
#   PMID 28486337 — meta-analysis of 15 studies: eccentric-only training
#   grew muscle a little more than concentric-only (10.0% vs 6.8%, not
#   significant, p = 0.076); both are effective and belong in a programme.
# - Schoenfeld BJ, Ogborn DI, Krieger JW 2015, Sports Med 45(4):577-585,
#   doi:10.1007/s40279-015-0304-0, PMID 25601394 — meta-analysis of eight
#   studies whose sets went to muscle failure: similar hypertrophy with
#   repetition durations (the whole rep, lifting plus lowering) from 0.5 to
#   8 s.
# - Kawakami Y, Nakazawa K, Fujimoto T, Nozaki D, Miyashita M, Fukunaga T
#   1994, Eur J Appl Physiol Occup Physiol 68(2):139-147,
#   doi:10.1007/BF00244027, PMID 8194543 — MRI of four men: the brachialis
#   was estimated (from PCSA and moment arms) to contribute 47% of maximal
#   elbow-flexor torque, the biceps 34%, the brachioradialis 19%. A capacity
#   estimate, not activation during any exercise (activation row only).
# - Date S, Kurumadani H, Nakashima Y, Ishii Y, Ueda A, Kurauchi K, Sunagawa
#   T 2021, Front Physiol 12:809422, doi:10.3389/fphys.2021.809422, PMID
#   35002781 — six men, unloaded elbow flexion, surface vs fine-wire EMG:
#   the brachialis has its own EMG pattern, distinct from both biceps heads
#   (activation row only: it shows the muscle is active in elbow flexion,
#   not how hard).
# - Boland MR, Spigelman T, Uhl TL 2008, J Hand Surg Am 33(10):1853-1859,
#   doi:10.1016/j.jhsa.2008.07.019, PMID 19084189 — fine-wire EMG: the
#   brachioradialis is active in elbow flexion whatever the forearm position
#   (activation row only).
from common_1_50 import *

N = "Machine Preacher Curl"

ex(name=N, var="machinePreacherCurl",
   # From the front-left (yaw -1.0): the head and near shoulder on the
   # right, the hands and handle sweeping the middle-left of the frame
   # (v ~0.20-0.45, u ~0.15-0.62), so the labels keep out of that band. The
   # grip label sits on the top-left row above the fists at the top of the
   # rep (their tops at v ~0.17; the pill 0.103-0.145 after the squeeze),
   # where no button sits. It is kept short (the pill u 0.02-0.34 with the
   # app's edge clamp) because the grip mistake turns the lifter side-on and
   # lifts it, which puts both fists and the handle at u 0.42-0.49, v
   # 0.085-0.18, under where a longer pill would reach. The pad label is
   # short so it starts right of the head (u 0.732, the head ends at
   # ~0.68). The pivot label sits right of the body below the hips (on the
   # range row), its leader running up to the near elbow: at hip height the
   # seat-too-low ghost's lowered hips and thighs (v ~0.45-0.49 in its side
   # view) would be drawn across the pill.
   # Range and lowering sit below the handle's lowest point on the left
   # (the fists' bottoms at v ~0.45). The lowering cue tracks the far elbow,
   # which stays put (its red ring, with no ghost, marks the joint that
   # snaps straight), and its pill is the longer one, so its leader runs
   # straight up past the range pill's end (~0.02 clear with the app's edge
   # clamp) instead of through it; the grip leader has the near wrist.
   overrides={"grip": (0.10, "leading"), "pad": (0.14, "trailing"), "pivot": (0.56, "trailing"),
              "range": (0.56, "leading"), "lower": (0.68, "leading")},
   annotations=[
       ("pivot", "Elbows on the pivots", "forearm_L"),
       ("pad", "Arms on pad", "upper_arm_L"),
       ("grip", "Wrists straight", "hand_L"),
       ("range", "Arms almost straight", "hand_R"),
       ("lower", "Lower over two seconds", "forearm_R"),
   ],
   # Cue titles are neutral topic names, as across the app: the trainer's
   # mistake banner reads "COMMON MISTAKE · <TITLE>", so a title that states
   # the correct form ("Palms Up", "Upper Arms Down", "Elbows on the
   # Pivots") read as if that were the mistake (seen on the app's fault
   # screenshots, 2026-09-30).
   cues={
       "pivot": ("Pivot Alignment",
                 "Each elbow lines up with the lever's pivot on that side.",
                 "The lever turns about those two pivots. With the elbows on the same axis, the handle travels the same arc as the hands, so it stays put in the palms from bottom to top; with the elbows off the axis, the handle slides along the hands as it turns.",
                 "The seat set too low, the elbows sitting below the pivots so the handle slides along the palms as it turns.",
                 "Before the first set, raise or lower the seat until both elbows sit level with the round pivots at the sides of the pad, then check again with the handle in your hands."),
       "pad": ("Upper Arm Position",
               "The backs of the upper arms stay on the pad, the armpits over its top edge.",
               "With the backs of the upper arms resting on the pad, sloping down at about 45°, the elbows are the only joints that move. Lifting the elbows as the handle rises raises the upper arms, which brings the front of the shoulders into the lift and takes the elbows off the pivots.",
               "The elbows lifting off the pad as the handle nears the top, the upper arms rising with it.",
               "Keep the elbows heavy on the pad from the first rep to the last and move only the forearms; if the elbows start to lift, take some weight off the stack."),
       "grip": ("Grip and Wrists",
                "Palms up on the straight handle, wrists straight.",
                "In trained lifters, curls with the palms turned up have worked the biceps harder on the way up than palm-in or palm-down curls. Curling the wrists in moves the handle with the wrists instead of the elbows, and a bent wrist grips far more weakly.",
                "At the top, the wrists bending in so the handle tips back toward the face.",
                "Hold the handle underhand with the hands straight in front of the shoulders and keep the knuckles in line with the forearms from bottom to top."),
       "range": ("Bottom of the Rep",
                 "Each rep starts with the arms almost straight and the plates still lifted.",
                 "The almost-straight bottom of the curl is the part half reps leave out. In new lifters on preacher curls, training that lower part has built more strength, and at least as much muscle, as training only the upper part, and full-range reps more strength than partial ones.",
                 "Turning each rep back up while the forearms are still angled up, so the plates stop well short of touching down.",
                 "Lower until the forearms slope down past level and the arms are almost straight, stopping just before the plates touch down, then curl again without a bounce."),
       "lower": ("Lowering Speed",
                 "Take about two seconds to lower the handle.",
                 "The lowering half works the elbow flexors too: in training studies, lowering-only work has built about as much muscle as lifting-only work, or a little more. In sets taken to failure, reps lasting from half a second to about eight seconds have built similar muscle, so the aim is control, not a slow count.",
                 "Letting the stack drop, the handle falling back and the arms snapping straight at the bottom.",
                 "Curl up in about a second, hold the top for a moment, then take about two seconds to lower without letting the plates touch down."),
   },
   # Activation follows the paint: biceps and brachialis bright (PRIMARY),
   # brachioradialis and forearm muscles dim (SECONDARY). The biceps and
   # brachioradialis keep the app's machine-curl values (0.84, 0.38; no EMG
   # study of this machine was found); the brachialis moves from the
   # siblings' secondary 0.66-0.68 to a HIGH primary 0.72: ExRx (editorial)
   # names it the target of this lever preacher curl, and Kawakami 1994
   # (MRI, four men) estimated it the largest share of maximal elbow-flexor
   # torque (47% vs the biceps' 34%, from PCSA and moment arms, not
   # activation). Keeping it below the biceps is a house choice that matches
   # the other machine and preacher curls (biceps 0.84); no study measured
   # the two on this lift (Coratella 2023 Sports compared the biceps across
   # grips only and did not record the brachialis). StrengthLog's machine
   # curl page names only the biceps and forearm flexors, not the
   # brachialis. Forearms 0.30: the 1-50 curls' house value (the
   # grip on the handle; ExRx lists the wrist flexors as stabilisers).
   activation=[("Biceps Brachii", P, HI, 0.84), ("Brachialis", P, HI, 0.72),
               ("Brachioradialis", S, LOW, 0.38), ("Forearms", S, LOW, 0.30)],
   stabilisers=["anterior deltoid", "rotator cuff", "core"],
   comparison=("LETTING THE STACK DROP", "Two seconds down, plates lifted", "Handle drops, arms snap straight",
               "Lowering under control, about two seconds here, keeps the elbow flexors working through the lowering half, which builds muscle about as well as the lift.",
               "Letting the stack fall hands the lowering half to the machine and ends each rep with the elbows snapping straight."),
   # Both arms work, so both biceps glow at full strength; softer, the
   # brachialis and brachioradialis at the near elbow.
   glows=[glow(N, ["upper_arm_L", "forearm_L"], A, 0.55, 0.06, 0.05),
          glow(N, ["upper_arm_R", "forearm_R"], A, 0.55, 0.06, 0.05),
          glow(N, ["forearm_L"], SOFT, 0.30, 0.045, 0.04)])

SETUP[N] = [
    "Set the seat so your elbows sit level with the pivots on each side.",
    "Sit with your chest to the pad and your armpits over its top edge.",
    "Rest the backs of your upper arms on the pad's slope.",
    "Take the straight handle underhand, hands in front of your shoulders.",
    "Start with your arms almost straight.",
]
