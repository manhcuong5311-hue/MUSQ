# Trainer content for exercises 1-50 redone (2026-09-29), family "compound":
# 015 Pendlay Row and 050 Close-Grip Bench Press from the HIKSEMI drive's
# "1-100 🟢" folder (models Back/PendlayRow, Triceps/CloseGripBenchPress).
# Same format as spec.py, on top of common_1_50.py; spec_1_50.py collects
# this family with the others. notes_1_50_compound.md maps every claim in
# the copy to the sources below and lists the model facts it relies on.
#
# What each model shows, from the rig (joint angles, hand and bar positions
# every 0.5 s in briefs_1_50/*.md, finer probes of the bar, skinned-mesh
# gaps and joint positions with Blender's Python) and the trainer stills
# (SCRATCH/shots/view/<slug>_t{0,1,2,3,5}.png). Both clips are two reps in
# 8 s. Torso length (neck to pelvis joint) 0.59 m in both.
#
# - Pendlay Row (PendlayRow, yaw -2.0, zoom 0.803: from behind on the
#   lifter's left, ~25° past a side view; the lifter faces screen-left, the
#   head at u 0.44, v 0.34, the hips on the right at u 0.83, the near (left)
#   plate on the left of the frame, the far plate behind the legs). A 2.2 m
#   barbell with 45 cm plates. Feet about hip-width (ankles 0.28 m apart),
#   toes forward. Knees bent to 84°, hips 50°, the pelvis 0.61 m up, the
#   trunk 70° from vertical (about 20° above level), head in line. Nothing
#   but the arms and the bar moves: every other joint, the shoulder, collar
#   bone and shoulder-blade joints included, holds its position to the
#   millimetre for the whole clip (so the model shows no shoulder-blade
#   squeeze; the shoulders stay set). Overhand grip (palms facing back and
#   down), the wrists 0.62 m apart, ~12 cm outside each shoulder joint (wider
#   than the shoulders: ExRx's wide overhand grip, not its shoulder-width
#   one); wrists 2-13° flexed. At 0 s and 4 s the plates are at their lowest,
#   3.6 cm above the floor (shoe soles at 0.001 m), the bar ~23 cm in front
#   of the toes, about under the shoulders (the wrists 6 cm ahead of the
#   shoulder joints), elbows 127° (the arms never straighten). The pull
#   (0-1.25 s) lifts the bar 24 cm and brings it 20 cm back toward the body;
#   held 1.25-1.9 s with the bar just under the lower chest (bar axis 6 cm
#   from the sternal pec surface) and brushing the thighs just above the
#   knees, elbows 64-66°, the upper arms 14° behind the trunk line and
#   12-21° out from the sides; lowered 1.9-4.0 s; no pause at the floor (the
#   bar is within 1 cm of its lowest point for ~0.3 s, 3.83-4.17 s, then
#   rises again). Highlight: bright rear deltoid, infraspinatus, teres minor,
#   supraspinatus, subscapularis, rhomboid major and the upper, middle and
#   lower trapezius; dim both biceps heads, brachioradialis, the forearm
#   flexors and extensors, palmaris longus and latissimus dorsi.
# - Close-Grip Bench Press (CloseGripBenchPress, the bench lifts' .bench
#   framing: yaw -1.0, zoom 0.66: from the lifter's left, the feet on the
#   left of the frame, the head on the right, the bar across above the
#   chest). A flat bench (pad 0.36 m wide, top 0.53 m up), no rack. Head,
#   upper back and hips on the pad; feet flat on the floor, set wide: ankles
#   0.54 m apart (the shoulder joints are 0.39 m apart, the hip joints
#   0.18 m) and ahead of the knees (knees 129°). Overhand grip, the wrists
#   0.38 m apart, directly above the shoulder joints (about shoulder width,
#   ~95-100% of the shoulder breadth). Elbows 33° at the bottom (0 s, 4 s),
#   142° at the top (1.33-1.5 s): the model stops ~40° short of straight
#   arms. The upper arms stay 2-10° out from the sides; at the bottom the
#   elbows point toward the hips, 26 cm down the body from the shoulders,
#   just below the bench top beside it (the near elbow stays in view at the
#   bench edge; the far one is hidden behind the torso at the bottom). The
#   bar touches the lower chest (~13 cm toward the feet from the shoulder
#   joints, 4-5 cm above the pec's lower edge) and is pressed up and 13 cm
#   back to finish directly over the shoulder joints (a J path, 42 cm of
#   vertical travel). Wrists bent back 20-51° (-33° at the bottom, -51°
#   mid-descent, -20° at the top), so no cue asks for straight wrists. Up
#   0-1.33 s, held to 2.0 s, lowered over ~2 s, touch and go at the chest.
#   Highlight: the three triceps heads bright; the clavicular, sternal and
#   abdominal pec and the anterior deltoid dim.
#
# Sources (each checked; notes_1_50_compound.md maps the claims to them):
# - StrengthLog, How to Do Pendlay Row: Muscles Worked & Proper Form
#   (strengthlog.com/pendlay-row, read 2026-09-29): primary lats, trapezius,
#   rear deltoids; secondary biceps, lower back, forearm flexors, rotator
#   cuff; hinge and grip overhand, pull without otherwise moving the upper
#   body, "as high as you can, so that it touches your abs or chest if
#   possible", lower with control back to the floor; a variant of the barbell
#   row in which the upper body stays fixed (only the bar and the arms move)
#   and the bar goes back on the floor between reps, sparing some static work
#   for the core and lower back while each rep rebuilds tension.
# - ExRx.net, Barbell Bent-over Row (WeightExercises/BackGeneral/
#   BBBentOverRow, Internet Archive snapshot 2024-12-26): "Also known as
#   Pendlay Row"; grasp the bar with a wide overhand grip, pull to the upper
#   waist; torso may be kept horizontal for strict execution; knees bent to
#   keep the low back straight, and if it rounds, bend the knees more or
#   don't position the torso as low; a shoulder-width or underhand grip can
#   increase lat involvement, while a wide overhand grip works the whole back
#   and slightly emphasises the rear delt, infraspinatus and teres minor;
#   target back, general; synergists middle and lower trapezius, rhomboids,
#   latissimus dorsi, teres major, posterior deltoid, infraspinatus, teres
#   minor, brachialis, brachioradialis; stabilisers erector spinae,
#   hamstrings, gluteus maximus.
# - Fenwick CMJ, Brown SHM, McGill SM 2009, J Strength Cond Res 23(5):
#   1408-1417, doi 10.1519/JSC.0b013e3181b07334, PMID 19620925 — 7 healthy
#   men, inverted, standing bent-over and one-arm cable rows: the bent-over
#   row produced large, symmetrical activation across the back but the
#   largest lumbar spine load of the three. (spec_131_160.py cites it as
#   23(2):350-358; that is wrong, see the notes.)
# - Moseley JB, Jobe FW, Pink M, Perry J, Tibone J 1992, Am J Sports Med
#   20(2):128-134, doi 10.1177/036354659202000206, PMID 1558238 — indwelling
#   EMG of eight scapular muscles (upper, middle and lower trapezius,
#   levator scapulae, rhomboids, pectoralis minor, middle and lower serratus
#   anterior) in 9 healthy subjects doing 16 shoulder rehabilitation
#   exercises: scaption, rowing, push-up with a plus and press-up make up the
#   core of a scapular strengthening program.
# - Lehman GJ 2005, J Strength Cond Res 19(3):587-591, doi 10.1519/R-15024.1,
#   PMID 16095407 — isometric bench press holds: moving from wide to narrower
#   grips raised triceps (lateral head) activity and lowered the sternal pec;
#   the changes were small.
# - Larsen S, Gomo O, van den Tillaar R, Front Sports Act Living 2020;
#   2:637066 (published online 22 Jan 2021), doi 10.3389/fspor.2020.637066,
#   PMID 33554113 — 1-RM bench press at 1.0 (narrow, 0.40 m), 1.4 and 1.7
#   times the shoulder (biacromial) width: the narrow grip kept the
#   shoulders less abducted than the medium and wide grips in every phase,
#   the wide and medium grips produced larger horizontal shoulder moments in
#   the sticking region, medial triceps activity was higher with the medium
#   and narrow grips than the wide one, pec and anterior deltoid did not
#   differ; 103.7 vs 108.9 vs 109.8 kg (narrow, medium, wide). Compares grip
#   widths, not elbow positions at one grip.
# - Mausehund L, Werkhausen A, Bartsch J, Krosshaug T 2022, J Strength Cond
#   Res 36(10):2685-2695, doi 10.1519/JSC.0000000000003948, PMID 33555823 —
#   35 strength-trained adults, 6-8RM sets: medium, wide, and narrow grips
#   (~112% of biacromial width) with the elbows in (BPNI) and with the
#   elbows out, ~45° shoulder abduction at the bottom (BPNO). At the narrow
#   grip, flaring left pec (sternal 51.5 vs 50.3, clavicular 59.6 vs 56.3,
#   abdominal 54.6 vs 53.7 %MVIC) and triceps EMG unchanged and raised the
#   elbow net joint moments 7-11% (peak normalised elbow moment up to 14%);
#   shoulder abduction at the bottom was 37.9° with the elbows in, 56.5°
#   with them out, no different from the medium grip's 59.3°. Narrow and
#   medium grips gave up to 15% more lateral-triceps EMG than the wide grip
#   ("relatively small"); narrowing the grip raised anterior-deltoid and
#   clavicular-pec EMG and elbow range of motion; the buttocks stayed on the
#   bench and the feet against the floor.
# - Saeterbakken AH, Stien N, Pedersen H, Solstad TEJ, Cumming KT, Andersen V
#   2021, Int J Environ Res Public Health 18(12):6444, doi
#   10.3390/ijerph18126444, PMID 34198674 — 6-RM bench press, narrow,
#   medium and wide grips: narrow 6.6-8.4% lighter; triceps lower with the
#   wide grip than the medium and narrow ones (in trained men 10.6% below
#   medium), narrow and medium the same (p = 0.897, all subjects);
#   pectoralis activity similar across the three widths; narrow grip, all
#   subjects: triceps 70.3, anterior deltoid 90.0, clavicular pec 88.0,
#   sternal pec 100 %MVIC; head, shoulders and buttocks on the bench.
# - Tanimoto M, Arakawa H, Sato M, Nagano A 2023, Sports 11(8):154, doi
#   10.3390/sports11080154, PMID 37624134 — 10-RM with 40 cm and 81 cm grips:
#   the pectoralis-to-triceps EMG ratio was almost unchanged by hand width.
# - Stastny P et al. 2017, PLoS One 12(2):e0171632, doi
#   10.1371/journal.pone.0171632, PMID 28170449 — systematic review of bench
#   press EMG (the standard grip): triceps and pectoralis major similarly
#   active, both clearly more than the anterior deltoid.
# - Lockie RG et al. 2017, Sports 5(3):46, doi 10.3390/sports5030046, PMID
#   29910406 — 1-RM close-grip bench press at 95% of shoulder (biacromial)
#   width vs the preferred grip: 5% less load; the close grip "is typically
#   performed to place greater emphasis on the triceps brachii", with less
#   shoulder abduction; bar travel 0.43 vs 0.41 m (longer with the close
#   grip); touch and go, head, shoulders and buttocks flat on the bench,
#   feet flat on the floor.
# - Madsen N, McLaughlin T 1984, Med Sci Sports Exerc 16(4):376-381, doi
#   10.1249/00005768-198408000-00010, PMID 6493018 — film of 19 expert and
#   17 novice benchers: the experts lowered the bar more slowly and used a
#   bar path closer to the shoulders.
# - Muyor JM et al. 2019, PLoS One 14(6):e0218209, doi
#   10.1371/journal.pone.0218209, PMID 31199829 — bench press at 60% 1RM, a
#   150% biacromial grip, with the feet on the floor vs held up (hips and
#   knees at 90°): every measured muscle, the abdominals included, worked
#   harder with the feet up, which the authors put down to the instability
#   of pressing without the feet's support (and the abdominals' rise to the
#   need to stabilise the core).
# - ExRx.net, Barbell Close Grip Bench Press (WeightExercises/Triceps/
#   BBCloseGripBenchPress, snapshot 2024-12-26): shoulder-width grip; lower
#   to the chest with the elbows close to the body; "Grip can be slightly
#   narrower than shoulder width but not too close. Too close of grip can
#   decrease range of motion, may tend to hyper-adduct wrist joint, and
#   unnecessarily decrease stability of bar" (the range-of-motion part is
#   not used: Lockie and Mausehund measured longer travel with closer
#   grips); target triceps, synergists anterior deltoid, sternal and
#   clavicular pec, coracobrachialis; dynamic stabiliser biceps.
# - ExRx.net, Bench Press Analysis (Kinesiology/BenchPress, snapshot
#   2025-02-01), expert opinion without a study for these points:
#   retracting the shoulder blades forms a more stable base against the
#   bench and decreases anterior forces through the shoulder at the bottom;
#   feet apart on the floor give a more stable base; the bar rises to over
#   the shoulders in a J path. (Its "may" / "is thought to" lines on elbow
#   position and pec versus triceps are not used; Mausehund 2022 measured
#   it.)

