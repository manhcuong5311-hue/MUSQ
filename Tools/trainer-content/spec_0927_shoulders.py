# Trainer content for the late additions (2026-09-27), family: shoulders.
# Seated Dumbbell Lateral Raise (207), Cable Rear Delt Row (222) and Dumbbell
# Upright Row (224) from the HIKSEMI drive's "190-240" exports. Same format as
# spec.py; spec_0927.py imports this module (with the hip thrust family) and
# gen.py reads SPEC / SETUP. Rows and overrides are written on the usual
# 0.14/0.32/0.50/0.68/0.86 scale; spec_0927.py squeezes them into 0.16-0.80.
#
# What each model shows (rig joints sampled over the clip, body axes from the
# hips and spine; torso length, neck to pelvis, 0.59 m; 8 s clips, two reps):
# - Seated Dumbbell Lateral Raise (207): sitting upright (trunk 0 deg) on the
#   end of a flat bench, knees ~112 deg, feet flat ~0.38 m apart. A dumbbell
#   in each hand, handles front to back and palms in at the bottom, the arms
#   hanging ~18 deg out from the sides beside the thighs. Both arms rise
#   together until the upper arms are level (~89 deg) with the elbows level
#   with the wrists and the hands at shoulder height, then lower; elbows fixed
#   at ~166 deg through the rep (~178 deg in the pause between reps). The
#   upper arms travel ~20 deg in front of the line of the shoulders (hands
#   ~27 deg), palms down at the top with the handles level (thumbs forward,
#   the thumb side ~0.2 up). No shrug, no trunk movement. The elbows are
#   straight (~178 deg) in the pause at the bottom and set to ~166 deg as the
#   dumbbells leave the sides. Framed from the front-left (yaw -0.6): the
#   LEFT arm is on the right of the screen.
# - Cable Rear Delt Row (222): sitting tall (trunk ~3 deg back) on a cable
#   row bench, feet flat on the floor against the base of the foot rest,
#   knees ~144 deg. Straight bar on a pulley at shoulder height, the cable
#   level; overhand grip, hands ~0.67 m apart (about 1.6 times the rig's
#   shoulder-joint width), thumbs toward each other. From arms reaching
#   forward (elbows ~157 deg, upper arms ~8 deg below level, ~65 deg in from
#   the sides) the elbows travel out and back to ~14 cm behind the shoulder
#   joints (upper arms ~30 deg behind the line of the shoulders), ending
#   ~12 cm below shoulder height (upper arms ~24 deg below level), elbows
#   ~31 deg; the bar ends level with the shoulder joints, ~10 cm in front of
#   the base of the neck (the top of the chest). Hand height is constant.
#   The forearms slope up from the low elbows to the level bar, so the wrists
#   flex ~45-70 deg through the pull. Rig artefact: the shoulder joints move
#   ~7 cm forward and the shoulder blades ~4 cm apart from the reach to the
#   finish (the reverse of drawing them back), so the copy says nothing about
#   blade movement. Seen from behind-left (yaw -2.6): the LEFT arm is on the
#   left.
# - Dumbbell Upright Row (224): standing tall, feet ~0.3 m apart, knees
#   ~174 deg. A dumbbell in each hand, overhand, handles across (side to
#   side), hands ~0.40-0.47 m apart in front of the thighs. The elbows lead
#   out and up until the upper arms are level (90 deg, lowered from 110 deg
#   on 2026-09-26), ~40 deg in front of the line of the shoulders; elbows
#   153 -> 72 deg; the hands finish ~14 cm below and ~25 cm in front of the
#   shoulder joints (the front of the chest), the wrists flexed so the inner
#   ends of the dumbbells tip up ~21 deg. No shrug, no trunk movement. Each
#   dumbbell's grip rod runs ~7 cm past its end caps, so with the hands this
#   close the two rods overlap in the middle and read as one bar; the copy
#   says the hands, not the dumbbells, are shoulder-width.
#   Framed from the front-left (yaw -0.5): the LEFT arm is on the right.
#
# Sources (checked 2026-09-27):
# - Coratella G, Tornatore G, Longo S, Esposito F, Ce E 2020, Int J Environ
#   Res Public Health 17(17):6015, doi:10.3390/ijerph17176015 (PMC7503819) —
#   10 competitive bodybuilders, every exercise seated (to keep the lumbar
#   muscles out of it), 8-RM: on the way up the thumbs-forward raise to 90 deg
#   gave medial deltoid similar to thumbs down and more than thumbs up, the
#   90 deg bent-elbow raise and the front raise; in it medial and posterior
#   deltoid were about equal (~55, ~52% MVIC), the anterior ~36%; thumbs down
#   gave the most posterior deltoid and upper trapezius, and the most medial
#   deltoid while lowering.
# - Campos YAC, Vianna JM, Guimaraes MP et al. 2020, J Hum Kinet 75:5-14,
#   doi:10.2478/hukin-2020-0033 (PMC7706677) — seated lateral raise to 90 deg
#   (back supported, 60% 1RM): medial 30.3, posterior 24.0, anterior 21.2%
#   MVIC; medial similar to the seated shoulder press, posterior higher.
# - Wickham J, Pizzari T, Stansfeld K, Burnside A, Watson L 2010,
#   J Electromyogr Kinesiol 20(2):212-222, doi:10.1016/j.jelekin.2009.06.004
#   — supraspinatus and middle deltoid lead shoulder abduction.
# - Escamilla RF, Yamashiro K, Paulos L, Andrews JR 2009, Sports Med
#   39(8):663-685, doi:10.2165/00007256-200939080-00004 — the scapula rotates
#   up during elevation, driven by the serratus anterior and trapezius.
# - Durall CJ, Manske RC, Davies GJ 2001, Strength Cond J 23(5):10-18 —
#   expert guidance: elevate with the arm turned out (thumbs toward the
#   ceiling) to limit compression, illustrated as scaption ~30 deg in front of
#   the frontal plane (Fig. 6); limit the upright row to ~80 deg with the
#   elbows below the shoulders, or avoid it.
# - Schoenfeld B, Kolber MJ, Haimes JE 2011, Strength Cond J 33(5):25-28 —
#   upright row: impingement peaks ~70-120 deg of elevation (imaging and
#   surgical studies, greatest at 70-90 deg without external rotation); pull
#   close to the body, through the elbows; just below shoulder height if free
#   of symptoms, lower or not at all if it hurts; can be safe and effective
#   with these precautions. Cites upper trapezius 85% and middle deltoid 78%
#   MVC (Andersen 2008).
# - Andersen LL, Kjaer M, Andersen CH, Hansen PB, Zebis MK, Hansen K,
#   Sjogaard G 2008, Muscle activation during selected strength exercises in
#   women with chronic neck muscle pain, Phys Ther 88(6):703-711 — 12 women
#   with trapezius myalgia: upper trapezius 85 +-5% MVC in the upright row and
#   97 +-6% in the lateral raise (3-10 kg), 102 +-11% in the shrug.
# - McAllister MJ, Schilling BK, Hammond KG, Weiss LW, Farney TM 2013,
#   J Strength Cond Res 27(1):181-187, doi:10.1519/JSC.0b013e31824f23ad —
#   barbell upright row at 50/100/200% of biacromial breadth: deltoid and
#   trapezius activity rose and biceps fell as the grip widened (mainly
#   100 vs 200%; lowering, lateral deltoid and upper trapezius were also
#   higher at 100 than 50%; biceps differed only 50 vs 200%, lowering); bar
#   kept below the xiphoid; dumbbell upright rows untested.
# - Sweeney S, Porcari JP, Camic C, Kovacs A, Foster C, ACE ProSource,
#   September 2014 (ACE-sponsored, not peer reviewed) — barbell upright row
#   anterior/medial/posterior deltoid 33/73/31% MVC; 45 deg incline row
#   (arms perpendicular to the body) medial 84, posterior 69.
# - Vasconcelos CMWA, Lopes CR, Almeida VM, Krause Neto W, Soares EG 2023,
#   Int J Strength Cond 3(1), doi:10.47206/ijsc.v3i1.190 — seated cable row:
#   upper and middle trapezius and posterior deltoid rose with shoulder
#   abduction (highest at 60 and 90 deg; hands set at elbow width for 90);
#   the latissimus and peak force were higher with the elbows near the sides.
#   Table 1, concentric peak %MVIC at 60/90 deg: upper trapezius 131/138,
#   middle trapezius 110/116, posterior deltoid 99/105 (60 and 90 deg not
#   significantly different); with the elbows at the sides the posterior
#   deltoid was still 67-72.
# - Padovan R, Ce E, Longo S, Tornatore G, Trentin C, Esposito F, Coratella G
#   2026, J Hum Kinet 91 (online 2025-09-23), doi:10.5114/jhk/209550 —
#   seated row, 14 trained men, 8-RM: a wide bar to the lower chest gave more
#   upper, middle and lower trapezius and lateral deltoid, a narrow handle to
#   the belly more latissimus; posterior deltoid did not differ.
# - Lehman GJ, Buchan DD, Lundy A, Myers N, Nalborczyk A 2004, Dyn Med 3:4,
#   doi:10.1186/1476-5918-3-4 — the seated row gave the highest middle
#   trapezius/rhomboid activity of the pulls tested.
# - Reinold MM, Wilk KE, Fleisig GS et al. 2004, J Orthop Sports Phys Ther
#   34(7):385-394, doi:10.2519/jospt.2004.34.7.385 — prone horizontal
#   abduction at 100 deg with external rotation: posterior 88, middle deltoid
#   87% MVIC.
# - ExRx.net: Dumbbell Seated Lateral Raise (DeltoidLateral/DBSeatedLateralRaise:
#   raise until the slightly bent elbows are at shoulder height, elbows at or
#   above the wrists, fixed 10-30 deg elbow bend, at the top the elbow
#   directly out to the side of the shoulder; target lateral deltoid;
#   synergists anterior deltoid, supraspinatus, middle/lower trapezius,
#   serratus anterior; stabilisers upper trapezius, levator scapulae, wrist
#   extensors), Cable Rear Delt Row (DeltoidPosterior/CBRearDeltRow:
#   sit upright, knees slightly bent, pull to the upper chest just below the
#   neck with the elbows out at shoulder height until they pass slightly
#   behind the back; elbows dropping bring in the latissimus; target
#   posterior deltoid; synergists lateral deltoid, infraspinatus, teres minor,
#   middle/lower trapezius, rhomboids, brachialis, brachioradialis), Dumbbell
#   Upright Row (DeltoidLateral/DBUprightRow: palms to the thighs, elbows
#   lead, wrists flex, elbows to the sides). exrx.net returns Cloudflare 403
#   to direct fetches, so the wording was checked through search-result text.
#
# Evidence is thin for all three as named: no study tests a seated lateral
# raise on a bench without a backrest against a standing one, a cable rear
# delt row, or a dumbbell upright row. Activation follows the closest studied
# lifts (the seated lateral raises above; the 90 deg seated cable row, the
# wide-grip seated row, prone horizontal abduction; the barbell upright row).

