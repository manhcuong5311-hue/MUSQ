# Trainer content for the Desktop "300-400" folder (2026-10-12), family "kb":
# the builder's 391 Kettlebell Swing (Legs/KettlebellSwing), 392 Sumo
# Kettlebell Deadlift (Legs/SumoKettlebellDeadlift) and 394 Kettlebell
# Deadlift (Legs/KettlebellDeadlift). Same format as spec.py on top of
# common_1_50.py; spec_1012.py imports this module and gen.py reads SPEC /
# SETUP. notes_1012_kb.md maps every claim in the copy to the sources below
# or to a model measurement.
#
# What the models show, measured from the rigs with Blender's Python + pxr
# (the lab's $LAB/r1012/kb/ in the session scratchpad: measure.py, joint
# angles, bell bounds and stance per frame; swingfine.py, the swing frame by
# frame; sweep.py and projstills.py, joints and bell projected through the
# trainer framings; ghost.py, a port of FaultGhost.solve), the motion briefs
# (briefs_1012/<Resource>.md), the paint ($LAB/r1012/tiers.txt), the trainer
# stills ($LAB/r1012/stills) and joints.json. Frame: Y up, the lifter faces
# +z, their left is +x, metres. One body in all three: neck to pelvis
# 0.592 m, thigh 0.444 m, shoulder joints 0.39 m apart, hip joints 0.18 m.
# Hip angles below are trunk-to-thigh in the side view (180 = straight); the
# briefs' 3-D angle reads lower in the wide stances because the thighs splay
# out.
# - Kettlebell Swing (391, yaw -1.3: side-on from the lifter's left, facing
#   screen-left). One kettlebell (24 x 27 x 25 cm) in both hands, overhand
#   (palms facing back at the bottom, down at the top), wrists 17 cm apart,
#   elbows 171° all clip (straight arms). Feet flat and still, ankle joints
#   54 cm apart (a little wider than the shoulders), toes out 15°. Four
#   identical swings in 7.96 s, one every 2.0 s; the clip starts and loops at
#   the bottom. Bottom (0, 2, 4, 6 s): hips 90°, knees 153° (a 27° bend),
#   shins upright (3-4° back of vertical), trunk 60° forward, pelvis 6 cm
#   lower and 25 cm further back than standing; the hands 0.63 m up, 16 cm
#   above the knee joints and between the thighs; the bell's centre 0.44 m up
#   and 9 cm behind the knee joints, its top 0.58 m, its bottom 0.31 m (never
#   near the floor). Up: the hips are straight (>= 175°) by 0.58 s, the knees
#   176° with them, the trunk vertical by 0.75 s, while the bell passes hip
#   height and keeps rising. Top (1, 3, 5, 7 s): the bell's centre 1.29 m,
#   its top 1.41 m, 13 cm below the shoulder joints (1.43 m): about chest
#   height; the arms 9° below level, the bell 71 cm in front of the
#   shoulders; it stays within 7 cm of its peak from 0.9 to 1.1 s. Hips
#   179°, knees 177°, trunk 0° (never past -0.5°): no lean back. Down: the
#   body stays straight (hips >= 175°) until ~1.42 s, when the hands have
#   dropped to ~0.99 m, just above hip height; then the hips fold to 90° by
#   2.0 s as the bell swings back between the legs. The spine keeps its
#   standing shape at the bottom (the three back segments 14° apart in both)
#   and the head stays within 12° of the trunk line.
#   Paint: biceps femoris, semitendinosus, semimembranosus, gluteus maximus,
#   medius and minimus bright; erector spinae, the four quadriceps heads and
#   the forearm muscles (brachioradialis, wrist and finger flexors and
#   extensors, palmaris longus) dim.
# - Sumo Kettlebell Deadlift (392, yaw -0.5: front three-quarter from the
#   lifter's left). One kettlebell (28 x 29 x 24 cm), both hands overhand on
#   the handle (palms facing back), wrists 18 cm apart, elbows 171-172°.
#   Ankle joints 66 cm apart (1.7 times the shoulder joints), toes out 35°,
#   feet flat. Two reps in 7.96 s: standing 0-0.58 s, down to 1.71 s, the
#   bell resting on the floor 1.71-2.12 s (within 0.5 cm), up to ~3.4 s,
#   standing 3.38-4.58 s, the same again. Bottom: knees 89° (thighs about
#   level), hips 50°, trunk 49° forward, shins 9° forward, pelvis 36 cm
#   lower and 30 cm back; each thigh points 35° out, over its foot (knees
#   69 cm apart, outside the ankles); the arms hang straight down inside the
#   knees, shoulders 3 cm ahead of the hands; the bell between the feet,
#   its centre 4 cm ahead of the ankle joints (about mid-foot). Top: knees
#   176°, hips 177°, trunk 1°; the arms angle ~27° forward, so the bell
#   hangs a hand's width in front of the hips rather than against them.
#   Paint: hamstrings, glutes and quadriceps bright; erector spinae and the
#   forearm muscles dim.
# - Kettlebell Deadlift (394, yaw -0.8: front three-quarter from the left).
#   The same bell and grip. Ankle joints 44 cm apart (about shoulder-width),
#   toes out 18°, feet flat. Same timing as the sumo (bell on the floor
#   1.71-2.12 and 5.71-6.12 s). Bottom: knees 104° (shins 11° forward, knees
#   7 cm ahead of the ankles, over the feet), hips 49°, trunk 66° forward,
#   pelvis 26 cm lower and 32 cm back; the bell's centre 6 cm ahead of the
#   ankle joints, level with the middle of the feet (ankle to toe joint);
#   the arms 9° from vertical, shoulders 8 cm ahead of the hands. Top as the
#   sumo (knees 176°, hips 177°, trunk 1°, arms ~29° forward). Paint:
#   hamstrings and glutes bright; erector spinae, quadriceps and forearm
#   muscles dim.
# How they differ from the library: the Kettlebell Romanian Deadlift (its
# 2026-10-12 model) keeps its knees at 139-161° and never sets the bell
# down; the Dumbbell Deadlift (also re-modelled 2026-10-12) holds two
# dumbbells at the sides and sinks to 58-65° knees; the Sumo
# Deadlift and Trap Bar Deadlift are barbell pulls. The swing is the only
# ballistic lift of the set: the hips throw the bell, nothing is lowered
# slowly. Against each other: the sumo stands half again as wide with the
# toes turned out twice as far, sinks 10 cm further with the knees bent 15°
# further and keeps the trunk 17° more upright than the kettlebell deadlift.
#
# Sources (each opened; quotes and details in notes_1012_kb.md):
# - McGill SM, Marshall LW 2012, J Strength Cond Res 26(1):16-27, doi
#   10.1519/JSC.0b013e31823a4063, PMID 21997449 (abstract): seven men and one
#   kettlebell master, 16 kg bell: swings are a hip-hinge squat pattern with
#   rapid activation-relaxation pulses of ~50% MVC for the low back
#   extensors and ~80% MVC for the gluteal muscles, ~3,200 N of low back
#   compression.
# - Van Gelder LH, Hoogenboom BJ, Alonzo B, Briggs D, Hatzel B 2015, Int J
#   Sports Phys Ther 10(6):811-826, PMC4637916 (full text): 19 novices,
#   8-16 kg, swings to a target just above eye level: two-handed swing
#   gluteus maximus 69.4% and gluteus medius 53.0% of MVIC; biceps femoris
#   78.95% across all swings; the biceps femoris peaked before the gluteus
#   maximus; terminal hip flexion 85° and extension ~10°.
# - Zebis MK, Skotte J, Andersen CH et al. 2013, Br J Sports Med
#   47(18):1192-1198, doi 10.1136/bjsports-2011-090281, PMID 22736206
#   (abstract): 16 female elite handball and soccer players: the kettlebell
#   swing and the Romanian deadlift targeted semitendinosus over biceps
#   femoris at very high levels (73-115% of MVC).
# - Del Monte MJ, Opar DA, Timmins RG, Ross JA, Keogh JWL, Lorenzen C 2020,
#   J Strength Cond Res 34(7):1953-1958, doi 10.1519/JSC.0000000000002254,
#   PMID 28930870 (abstract): 14 participants, hip hinge, squat and double
#   knee extension swings: the hip hinge swing drew more medial hamstring and
#   biceps femoris activity than the squat swing and the double knee
#   extension swing.
# - Lyons BC, Mayo JJ, Tucker WS, Wax B, Hendrix RC 2017, J Strength Cond
#   Res 31(9):2363-2370, doi 10.1519/JSC.0000000000001771, PMID 28394829
#   (abstract): one-arm swing, snatch and clean: erector spinae higher in the
#   swing than the snatch, vastus lateralis higher in the swing than the
#   clean (no values in the abstract).
# - Bullock GS, Schmitt AC, Shutt JM, Cook G, Butler RJ 2017, Int J Sports
#   Phys Ther 12(3):324-332, PMID 28593086, PMC5455182 (full text): 15 subjects at full
#   effort, shoulder-height swing cycle 1.45 +- 0.16 s (the model's is 2.0 s,
#   so the copy prescribes no pace).
# - Escamilla RF, Francisco AC, Fleisig GS et al. 2000, Med Sci Sports Exerc
#   32(7):1265-1275, doi 10.1097/00005768-200007000-00013, PMID 10912892
#   (abstract): sumo lifters stood wider (70 vs 32 cm), turned the feet out
#   more (42 vs 14°) and kept the trunk 5-10° more upright than conventional.
# - Escamilla RF, Francisco AC, Kayes AV, Speer KP, Moorman CT 2002, Med Sci
#   Sports Exerc 34(4):682-688, doi 10.1097/00005768-200204000-00019, PMID
#   11932579 (abstract): 13 football players at 12RM: vastus medialis,
#   vastus lateralis and tibialis anterior more active in the sumo, medial
#   gastrocnemius in the conventional deadlift.
# - Hanen NC, Ben Mansour K, Ertel GN, Duchene Y, Gauchard GC 2025, Front
#   Bioeng Biotechnol 13:1597209, doi 10.3389/fbioe.2025.1597209, PMC12148905
#   (full text): 30 experienced men at 85% 1RM: biceps femoris higher in the
#   conventional deadlift in both phases, vastus lateralis higher in the
#   sumo early in the lift, gluteus maximus not different; the conventional
#   lift had the larger hip extension moments.
# - Lee S, Schultz J, Timgren J et al. 2018, J Exerc Sci Fit 16(3):87-93,
#   doi 10.1016/j.jesf.2018.08.001, PMID 30662500, PMC6323186 (abstract): conventional vs
#   Romanian deadlift: rectus femoris 58.6 vs 25.3 %peak, gluteus maximus
#   51.5 vs 46.9 %peak.
# - Swinton PA et al. 2011, J Strength Cond Res 25(7):2000-2009, doi
#   10.1519/JSC.0b013e3181e73f87, PMID 21659894 (abstract): load at the sides (hexagonal
#   bar): lower lumbar, hip and ankle moments, a higher knee moment. Camara
#   KD et al. 2016, J Strength Cond Res 30(5):1183-1188, doi
#   10.1519/JSC.0000000000001352, PMID 26840440 (abstract): hexagonal bar more vastus
#   lateralis, straight bar more biceps femoris and erector spinae. Used only
#   to rank the deadlifts' rows.
# - Powers CM 2010, J Orthop Sports Phys Ther 40(2):42-51, doi
#   10.2519/jospt.2010.3337, PMID 20118526 (abstract): impaired control of the hip, pelvis
#   and trunk affects knee mechanics.
# - McCall P, ACE ProSource October 2015, Do it Better: ACE's Technique
#   Series Continues With the Two-handed Kettlebell Swing (acefitness.org):
#   feet about shoulder-width, palms-down grip, a hip hinge, not a squat,
#   shins relatively vertical with minimal knee movement, spine long and
#   straight, hike the bell back between the legs, explosive hip extension
#   drives it, strength from the legs and hips, not the shoulders, to chest
#   or shoulder height, stand upright at the top and brace the abs; common
#   errors: squatting instead of hinging, lifting the bell with the arms and
#   shoulders as in a front raise.
# - ACE Exercise Library, Swing (acefitness.org/acefit/exercise-library-
#   details/0/391/): both hands, palms facing down, back straight, sink into
#   the hips to bring the bell between the legs, under the hips; push the
#   hips forward, pull the knees back; the bell rises to chest height; the
#   strength comes from the legs and hips, not the shoulders.
# - StrengthLog, Kettlebell Swing (strengthlog.com): primary glutes and lower
#   back, secondary hamstrings, adductors, trapezius, forearm flexors; bell
#   one or two feet in front to start, knees bent only slightly, swing to
#   about chest height, the hips (not the arms) lift the bell; goblet or
#   front squats suit the quads better.
# - REP Fitness Editorial Team (reviewed by R. Borchert, NASM-CPT), How to
#   Deadlift with a Kettlebell (repfitness.com, 2026): kettlebell deadlift:
#   bell between the feet, handle over the middle of the feet, palms facing
#   you, push the hips back, flatten the back by pulling the chest up and
#   engaging the lats, drive through the heels, stand tall squeezing the
#   glutes without hyperextending, let the bell touch the floor briefly;
#   mistakes: rounding the lower back, squatting instead of hinging, knees
#   caving in, hyperextending at the top. Sumo: feet wider than
#   shoulder-width, toes out about 45°, bell centred between the feet, shins
#   vertical at the grip, a more upright torso, emphasis on the inner thighs
#   and glutes, drive the knees out, the bell straight up and down. Muscles:
#   glutes, hamstrings, erector spinae, lats, traps, core, grip.
# No EMG study was found for a kettlebell deadlift of either stance; their
# rows are ranked from the closest studied lifts and the library (see the
# notes). The activation rows follow the paint: bright = primary, dim =
# secondary; the rig lights the three glutes as one group, so the bright
# glutes are one Gluteus Maximus row with the gluteus medius among the
# swing's stabilisers.