from common_1_50 import *

# ---------------------------------------------------------------- pendlay row

ex(name="Pendlay Row", var="pendlayRow",
   # From behind on the left (yaw -2.0): the lifter fills the middle band
   # (v 0.29-0.66), head on the left at u 0.34-0.47, hips on the right, the
   # near plate sweeping up and back on the left (u 0.07-0.51, v 0.37-0.66).
   # The two upper-body labels share the top row, one each side: the torso
   # leader passes right of the head to the chest, the flat-back leader
   # drops onto the lower back from above. The shoulders label sits a row
   # lower on the left, clear of the head and the torso leader, its leader to
   # the near shoulder blade; it is kept short (Shoulders back) because in
   # the mistake view, where the lifter shrinks and rises, the longer
   # Shoulders held back pill covered the back of the head on the
   # simulator. The floor and pull labels sit bottom left below the
   # plate's lowest point: floor higher, its leader rising almost straight
   # up to the near wrist on the bar, just inside the near plate at the
   # bottom of the rep (the floor fault's moment); pull lower, its leader
   # to the near elbow, which drives up past the back at the top, passing
   # right of the floor pill's end. (The floor label used to track the far
   # wrist and the pull label the near one: the far wrist is hidden behind
   # the near leg all rep, so on the simulator the floor dot sat on the near
   # knee at the bottom and mid-thigh at the top, never on the bar.) No
   # leader crosses another leader or a pill; the floor row sits a little
   # above the evenly spaced 0.77, leaving more room above the pull pill.
   overrides={"torso": (0.14, "leading"), "spine": (0.14, "trailing"), "shoulders": (0.23, "leading"),
              "floor": (0.75, "leading"), "pull": (0.86, "leading")},
   annotations=[
       ("torso", "Back near level, still", "chest"),
       ("spine", "Flat back, knees bent", "spine"),
       ("floor", "Bar back to the floor", "hand_L"),
       ("pull", "Row to the lower chest", "forearm_L"),
       ("shoulders", "Shoulders back", "scapula_L"),
   ],
   cues={
       "torso": ("Torso Angle",
                 "The back stays close to level and still; only the arms and the bar move.",
                 "Keeping the upper body still is part of what sets the Pendlay row apart: the arms and the bar are the only things that move, and a torso held close to level is the strict way to row a barbell. Lifting the chest to start each pull can let the hips and lower back swing the bar up instead of the upper back rowing it.",
                 "The chest lifting toward upright on each rep to heave the bar off the floor.",
                 "Set your back close to level before the first pull and hold that angle for every rep, moving only your arms."),
       "spine": ("Flat Back",
                 "The back stays flat from the hips to the neck, with the knees bent well to let it.",
                 "Of three rows compared in one study, the standing bent-over row worked the muscles across the back hard on both sides but put the largest load on the lower spine. Bending the knees lets the hips hinge low without the lower back rounding; if it still rounds, bend the knees more or do not take the torso as low.",
                 "The lower back rounding and the head dropping to reach the bar on the floor.",
                 "Brace before each pull, keep your chest out and your back flat, and bend your knees as much as you need to reach the bar that way."),
       "floor": ("Back to the Floor",
                 "The bar comes back down to the floor at the end of every rep.",
                 "Setting the bar back on the floor between reps is the other thing that sets the Pendlay row apart from a regular bent-over row. When it rests there, the lower back is not holding it out in front for the whole set, and each rep starts by building tension again.",
                 "Stopping the plates short of the floor and pulling again, which turns the set into a bent-over row.",
                 "Lower the bar with control until the plates reach the floor, then pull the next rep from there."),
       "pull": ("Pull Height",
                "The bar rises to just under the chest, the elbows driving back past the torso.",
                "Pendlay row guides teach a pull as high as you can, until the bar touches the upper stomach or chest if possible. Stopping the bar half-way, well short of the chest, makes every rep a partial that leaves out the end of the pull.",
                "Stopping the bar about half-way up, out in front of the knees, and letting it drop again.",
                "Drive your elbows back and up until the bar is just under your lower chest, then lower it."),
       "shoulders": ("Shoulder Position",
                     "The shoulders stay set, held back, while the arms row.",
                     "The middle and lower trapezius and the rhomboids pull the shoulder blades back, and an EMG study of the shoulder-blade muscles named rowing as one of four core exercises for strengthening them. Keeping the shoulders set gives the pull a fixed base; rounding them toward the floor lets the shoulder blades slide forward around the ribs instead.",
                     "The shoulders rounding forward toward the floor, the upper back hunched over the bar.",
                     "Pull your shoulders back and down before the first pull and hold them there, rowing with the elbows."),
   },
   # Bright on the model: the trapezius (all three parts), rhomboids, rear
   # deltoid and the rotator cuff (infraspinatus, teres minor,
   # supraspinatus, subscapularis); dim: the lats, biceps and forearms. The
   # model's grip is wider than the shoulders, the wide overhand grip ExRx
   # says slightly emphasises the rear delt, infraspinatus and teres minor
   # (a shoulder-width or underhand grip would bring in more lat).
   # StrengthLog lists the lats with the trapezius and rear delts as primary
   # (flagged in the notes); ExRx lists them all as synergists. Fractions are
   # estimates: no study has measured these muscles together in a Pendlay
   # row.
   activation=[("Trapezius", P, HI, 0.82), ("Rhomboids", P, HI, 0.78), ("Posterior Deltoid", P, HI, 0.74),
               ("Rotator Cuff", P, MOD, 0.60), ("Latissimus Dorsi", S, MOD, 0.58), ("Biceps Brachii", S, MOD, 0.46),
               ("Forearms", S, LOW, 0.30)],
   stabilisers=["erector spinae", "hamstrings", "glutes"],
   comparison=("TORSO HEAVING UP", "Back near level, only arms move", "Chest swings up to start the bar",
               "With the back held close to level, the arms and upper back row the bar from the floor to the chest on every rep.",
               "Lifting the chest to start each pull can let the hips and lower back swing the bar up, taking the work away from the upper back."),
   glows=[glow("Pendlay Row", ["scapula_L", "scapula_R", "chest"], A, 0.58, rx=0.14, ry=0.05),
          glow("Pendlay Row", ["deltoid_arc_scapula_2_L"], A, 0.45, rx=0.045, ry=0.04),
          glow("Pendlay Row", ["support_LatissimusDorsi_L"], SOFT, 0.30, rx=0.07, ry=0.035),
          glow("Pendlay Row", ["upper_arm_L", "forearm_L"], SOFT, 0.28, rx=0.045, ry=0.05)])