from common_0927 import *

# ---------------------------------------------------------------- Seated Dumbbell Lateral Raise

N = "Seated Dumbbell Lateral Raise"


def delt(name, side, kind=A, opacity=0.55, dx=0.0, dy=0.0, rx=0.08, ry=0.06):
    """A glow on one deltoid, from the probed front and back of the shoulder."""
    return glow(name, [f"deltoid_arc_clavicle_2_{side}", f"deltoid_arc_scapula_2_{side}"], kind, opacity,
                rx=rx, ry=ry, dx=dx, dy=dy)


ex(name=N, var="seatedDumbbellLateralRaise",
   annotations=[
       ("traps", "Shoulders down, no shrug", "support_TrapeziusUpper_L"),
       ("height", "Stop at shoulder height", "hand_R"),
       ("elbow", "Soft, fixed elbows", "forearm_R"),
       ("plane", "Arms slightly forward", "upper_arm_L"),
       ("torso", "Sit tall, no swing", "spine"),
   ],
   cues={
       "traps": ("Shoulder Position",
                 "The shoulders stay down while the arms rise.",
                 "Keeping the shoulder blades down keeps the lateral deltoids lifting the arms instead of the upper trapezius shrugging them up.",
                 "Shrugging the shoulders up toward the ears as the dumbbells rise.",
                 "Keep the shoulder blades down and the neck long, and lead the raise with the elbows."),
       "height": ("Range of Motion",
                  "The arms rise from your sides to shoulder height.",
                  "The dumbbells pull hardest on the side delts as the arms come level; above that the shoulder blades rotate up further and the traps and serratus take a bigger share.",
                  "Swinging the dumbbells up above shoulder height.",
                  "Raise until the elbows are level with the shoulders, pause briefly, then lower slowly until the arms hang by your sides."),
       "elbow": ("Elbow Bend",
                 "The arms are long levers with a slight, fixed bend.",
                 "In an EMG study of seated lateral raises the side delts worked harder with the elbows nearly straight than bent to 90°; bending as you lift shortens the lever and lets the hands drop below the elbows.",
                 "Bending the elbows more as the dumbbells rise, so the hands drop below the elbows.",
                 "Set a slight bend as the dumbbells leave your sides and hold that angle up and down, the elbows level with or a little above the wrists."),
       "plane": ("Arm Path",
                 "The arms rise a little in front of the body, hands level.",
                 "Raising slightly forward of the shoulders follows the line of the shoulder blade, a path often advised for comfort; in seated raises, thumbs forward worked the side delts about as hard on the way up as tipping the thumbs down, without the extra rear-delt and upper-trap activity that thumbs down brought.",
                 "Pulling the arms back behind the line of the shoulders at the top.",
                 "Keep the dumbbells a little in front of the shoulders all the way up, hands level and thumbs forward; turn the thumbs slightly up if the shoulder pinches."),
       "torso": ("Torso Control",
                 "You sit tall and still; only the arms move.",
                 "Sitting takes the legs out of the lift, but rocking the torso back can still swing the dumbbells up and arches the lower back.",
                 "Leaning back and rocking the torso to heave the dumbbells up.",
                 "Sit tall on the end of the bench with the feet flat, brace the core and keep the torso upright for every rep."),
   },
   # Coratella 2020 (seated, thumbs forward, 8-RM) found medial and posterior
   # deltoid about equal (~55 and ~52% MVIC) and the anterior ~36%; Campos
   # 2020 (seated) had medial 30, posterior 24 and anterior 21% MVIC. Wickham
   # 2010 puts the supraspinatus beside the medial deltoid. %MVIC is not
   # comparable across muscles, so the lateral deltoid (the ExRx target)
   # stays first. The upper trapezius is listed with the stabilisers, as ExRx
   # does (Andersen 2008 found it very active in lateral raises in women with
   # neck pain), and the traps cue keeps it from taking over.
   activation=[("Lateral Deltoid", P, HI, 0.86), ("Supraspinatus", S, MOD, 0.50),
               ("Posterior Deltoid", S, MOD, 0.48), ("Anterior Deltoid", S, MOD, 0.42)],
   stabilisers=["upper trapezius", "serratus anterior", "rotator cuff", "wrist extensors"],
   comparison=("ROCKING BACK", "Sitting tall, arms to 90°", "Torso rocks back to lift",
               "Sitting tall and still makes the side delts raise the dumbbells through the whole arc.",
               "Rocking back swings the dumbbells up with the trunk, takes load off the shoulders and arches the lower back."),
   glows=[delt(N, "L", dx=0.02), delt(N, "R", SOFT, 0.30, dx=-0.02)],
   # Both arms sweep rows 0.34-0.51 on each side, so the labels sit above the
   # shoulders and below the hands. The height cue points at the right hand
   # (screen left, where the arm is seen long) and the elbow cue at the right
   # elbow from below; the plane cue comes up from the lower right and the
   # torso cue from the bottom left (from the bottom right its leader grazed
   # the plane pill's inner end).
   overrides={"height": (0.14, "leading"), "traps": (0.14, "trailing"), "elbow": (0.68, "leading"),
              "plane": (0.68, "trailing"), "torso": (0.86, "leading")})

