# Trainer content for the legs batch 300-350 (2026-09-26): the lunges —
# Forward Lunge (323), Barbell Lunge (324), Smith Machine Reverse Lunge (325)
# from the quads series and the Curtsy Lunge (01) from the 30-leg set,
# converted from SourceExports/300-350. Same format as spec.py, on top of
# common_300_350.py.
#
# What each model shows, from the rig (joints sampled every 0.125 s with
# Blender's pxr; torso = neck to pelvis = 0.59 m in all four) and the framing
# screenshots. All four alternate legs: 4 s per rep, two reps in 8 s, bottoms
# at ~1.9 s and ~5.9 s (curtsy ~1.6 s and ~5.6 s).
# - Forward Lunge: bodyweight, hands on the hips (on the iliac crests), feet
#   hip-width (ankles 0.22 m apart). Rep 1 the LEFT foot steps forward, rep 2
#   the RIGHT: a long step (front ankle lands 0.98 m ahead of the start, the
#   back ankle 0.84 m behind it with the back heel up, ball of the foot on
#   the floor), heel first then the whole foot (0.5-1.0 s), then the body
#   sinks straight down to both knees ~89° (1.0-2.0 s): back kneecap 0.11 m
#   above the floor, front shin ~9° off vertical, front kneecap ~9 cm behind
#   the toes, front heel flat, trunk lean 2° at the top to 8° at the bottom,
#   pelvis level and square, no knee caving (the front knee sits ~5 cm
#   outside the hip-ankle line). 2-3 s it rises, 3-4 s it pushes back off
#   the front foot to feet together. The pelvis travels 0.61 m forward and
#   back, so the lifter crosses the screen from right to centre each rep.
#   Framed at yaw -1.3 (near side-on, facing screen left, LEFT side toward
#   the camera). Compared with the older Lunge model (stationary split
#   stance, left leg forward throughout, ankles 0.71 m apart, knees 80°/72°,
#   front shin 18°, trunk vertical): this one steps out and back and
#   alternates legs, stands in a longer stance with a more upright front shin
#   and stops at ~90° rather than below it, and leans a few degrees at the
#   bottom.
# - Barbell Lunge: the Forward Lunge's legs exactly (same timeline), with a
#   2.2 m bar high on the upper back (wrists ~12 cm behind and 3 cm below the
#   shoulder joints, ~10 cm below the base of the neck), hands 0.78 m apart
#   against shoulder joints 0.39 m apart (each wrist ~0.2 m outside its
#   shoulder joint, about a hand's width outside the shoulder; the Smith
#   grip is the same), elbows down. Trunk 2° -> 8° lean. Framed at yaw -0.6
#   (three-quarter front) because side-on the near plate hid the head.
# - Smith Machine Reverse Lunge: a REVERSE lunge inside the Smith machine.
#   Feet hip-width, ankles ~20 cm in front of the bar line (heels ~15 cm,
#   toes ~35 cm); the bar high on the upper back (as the barbell lunge)
#   stays 0.11 m behind the start pelvis, running straight up and down
#   (hands move < 2 cm front to back). Rep 1 the LEFT foot steps back (the
#   RIGHT leg works), rep 2 the RIGHT foot steps back (the LEFT leg works):
#   back ankle lands 0.78 m behind the front one, on the ball of the foot.
#   The hips travel 0.22 m back and the trunk tips forward as the foot goes
#   back: ~20° by 1 s, 22° at the bottom, upright again at the top. Bottom:
#   front knee 83°, front hip (trunk-thigh) 80°, front shin ~17° off
#   vertical, front kneecap 3 cm behind the toes, back knee 88° with the
#   kneecap 0.11 m above the floor, front heel flat, pelvis level and square.
#   At the bottom the bar shaft sits ~11 cm ahead of the pelvis (the hands
#   ~7 cm), ~20 cm behind the front ankle and ~58 cm ahead of the back one:
#   between the feet but a quarter of the stance behind the front foot, not
#   over its middle. Framed at yaw -1.0 (LEFT side toward the camera,
#   facing screen left).
# - Curtsy Lunge: bodyweight, hands clasped in front of the chest (~0.19 m
#   in front of and 0.21 m below the base of the neck, elbows out). Starts
#   with the feet a little wider than hip-width (ankles 0.32 m apart), knees
#   soft (157°). Rep 1 the RIGHT foot steps back 0.46 m and across to 0.24 m
#   left of the start midline, i.e. ~8 cm past the left foot's line, landing
#   high on the ball of the foot (ankle 0.21 m up); the LEFT leg works. Rep 2
#   mirrors it. Bottom: front knee 70°, front hip 108°, front shin ~47°
#   forward (the knee well past the toes) with the front heel flat, back knee
#   81°, trunk lean ~10°; the pelvis stays square (no turn) and level (no
#   drop) and shifts 0.10 m back and 0.10 m over the front foot. No knee
#   caving. Framed at yaw -0.5 (three-quarter front, LEFT side toward the
#   camera). The rig has no toe joints (foot_*.tip still points along the
#   foot, 0.2 m ahead of the ankle). These figures agree with the motion
#   brief (facing 0: the stepping foot 0.46 m back and 0.24 m across,
#   lean +10°, front shin +47°).
#
# Label joints: cues about one leg name the leading or trailing leg
# (`patella_front`, `foot_back`, ...), which the app resolves every frame
# like the Walking Lunge's (Exercise3DView.trackedPoint), so the dots follow
# whichever leg is in front in both reps. probe.py writes these `_front` /
# `_back` points into joints.json for the lifts in its ALTERNATING set,
# choosing the leading leg per sample the way BodyFrame.leadingSide does,
# so gen.py and validate() place them like any other joint. The rest sit
# on the pelvis, chest, hands or upper trap. Layouts were scored at all 8
# probed moments (pills over the body, head or plates; leaders through the
# head, across limbs or each other) and drawn over the start and both
# bottom screenshots. In the mistake view the model sits ~0.09 higher on
# screen than in the trainer, and a cue's own pill must not hide its ghost;
# the Curtsy cross and Smith drive ghosts are turned for that reason (see
# the fault table).
#
# Sources (each checked; see notes_300_350_lunge.md for which claim each
# supports):
# - Muyor JM, Martín-Fuentes I, Rodríguez-Ridao D, Antequera-Vique JA 2020,
#   PLoS One 15(4):e0230841, doi 10.1371/journal.pone.0230841 — barbell on
#   the upper traps, step forward to 90° at the knee and return: vastus
#   lateralis and medialis highest, then gluteus medius and maximus about
#   equal, then rectus femoris, biceps femoris lowest; concentric above
#   eccentric in every muscle (Table 3 amplitudes as printed, in mV:
#   concentric VL 208, VM 207, RF 148, GMed 106, GMax 106, BF 89; the text
#   and Fig 3 give the same order normalised to MVIC).
# - Farrokhi S, Pollard CD, Souza RB, Chen YJ, Reischl S, Powers CM 2008,
#   J Orthop Sports Phys Ther 38(7):403-409, doi 10.2519/jospt.2008.2634 —
#   bodyweight forward lunge (step out and back): upright trunk VL 45.6%,
#   gluteus maximus 18.5%, biceps femoris 11.9% MVIC; a forward trunk lean
#   raised hip extensor impulse and gluteus maximus (+20%) and biceps
#   femoris (+50%) EMG, VL unchanged.
# - Bezerra ES, Diefenthaeler F, Nunes JP, Sakugawa RL, Heberle I, Moura BM,
#   Moro ARP, Marcolin G, Paoli A 2021, Int J Exerc Sci 14(1):202-210, doi
#   10.70252/IGJM9937 (PMC8136561) — static, step-forward and walking lunges
#   with dumbbells (30% of body weight): an inclined trunk doubled lower-back
#   erector spinae activity (20 vs 40% MVIC) but did not change gluteus
#   maximus (45 vs 50%, p = 0.36) or biceps femoris (23 vs 24%).
# - Riemann BL, Lapinski S, Smith L, Davies G 2012, J Athl Train
#   47(4):372-378, doi 10.4085/1062-6050-47.4.16 — anterior lunge (step to
#   70% of leg length, erect torso, push back to standing): of the total net
#   joint extensor moment impulse, hip 62%, ankle 21%, knee 17% unloaded;
#   the knee moves most but the lunge is hip-extensor dominant kinetically;
#   added load raised the hip and ankle work, not the knee's.
# - Escamilla RF et al. 2008, J Orthop Sports Phys Ther 38(11):681-690, doi
#   10.2519/jospt.2008.2694 — patellofemoral force and stress greater with a
#   short step than a long step at 70-90° of knee flexion.
# - Hofmann CL, Holyoak DT, Juris PM 2017, J Orthop Sports Phys Ther
#   47(1):31-40, doi 10.2519/jospt.2017.6336 — trunk and shank position
#   trade patellofemoral stress between the lead and trail knees; a forward
#   trunk and forward shank gave the highest lead-knee stress, a vertical
#   shank gave the trail knee a higher peak than the lead knee, and
#   restricting the lead shank's forward travel may cut lead-knee stress at
#   the trail knee's expense (abstract).
# - Fry AC, Smith JC, Schilling BK 2003, J Strength Cond Res 17(4):629-633 —
#   stopping the knees passing the toes in the squat cut knee torque but
#   raised hip torque about tenfold and the forward trunk lean.
# - Hoogenboom BJ, Ferguson M, Krauss Z, Tran S 2024, Appl Sci
#   14(24):11480, doi 10.3390/app142411480 — bodyweight reverse lunge, peak
#   %MVIC: stationary (front) leg gluteus medius 49, gluteus maximus 37,
#   rectus femoris 36, biceps femoris 17; stepping leg rectus femoris 106,
#   biceps femoris 37, gluteus maximus 35, gluteus medius 34. Only the front
#   leg's gluteus medius and the stepping leg's rectus femoris passed 40%;
#   the stepping leg's rectus femoris peaked as the lifter rose (95% of
#   trials). Descriptive (no between-leg statistics); vasti not recorded.
# - Marchetti PH, Guiselini MA, da Silva JJ, Tucker R, Behm DG, Brown LE
#   2018, J Hum Kinet 62:15-22, doi 10.1515/hukin-2017-0174 (PMC6006536) —
#   high-bar barbell split-stance lunge, feet hip-width vs 50% of hip-width
#   (in-line) at 10RM: side-to-side sway under the front foot 14.8 vs
#   19.4 cm (+24%); vastus lateralis, biceps femoris, gluteus maximus and
#   medius activation did not differ between the two.
# - Shin HJ, Kim HM, Cho HY, Kim SH 2026, J Clin Med 15(14):5567, doi
#   10.3390/jcm15145567 — holding phase of a bodyweight forward lunge: a
#   narrow stance raised gluteus medius and lowered vastus lateralis and
#   medialis activity against standard and wide stances (notes only: the
#   Barbell Lunge track cue and the Curtsy rows).
# - DiStefano LJ, Blackburn JT, Marshall SW, Padua DA 2009, J Orthop Sports
#   Phys Ther 39(7):532-540, doi 10.2519/jospt.2009.2796 (values as tabled
#   by Boren K et al. 2011, Int J Sports Phys Ther 6(3):206-223, Table 1,
#   PMC3201064) — forward lunge gluteus maximus 44% and medius 42% MVIC,
#   transverse lunge 49% and 48%, sideways lunge 41% and 39%; side-lying
#   abduction (81%) best for the medius, single-leg squat and deadlift for
#   the maximus.
# - Simenz CJ, Garceau LR, Lutsch BN, Suchomel TJ, Ebben WP 2012, J Strength
#   Cond Res 26(12):3398-3405, doi 10.1519/JSC.0b013e3182472fad — of four
#   step-up variations, the crossover step-up drew the greatest concentric
#   gluteus medius activity (closest studied crossing movement to the
#   curtsy lunge).
# - Schwanbeck S, Chilibeck PD, Binsted G 2009, J Strength Cond Res
#   23(9):2588-2591, doi 10.1519/JSC.0b013e3181b1b181 — squats at 8RM: EMG
#   34%, 26% and 49% higher in gastrocnemius, biceps femoris and vastus
#   medialis with free weights than on the Smith machine (a squat study;
#   used only to keep the Smith lunge's rows a little under the barbell
#   lunge's).
# - Powers CM 2010, J Orthop Sports Phys Ther 40(2):42-51, doi
#   10.2519/jospt.2010.3337 — impaired control of the hip, pelvis and trunk
#   alters knee mechanics (dynamic valgus).
# - Boyd J, Milton K 2017, The Undervalued Lunge, NSCA Personal Training
#   Quarterly 4(4):44-48 — step longer than a walking stride, feet about
#   hip-width, back heel up, both knees ~90°, torso erect, push through the
#   front heel; common errors: feet too close, over-pronation of the foot
#   with the knee caving in, back foot turned out, forward torso lean.
# - ACE Exercise Library, Forward Lunge (barbell) — bar on the upper back,
#   grip slightly wider than the shoulders, feet hip-width, step forward,
#   back knee almost to the floor, push the front foot into the floor to
#   stand, alternate legs.
# - StrengthLog exercise guides: Lunges (quads, adductors, glutes; a step
#   long enough for both knees to reach ~90°, push back with the front leg;
#   railroad tracks, not a tightrope, feet hip-width), Smith Machine Lunges
#   (both feet directly under the bar, step back, keep the back upright,
#   weight on the front heel — both points diverge from this model; see the
#   notes), Curtsy Lunges (quads, glutes, adductors; step back and
#   diagonally behind the front leg; no studies cited).
# - ExRx.net Smith Rear Lunge and Barbell Lunge (Wayback copies of
#   2023-12-27 and 2024-01-05; the live pages block scripts): Smith — feet
#   under the bar or slightly forward, a long lunge with the feet slightly
#   forward emphasises the gluteus maximus, a short one with the feet under
#   the bar the quadriceps; Barbell — lunge forward, land on the heel, then
#   the forefoot, a long lunge emphasises the gluteus maximus. Both: keep
#   the torso upright, lead knee pointing the same way as the foot; target
#   gluteus maximus, synergists quadriceps, adductor magnus, soleus,
#   stabilisers include the gluteus medius (a classification, not EMG).
# No EMG study was found for the curtsy lunge or for any Smith machine lunge;
# their rows are ranked from the closest studied lunges and kept modest (see
# the notes).

