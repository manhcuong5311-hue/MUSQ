# Trainer content for batch 191-240 (2026-09-26), family: front raises,
# rear-delt rows and upright rows. Source exports 213-216, 220, 221, 223, 225
# and 226 from the HIKSEMI drive's "190-240" folder (SourceExports/190-240).
# Same format as spec.py; spec_191_240.py imports this module and gen.py
# reads SPEC / SETUP.
#
# What each model shows, from the briefs, the framing shots and the rig
# (joints sampled over the clip; torso length, neck to pelvis, is 0.59 m):
# - Plate Front Raise: standing tall, feet ~0.3 m apart, knees ~174°. Both
#   hands hold one plate (~45 cm across) at its sides, 3 and 9 o'clock,
#   palms facing. Elbows stay soft (~153-159°). The plate rises from in front
#   of the thighs to face height: upper arms ~95° (just past parallel), plate
#   centre ~1.53 m, standing upright in front of the face. Torso still.
# - Barbell Front Raise: standing tall, feet ~0.3 m apart. Overhand grip,
#   hands ~0.48 m apart (about shoulder-width). Elbows ~170°. The bar rises
#   from the thighs to shoulder height (upper arms ~89°). Framed nearly
#   side-on from the left front (yaw -1.0).
# - Cable Front Raise: back to a low pulley, the cable running between the
#   legs to a straight bar; feet ~0.36 m apart, knees ~172°, trunk held ~15°
#   forward from the hips for the whole clip. Overhand grip ~0.47 m, elbows
#   ~170°. The bar rises from the thighs until the hands are level with the
#   shoulders (upper arms ~105° to the leaning trunk, level with the floor).
#   The bar and cable follow the hands in the USD, but the framing shot
#   shows the bar left at the hips: the equipment clip (frames 1-187) and
#   the skeleton clip (7-187) loop separately in the app, so they drift
#   apart (for the lead: pad every time-sampled attribute to 1-192 in the
#   converter; see the notes).
# - Alternating Dumbbell Front Raise: standing tall, feet ~0.3 m apart, a
#   dumbbell in each hand, overhand (handles across, palms to the thighs),
#   elbows ~170°. The LEFT arm raises to shoulder height (upper arm ~89°) and
#   lowers, then the right; the resting dumbbell stays at the thigh. The
#   left dumbbell's clip is only frames 1-91, so in the app it loops early
#   and floats in front of the face during the right-arm rep (same fix).
# - Rear Delt Row: dumbbells, hinged ~50° forward from the hips (hip angle
#   ~113°), knees ~156°, feet ~0.34 m apart. Overhand grip with the handles in
#   line with the shoulders. Both arms row together, elbows flaring out to
#   the sides: from straight (~177°) to ~76°, the upper arms finishing square
#   to the trunk (~87°) and just past the line of the back; hands apart
#   0.47 -> 0.97 m. Seen from behind-left (yaw -2.3).
# - Machine Rear Delt Row: seated on a chest-supported row machine, chest on
#   the pad, trunk ~8° forward, feet flat on the floor just behind the foot
#   decks (the toes clip their front edge), knees ~115°.
#   Overhand grip on wide horizontal handles level with the shoulders (hand
#   height constant). The elbows travel at shoulder height (upper arms
#   81-93° from the sides) from a forward reach (elbows ~159°) back to just
#   past the line of the shoulders (elbows ~87-94°). Seen from behind-right
#   (yaw 2.4).
# - Barbell Upright Row: standing tall, feet ~0.3 m apart. Overhand grip,
#   hands ~0.42-0.50 m apart (about shoulder-width, ~100-125% of the rig's
#   shoulder breadth). The bar rises close to the body (hands 0.17-0.24 m in
#   front of the shoulders) from the thighs to the upper chest (wrists ~5 cm
#   below the shoulders); elbows lead and finish ~110° from the sides, about
#   10 cm and 20° above shoulder height (elbows ~55°). No shrug in the rig.
#   That is a little past the guidance the copy follows (just below 90°,
#   Schoenfeld 2011; humerus no higher than horizontal, McAllister 2013), so
#   the copy says around shoulder height and no higher; a re-export that
#   stops at ~90-95° is for the lead to decide. Same in all three models.
# - Cable Upright Row: the same pull facing a low pulley a short step away
#   (cable ~20-30° off vertical), straight bar, overhand ~0.47-0.54 m.
#   Framed from the right front (yaw +0.6). Same bar-at-the-hips drift in the
#   framing shot as the cable front raise (cable parts 1-184/190).
# - Smith Machine Upright Row: the same pull on a Smith bar (bar ~16-18 cm
#   in front of the ankles, just in front of the thighs; at the bottom it
#   sits at ~0.84 m, the top of the thighs), overhand ~0.42-0.51 m, elbows
#   ~178° -> ~45°, upper arms to ~110°.
#
# Sources:
# - Coratella G, Tornatore G, Longo S, Esposito F, Ce E 2020, Int J Environ
#   Res Public Health 17(17):6015, doi:10.3390/ijerph17176015 — frontal raise
#   (thumb-to-thumb, elbows almost straight, to 90°): greater anterior
#   deltoid and clavicular pectoralis activity than every lateral raise
#   variation; medial deltoid and upper trapezius lower than in lateral
#   raises; frontal raise mainly anterior deltoid + clavicular pectoralis.
# - Demirtas B, Cakir O, Cetin O, Cilli M 2023, Kinesiologia Slovenica
#   29(1):73-87, doi:10.52165/kinsi.29.1.73-87 — one-arm dumbbell front
#   raise to 90°, 14 trained men, 80% 1RM: anterior deltoid concentric
#   51.6% with a pronated grip vs 43.4% with a hammer (palms-in) grip
#   (p<0.05); medial deltoid 27 vs 21% (not significant). The palms-facing
#   plate raise takes the anterior deltoid down from the overhand value
#   accordingly; the medial deltoid keeps the overhand value.
# - Sweeney S, Porcari JP, Camic C, Kovacs A, Foster C — ACE-sponsored EMG
#   study, Dynamite Delts: ACE Research Identifies Top Shoulder Exercises,
#   ACE ProSource, September 2014, reprinted in the ProSource Research
#   Special Issue 2015 (not peer reviewed; PDF at
#   https://acewebcontent.azureedge.net/certifiednews/images/article/pdfs/ACEShoulderStudy.pdf):
#   dumbbell front raise anterior/medial/posterior deltoid 57/36/9 %MVC;
#   barbell upright row 33/73/31; 45° incline (chest-supported, arms
#   perpendicular to the body) row medial 84, posterior 69; seated rear
#   lateral raise posterior 73.
# - McAllister MJ, Schilling BK, Hammond KG, Weiss LW, Farney TM 2013,
#   J Strength Cond Res 27(1):181-187, doi:10.1519/JSC.0b013e31824f23ad —
#   upright row at 50/100/200% of biacromial breadth, one load (85% of the
#   1RM at 100%) for all grips: significant increases mainly between 100%
#   and 200% (lateral and posterior deltoid concentric; lateral deltoid,
#   upper and middle trapezius eccentric); biceps fell significantly only
#   eccentrically, 50% vs 200%. Bar raised no higher than the xiphoid to
#   keep the humerus from passing horizontal.
# - Schoenfeld B, Kolber MJ, Haimes JE 2011, Strength Cond J 33(5):25-28 —
#   the upright row: elevating the arms above shoulder height while
#   internally rotated risks subacromial impingement (peaking ~70-120° of
#   elevation; imaging and surgical studies greatest at 70-90° without
#   external rotation); pull the bar close to the body, pull through the
#   elbows not the wrists; just below shoulder height for people without
#   symptoms, lower for anyone with pain. The risk evidence is anatomical,
#   imaging and expert guidance, not injury rates.
# - Andersen LL, Kjaer M, Andersen CH, Hansen PB, Zebis MK, Hansen K,
#   Sjogaard G 2008, Phys Ther 88(6):703-711 — 12 women with trapezius
#   myalgia: upright row upper trapezius 85 ±5% MVC with light loads
#   (3-10 kg; shrug 102, lateral raise 97).
# - Vasconcelos CMWA, Lopes CR, Almeida VM, Krause Neto W, Soares EG 2023,
#   Int J Strength Cond 3(1), doi:10.47206/ijsc.v3i1.190 — seated cable row:
#   upper and middle trapezius and posterior deltoid activity rose as
#   shoulder abduction increased (highest at 60° and 90°); latissimus
#   activity and peak force were higher with the elbows near the sides.
# - Reinold MM, Wilk KE, Fleisig GS et al. 2004, J Orthop Sports Phys Ther
#   34(7):385-394 — prone horizontal abduction at 100° with external
#   rotation: posterior deltoid 88%, middle deltoid 87% MVIC.
# - Escamilla RF, Yamashiro K, Paulos L, Andrews JR 2009, Sports Med
#   39(8):663-685 — rowing-type exercises and prone horizontal abduction
#   show high cuff, deltoid and scapular activity; scaption with internal
#   rotation (the empty can) increases scapular internal rotation and
#   anterior tilt, narrowing the subacromial space, compared with the full
#   can; the serratus anterior drives scapular upward rotation.
# - ExRx.net: Dumbbell Rear Delt Row (upper arm perpendicular to the trunk,
#   elbow directly out from the shoulder; a 45° torso is not enough to
#   target the rear delts, keep it near horizontal); Barbell / Cable / Smith
#   Upright Row (overhand, elbows lead, wrists flex, stand close to the
#   pulley; ExRx pulls the bar to the neck, this copy stops at the upper
#   chest per Schoenfeld 2011 and McAllister 2013); Barbell Front Raise and
#   Cable Bar Front Raise (overhand, elbows straight or slightly bent, upper
#   arms raised to just above horizontal). Pages, under
#   https://exrx.net/WeightExercises/: DeltoidPosterior/DBRearDeltRow,
#   DeltoidLateral/BBUprightRow, DeltoidLateral/CBUprightRow,
#   DeltoidLateral/SMUprightRow, DeltoidAnterior/BBFrontRaise,
#   DeltoidAnterior/CBBarFrontRaise (exrx.net blocks direct fetches; the
#   wording was checked through search-result text).
#
# Evidence is thin for the plate, cable and alternating front raises and
# for the machine rear-delt row specifically; their activation follows the
# closest studied variation (dumbbell or barbell front raise, the hammer
# grip for the plate; the 45° incline row, prone horizontal abduction and
# the 90°-abduction seated row).
#
# Labels: every entry pins its rows with `overrides`, checked by drawing the
# pills and leaders to all eight probed joint positions; no two cues share
# a joint, no leaders cross, no leader runs through another cue's pill, and
# every dot stays at least ~11 pt clear of every pill, its own included.