SETUP[N] = [
    "Sit tall on the end of a flat bench, feet flat and apart.",
    "Hold a dumbbell in each hand beside your thighs.",
    "Palms facing in, arms long by your sides.",
    "Brace your core and set your shoulders down.",
]

# ---------------------------------------------------------------- Cable Rear Delt Row

N = "Cable Rear Delt Row"
ex(name=N, var="cableRearDeltRow",
   annotations=[
       ("grip", "Wide overhand grip", "hand_L"),
       ("traps", "Shoulders down, no shrug", "support_TrapeziusUpper_L"),
       ("elbow", "Elbows high and wide", "forearm_L"),
       ("range", "Elbows past the back", "forearm_R"),
       ("torso", "Sit tall, no leaning back", "spine"),
   ],
   cues={
       "grip": ("Grip",
                "Overhand, hands well outside the shoulders.",
                "A wide grip lets the elbows travel out to the sides; in an EMG study a wide-grip seated row worked the traps and side delts more and the lats less than a close-grip row, with similar rear-delt activity.",
                "Taking the bar with the hands about shoulder-width or closer.",
                "Hold the bar overhand with the hands well outside shoulder-width, thumbs around it."),
       "traps": ("Shoulder Position",
                 "The shoulders stay down as the elbows travel back.",
                 "Shrugging shifts the finish of the pull toward the upper trapezius and away from the rear delts and mid-back.",
                 "Shrugging the shoulders up toward the ears at the end of each rep.",
                 "Keep the neck long and the shoulders down, away from the ears, as the elbows travel back."),
       "elbow": ("Elbow Height",
                 "The elbows stay high and wide as the bar comes in.",
                 "In EMG testing of the seated cable row, rear-delt and trap activity rose as the elbows were raised out to the sides, and lat activity was higher with them near the ribs.",
                 "Elbows dropping and tucking toward the ribs, so the bar comes in low.",
                 "Lead with the elbows, keep them out to the sides and close to shoulder height, and pull the bar to the top of the chest."),
       "range": ("Range of Motion",
                 "From a full forward reach until the elbows pass just behind the back.",
                 "Reaching the arms forward until they are nearly straight and then drawing the elbows back past the body works the rear delts and mid-back through their whole range.",
                 "Short reps that stop with the elbows still in front of the body.",
                 "Let the arms reach forward until they are nearly straight, then pull until the bar meets the top of the chest and the elbows sit just behind the back."),
       "torso": ("Torso Control",
                 "The torso stays upright and still.",
                 "Leaning back swings the weight with the body and hands part of the pull to the hips and lower back; a still, upright torso leaves the rear delts to move the bar.",
                 "Leaning back behind upright to drag the bar in.",
                 "Sit tall with the knees slightly bent, brace the core and keep the torso upright from the first rep to the last."),
   },
   # No study of this lift; the 60-90 deg seated cable row (Vasconcelos
   # 2023), the wide-grip seated row (Padovan 2026) and prone horizontal
   # abduction (Reinold 2004) are the closest. Prone horizontal abduction and
   # the ACE incline row put the middle deltoid level with or above the
   # posterior; kept a little lower here because the elbows finish ~24 deg
   # below level. Vasconcelos and Padovan both found the upper trapezius
   # rising most as the elbows went out; kept moderate and below the
   # posterior deltoid (the ExRx target) because %MVIC is not comparable
   # across muscles and the traps cue asks for no shrug. The rhomboids were
   # never measured on their own (Lehman 2004 recorded them with the middle
   # trapezius), so they are listed with the stabilisers.
   activation=[("Posterior Deltoid", P, HI, 0.80), ("Lateral Deltoid", S, MOD, 0.66),
               ("Middle Trapezius", S, MOD, 0.62), ("Upper Trapezius", S, MOD, 0.50)],
   stabilisers=["rhomboids", "infraspinatus", "lower trapezius", "erector spinae"],
   comparison=("ELBOWS DROPPING", "Elbows high, bar to the chest", "Elbows drop to the ribs",
               "Pulling with the elbows high and wide keeps the rear delts and mid-back doing the work.",
               "Dropping the elbows turns it into an ordinary wide-grip row: the lats join in and the rear delts and mid-back do less."),
   glows=[glow(N, ["deltoid_arc_scapula_2_L"], A, 0.55, rx=0.08, ry=0.06),
          glow(N, ["deltoid_arc_scapula_2_R"], SOFT, 0.30, rx=0.08, ry=0.06),
          glow(N, ["scapula_L", "scapula_R"], SOFT, 0.28, rx=0.08, ry=0.05, dy=0.03)],
   # Seen from behind-left, both arms sweep a band at rows 0.31-0.37 across
   # the whole width, so the labels sit above the head and below the arms.
   overrides={"grip": (0.14, "leading"), "traps": (0.14, "trailing"), "elbow": (0.50, "leading"),
              "torso": (0.68, "leading"), "range": (0.68, "trailing")})