from common_300_350 import *

NAMES = ["Forward Lunge", "Barbell Lunge", "Smith Machine Reverse Lunge", "Curtsy Lunge"]


def front_glow(name, stems, first, kind=A, opacity=0.55, rx=0.12, ry=0.07, dx=0.0, dy=0.0):
    """glow() centred on the working leg: `stems` on the side `first` over
    rep 1 (probe samples 1-3) and the other side over rep 2 (samples 5-7),
    leaving out the two standing samples, since the working leg swaps."""
    other = "R" if first == "L" else "L"
    pts = [J[name][s + "_" + first][k] for s in stems for k in (1, 2, 3)]
    pts += [J[name][s + "_" + other][k] for s in stems for k in (5, 6, 7)]
    tx, ty = sum(u for u, _ in pts) / len(pts), sum(v for _, v in pts) / len(pts)
    joints = [s + "_" + side for s in stems for side in ("L", "R")]
    mx, my = mean(name, joints)
    return glow(name, joints, kind, opacity, rx, ry, dx=tx - mx + dx, dy=ty - my + dy)


# ---------------------------------------------------------------- shared cues

# Forward and barbell lunges (step out, sink, push back; legs alternate).
STEP = ("Step Length",
        "Each rep starts with one long step forward.",
        "A step long enough for both knees to reach about 90° keeps the front shin close to upright; in a lunge study, a short step put more load on the front of the knee near the bottom than a long step did. A fully upright shin shifts some of that load to the back knee, so aim for 90° at both knees, not the longest step you can take.",
        "Taking a short step, so the front knee has to travel well past the toes to reach depth.",
        "Step further than a normal walking stride, land heel first and let the whole foot settle before you lower.")