from common_191_240 import *

# ---------------------------------------------------------------- front raises

FR_ACTIVATION = [("Anterior Deltoid", P, HI, 0.84), ("Upper Pectoralis", S, MOD, 0.56), ("Lateral Deltoid", S, MOD, 0.40)]

SHOULDER_FR = ("Shoulder Position",
               "The shoulders stay down while the arms rise.",
               "Shrugging lets the upper trapezius hoist the shoulders and the weight with them; keeping the shoulder blades set leaves the front deltoids to raise the arms.",
               "Shoulders hunching up and forward as the weight rises.",
               "Set the shoulders down and back before the first rep and keep the neck long.")
ELBOW_FR = ("Arm Position",
            "The arms stay long with a slight bend.",
            "A soft, fixed elbow holds the weight far from the shoulder, so the front deltoid works a long lever; bending further as the weight rises shortens it and invites a swing.",
            "Bending the elbows as the weight rises, curling it in toward the face.",
            "Set a slight bend in the elbows at the bottom and hold exactly that angle up and down.")
TORSO_FR = ("Torso Control",
            "Only the arms move.",
            "Leaning back lets the hips swing the weight up and arches the lower back; a still torso leaves the front deltoids to lift it without help from momentum.",
            "Rocking the torso back to heave the weight up.",
            "Brace the core, squeeze the glutes and keep the torso vertical from the first rep to the last.")