from common_1_50 import *

NAMES = ["Kettlebell Swing", "Sumo Kettlebell Deadlift", "Kettlebell Deadlift"]


def posterior_glows(name, dx=0.03):
    """Hamstrings and glutes behind the thighs, then the lower back."""
    return [glow(name, ["pelvis", "patella_L", "patella_R"], A, 0.55, rx=0.13, ry=0.09, dx=dx),
            glow(name, ["spine", "chest"], SOFT, 0.30, rx=0.08, ry=0.06)]


# ---------------------------------------------------------------- swing

ex(name="Kettlebell Swing", var="kettlebellSwing",
   # Side-on (yaw -1.3), facing screen-left. The bell sweeps an arc from
   # between the legs (u 0.55-0.77, v 0.58-0.70) to the left edge at the
   # top (u 0-0.21, v 0.23-0.34), through the middle left (u 0.27-0.47,
   # v 0.46-0.58 at 0.5 s); the head swings from (0.35, 0.33) at the bottom
   # to (0.58, 0.18) at the top, the hips back to u 0.84 at the bottom. At
   # the bottom the head is left of the back, so the head's label sits on
   # the left and the back's on the right, or their leaders cross. The
   # mistake view shrinks and lifts the model, and the bell at the top of
   # its arc rises to v ~0.16-0.25 there, so the stand-tall label sits a
   # little higher than the top row, at v 0.12 on the left (the mistake
   # banner is above 0.065 and only in the middle; the buttons are on the
   # right). The arms label top right (starting u 0.76, clear of the head
   # and the lifted shoulder) on the near shoulder; flat back right at
   # v 0.30 beside the back (at 0.32 its pill touched the top of the glutes
   # in its mistake view); hips back right at v 0.64 behind the thighs; the
   # backswing label left at v 0.64, under the bell's arc and left of the
   # knees. Round 1 had a longer arms label top left (the raised-arms ghost
   # ran through it); round 2 had stand tall in the top row (in its mistake
   # view the pill sat on the bell) and "Arms just guide", whose pill touched
   # the lifted shoulder in its mistake view.
   overrides={"top": (0.095, "leading"), "drive": (0.14, "trailing"), "back": (0.30, "trailing"),
              "hinge": (0.68, "trailing"), "hike": (0.68, "leading")},
   annotations=[
       ("hinge", "Hips back", "pelvis"),
       ("hike", "Hike above the knees", "hand_L"),
       ("back", "Flat back", "chest"),
       ("drive", "Arms guide", "upper_arm_L"),
       ("top", "Stand tall", "head"),
   ],
   cues={
       "hinge": ("Hip Hinge",
                 "As the bell swings back, the hips push back and the chest tips forward while the knees bend only a little and the shins stay upright.",
                 "The swing is a hip hinge, not a squat: the glutes and hamstrings stretch as the hips fold, then snap them straight. In one study a hinge-style swing drew more hamstring activity than a squat-style swing. The model folds its hips to about 90 degrees but bends its knees only about 27.",
                 "Squatting the bell down: the knees bend further and push forward, the hips sink and the chest stays more upright.",
                 "Push the hips straight back, keep the shins close to vertical and the knees soft, and let the chest tip forward over the bell."),
       "hike": ("Backswing",
                "The bell swings back between the legs at knee height, the hands staying above the knees and the forearms close to the inner thighs.",
                "The hips have to stop the bell and throw it forward again, so it should arrive close to them. The further a load swings from the hips, the longer its lever on the lower back; a bell that drops low drags the chest and back down after it.",
                "Letting the hands sink to the knees and the bell swing low, the chest diving toward the floor after it.",
                "Hike the bell back between your thighs with the hands above your knees and the forearms close to your inner thighs, and keep the chest from following it down."),
       "back": ("Flat Back",
                "The back keeps its standing shape at the bottom and the top, long from the hips to the head, the neck in line.",
                "The swing loads the spine quickly: in a lab study, swings with a 16 kg bell put about 3,200 newtons of compression on the lower back while the back muscles worked at about half their maximum. A long, braced spine leaves the bending to the hips.",
                "Rounding the back and dropping the head as the bell swings between the legs.",
                "Brace before every swing, keep the spine long and the neck in line, and fold only at the hips."),
       "drive": ("Hip Drive",
                 "The hips snap straight and the bell floats up to about chest height on straight arms.",
                 "The hips, not the shoulders, throw the bell. In the model they are straight by the time the bell passes hip height, and it keeps rising on its own for about another third of a second. Lifting it with the arms turns the top of each swing into a front raise and takes the work away from the hips.",
                 "Raising the bell with the arms and shoulders, like a front raise, up toward head height.",
                 "Drive the hips forward hard, keep the elbows straight and let the arms only guide the bell as it floats to about chest height."),
       "top": ("Stand Tall",
               "At the top the hips and knees are straight and the body stands in one line from the heels to the head, with no lean back.",
               "Straightening the hips is what finishes the swing; with the abs braced the trunk stays still while the bell floats. Leaning back past upright bends the lower back instead of the hips.",
               "Leaning back as the bell rises, the hips pushed forward past the shoulders.",
               "Finish with the knees and hips straight, glutes and abs tight and the shoulders over the hips, then let the bell drop."),
   },
   # Ranked as painted: hamstrings and glutes bright, erector spinae,
   # quadriceps and forearms dim. Gluteus maximus 0.80: McGill and Marshall
   # 2012 measured ~80% MVC for the gluteal muscles with a 16 kg bell; Van
   # Gelder 2015's novices reached 69.4% MVIC in the two-handed swing.
   # Hamstrings 0.76, just under: the swing drew very high semitendinosus
   # activity (Zebis 2013, 73-115% MVC with the RDL), the biceps femoris
   # averaged ~79% MVIC across Van Gelder's swings, and the hip hinge style
   # drew the most hamstring activity (Del Monte 2020); McGill's biceps
   # femoris was lower, so they sit under the glutes, as StrengthLog ranks
   # them. Erector spinae 0.50: McGill's ~50% MVC for the low back extensors
   # (StrengthLog lists the lower back as primary; the model paints it dim).
   # Quadriceps LOW 0.30, an estimate: the knees only straighten from 153° to
   # 177°; Lyons 2017 found vastus lateralis activity in the swing (more than
   # in the clean) without values. Forearms LOW 0.35, an estimate: two hands
   # share one bell through the arc, so a little under the library's Romanian
   # and stiff-leg deadlifts' grip rows (0.36) and under its barbell and
   # dumbbell deadlifts' 0.45 (StrengthLog and ACE name the forearm flexors
   # for the grip; no EMG found).
   # The bright gluteus medius (53% MVIC two-handed, Van Gelder 2015) is
   # covered by the glute row and named among the stabilisers.
   activation=[("Gluteus Maximus", P, HI, 0.80), ("Hamstrings", P, HI, 0.76),
               ("Erector Spinae", S, MOD, 0.50), ("Forearms", S, LOW, 0.35), ("Quadriceps", S, LOW, 0.30)],
   stabilisers=["gluteus medius", "adductors", "trapezius", "core"],
   comparison=("SQUATTING THE SWING", "Hips back, shins upright", "Knees forward, hips sink",
               "With the hips pushed back and the shins upright, the hips fold and then snap straight to throw the bell.",
               "Squatting the bell down moves the bend to the knees; in one study a squat-style swing drew less hamstring activity than a hinge."),
   glows=posterior_glows("Kettlebell Swing"))