STEP_BAR = ("Step Length",
            "Each rep starts with one long step forward, the bar riding with you.",
            "A step long enough for both knees to reach about 90° keeps the front shin near upright and the bar over the middle of the stance; in a lunge study, a short step loaded the front of the knee more near the bottom. A fully upright shin shifts some load to the back knee, so aim for 90° at both knees, not the longest step.",
            "Taking a short step, so the front knee has to travel well past the toes to reach depth.",
            "Step further than a normal walking stride, land heel first and let the whole foot settle before you lower.")
KNEE = ("Knee Alignment",
        "The front knee points the same way as the toes.",
        "Some forward knee travel is normal and is part of what loads the quadriceps; what matters is that the knee stays in line with the foot. A knee that caves inward often shows the hip or foot losing control of the leg, and twists the knee under load.",
        "The front knee caving inward toward the other leg as you lower or push back.",
        "Keep the front knee over the middle toes and the foot pointing ahead, toes turned out only slightly, all the way down and back up.")
DRIVE_FWD = ("Push Back",
             "The front leg pushes you all the way back to the start.",
             "Pressing through the whole front foot makes the front leg's hip and knee extensors do the return; in a joint-moment study of the forward lunge the hip extensors supplied the largest share of the effort, though the knee bends most. Rocking onto the toes tips the weight forward and makes the step back hard to control.",
             "Rising onto the ball of the front foot, the heel lifting, to push back.",
             "Keep the front foot flat, press through the heel and mid-foot and step back until the feet are together, then lunge with the other leg.")