def height_fr(what, top):
    return ("Range of Motion",
            f"The {what} rises from the thighs to {top}.",
            "Raising to about shoulder level loads the anterior deltoid where the weight pulls hardest on the shoulder; swinging much higher hands more of the lift to the traps and serratus, which rotate the shoulder blade up.",
            f"Swinging the {what} up above the head.",
            f"Lift until the arms are level with the floor or just above, pause, and lower the {what} to the thighs slowly.")

def fr_glows(name):
    return [glow(name, ["deltoid_arc_clavicle_2_L"], A, 0.55, rx=0.10, ry=0.07),
            glow(name, ["deltoid_arc_clavicle_2_R"], SOFT, 0.32, rx=0.09, ry=0.06),
            glow(name, ["support_PectoralisMajor_Clavicular_L", "support_PectoralisMajor_Clavicular_R"], SOFT, 0.28, rx=0.10, ry=0.05, dy=0.03)]

ex(name="Plate Front Raise", var="plateFrontRaise",
   annotations=[
       ("height", "Plate to face height", "hand_L"),
       ("shoulder", "Shoulders stay down", "support_TrapeziusUpper_L"),
       ("elbow", "Soft, fixed elbows", "forearm_L"),
       ("grip", "Grip at 3 and 9 o'clock", "hand_R"),
       ("torso", "No backward lean", "spine"),
   ],
   cues={
       "height": ("Range of Motion",
                  "The plate rises from the thighs to about face height.",
                  "Lifting until the arms are just past parallel works the anterior deltoid through its working range; heaving the plate overhead hands more of the lift to the traps and serratus, which rotate the shoulder blade up.",
                  "Swinging the plate up above the head at the top of each rep.",
                  "Raise until the arms are just above parallel and the plate is in front of the face, pause, then lower to the thighs under control."),
       "shoulder": SHOULDER_FR,
       "elbow": ELBOW_FR,
       "grip": ("Grip",
                "Hands on the rim at 3 and 9 o'clock, palms facing.",
                "Holding the plate at its sides centres it between the hands, so both arms lift the same load with the wrists straight.",
                "Wrists bending as the plate rises, so it tilts back toward the face.",
                "Squeeze the rim at the sides with the palms facing, wrists in line with the forearms and the plate upright."),
       "torso": TORSO_FR,
   },
   # Palms facing (a hammer-type grip): anterior deltoid scaled down from the
   # overhand value per Demirtas 2023 (43.4 vs 51.6% concentric, p<0.05). The
   # medial deltoid showed no significant grip effect there (21 vs 27%), so
   # it keeps the overhand value.
   activation=[("Anterior Deltoid", P, HI, 0.72), ("Upper Pectoralis", S, MOD, 0.56), ("Lateral Deltoid", S, MOD, 0.40)],
   stabilisers=["serratus anterior", "upper trapezius", "forearms", "core"],
   comparison=("SWINGING THE PLATE", "Strict raise to face height", "Hips swing the plate up",
               "A controlled raise with a still torso keeps the front deltoids lifting the whole plate.",
               "Leaning back and swinging moves the plate with momentum and loads the lower back instead of the shoulders."),
   overrides={"height": (0.68, "leading"), "shoulder": (0.14, "trailing"), "elbow": (0.14, "leading"), "grip": (0.50, "leading"), "torso": (0.32, "trailing")},
   glows=fr_glows("Plate Front Raise"))