SETUP["Kettlebell Swing"] = [
    "Stand with your feet a little wider than your shoulders, toes turned slightly out, the kettlebell on the floor about a foot in front of you.",
    "Hinge forward with a flat back and grip the handle with both hands, palms facing down.",
    "Brace, then hike the bell back between your thighs, like a football snap, to start the first swing.",
    "At the end of the set, let the bell swing back once more and guide it down to the floor in front of you.",
]

# ---------------------------------------------------------------- sumo

ex(name="Sumo Kettlebell Deadlift", var="sumoKettlebellDeadlift",
   # Front three-quarter (yaw -0.5): the body fills u 0.17-0.81 at the
   # bottom, the feet the two bottom corners (far foot u 0.17-0.35, near
   # foot u 0.69-0.81), the knees u 0.27-0.35 and 0.72-0.80 at v 0.65, the
   # bell u 0.29-0.64 from v 0.46 down to the floor, the head from (0.52,
   # 0.18) to (0.45, 0.41). So: the stand-tall label top left (ending u
   # 0.25) and the chest label top right (starting u 0.62, right of the
   # head); two short labels on the right beside the near shoulder (v 0.32)
   # and above the near thigh (v 0.48); the toes label short on the left at
   # v 0.64, left of the far knee. Round 1 had the chest label top left and
   # stand tall top right: at the bottom their leaders crossed over the
   # head.
   overrides={"lockout": (0.14, "leading"), "torso": (0.14, "trailing"), "hips": (0.32, "trailing"),
              "knees": (0.50, "trailing"), "stance": (0.68, "leading")},
   annotations=[
       ("stance", "Toes out", "foot_R"),
       ("knees", "Knees out", "patella_L"),
       ("torso", "Chest up, back flat", "chest"),
       ("hips", "Rise together", "thigh_L"),
       ("lockout", "Stand tall", "head"),
   ],
   cues={
       "stance": ("Stance",
                  "The feet stand well wider than the shoulders with the toes turned out about 35 degrees, the bell on the floor between them.",
                  "Wide feet with the toes turned out give the knees room to open over the feet, so the hips can sink between the heels and the bell can pass between the legs. Sumo pullers in competition stood about twice as wide as conventional ones and turned their feet out about 42 degrees.",
                  "Standing wide with the toes pointing straight ahead, so the knees cannot follow the feet.",
                  "Set your feet just outside your shoulders, turn the toes out about 30 to 45 degrees and centre the bell between your feet, level with their middle."),
       "knees": ("Knee Tracking",
                 "The knees push out over the turned-out toes on the way down and the way up.",
                 "In a wide stance the knees have to travel out as well as forward to stay over the feet, which keeps the hips open and the load straight through each knee. Knees caving in is a common kettlebell deadlift mistake, and weak control at the hip has been linked to the knee drifting inward.",
                 "The knees caving in toward each other as you sink or stand up.",
                 "Push the knees out in line with the toes all the way down and up, the arms hanging inside them."),
       "torso": ("Chest Up",
                 "The chest stays up and the back flat, the trunk leaning only about halfway forward at the bottom.",
                 "The wide stance is what lets the trunk stay this upright: sumo pullers keep the trunk more vertical than conventional ones, and the model leans about 49 degrees at the bottom. A flat, braced back passes the drive from the legs to the bell; a chest that drops to meet the bell rounds the back.",
                 "The chest dropping toward the bell and the back rounding at the bottom.",
                 "Pull the chest up and the shoulders back, engage the lats, and sink the hips between the heels rather than folding over."),
       "hips": ("Hips and Chest",
                "The hips and chest rise at the same rate, the trunk righting itself steadily from the bottom.",
                "Rising together keeps the trunk upright and the work shared between the thighs and the hips. When the hips shoot up first, the knees straighten early and the chest stays low, so the back is left to lift the bell the rest of the way.",
                "The hips shooting up out of the bottom while the chest stays low over the bell.",
                "Drive through the whole foot, push the knees out and let the hips and shoulders rise together until you stand tall."),
       "lockout": ("Lockout",
                   "Finish standing tall with the hips and knees straight and the glutes squeezed.",
                   "The lift is complete when the hips and knees are straight; leaning back past upright only bends the lower back under the load.",
                   "Leaning back at the top, the hips pushed forward past the shoulders.",
                   "Squeeze the glutes as you stand and stop with the shoulders over the hips, ribs down, then lower the bell the way it came up."),
   },
   # Ranked as painted: hamstrings, glutes and quadriceps bright; erector
   # spinae and forearms dim. No EMG study of a kettlebell sumo deadlift was
   # found, so the fractions are estimates anchored on the barbell lifts: the
   # library Sumo Deadlift (gluteus maximus 0.84, hamstrings 0.66, quadriceps
   # 0.72) a step lower for one kettlebell's load. The quadriceps 0.74, just
   # under the glutes: the vasti were more active in the sumo than in the
   # conventional deadlift (Escamilla 2002; Hanen 2025 early in the lift),
   # and this model bends its knees to 89°. Hamstrings MODERATE 0.56, under
   # the conventional kettlebell deadlift's 0.66: the biceps femoris was
   # lower in the sumo in Hanen 2025 (Escamilla 2002 found no difference).
   # Erector spinae 0.50 (under the conventional 0.54: a more upright trunk,
   # 49° here against 66°; Hanen 2025's thoracic erector lower in the sumo's
   # second phase). Forearms LOW 0.35 as the swing's. The adductors are not
   # painted, so they are named among the stabilisers.
   activation=[("Gluteus Maximus", P, HI, 0.76), ("Quadriceps", P, HI, 0.74), ("Hamstrings", P, MOD, 0.56),
               ("Erector Spinae", S, MOD, 0.50), ("Forearms", S, LOW, 0.35)],
   stabilisers=["adductors", "lats", "trapezius", "core"],
   comparison=("KNEES CAVING IN", "Knees out over the toes", "Knees collapse inward",
               "Knees pushed out over the turned-out toes keep the hips open, so the thighs and glutes drive the bell up with the chest up.",
               "When the knees cave in over wide, turned-out feet, the knees take the load at an angle and the chest tips forward."),
   glows=posterior_glows("Sumo Kettlebell Deadlift", dx=0.0) + [
       glow("Sumo Kettlebell Deadlift", ["patella_L", "thigh_L"], SOFT, 0.26, rx=0.06, ry=0.08),
       glow("Sumo Kettlebell Deadlift", ["patella_R", "thigh_R"], SOFT, 0.26, rx=0.06, ry=0.08)])