LUNGE_ACT = [("Quadriceps", P, HI, 0.82), ("Gluteus Maximus", S, MOD, 0.46),
             ("Gluteus Medius", S, MOD, 0.40), ("Hamstrings", S, LOW, 0.24)]

# ---------------------------------------------------------------- forward lunges

ex(name="Forward Lunge", var="forwardLunge",
   # Side-on, facing left. The lifter stands at the right edge (u 0.78) and
   # travels to the centre (u 0.45) each rep, so right-hand pills below the
   # top row would cover the standing body, and at the bottom the front shin
   # fills the lower left (u 0.16-0.25). The leg dots follow the front and
   # back legs in both reps. Short labels on the left clear the elbow
   # (u 0.36) and the head (u 0.39) at the bottom. The step pill sits bottom
   # left under the landing front foot, its dot on the front ankle (the toe,
   # at v 0.78, would sit on the pill's top edge), and the depth pill bottom
   # right under the back knee, so both leaders stay short and apart
   # whenever a foot is out; they cross only at the feet in the moments the
   # lifter stands with the feet together.
   overrides={"torso": (0.14, "trailing"), "drive": (0.32, "leading"), "knee": (0.50, "leading"),
              "step": (0.86, "leading"), "depth": (0.86, "trailing")},
   annotations=[
       ("step", "Take a long step", "foot_front"),
       ("torso", "Chest up, torso tall", "chest"),
       ("knee", "Knee tracks toes", "patella_front"),
       ("depth", "Knees to 90°", "patella_back"),
       ("drive", "Push back", "pelvis"),
   ],
   cues={
       "step": STEP,
       "torso": ("Torso Position",
                 "Stay tall as you step out and lower.",
                 "An upright torso keeps the weight between the feet, so the front leg's quadriceps and glutes share the work; folding forward to catch the landing shifts the load toward the hips and lower back and the weight onto the front toes.",
                 "Leaning the chest forward over the front thigh as you lower.",
                 "Keep the chest up, the shoulders over the hips and the eyes forward, hands resting on the hips."),
       "knee": KNEE,
       "depth": ("Depth",
                 "Both knees bend to about 90° at the bottom.",
                 "Lowering until the back knee hovers just above the floor takes the front leg through its full range; stopping short, or letting the hips drift forward instead of down, leaves out the bottom of the rep.",
                 "Stopping halfway down, with the hips pushed forward over the front foot.",
                 "Drop the back knee straight down until it is just above the floor, both knees near 90°, then drive up."),
       "drive": DRIVE_FWD,
   },
   activation=LUNGE_ACT,
   stabilisers=["adductors", "calves", "core"],
   comparison=("SHORT STEP", "Long step, shin near upright", "Short step, knee crowds forward",
               "A long step lets both knees reach 90° with the front shin close to upright, so the quadriceps and glutes share the work.",
               "A short step makes the front knee travel well past the toes to reach depth, which raises the load on the front of the knee near the bottom."),
   glows=[front_glow("Forward Lunge", ["thigh", "patella"], "L", rx=0.12, ry=0.06, dx=0.02),
          front_glow("Forward Lunge", ["thigh"], "L", SOFT, 0.30, rx=0.07, ry=0.06, dx=0.04)])