SETUP["Plate Front Raise"] = [
    "Stand with your feet hip-width apart, knees soft.",
    "Hold a plate at 3 and 9 o'clock, palms facing each other.",
    "Let it hang in front of your thighs, elbows slightly bent.",
    "Brace your core and set your shoulders down.",
]

ex(name="Barbell Front Raise", var="barbellFrontRaise",
   annotations=[
       ("height", "Bar to shoulder level", "hand_R"),
       ("grip", "Overhand, shoulder-width", "hand_L"),
       ("elbow", "Arms long, elbows soft", "forearm_R"),
       ("shoulder", "Shoulders down, no shrug", "attachment_TrapeziusUpper_R"),
       ("torso", "No backward lean", "spine"),
   ],
   cues={
       "height": height_fr("bar", "shoulder height"),
       "grip": ("Grip",
                "Overhand, hands about shoulder-width.",
                "With the hands about shoulder-width each arm rises straight in front of its own shoulder and the bar stays level; bunching the hands together angles the arms in across the chest and makes the bar harder to balance.",
                "Hands bunched together in the middle of the bar.",
                "Hold the bar overhand with the hands about shoulder-width, thumbs around it and wrists straight."),
       "elbow": ELBOW_FR,
       "shoulder": SHOULDER_FR,
       "torso": TORSO_FR,
   },
   activation=FR_ACTIVATION,
   stabilisers=["serratus anterior", "upper trapezius", "wrist extensors", "core"],
   comparison=("LEANING BACK", "Upright, bar to shoulder height", "Torso leans back to lift",
               "Standing tall makes the front deltoids raise the bar through the whole arc.",
               "Leaning back swings the bar up with the hips and arches the lower back."),
   overrides={"height": (0.50, "leading"), "grip": (0.68, "leading"), "elbow": (0.14, "leading"), "shoulder": (0.14, "trailing"), "torso": (0.50, "trailing")},
   glows=fr_glows("Barbell Front Raise"))
SETUP["Barbell Front Raise"] = [
    "Stand with your feet hip-width apart, knees soft.",
    "Hold the bar overhand, hands about shoulder-width.",
    "Let it rest against your thighs, arms long.",
    "Brace your core and set your shoulders down.",
]

ex(name="Cable Front Raise", var="cableFrontRaise",
   annotations=[
       ("height", "Bar to shoulder level", "hand_R"),
       ("shoulder", "Shoulders down, no shrug", "attachment_TrapeziusUpper_L"),
       ("elbow", "Soft, fixed elbows", "forearm_R"),
       ("torso", "Slight lean, held still", "spine"),
       ("stance", "Cable between the feet", "foot_R"),
   ],
   cues={
       "height": ("Range of Motion",
                  "The bar rises from the thighs to shoulder height.",
                  "Pulling from behind and below, the cable resists the raise from the very first centimetre, where a dumbbell barely loads the front deltoid; stopping at shoulder level keeps the work on the deltoid.",
                  "Swinging the bar up above the head.",
                  "Lift until the hands are level with the shoulders, pause, and let the bar return to the thighs slowly."),
       "shoulder": SHOULDER_FR,
       "elbow": ELBOW_FR,
       "torso": ("Torso Position",
                 "A slight forward lean, held for the whole set.",
                 "Leaning a little forward from the hips counters the cable pulling back, so the trunk stays still while the front deltoids lift.",
                 "Rocking back upright, or past it, to swing the bar up.",
                 "Hinge about 15° forward from the hips, brace, and hold that angle as the bar rises and lowers."),
       "stance": ("Base",
                  "Back to the stack, feet a little wider than the hips.",
                  "A wide, balanced base with the cable running between the feet lets you lean slightly into its pull without being tipped back toward the stack.",
                  "Feet close together and knees locked, so the cable pulls the body back as the bar rises.",
                  "Stand a step in front of the pulley, feet a little wider than hip-width with the cable between them, knees soft."),
   },
   activation=FR_ACTIVATION,
   stabilisers=["serratus anterior", "upper trapezius", "erector spinae", "core"],
   comparison=("LEANING BACK", "Slight lean held, bar to shoulders", "Torso rocks back to lift",
               "Holding a slight forward lean keeps the trunk still, so the front deltoids raise the bar against the cable.",
               "Rocking back lets the stack pull the body and swings the bar up with the hips."),
   overrides={"height": (0.50, "leading"), "shoulder": (0.14, "trailing"), "elbow": (0.14, "leading"), "torso": (0.68, "leading"), "stance": (0.86, "leading")},
   glows=fr_glows("Cable Front Raise"))