SETUP["Pendlay Row"] = [
    "Stand with your feet about hip-width apart, the bar on the floor in front of your toes.",
    "Bend your knees well and push your hips back until your back is close to level.",
    "Grip the bar overhand, hands a little wider than your shoulders.",
    "Brace with a flat back and your shoulders held back, arms reaching down to the bar.",
]

# ---------------------------------------------------------------- close-grip bench press

ex(name="Close-Grip Bench Press", var="closeGripBenchPress",
   # The .bench framing: feet on the left (u 0.05-0.18, v 0.72-0.78), head
   # on the right (u 0.65), the bar and plates sweeping v 0.29-0.57 over the
   # chest. The grip and elbow labels share the top row above the plates'
   # highest point, the grip leader dropping to the near wrist, the elbow
   # leader to the near elbow at the bench edge, which stays in view all rep
   # (the far elbow is hidden behind the torso at the bottom); the two
   # leaders do not cross, and neither crosses a plate. Below the bench the
   # shoulder label sits higher on the right with its leader to the near
   # shoulder blade, the bar-path label lower with its leader to the lower
   # chest, which stays left of the shoulder label's inner end. The feet
   # label sits under the shoes on the lowest row.
   overrides={"elbow": (0.14, "leading"), "grip": (0.14, "trailing"), "scapula": (0.77, "trailing"),
              "barpath": (0.86, "trailing"), "feet": (0.86, "leading")},
   annotations=[
       ("grip", "Hands shoulder-width", "hand_L"),
       ("elbow", "Elbows tucked to the sides", "forearm_L"),
       ("barpath", "Bar to lower chest", "support_PectoralisMajor_Sternal_L"),
       ("scapula", "Shoulders pinned", "scapula_L"),
       ("feet", "Feet planted", "foot_L"),
   ],
   cues={
       "grip": ("Grip Width",
                "The hands sit about shoulder-width apart, right above the shoulders.",
                "A grip about as wide as the shoulders is the usual way to shift the bench press toward the triceps: in EMG studies, triceps activity was higher than with a wide grip, though not clearly higher than with a medium one, while the chest changed little. Much closer than that can bend the wrists sideways and make the bar harder to balance.",
                "Hands nearly touching in the middle of the bar, the wrists bending sideways.",
                "Grip the bar with your hands about shoulder-width apart, directly above your shoulders, thumbs wrapped around it."),
       "elbow": ("Elbow Position",
                 "The upper arms stay close to the sides as the bar comes down.",
                 "Tucked upper arms keep the shoulders in the low-abduction position the close grip gives: in one study, a grip at shoulder width kept the shoulders less abducted than medium and wide grips. In another, flaring the elbows at the same close grip opened the shoulders out about as far as a medium grip and put more load through the elbows, without shifting the work to the chest.",
                 "The elbows flaring out to the sides as the bar comes down, the upper arms swinging away from the ribs.",
                 "Keep your upper arms close to your sides as you lower the bar, elbows pointing toward your hips."),
       "barpath": ("Bar Path",
                   "The bar touches the lower chest and presses up and back to finish over the shoulders.",
                   "With the elbows tucked, the lower chest is where the bar meets the body, and pressing up and slightly back ends each rep with the bar balanced over the shoulder joints. In a film study of expert and novice benchers, the experts kept the bar's path closer to the shoulders; letting it drift down onto the stomach takes it further away.",
                   "The bar drifting down onto the stomach and pressed straight up from there, away from the shoulders.",
                   "Lower the bar to your lower chest, touch, then press it up and slightly back until it is over your shoulders."),
       "scapula": ("Shoulder Position",
                   "The shoulders stay down on the bench for the whole set.",
                   "Shoulder blades held back and down against the bench are thought to give the press a stable base and to ease the forward push on the front of the shoulder at the bottom of the rep. Rolling the shoulders up off the bench to finish a rep gives that base up.",
                   "The shoulders rolling up and forward off the bench as the bar goes up.",
                   "Pull your shoulder blades back and down into the bench before the first rep and keep them there to the last."),
       "feet": ("Base",
                "The feet stay flat on the floor and the hips stay on the bench.",
                "Feet planted apart on the floor give the press a stable base: in one study, pressing with the feet held up off the floor made every measured muscle work harder, the abdominals included, which the authors put down to the body being less stable without the feet's support. Feet flat with the hips, shoulders and head on the bench is the standard set-up, the one used in studies of this lift.",
                "The heels lifting or the feet drifting, and the hips rising off the bench to force a hard rep up.",
                "Plant both feet flat, set wider than your shoulders, and keep your hips on the bench for every rep."),
   },
   # Triceps bright, pecs and front delt dim on the model, as ExRx's target
   # and synergists. EMG keeps the pecs about as active as the triceps in a
   # bench press, and a close grip shifts that only a little (Lehman 2005,
   # Saeterbakken 2021, Tanimoto 2023, Mausehund 2022; flagged in the
   # notes), so the pec sits at the top of the moderate band. The close-grip
   # studies do not put the front delt clearly below the pec (a narrower
   # grip raised its EMG in Mausehund 2022), so it sits mid-band. Fractions
   # are estimates.
   activation=[("Triceps Brachii", P, HI, 0.86), ("Pectoralis Major", S, MOD, 0.68), ("Anterior Deltoid", S, MOD, 0.60)],
   stabilisers=["rotator cuff", "serratus anterior", "biceps brachii", "core"],
   comparison=("ELBOWS FLARED", "Elbows tucked, bar to lower chest", "Elbows flare out to the sides",
               "Upper arms close to the sides keep the shoulders in the low-abduction position the close grip gives, with the bar coming down to the lower chest.",
               "Flaring the elbows opens the shoulders out toward a regular bench press and, in one study, put more load through the elbow joints without moving work to the chest."),
   glows=[glow("Close-Grip Bench Press", ["upper_arm_L", "forearm_L"], A, 0.58, rx=0.055, ry=0.06),
          glow("Close-Grip Bench Press", ["upper_arm_R", "forearm_R"], A, 0.50, rx=0.05, ry=0.055),
          glow("Close-Grip Bench Press", ["support_PectoralisMajor_Sternal_L", "support_PectoralisMajor_Sternal_R"], SOFT, 0.32, rx=0.08, ry=0.04),
          glow("Close-Grip Bench Press", ["deltoid_arc_clavicle_2_L"], SOFT, 0.28, rx=0.04, ry=0.035)])

SETUP["Close-Grip Bench Press"] = [
    "Lie on a flat bench with your head, upper back and hips on the pad.",
    "Plant your feet flat on the floor, set wider than your shoulders.",
    "Grip the bar overhand with your hands about shoulder-width apart.",
    "Pull your shoulder blades back and down, then hold the bar over your shoulders.",
]