SETUP["Forward Lunge"] = [
    "Stand tall with your feet hip-width apart.",
    "Rest your hands on your hips.",
    "Clear room in front of you for a long step.",
    "Brace your core before each step.",
]

ex(name="Barbell Lunge", var="barbellLunge",
   # Three-quarter front, travelling toward the camera-left: the standing
   # body sits at u 0.5-0.72 and the plates cover rows 0.32-0.46 on both
   # sides at the bottom, while the rep-2 front shin fills the lower left.
   # The trunk cue points at the upper trap (where the bar sits) from the top
   # right so its leader passes beside the head, not through it; the right
   # pills are short enough to clear the standing left shin (u 0.67).
   # Rows 0.55 sit between the plates' lower edge and the front thigh. The
   # leg dots follow the front and back legs in both reps; the track leader
   # stays short to the back foot and none cross.
   overrides={"torso": (0.14, "trailing"), "knee": (0.55, "leading"), "drive": (0.55, "trailing"),
              "track": (0.68, "trailing"), "step": (0.86, "trailing")},
   annotations=[
       ("step", "Take a long step", "toe_front"),
       ("torso", "Chest up, tall", "support_TrapeziusUpper_L"),
       ("track", "Feet hip-width", "foot_back"),
       ("knee", "Knee tracks toes", "patella_front"),
       ("drive", "Push back", "pelvis"),
   ],
   cues={
       "step": STEP_BAR,
       "torso": ("Torso Position",
                 "Stay tall under the bar.",
                 "With the bar on the upper back, an upright torso keeps it over the middle of the stance; letting the chest drop tips the bar forward, loads the lower back and pushes the weight onto the front toes.",
                 "The chest dropping and the upper back rounding under the bar as you lower.",
                 "Keep the chest up, the elbows down under the bar and the upper back tight, eyes forward."),
       "track": ("Foot Width",
                 "Each foot keeps its own track, about hip-width apart.",
                 "Hip-width tracks give a stable base under the bar; stepping onto the back foot's line, like walking a tightrope, narrows it. In a barbell lunge study, feet at half hip-width let the weight sway about a quarter more from side to side over the front foot.",
                 "Stepping the front foot in line with, or across, the back foot.",
                 "Step straight forward from the hip so the feet land about hip-width apart, as if on two rails."),
       "knee": KNEE,
       "drive": ("Push Back",
                 "The front leg pushes you and the bar back to the start.",
                 "Pressing through the whole front foot keeps the bar over a stable base and makes the front leg's hip and knee extensors do the return; in a joint-moment study of the forward lunge the hip extensors supplied the largest share of the effort, though the knee bends most. Rocking onto the toes tips the bar forward.",
                 "Rising onto the ball of the front foot, the heel lifting, to push back.",
                 "Keep the front foot flat, press through the heel and mid-foot and step back until the feet are together under the bar, then lunge with the other leg."),
   },
   activation=[("Quadriceps", P, HI, 0.84), ("Gluteus Maximus", S, MOD, 0.50),
               ("Gluteus Medius", S, MOD, 0.48), ("Hamstrings", S, LOW, 0.28)],
   stabilisers=["adductors", "erector spinae", "calves", "core"],
   comparison=("FEET IN LINE", "Feet about hip-width apart", "Front foot lands in line",
               "Landing each foot on its own track keeps a wide base, so the bar stays balanced over the stance.",
               "Stepping onto the back foot's line narrows the base, so the bar and hips sway more from side to side and each rep is harder to balance."),
   glows=[front_glow("Barbell Lunge", ["thigh", "patella"], "L", rx=0.12, ry=0.07),
          glow("Barbell Lunge", ["thigh_L"], SOFT, 0.30, rx=0.07, ry=0.06, dx=-0.02, dy=0.03)])