SETUP["Cable Front Raise"] = [
    "Attach a straight bar to a low pulley.",
    "Stand with your back to the stack, the cable between your feet.",
    "Hold the bar overhand, hands about shoulder-width.",
    "Lean slightly forward from the hips, arms long.",
]

ex(name="Alternating Dumbbell Front Raise", var="alternatingDumbbellFrontRaise",
   annotations=[
       ("height", "Stop at shoulder height", "hand_L"),
       ("shoulder", "Shoulders down, no shrug", "attachment_TrapeziusUpper_R"),
       ("elbow", "Soft, fixed elbows", "forearm_R"),
       ("alternate", "Chest square, no twist", "upper_arm_R"),
       ("torso", "No lean or sway", "chest"),
   ],
   cues={
       "height": ("Range of Motion",
                  "Each dumbbell rises from the thigh to shoulder height.",
                  "Raising to about shoulder level loads the anterior deltoid where the dumbbell pulls hardest on the shoulder; swinging higher hands more of the lift to the traps and serratus.",
                  "Swinging the dumbbell up above the head.",
                  "Raise one arm until it is level with the floor, pause, and lower it to the thigh before the other arm starts."),
       "shoulder": ("Shoulder Position",
                    "Both shoulders stay down while the arms take turns.",
                    "Keeping the shoulder blades set stops the upper trapezius hiking the dumbbell up, so the front deltoid does the lifting.",
                    "Shoulders hiking toward the ears as each dumbbell rises.",
                    "Keep both shoulders down and level, the neck long, as each arm lifts."),
       "elbow": ("Arm Position",
                 "Both arms stay long with a slight bend.",
                 "A soft, fixed elbow keeps a long lever on the front deltoid and the stress off the elbow joint.",
                 "Bending the elbows, curling the dumbbells in toward the body.",
                 "Hold a slight bend in both elbows, working and resting, and keep it constant up and down."),
       "alternate": ("Trunk Control",
                     "The chest stays square while the arms take turns.",
                     "With one dumbbell out in front and the other at the thigh the load is off-centre, pulling the trunk forward and toward the working side; holding it square and still makes each front deltoid lift its own dumbbell instead of the trunk throwing it up.",
                     "Twisting the trunk so the working shoulder swings forward to throw the dumbbell up.",
                     "Brace the core, keep the chest and hips facing forward, and let only the working arm move."),
       "torso": ("Torso Control",
                 "No lean back and no rocking side to side.",
                 "Rocking the body to start each rep swings the dumbbell up with momentum and arches the lower back.",
                 "Leaning back to heave the dumbbell up.",
                 "Stand tall with the glutes and core tight, and keep the torso still as the arms alternate."),
   },
   activation=FR_ACTIVATION,
   stabilisers=["serratus anterior", "obliques", "upper trapezius", "core"],
   comparison=("TWISTING TO LIFT", "Chest square, one arm lifts", "Shoulder swings forward",
               "Holding the trunk square makes each front deltoid raise its dumbbell on its own.",
               "Swinging the working shoulder forward throws the dumbbell up with the trunk and takes load off the front deltoid."),
   overrides={"height": (0.68, "trailing"), "shoulder": (0.14, "leading"), "elbow": (0.32, "leading"), "alternate": (0.50, "leading"), "torso": (0.14, "trailing")},
   glows=fr_glows("Alternating Dumbbell Front Raise"))
SETUP["Alternating Dumbbell Front Raise"] = [
    "Stand with a dumbbell in each hand in front of your thighs.",
    "Palms facing your body, elbows softly bent.",
    "Feet hip-width, core braced.",
    "Raise one arm at a time; the other rests at your thigh.",
]

# ---------------------------------------------------------------- rear-delt rows

def rd_glows(name):
    return [glow(name, ["deltoid_arc_scapula_2_L"], A, 0.55, rx=0.10, ry=0.07),
            glow(name, ["deltoid_arc_scapula_2_R"], SOFT, 0.32, rx=0.09, ry=0.06),
            glow(name, ["scapula_L", "scapula_R"], SOFT, 0.28, rx=0.09, ry=0.06)]