SETUP[N] = [
    "Set the pulley at seated shoulder height with a straight bar.",
    "Sit tall facing the stack, knees slightly bent, feet flat.",
    "Take the bar overhand, hands well outside your shoulders.",
    "Start with your arms reaching forward at shoulder height.",
]

# ---------------------------------------------------------------- Dumbbell Upright Row

N = "Dumbbell Upright Row"
ex(name=N, var="dumbbellUprightRow",
   annotations=[
       ("height", "Stop near shoulder level", "forearm_R"),
       ("elbow", "Elbows lead the dumbbells", "forearm_L"),
       ("path", "Dumbbells close to body", "hand_L"),
       ("width", "Hands shoulder-width", "hand_R"),
       ("torso", "Torso still, no swing", "spine"),
   ],
   cues={
       "height": ("Range of Motion",
                  "The dumbbells rise to chest height, the elbows to shoulder height.",
                  "With the arms turned in, the space under the point of the shoulder that the rotator cuff tendons pass through narrows as the elbows come up toward shoulder height and beyond, which can irritate sensitive shoulders; stopping at or just below shoulder level, as most guidance advises, keeps the side delts and traps working while limiting that squeeze.",
                  "Hauling the dumbbells up to the chin with the elbows high above the shoulders.",
                  "Pull until the elbows reach shoulder height at most, then lower under control; stop lower if the shoulder pinches."),
       "elbow": ("Elbow Path",
                 "The elbows lead and stay higher than the hands.",
                 "Pulling through the elbows rather than the wrists keeps the most work at the shoulder, on the side delts and traps; leading with the hands turns the start of the lift into a curl.",
                 "Leading with the hands, curling the dumbbells up with the elbows trailing low.",
                 "Drive the elbows up and out, higher than the hands, letting the wrists bend as the dumbbells rise."),
       "path": ("Dumbbell Path",
                "The dumbbells rise close in front of the body.",
                "Keeping them close keeps the pull on the side delts and upper traps; dumbbells that drift out in front add load to the front of the shoulder and the lower back.",
                "Letting the dumbbells swing out in front, away from the stomach and chest.",
                "Keep the dumbbells just in front of the body from the thighs to the chest, and lower them the same way."),
       "width": ("Hand Position",
                 "The hands stay about shoulder-width apart, one in front of each shoulder.",
                 "In EMG testing of the barbell upright row, side-delt and trap activity rose as the grip widened, most clearly at twice shoulder-width, and on the way down it was higher with the hands shoulder-width apart than half that; dumbbells have not been tested.",
                 "Bringing the hands in close together in the middle, narrower than the shoulders.",
                 "Hold the handles across, overhand, one hand in front of each shoulder, and keep that spacing up and down."),
       "torso": ("Torso Control",
                 "Only the arms and shoulders move.",
                 "Leaning back and thrusting the hips swings the dumbbells up with the body, taking load off the shoulders and putting it on the lower back.",
                 "Leaning back and driving the hips forward to start the dumbbells moving.",
                 "Stand tall with soft knees, brace the core and lift without any swing."),
   },
   # As the barbell upright rows: no dumbbell upright row EMG exists
   # (McAllister 2013 names it as untested).
   activation=[("Lateral Deltoid", P, HI, 0.80), ("Upper Trapezius", P, HI, 0.80),
               ("Anterior Deltoid", S, LOW, 0.36), ("Biceps Brachii", S, LOW, 0.30)],
   stabilisers=["levator scapulae", "rotator cuff", "forearms", "core"],
   comparison=("ELBOWS TOO HIGH", "Elbows no higher than the shoulders", "Dumbbells hauled to the chin",
               "Stopping with the elbows at or just below shoulder height keeps the side delts and traps working without raising the arms any higher while they are turned in.",
               "Hauling the dumbbells to the chin lifts the arms high while they are turned in, which narrows the space for the rotator cuff tendons and can pinch them in some lifters."),
   glows=[delt(N, "L", A, 0.55, dx=0.02, rx=0.10, ry=0.07), delt(N, "R", SOFT, 0.32, dx=-0.02, rx=0.09, ry=0.06),
          glow(N, ["attachment_TrapeziusUpper_L", "attachment_TrapeziusUpper_R", "support_TrapeziusUpper_L"], SOFT, 0.28,
               rx=0.10, ry=0.04)],
   # The arms sweep rows 0.23-0.44 on both sides and the head sits at 0.18.
   overrides={"height": (0.14, "leading"), "elbow": (0.14, "trailing"), "width": (0.53, "leading"),
              "torso": (0.68, "leading"), "path": (0.68, "trailing")})

SETUP[N] = [
    "Stand with your feet hip-width apart, knees soft.",
    "Hold the dumbbells overhand in front of your thighs.",
    "Handles across, hands about shoulder-width apart.",
    "Brace your core and keep your chest up.",
]


if __name__ == "__main__":
    probs = validate(["Seated Dumbbell Lateral Raise", "Cable Rear Delt Row", "Dumbbell Upright Row"]); print("\n".join(probs) or "OK")