SETUP["Barbell Lunge"] = [
    "Set the bar in a rack just below shoulder height.",
    "Step under it and rest it on your upper traps, hands about a hand's width outside your shoulders.",
    "Stand up, step back and set your feet hip-width apart.",
    "Clear room in front of you for a long step.",
]

# ---------------------------------------------------------------- Smith reverse lunge

ex(name="Smith Machine Reverse Lunge", var="smithMachineReverseLunge",
   # Facing left inside the rails. The planted front foot fills the bottom
   # left in both reps (u 0.17-0.35, v 0.80-0.84) and the back foot the
   # bottom right, the left plate spans v 0.22-0.50 and the right plate
   # v 0.15-0.48. So three short labels stack on the right between the plate
   # and the back foot (rows 0.55-0.69, clear of the back knee as it passes
   # at u 0.67), the stance cue points at the bar from the top right (the
   # bar is what the feet are placed against) and the knee cue sits left.
   # The step dot follows the back foot and the knee dot the front knee in
   # both reps.
   overrides={"stance": (0.14, "trailing"), "knee": (0.50, "leading"), "lean": (0.55, "trailing"),
              "drive": (0.62, "trailing"), "step": (0.69, "trailing")},
   annotations=[
       ("stance", "Feet ahead of bar", "hand_L"),
       ("step", "Step back", "foot_back"),
       ("lean", "Hinge ~20°, back flat", "chest"),
       ("knee", "Knee in line", "patella_front"),
       ("drive", "Front leg drives", "pelvis"),
   ],
   cues={
       "stance": ("Foot Position",
                  "Set the feet a little ahead of the bar before you unhook it.",
                  "The Smith bar only moves straight up and down, so foot placement decides where you end up under it. With the feet a little ahead of it, the hips sit back behind the bar, which stays just behind the front foot, and the knee stays over the foot. Feet right under the bar send the front knee much further forward, which suits some lifters but tips others onto their toes.",
                  "Standing with the front foot under or behind the bar, so at the bottom the front heel peels up or the chest folds over the knee to reach depth.",
                  "Stand with the feet hip-width, heels about half a foot's length in front of the bar, and keep the planted foot there on every rep."),
       "step": ("Step Back",
                "One foot steps straight back, well behind the bar.",
                "A long step back lets the back knee drop under the hip and both knees reach about 90°; a short step crowds the stance under the fixed bar, so the back knee meets the floor early or the front knee travels further.",
                "Stepping back only a short way, so the feet end up cramped under the bar.",
                "Step straight back about a stride, land on the ball of the foot and keep the feet hip-width apart."),
       "lean": ("Hip Hinge",
                "In this version the torso tips about 20° forward from the hips as the foot goes back.",
                "Tipping forward from the hips with a flat back lets the hips sit back behind the fixed bar. In a forward-lunge study a forward trunk raised the hip extensors' share of the effort and, modestly, glute and hamstring activity; in a loaded lunge study it mainly raised lower-back activity. Keep the lean moderate and the spine long; a more upright torso is also fine.",
                "Rounding the back under the bar instead of hinging at the hips.",
                "Keep the spine long and the chest proud, tip forward from the hips about 20° as you lower, then stand tall at the top."),
       "knee": KNEE,
       "drive": ("Front-Leg Drive",
                 "The planted front leg lifts you and the bar.",
                 "Both legs work: in a reverse lunge study the planted leg's gluteus medius was the more active, and the stepping leg's front thigh worked hard as the lifter rose. Driving mainly through the front foot keeps the front leg doing its share; shoving off the back foot shifts the lift onto the back leg.",
                 "Pushing up off the back foot, the back knee straightening first.",
                 "Keep the back foot light, press through the whole front foot and stand up on the front leg, then step the back foot in beside it."),
   },
   activation=[("Quadriceps", P, HI, 0.78), ("Gluteus Maximus", S, MOD, 0.50),
               ("Gluteus Medius", S, MOD, 0.42), ("Hamstrings", S, LOW, 0.30)],
   stabilisers=["adductors", "erector spinae", "core"],
   comparison=("FRONT FOOT UNDER THE BAR", "Front foot ahead of the bar", "Front foot under the bar",
               "With the front foot a little ahead of the fixed bar, the hips can sit back as you step back and the bar stays between the feet, just behind the front foot.",
               "With the front foot under the bar, the rails keep the bar over it, so reaching depth tips the weight onto the front toes or folds the chest over the knee."),
   glows=[front_glow("Smith Machine Reverse Lunge", ["thigh", "patella"], "R", rx=0.12, ry=0.07),
          glow("Smith Machine Reverse Lunge", ["pelvis"], SOFT, 0.35, rx=0.07, ry=0.06, dx=0.07, dy=0.02)])