ex(name="Rear Delt Row", var="rearDeltRow",
   annotations=[
       ("elbow", "Elbows out wide", "forearm_L"),
       ("height", "Elbows up to back level", "forearm_R"),
       ("hinge", "Stay hinged forward", "thigh_R"),
       ("traps", "Shoulders away from ears", "support_TrapeziusUpper_L"),
       ("back", "Flat back", "chest"),
   ],
   cues={
       "elbow": ("Elbow Path",
                 "The elbows flare out, the upper arms square to the torso.",
                 "Rowing with the upper arms at about 90° from the body moves the work from the lats to the rear deltoids and mid-back; tucking the elbows turns it back into a lat row.",
                 "Tucking the elbows in toward the ribs and rowing to the hips.",
                 "Pull the elbows up and out to the sides, the upper arms at right angles to the torso."),
       "height": ("Range of Motion",
                  "The elbows rise until they line up with the back.",
                  "The dumbbells pull hardest on the rear deltoids as the upper arms come level with the back, near the end of their shortening; stopping well below that skips the hardest part of the rep.",
                  "Short reps that stop with the elbows well below the back.",
                  "Row until the upper arms line up with the back, pause, then lower to straight arms."),
       "hinge": ("Torso Angle",
                 "The torso stays well forward.",
                 "The flatter the torso, the more directly the dumbbells pull against the rear deltoids; standing taller turns the pull toward an upright row for the side delts and traps.",
                 "Standing up taller as the set goes on.",
                 "Push the hips back with soft knees until the torso is past halfway to parallel, flatter if your hamstrings allow, and hold that angle for the set."),
       "traps": ("Shoulder Position",
                 "The shoulders stay away from the ears.",
                 "Shrugging hands the top of the row to the upper trapezius instead of the rear deltoids and mid-back.",
                 "Shrugging the shoulders toward the ears as the dumbbells rise.",
                 "Keep the neck long and draw the shoulder blades back, not up."),
       "back": ("Back Position",
                "A flat back from the hips to the head.",
                "A neutral spine lets the hips hold the hinge; a rounded back puts the load on the spine and lets the shoulders roll forward.",
                "Rounding the upper back with the head dropping.",
                "Brace, keep the chest proud and the neck in line with the spine, eyes on the floor ahead of the feet."),
   },
   activation=[("Posterior Deltoid", P, HI, 0.78), ("Lateral Deltoid", P, HI, 0.78), ("Middle Trapezius", S, MOD, 0.60),
               ("Rhomboids", S, MOD, 0.45)],
   stabilisers=["erector spinae", "hamstrings", "biceps brachii", "forearms"],
   comparison=("ELBOWS TUCKED", "Elbows out wide, arms at 90°", "Elbows tuck to the ribs",
               "Flaring the elbows so the upper arms stay square to the torso keeps the rear deltoids pulling.",
               "Tucking the elbows turns the pull into a lat row and moves the work away from the rear deltoids."),
   overrides={"elbow": (0.50, "leading"), "height": (0.68, "leading"), "hinge": (0.86, "leading"), "traps": (0.14, "trailing"), "back": (0.14, "leading")},
   glows=rd_glows("Rear Delt Row"))
SETUP["Rear Delt Row"] = [
    "Hold a dumbbell in each hand with an overhand grip.",
    "Hinge forward from the hips, knees soft, back flat.",
    "Let the dumbbells hang under your shoulders.",
    "Turn the handles so they line up with your shoulders.",
]

ex(name="Machine Rear Delt Row", var="machineRearDeltRow",
   annotations=[
       ("seat", "Handles at shoulder height", "hand_R"),
       ("elbow", "Elbows high and wide", "forearm_L"),
       ("range", "Full reach, full squeeze", "forearm_R"),
       ("traps", "Shoulders down", "support_TrapeziusUpper_L"),
       ("chest", "Chest on the pad", "chest"),
   ],
   cues={
       "seat": ("Seat Height",
                "The handles sit level with the shoulders.",
                "With the handles at shoulder height the elbows travel level with the shoulders, where the rear deltoids pull the arms back.",
                "Sitting so high that the arms slope down to the handles and the elbows drop.",
                "Adjust the seat so the handles line up with your shoulders when you hold them."),
       "elbow": ("Elbow Height",
                 "The elbows stay high and wide, level with the shoulders.",
                 "With the upper arms out at about 90° from the body, the row pulls through the rear deltoids and mid-back; low, tucked elbows hand it to the lats.",
                 "Elbows dropping and tucking toward the ribs as the handles come back.",
                 "Lead with the elbows, keeping them level with the shoulders and out to the sides for the whole pull."),
       "range": ("Range of Motion",
                 "From a full forward reach until the elbows are in line with the torso.",
                 "Letting the shoulders reach forward and then drawing the elbows back past the torso works the rear delts and mid-back through their full range.",
                 "Short reps that stop with the elbows still in front of the body.",
                 "Let the arms reach forward, then pull until the elbows are in line with the torso and squeeze the shoulder blades together."),
       "traps": ("Shoulder Position",
                 "The shoulders stay down as the elbows travel back.",
                 "Shrugging hands the finish to the upper trapezius and cuts the rear deltoids' range short.",
                 "Shrugging the shoulders up toward the ears at the end of each rep.",
                 "Keep the shoulder blades down and the neck long; squeeze them together, not up."),
       "chest": ("Body Position",
                 "The chest stays on the pad.",
                 "The pad takes the trunk out of the lift, so the rear deltoids have to move the handles without help from a body swing.",
                 "Leaning back off the pad to heave the handles.",
                 "Keep the chest against the pad and the torso still for the whole set."),
   },
   # Prone horizontal abduction (Reinold 2004) and the ACE 45° incline row
   # both show the middle deltoid about as active as the posterior in this
   # plane; kept secondary because no study of this machine exists.
   activation=[("Posterior Deltoid", P, HI, 0.82), ("Lateral Deltoid", S, HI, 0.70), ("Middle Trapezius", S, MOD, 0.60),
               ("Rhomboids", S, MOD, 0.45)],
   stabilisers=["rotator cuff", "lower trapezius", "forearms"],
   comparison=("ELBOWS DROPPING", "Elbows level with the shoulders", "Elbows drop toward the ribs",
               "Rowing with the elbows at shoulder height keeps the rear deltoids and mid-back pulling.",
               "Dropping the elbows turns it into an ordinary seated row and hands the work to the lats."),
   overrides={"seat": (0.50, "trailing"), "elbow": (0.50, "leading"), "range": (0.14, "trailing"), "traps": (0.14, "leading"), "chest": (0.68, "trailing")},
   glows=rd_glows("Machine Rear Delt Row"))