SETUP["Sumo Kettlebell Deadlift"] = [
    "Stand with your feet well wider than your shoulders, toes turned out about 35 degrees, as the model does.",
    "Set the kettlebell on the floor between your feet, centred and level with the middle of your feet.",
    "Sink your hips, push your knees out over your toes and grip the handle with both hands, palms facing you.",
    "Chest up, back flat, arms straight inside your knees; brace and stand up with the bell.",
]

# ---------------------------------------------------------------- conventional

ex(name="Kettlebell Deadlift", var="kettlebellDeadlift",
   # Front three-quarter from the left (yaw -0.8), as the library Dumbbell
   # Deadlift and Kettlebell RDL: the head swings from (0.52, 0.18) to (0.37,
   # 0.44), the hips back to u 0.80 at the bottom, the bell u 0.25-0.63 from
   # v 0.45 down to the floor, the far foot u 0.27-0.42 and the near foot u
   # 0.57-0.68 at the bottom of the frame. So, as this family's sumo and the
   # library Kettlebell RDL: the stand-tall label top left on the head (the
   # leftmost part of the body all rep, so its leader never crosses it); the
   # back label top right (starting u 0.62, right of the head) and the hips
   # label right at v 0.27, their leaders fanning down to the chest and the
   # pelvis without crossing; the bell label short on the left at v 0.72,
   # left of the far shin and the bell, its leader to the far (right) foot,
   # beside which the bell sits (to the hands it crossed the hanging bell at
   # the top and the far shin at the bottom); the knee label bottom right,
   # right of the near foot. Review (2026-10-12): the draft had the back
   # label top left and stand tall on the near hip at v 0.27 right, the
   # Dumbbell Deadlift's layout; at 1.0 s and 3.0 s (the stills it was never
   # shot at) the back leader ran across the face and the pill's end met the
   # top of the head as it passed through the middle of the rep.
   overrides={"lockout": (0.14, "leading"), "back": (0.14, "trailing"), "hinge": (0.26, "trailing"),
              "bell": (0.77, "leading"), "knees": (0.86, "trailing")},
   annotations=[
       ("hinge", "Hips back", "pelvis"),
       ("bell", "Bell mid-foot", "foot_R"),
       ("back", "Chest up, back flat", "chest"),
       ("knees", "Knees over toes", "patella_L"),
       ("lockout", "Stand tall", "head"),
   ],
   cues={
       "hinge": ("Hip Hinge",
                 "The hips push back first, and the knees bend only as far as it takes to reach the handle with a flat back.",
                 "Sending the hips back loads the glutes and hamstrings, the main movers here. In the model the hips fold to about 50 degrees while the knees bend to about 104, the shins staying close to upright; sinking the hips straight down instead turns the rep into a squat.",
                 "Squatting the bell up: the hips sink straight down, the knees push forward and the chest stays more upright.",
                 "Push the hips back as you lower, let the knees bend only as much as you need, and keep the shins nearly vertical."),
       "bell": ("Bell Position",
                "At the bottom of each rep the bell touches down on the floor between the feet, its handle over the middle of the feet.",
                "With the bell between the feet the load sits in line with the body, as with a trap bar, where the lower back and hips are loaded less than with a bar in front of the legs. A bell out in front of the toes pulls the arms and chest forward and lengthens the lever on the lower back.",
                "Letting the bell drift out in front of the toes, the arms reaching forward to it.",
                "Line the handle up with the middle of your feet, keep the arms long and the lats tight, and keep the bell close to your shins as it leaves and returns to the floor."),
       "back": ("Flat Back",
                "The chest stays up and the back flat from the floor to the top.",
                "A flat back lets the hips and legs do the lifting while the spine just holds its shape. Rounding the lower back on the way down is a common kettlebell deadlift mistake.",
                "The lower back rounding at the bottom as the bell nears the floor.",
                "Brace before each rep, pull the chest up and the shoulders back, and only go as low as you can with a flat back."),
       "knees": ("Knee Tracking",
                 "The knees bend in line with the feet, never caving inward.",
                 "Knees that follow the toes take the load straight through the joint. Letting them cave in is a common mistake, and weak control at the hip has been linked to the knee drifting inward.",
                 "The knees caving in toward each other at the bottom or as you stand.",
                 "Keep each knee over the middle toes as you lower the bell and as you drive up."),
       "lockout": ("Lockout",
                   "Stand tall at the top with the hips and knees straight and the glutes squeezed.",
                   "The lift is complete when the hips and knees are straight. Hyperextending at the top is a common mistake: leaning back past upright only bends the lower back under the load.",
                   "Leaning back at the top, the hips pushed forward past the shoulders.",
                   "Squeeze the glutes as you stand and stop with the shoulders over the hips, ribs down."),
   },
   # Ranked as painted: hamstrings and glutes bright; erector spinae,
   # quadriceps and forearms dim. No EMG study of a kettlebell deadlift was
   # found: estimates anchored on the library. Gluteus maximus 0.74, as the
   # library Dumbbell Deadlift (another bent-knee pull with the load in line
   # with the body; Lee 2018: a bent-knee deadlift drew more gluteus maximus
   # than the RDL). Hamstrings MODERATE 0.66, the library Deadlift's value:
   # the knees stay straighter than the Dumbbell Deadlift's 58-65° (its
   # 0.56) but bend far more than the Kettlebell RDL's 139° (its 0.82); the
   # conventional pull drew more biceps femoris than the sumo (Hanen 2025).
   # Erector spinae 0.54, as the Dumbbell Deadlift, under the hamstrings as
   # painted. Quadriceps 0.40, the lowest moderate value: a conventional
   # deadlift's knee bend works the rectus femoris far more than an RDL's
   # (Lee 2018), but less than the sumo's (Escamilla 2002). Forearms LOW
   # 0.35 as the swing's.
   activation=[("Gluteus Maximus", P, HI, 0.74), ("Hamstrings", P, MOD, 0.66),
               ("Erector Spinae", S, MOD, 0.54), ("Quadriceps", S, MOD, 0.40), ("Forearms", S, LOW, 0.35)],
   stabilisers=["adductors", "lats", "trapezius", "core"],
   comparison=("SQUATTING, NOT HINGING", "Hips back, shins near upright", "Hips sink, knees push forward",
               "Pushing the hips back to reach the bell loads the glutes and hamstrings while the back stays flat.",
               "Sinking the hips straight down with the chest upright turns the deadlift into a squat, so the thighs do the work the hips should."),
   glows=posterior_glows("Kettlebell Deadlift"))

SETUP["Kettlebell Deadlift"] = [
    "Stand with your feet about shoulder-width apart, toes turned slightly out, as the model does.",
    "Set the kettlebell on the floor between your feet, the handle over the middle of your feet.",
    "Push your hips back, bend your knees and grip the handle with both hands, palms facing you.",
    "Pull your shoulders back and your chest up, brace and stand up with the bell.",
]

if __name__ == "__main__":
    print("\n".join(validate(NAMES) + validate_library(NAMES)) or "OK")