SETUP["Smith Machine Reverse Lunge"] = [
    "Set the Smith bar just below shoulder height.",
    "Step under it and rest it on your upper traps, hands about a hand's width outside your shoulders.",
    "Stand with your feet hip-width, heels about half a foot's length in front of the bar.",
    "Turn the bar to unhook it and brace your core.",
]

# ---------------------------------------------------------------- curtsy lunge

ex(name="Curtsy Lunge", var="curtsyLunge",
   # Three-quarter front: the elbows reach both edges at rows 0.32-0.50, so
   # the chest cue points at the clasped hands from the top row. In rep 1
   # the crossing foot lands bottom right (u 0.78-0.86, v 0.74-0.80), so the
   # heel label goes bottom left and the crossing label sits above that foot,
   # short enough to clear the front hip (u 0.68). The cross, knee and heel
   # dots follow the back foot, front knee and front foot in both reps, so
   # in rep 2 the heel dot stays on the planted foot, not the raised one.
   overrides={"torso": (0.14, "leading"), "knee": (0.59, "leading"), "hips": (0.59, "trailing"),
              "cross": (0.68, "trailing"), "drive": (0.86, "leading")},
   annotations=[
       ("hips", "Hips square", "pelvis"),
       ("cross", "Cross behind", "foot_back"),
       ("knee", "Knee tracks toes", "patella_front"),
       ("torso", "Chest up, hands clasped", "hand_R"),
       ("drive", "Front heel down", "foot_front"),
   ],
   cues={
       "hips": ("Hip Position",
                "The hips keep facing forward while one leg steps behind.",
                "Keeping the pelvis square is what gives the curtsy its angle: the standing hip has to hold the pelvis level and facing forward while the other leg reaches across behind it, which asks more of the muscles on the side of that hip. Letting the hips turn makes it an ordinary reverse lunge with a twist.",
                "The hips and chest turning toward the back leg as it crosses behind.",
                "Keep both hip bones and the chest pointing straight ahead, and let the back leg reach across under a still pelvis."),
       "cross": ("Crossing Step",
                 "The back foot steps diagonally behind and across the front foot.",
                 "A modest cross, the back foot landing just past the line of the front foot, sets the angle; swinging it far across twists the pelvis toward the back leg and makes the rep harder to balance and the front knee harder to hold in line.",
                 "Swinging the back foot far across behind the body, well past the front foot.",
                 "Step back and across so the back foot lands just outside the front heel's line, on the ball of the foot, heel up."),
       "knee": ("Front Knee",
                "The front knee follows the front toes.",
                "With both feet on the same side of the body, the front leg has to control the sideways load as well, and a knee that drifts inward often shows the hip or foot losing that control. The knee may travel forward past the toes, which is normal while the heel stays down.",
                "The front knee collapsing inward over the arch as you lower.",
                "Keep the front knee over the middle toes and the foot pointing ahead, toes turned out only slightly, as you lower and rise."),
       "torso": ("Torso Position",
                 "The chest stays up, hands clasped in front of it.",
                 "A tall torso with only a slight forward lean keeps the weight over the front foot, where the front leg can drive; folding forward over the front thigh shifts the load onto the toes and the lower back.",
                 "Folding the chest forward over the front thigh at the bottom.",
                 "Keep the chest up and the hands clasped in front of it, with no more than a slight forward lean at the bottom."),
       "drive": ("Front-Leg Drive",
                 "Push back up through the whole front foot.",
                 "The front leg carries the body down and back up while the back foot rests high on its toes; a planted front heel gives a stable base to push through. Rising onto the toes tips the weight forward onto the front knee.",
                 "The front heel lifting as you push back up, the weight rolling onto the toes.",
                 "Keep the front heel down, press through the heel and mid-foot and bring the back foot back beside the front one, then switch sides."),
   },
   activation=[("Quadriceps", P, HI, 0.78), ("Gluteus Maximus", S, MOD, 0.48),
               ("Gluteus Medius", S, MOD, 0.48), ("Adductor Magnus", S, LOW, 0.30)],
   stabilisers=["gluteus minimus", "calves", "core"],
   comparison=("HIPS TURNING OPEN", "Hips square to the front", "Hips turn toward the back leg",
               "With the pelvis square, the standing hip has to hold the pelvis steady while the front thigh lowers and lifts you.",
               "When the hips open toward the back leg, the cross disappears: the rep turns into a twisted reverse lunge and loses the angle that makes the curtsy different."),
   glows=[front_glow("Curtsy Lunge", ["thigh", "patella"], "L", rx=0.15, ry=0.07),
          # the side of each hip (gluteus medius): the stance hip is the left
          # in rep 1 and the right in rep 2
          glow("Curtsy Lunge", ["thigh_L"], SOFT, 0.30, rx=0.05, ry=0.06, dx=0.05, dy=0.03),
          glow("Curtsy Lunge", ["thigh_R"], SOFT, 0.30, rx=0.05, ry=0.06, dx=-0.05, dy=0.03)])

SETUP["Curtsy Lunge"] = [
    "Stand tall with your feet a little wider than hip-width.",
    "Clasp your hands in front of your chest, elbows out.",
    "Soften your knees and face straight ahead.",
    "Brace your core before each step.",
]

if __name__ == "__main__":
    probs = validate(["Forward Lunge", "Barbell Lunge", "Smith Machine Reverse Lunge", "Curtsy Lunge"]); print("\n".join(probs) or "OK")