SETUP["Machine Rear Delt Row"] = [
    "Set the seat so the handles line up with your shoulders.",
    "Sit with your chest on the pad, feet flat on the floor.",
    "Take the wide handles with an overhand grip.",
    "Start with your arms reaching forward, elbows soft.",
]

# ---------------------------------------------------------------- upright rows

UR_ACTIVATION = [("Lateral Deltoid", P, HI, 0.80), ("Upper Trapezius", P, HI, 0.80), ("Anterior Deltoid", S, LOW, 0.36),
                 ("Biceps Brachii", S, LOW, 0.30)]

GRIP_UR = ("Grip",
           "Overhand, hands about shoulder-width.",
           "In EMG testing, side-delt and trap activity rose as the grip widened, most clearly at about twice shoulder-width, while biceps activity fell; a very narrow grip gives more of the pull to the arms.",
           "Hands close together in the middle of the bar.",
           "Hold the bar overhand with the hands about shoulder-width or a little wider, thumbs around the bar.")
ELBOW_UR = ("Elbow Path",
            "The elbows lead and stay higher than the hands.",
            "Pulling through the elbows rather than the wrists keeps the load on the deltoids and traps instead of the forearms and biceps.",
            "Leading with the hands, curling the bar up with the elbows trailing low.",
            "Drive the elbows up and out to the sides, letting the wrists bend as the bar rises.")
HEIGHT_UR = ("Range of Motion",
             "The bar rises to the upper chest, the elbows to around shoulder height.",
             "Raising the arms well above shoulder height while they are turned in narrows the space under the point of the shoulder that the rotator cuff tendons pass through, which can irritate sensitive shoulders; stopping around shoulder level keeps the side delts and traps working while limiting that squeeze.",
             "Hauling the bar up to the chin with the elbows high above the shoulders.",
             "Pull until the bar reaches the upper chest with the elbows around shoulder height and no higher, then lower under control; stop lower if the shoulder pinches.")
HIGH_UR = ("ELBOWS TOO HIGH", "Elbows near shoulder height", "Bar hauled to the chin",
           "Stopping with the elbows around shoulder height keeps the side delts and traps working without raising the arms any higher while they are turned in.",
           "Hauling the bar to the chin lifts the arms high while they are turned in, which narrows the space for the rotator cuff tendons and can pinch them in some lifters.")
UR_STABILISERS = ["levator scapulae", "rotator cuff", "forearms", "core"]

def ur_glows(name):
    return [glow(name, ["deltoid_arc_clavicle_2_L", "deltoid_arc_scapula_2_L"], A, 0.55, rx=0.10, ry=0.07),
            glow(name, ["deltoid_arc_clavicle_2_R", "deltoid_arc_scapula_2_R"], SOFT, 0.32, rx=0.09, ry=0.06),
            glow(name, ["attachment_TrapeziusUpper_L", "attachment_TrapeziusUpper_R", "support_TrapeziusUpper_L"], SOFT, 0.28,
                 rx=0.10, ry=0.05)]

ex(name="Barbell Upright Row", var="barbellUprightRow",
   annotations=[
       ("grip", "Overhand, shoulder-width", "hand_R"),
       ("elbow", "Elbows lead the bar", "forearm_L"),
       ("height", "Stop near shoulder level", "forearm_R"),
       ("barpath", "Bar close to the body", "hand_L"),
       ("torso", "Torso still, no swing", "pelvis"),
   ],
   cues={
       "grip": GRIP_UR,
       "elbow": ELBOW_UR,
       "height": HEIGHT_UR,
       "barpath": ("Bar Path",
                   "The bar rises in a straight line close to the body.",
                   "Keeping the bar close keeps the pull on the side delts and upper traps; a bar that drifts out adds load to the front of the shoulder and the lower back.",
                   "Letting the bar drift out in front, away from the stomach and chest.",
                   "Keep the bar almost brushing the body from the thighs to the upper chest, and lower it the same way."),
       "torso": ("Torso Control",
                 "Only the arms and shoulders move.",
                 "Leaning back and thrusting the hips swings the bar up with the body, taking load off the shoulders and putting it on the lower back.",
                 "Leaning back and driving the hips forward to start the bar moving.",
                 "Stand tall with soft knees, brace the core and lift without any swing."),
   },
   activation=UR_ACTIVATION,
   stabilisers=UR_STABILISERS,
   comparison=HIGH_UR,
   # grip moved down to 0.68: at 0.50 its pill sat just under its own dot
   # (hand_R at v 0.47) at the bottom of the rep.
   overrides={"grip": (0.68, "leading"), "elbow": (0.14, "trailing"), "height": (0.14, "leading"), "barpath": (0.50, "trailing"), "torso": (0.68, "trailing")},
   glows=ur_glows("Barbell Upright Row"))
SETUP["Barbell Upright Row"] = [
    "Stand with your feet hip-width apart, knees soft.",
    "Hold the bar overhand, hands about shoulder-width.",
    "Let it hang at arm's length against your thighs.",
    "Brace your core and keep your chest up.",
]

ex(name="Cable Upright Row", var="cableUprightRow",
   annotations=[
       ("grip", "Overhand, shoulder-width", "hand_R"),
       ("elbow", "Elbows lead the bar", "forearm_R"),
       ("height", "Stop near shoulder level", "forearm_L"),
       ("stance", "Stand close to the pulley", "foot_L"),
       ("torso", "Upright, no lean back", "spine"),
   ],
   cues={
       "grip": GRIP_UR,
       "elbow": ELBOW_UR,
       "height": HEIGHT_UR,
       "stance": ("Setup",
                  "Stand close to the low pulley, facing it.",
                  "The cable pulls toward the pulley; standing close makes it pull mostly downward, so the bar can rise close to the body as it would with a barbell.",
                  "Standing a big step back, so the cable drags the bar out in front.",
                  "Stand a short step from the pulley, feet hip-width, with the cable running down in front of the thighs."),
       "torso": ("Torso Control",
                 "The body stays upright against the cable.",
                 "The cable pulls forward toward the stack, so leaning back to fight it is tempting; it turns the lift into a swing and arches the lower back.",
                 "Leaning back away from the stack to pull the bar up.",
                 "Stand tall with soft knees, brace the core and let only the arms and shoulders move."),
   },
   activation=UR_ACTIVATION,
   stabilisers=UR_STABILISERS,
   comparison=HIGH_UR,
   overrides={"grip": (0.68, "leading"), "elbow": (0.14, "leading"), "height": (0.14, "trailing"), "stance": (0.86, "leading"), "torso": (0.50, "trailing")},
   glows=ur_glows("Cable Upright Row"))
SETUP["Cable Upright Row"] = [
    "Attach a straight bar to a low pulley.",
    "Face the stack a short step away, feet hip-width.",
    "Hold the bar overhand, hands about shoulder-width.",
    "Stand tall, arms long, bar in front of your thighs.",
]

ex(name="Smith Machine Upright Row", var="smithMachineUprightRow",
   annotations=[
       ("grip", "Overhand, shoulder-width", "hand_R"),
       ("elbow", "Elbows lead the bar", "forearm_L"),
       ("height", "Stop near shoulder level", "forearm_R"),
       ("stance", "Stand close to the bar", "foot_R"),
       ("torso", "Torso still, no swing", "spine"),
   ],
   cues={
       "grip": GRIP_UR,
       "elbow": ELBOW_UR,
       "height": HEIGHT_UR,
       "stance": ("Setup",
                  "Stand close, the bar just in front of the thighs.",
                  "A Smith bar only moves straight up and down, so where you stand sets the bar path; stand too far back and it rises out in front of you on every rep.",
                  "Standing back from the bar, so it rises away from the body.",
                  "Stand close enough that the bar almost brushes the thighs and stomach on the way up."),
       "torso": ("Torso Control",
                 "Only the arms and shoulders move.",
                 "The rails guide the bar, not the body; leaning back to start each rep swings the bar up with the hips.",
                 "Leaning back to heave the bar up the rails.",
                 "Stand tall with soft knees, brace, and lift without any swing."),
   },
   activation=UR_ACTIVATION,
   stabilisers=UR_STABILISERS,
   comparison=HIGH_UR,
   overrides={"grip": (0.50, "leading"), "elbow": (0.14, "trailing"), "height": (0.14, "leading"), "stance": (0.86, "leading"), "torso": (0.50, "trailing")},
   glows=ur_glows("Smith Machine Upright Row"))
SETUP["Smith Machine Upright Row"] = [
    "Set the Smith bar at the top of your thighs.",
    "Stand close, the bar just in front of your thighs.",
    "Grip it overhand, hands about shoulder-width.",
    "Unrack the bar and stand tall, arms long.",
]

if __name__ == "__main__":
    probs = validate(["Plate Front Raise", "Barbell Front Raise", "Cable Front Raise", "Alternating Dumbbell Front Raise", "Rear Delt Row", "Machine Rear Delt Row", "Barbell Upright Row", "Cable Upright Row", "Smith Machine Upright Row"]); print("\n".join(probs) or "OK")
