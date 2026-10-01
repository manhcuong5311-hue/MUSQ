# Trainer content for the 351-400 folder (2026-09-30), family "hinge": the
# builder's 363-368 (Good Morning, Seated Good Morning, Smith Machine Good
# Morning, Nordic Hamstring Curl, Assisted Nordic Curl, Glute-Ham Raise).
# Same format as spec.py, on top of common_1_50.py; spec_400.py collects it
# with the other families. notes_400_hinge.md maps each claim in the copy to
# the sources below and records the model facts it relies on.
#
# What each model shows, from the briefs (SCRATCH/briefs and briefs_legs:
# joint angles and positions every 0.5 s), a finer pass over the USD (every
# 0.125 s: trunk tip, knee and hip angles, the neck's distance to the knee,
# joint projections through the app's framing), the trainer stills at
# 0/1/2/3/5 s (SCRATCH/shots/view), the tiers (SCRATCH/tiers27.json),
# joints.json and the builder's notes (DANH_SACH_356_400.md, REFERENCES.md,
# FIX_/SOURCES_365_368, band_diagnostics.json of 367). The rig's frame: Y
# up, the lifter faces +z, their left is +x; torso (neck to pelvis) 0.59 m.
# Every model does two identical reps in 7.96 s, both legs together.
# Tiers: the good mornings light the hamstrings (biceps femoris,
# semitendinosus, semimembranosus) and the erector spinae bright = PRIMARY,
# the glutes (maximus, medius, minimus) dim = SECONDARY; the Nordic and the
# glute-ham raise light the hamstrings bright and the calves (gastrocnemius,
# soleus) and glutes dim (0.26); the Assisted Nordic paints the calves and
# glutes only faintly (0.11).
# - Good Morning (363, yaw -2.3: from behind the lifter's left, the back and
#   bar toward the camera, the lifter facing away and to screen-left): a
#   straight barbell high on the upper traps (bar centre level with the neck
#   joint, ~6 cm behind it), hands 0.78 m apart (~20 cm outside each
#   shoulder), elbows bent ~45° and pointing down. Ankles 0.28 m apart (about
#   hip width), toes out ~7°. Knees 162° all clip (a fixed ~18° bend). The
#   trunk tips from upright to 64° forward (26° above level) at the bottom,
#   the hips travel ~24 cm back and ~4 cm down, the shins tip ~7° back. ~1 s
#   down, ~0.5 s held at the bottom (1.67-2.21 s), ~1.1 s up, ~1.3 s standing.
# - Seated Good Morning (364, yaw -2.3): straddles the front end of a flat
#   bench (pad 0.40 m wide, 0.54 m high, running front to back under the
#   lifter), feet flat and wide (ankles 0.60 m apart, a little in front of
#   the knees), knees ~118° (bent ~62°). The same high bar and grip. The
#   pelvis never moves; the trunk tips from upright to 55° forward: ~1.3 s
#   down, ~0.4 s at the bottom (1.75-2.1 s), ~1.5 s up, ~0.6 s upright.
# - Smith Machine Good Morning (365, yaw -1.0: three-quarter from the
#   front-left, facing screen-left): a Smith bar high on the upper traps,
#   hands 0.74 m apart (~20 cm outside each shoulder, as the Good Morning's);
#   the bar runs straight up and down on its rails (its centre stays at z
#   0.01-0.04 all clip) and drops ~19 cm. Ankles 0.28 m apart, toes forward,
#   ~18 cm behind the bar's line. The skinned shoes run from z -0.23 to 0.08
#   (middle -0.07), so the bar runs over the front of the feet near the balls,
#   ~10 cm ahead of mid-foot (the builder's note puts the middle of the sole
#   ~25 mm behind the bar plane; the exported model does not show that).
#   Knees 164° at the top to 150° at the bottom (bent 16° to 30°), trunk 8°
#   to 52°, the hips ~42 cm back. ~1.25 s down, ~0.5 s at the bottom
#   (1.67-2.17 s), ~1.25 s up, ~1.5 s at the top.
# - Nordic Hamstring Curl (366, yaw -1.4: side-on from the left, facing
#   screen-left): kneels on a knee cushion on a padded base, ankles under a
#   padded roller on two posts. Hips straight all clip (knee, hip and
#   shoulder in one line). Knees from 89° (kneeling upright) to 164° (body
#   75° forward, ~15° above the floor); ~0.9 s down (0.67-1.58 s), ~0.6 s
#   held at the bottom (1.62-2.21 s), ~1.1 s back up to upright with no push
#   from the hands, ~1.3 s kneeling. The hands wait loosely in front of the
#   lower chest (elbows ~70°) and never touch the mat (5 cm thick): at the
#   bottom the wrists sit ~18 cm and the palms ~9 cm above it.
# - Assisted Nordic Curl (367, yaw -1.4): the same kneeling, anchor and
#   motion, plus a closed elastic loop from an adjustable anchor bar 1.26 m
#   up on a tower ~0.7 m behind the knees, around the front of the chest.
#   The contact slides ~8 cm up the chest as the trunk tips; the loop is
#   stretched ~14% at the top and ~106% at the bottom (the builder's
#   geometric band_diagnostics, not a calibrated force), so it pulls hardest
#   at the bottom. The calves and glutes are painted only faintly (0.11).
# - Glute-Ham Raise (368, yaw -1.4): a glute-ham developer: the lower thighs
#   over a round pad with the knees just behind it, the shins on a flat plate,
#   the feet against an upright footplate and the ankles between two rollers.
#   Hips straight all clip; knees from 89° (kneeling upright on the machine)
#   to 172° (body 83° forward, ~7° above level); timing as the Nordic (~0.9 s
#   down, ~0.6 s held, ~1.1 s up). Hands in front of the chest. This is the
#   knee-only glute-ham raise of the studies below (hips held straight), not
#   the version that also bends at the hips.
#
# Sources (each checked on its PubMed abstract, full text or the page
# itself, read 2026-09-30; notes_400_hinge.md maps the claims):
# - Vigotsky AD, Harper EN, Ryan DR, Contreras B 2015, PeerJ 3:e708, doi
#   10.7717/peerj.708 — good mornings at 50-90% 1RM, 15 trained men, high
#   bar: hamstring and erector EMG rose with load; knee flexion rose with
#   load (17.1° to 24.8°) and estimated hamstring length fell; lumbar and hip
#   flexion unchanged. At 90%: medial hamstrings 39.9, lateral 30.4,
#   thoracic erectors 66.6, lumbar erectors 70.9 %MVIC. Estimated hamstring
#   stretch greater than the maximum during sprinting. The MVIC tests
#   differed by muscle (prone knee flexion at 45° for the hamstrings, a prone
#   superman for the erectors, which the authors say may not be a true MVIC
#   position for everyone), so the percentages do not rank the muscles.
# - McAllister MJ, Hammond KG, Schilling BK, Ferreria LC, Reed JP, Weiss LW
#   2014, J Strength Cond Res 28(6):1573-1580, doi
#   10.1519/JSC.0000000000000302 — leg curl, good morning, glute-ham raise and
#   RDL at 85% 1RM (full text read): semitendinosus more active than biceps
#   femoris in all; hamstring activity highest in the RDL and glute-ham raise;
#   the glute-ham raise (a plate held at the xiphoid, 85% of a ~88 kg 1RM,
#   90° knee range, hip held at 0°) drew significantly more concentric BF, ST
#   and medial gastrocnemius (260.7 vs 139.7 µV) than the prone leg curl, and
#   the most erector activity (432 vs 217 µV in the GM and RDL); gluteus
#   medius (the only glute measured) lowest in the good morning (concentric
#   43.1 µV vs 194.1 prone leg curl and 220.7 glute-ham raise, both
#   significantly higher); good-morning bar on the superior trapezius, torso
#   lowered to parallel.
# - Ebben WP 2009, Int J Sports Physiol Perform 4(1):84-96, doi
#   10.1123/ijspp.4.1.84 — six exercises, 34 athletes (full text read):
#   hamstring (BF) %MVIC Russian curl 98, seated leg curl 81 (both
#   significantly different from all others), stiff-leg deadlift 49,
#   single-leg SLDL 48, good morning 43, squat 27; the good morning with the
#   bar at the base of the neck, ~15° knee flexion, torso to parallel. The
#   Russian curl is the knee-only glute-ham raise, not the floor Nordic: on
#   a glute-ham machine, knees 4 cm behind the pad's apex, ankles between the
#   foot pads, hips extended, a weight plate held at the chest, lowered until
#   nearly parallel.
# - Schellenberg F, Lindorfer J, List R, Taylor WR, Lorenzetti S 2013, BMC
#   Sports Sci Med Rehabil 5:27, doi 10.1186/2052-1847-5-27 — good mornings
#   (25% BW) vs deadlifts: GMs with ~5° knee flexion and a larger hip moment
#   than DLs at the same bar load, the same L4/L5 moment.
# - Jaeggi JS, Achermann B, Lorenzetti SR 2024, J Funct Morphol Kinesiol
#   9(2):68, doi 10.3390/jfmk9020068 — modelling, 8 women, 25% BW: gluteal
#   forces highest in the good morning and the split squat's front leg (of
#   back squat, split squat and good morning); the hamstrings' highest in the
#   split squat's front leg.
# - Kwon YJ, Lee HO 2013, J Phys Ther Sci 25(10):1295-1297, doi
#   10.1589/jpts.25.1295 — prone (hip at 0°) hip extension MVCs at 0-110°
#   knee flexion: hip extension torque and BF/ST activity fell beyond ~60° of
#   knee flexion, the gluteus maximus then more active than both.
# - Liu J, Teng HL, Selkowitz DM, Asavasopon S, Powers CM 2022, Physiother
#   Theory Pract 38(13):2650-2657, doi 10.1080/09593985.2021.1975338 (PMID
#   34496710) — maximal isometric hip extension, hip at 0° or 45°, knee
#   straight or bent, EMG-driven model: the hamstrings' torque share highest
#   with the knee straight, the gluteus maximus/hamstring ratio highest with
#   the hip at 0° and the knee at 90°.
# - Németh G, Ekholm J, Arborelius UP, Harms-Ringdahl K, Schüldt K 1983,
#   Scand J Rehabil Med 15(2):97-101 (PMID 6867638) — knee angle did not
#   affect isometric hip-extensor strength at hip angles of 0-90° flexion.
# - Schwanbeck S, Chilibeck PD, Binsted G 2009, J Strength Cond Res
#   23(9):2588-2591, doi 10.1519/JSC.0b013e3181b1b181 — squats, 6
#   participants at 8RM, free bar vs Smith: gastrocnemius, biceps femoris
#   and vastus medialis 34, 26 and 49% higher with the free bar (the Smith
#   bar's biceps femoris about a fifth lower); lumbar erectors not different.
# - Everett G, Catalyst Athletics, Seated Good Morning
#   (catalystathletics.com/exercise/184/Seated-Good-Morning/): bar as for a
#   back squat, straddling a bench, knees bent, feet flat in front of the
#   knees, back set in extension and braced, hinge forward as far as
#   possible without losing the back extension; mainly for the back's
#   isometric arch, secondarily glutes and hamstrings.
# - van Dyk N, Behan FP, Whiteley R 2019, Br J Sports Med 53(21):1362-1370,
#   doi 10.1136/bjsports-2018-100045 — meta-analysis, 15 studies, 8459
#   athletes: programmes including the NHE, injury risk ratio 0.49.
# - Petersen J, Thorborg K, Nielsen MB, Budtz-Jørgensen E, Hölmich P 2011,
#   Am J Sports Med 39(11):2296-2303, doi 10.1177/0363546511419277 — 942
#   soccer players: acute hamstring injuries 3.8 vs 13.1 per 100 player
#   seasons (RR 0.29) with a 10-week Nordic programme.
# - van der Horst N, Smits DW, Petersen J, Goedhart EA, Backx FJ 2015, Am J
#   Sports Med 43(6):1316-1323, doi 10.1177/0363546515574057 — amateur soccer,
#   25 NHE sessions in 13 weeks: injury incidence 0.25 vs 0.8 per 1000 h.
# - Mjølsnes R, Arnason A, Østhagen T, Raastad T, Bahr R 2004, Scand J Med
#   Sci Sports 14(5):311-317, doi 10.1046/j.1600-0838.2003.367.x — 10 weeks:
#   Nordics +11% eccentric hamstring torque, leg curls no change.
# - Bourne MN, Duhig SJ, Timmins RG et al. 2017, Br J Sports Med
#   51(5):469-477, doi 10.1136/bjsports-2016-096130 — 10 weeks of NHE
#   lengthened BFlh fascicles and increased semitendinosus volume.
# - Bourne MN, Williams MD, Opar DA, Al Najjar A, Kerr GK, Shield AJ 2017,
#   Br J Sports Med 51(13):1021-1028, doi 10.1136/bjsports-2015-095739 — the
#   Nordic preferentially recruits the semitendinosus (fMRI).
# - Cuthbert M, Ripley N, McMahon JJ, Evans M, Haff GG, Comfort P 2020,
#   Sports Med 50(1):83-99, doi 10.1007/s40279-019-01178-7 — lower NHE
#   volumes gave eccentric strength and fascicle gains like high volumes.
# - Ditroilo M, De Vito G, Delahunt E 2013, J Electromyogr Kinesiol
#   23(5):1111-1118, doi 10.1016/j.jelekin.2013.05.008 — NHE BF EMG averaged
#   134% of a maximal eccentric dynamometer contraction; a sharp rise in
#   falling speed at 47.9-80.5°; faster peak knee velocity went with lower
#   peak EMG (r = -0.62).
# - Delahunt E, McGroarty M, De Vito G, Ditroilo M 2016, Eur J Appl Physiol
#   116(4):663-672, doi 10.1007/s00421-015-3325-3 — 6 weeks of NHE: more
#   eccentric strength, longer control of the forward fall, more hamstring
#   EMG.
# - Monajati A, Larumbe-Zabala E, Goss-Sampson M, Naclerio F 2017, J Hum
#   Kinet 60:29-37, doi 10.1515/hukin-2017-0105 — Nordic hamstring
#   activation above 70% MVIC between 60 and 40° of knee flexion, down to 27%
#   at the end of the movement.
# - Šarabon N, Marušič J, Marković G, Kozinc Ž 2019, PLoS One
#   14(10):e0223437, doi 10.1371/journal.pone.0223437 — standard NHE peak EMG
#   ST 106.7 and BF 99.7 %MVC, erector spinae ~65%, gluteus maximus
#   relatively low in all variations; told to hold 50° or 75° of hip
#   flexion, participants performed a combination of hip flexion, pelvic
#   rotation and spine flexion (the limitations: they often flexed the lumbar
#   spine instead of the hip); the hip-flexion instructions gave greater peak
#   knee and hip torque.
# - Narouei S, Imai A, Akuzawa H, Hasebe K, Kaneoka K 2018, J Exerc Rehabil
#   14(2):231-238, doi 10.12965//jer.1835200.600 (the registered DOI has the
#   double slash; PMID 29740557, PMC5931159) — NHE: semitendinosus and
#   biceps femoris most active; back extensors and internal oblique above
#   the other trunk and hip muscles.
# - Murakami Y, Nishida S, Kasahara K, Yoshida R, Hayakawa R, Nakamura M
#   2023, PLoS One 18(12):e0293938, doi 10.1371/journal.pone.0293938 — NHE
#   eccentric phase: BF 52.8, ST 49.2, medial gastrocnemius 28.7, gluteus
#   maximus 30.8 (SD 41.6) %MVIC.
# - Bergmann J, Schmidt M, Jaitner T 2026, Sports Biomech (online), doi
#   10.1080/14763141.2026.2657898 — a device with rigid heel fixation, set
#   kneeling height and knee position: break-point angle 56.0° vs 74.8° with
#   a partner holding the ankles, and higher hamstring EMG; rigid heel
#   fixation alone (74.3°) did no better than the partner.
# - Ishøi L, Meincke S, Lund AP, Stenholm A, DeLang M, Thornton K, Thorborg
#   K 2025, Phys Ther Sport 73:39-47, doi 10.1016/j.ptsp.2025.02.007 — youth
#   elite football, 8 weeks: band-assisted NHE (a band around the chest,
#   heavy to light) and regular NHE both ~20% stronger, the assisted group
#   with less soreness and perceived exertion.
# - Demeusoy P, Corcelle B, Bontemps B et al. 2026 (e2025), J Sport Rehabil
#   35(2):157-163, doi 10.1123/jsr.2024-0251 — one maximal repetition, 12
#   participants: assisted NHEs reached higher eccentric torque and EMG
#   integrals (BF, ST and both gastrocnemius heads) than the unassisted one,
#   put down to greater muscle length at the end of the movement and longer
#   time under tension (integrals grow with duration).
# - E3 Rehab, How to perform Nordic hamstring curls (e3rehab.com, 2 July
#   2023): a soft pad under the knees, the feet anchored, a straight line
#   from the knees through the hips to the shoulders, catch yourself with the
#   hands and push back up; letting the hips bend is an acceptable
#   regression, straightening out over time; assistance with a band around
#   the chest anchored above and behind; shorten the range by stacking
#   objects in front.
# - Schmitt K, Porcari JP, Camic C, Kovacs A, Foster C, with Green DJ, ACE
#   Certified, February 2018 (ACE-sponsored, not peer-reviewed): the
#   glute-ham raise on a machine with the feet against the footplate, the
#   ankles between the rollers, the knees just behind the pad, from upright
#   to parallel, and without equipment (kneeling on a mat, a partner holding
#   the ankles); against the prone leg curl, both lower for BF, but ST
#   significantly higher without equipment and not different on the machine.
# No EMG study of the seated or the Smith machine good morning, of a
# band-assisted Nordic at a matched submaximal effort, or of the gluteus
# maximus in the good morning or the glute-ham raise was found; those rows
# are ranked from the closest studied lifts and the mechanics (see the
# notes).

from common_1_50 import *

GM, SEATED, SMITH = "Good Morning", "Seated Good Morning", "Smith Machine Good Morning"
NORDIC, ASSISTED, GHR = "Nordic Hamstring Curl", "Assisted Nordic Curl", "Glute-Ham Raise"


def gm_glows(name):
    """Both hamstrings bright between hips and knees, the erector spinae
    bright up the middle of the back, the glutes soft."""
    return [glow(name, ["thigh_L", "patella_L", "thigh_R", "patella_R"], A, 0.55, rx=0.12, ry=0.07),
            glow(name, ["spine", "chest"], A, 0.45, rx=0.06, ry=0.07),
            glow(name, ["pelvis"], SOFT, 0.30, rx=0.08, ry=0.05)]


def kneeling_glows(name, soft=0.30):
    """The hamstrings along the thigh's sweep, then the calves along the
    shins lying on the pad and the glutes, soft."""
    return [glow(name, ["thigh_L", "patella_L"], A, 0.55, rx=0.11, ry=0.07),
            glow(name, ["patella_L", "foot_L"], SOFT, soft, rx=0.08, ry=0.04),
            glow(name, ["pelvis"], SOFT, round(soft - 0.05, 2), rx=0.07, ry=0.05)]


# ---------------------------------------------------------------- shared cues

GM_BAR = ("Bar Position",
          "The bar rests high across the upper traps, the hands wide and the elbows pointing down.",
          "The upper back carries the bar, not the neck or the hands. Set on the upper traps with the shoulder blades squeezed together, the spot the good mornings in the lab studies used, it has a shelf of muscle to sit on as the chest tips toward the floor.",
          "Setting the bar low on the back of the shoulders, where the hands have to hold it on and it shifts as the chest drops.",
          "Set the bar across the upper traps, squeeze the shoulder blades together and pull the bar down into your back with the hands.")

GM_BACK = ("Back Position",
           "The back stays long and braced from the top of the rep to the bottom.",
           "With the bar on the shoulders, the trunk is a long lever with the load at its far end, so the back muscles work hard just to hold it still: in one study the lower-back muscles worked at about 70% of their own maximum at heavy loads. Holding the brace keeps the bend at the hips, where the hamstrings can take the stretch.",
           "The lower back rounding as the chest nears the bottom, the spine bending once the hips stop.",
           "Take a big breath and brace before each rep, keep the chest proud and the head in line with the back, and end the rep where the back would start to round.")

NORDIC_LINE = ("Body Line",
               "The knees, hips and shoulders stay in one straight line from top to bottom.",
               "The Nordic lowers the whole body as one piece around the knees, so the hamstrings brake the fall at the knee; the lab versions held the hips straight the whole way. Bending at the hips turns part of the lowering into a hinge; in one study, lifters told to bend further at the hips also tipped the pelvis and rounded the lower back.",
               "Bending at the hips as you lean, the backside pushing back and the chest folding toward the floor.",
               "Squeeze the glutes and brace the belly before you start, and keep them tight so the hips stay straight all the way down and back up. A slight hip bend is a fair way to start; work toward the straight line.")

NORDIC_ANCHOR = ("Ankle Anchor",
                 "The ankles are locked under the padded roller so the heels cannot lift.",
                 "The anchor is what the hamstrings pull against: if the heels can rise, the lower legs lift instead of the body lowering. In one study, fixing the heels alone made no difference against a partner holding the ankles; a set-up that also fixed the kneeling height and knee position let lifters control the lowering to a straighter knee, with more hamstring activity.",
                 "The heels lifting off the pad as you lean, the ankles loose under the anchor.",
                 "Kneel on a thick pad and hook the ankles firmly under the roller, or have a partner press down on your lower calves, and set up the same way before each set.")

NORDIC_HANDS = ("Hand Position",
                "The hands wait loosely in front of the chest, ready to catch you, off the floor.",
                "Holding the hands up leaves the lowering and the hold to the hamstrings. The hands are there to catch a fall once you can no longer slow it, not to prop you up at the bottom.",
                "Putting the hands down on the floor to hold the bottom, the arms taking the weight the hamstrings should hold.",
                "Keep the hands loose in front of the chest, and put them down only to catch yourself once you can no longer slow the fall.")

# ---------------------------------------------------------------- good morning

# From behind the lifter's left: the plates sweep the left and right edges
# from v 0.22 (top) to 0.46 (bottom) and the head runs from the top centre
# down to the left (u 0.43-0.63). The bar label sits top left and points at
# the near hand on the bar, whose leader stays left of the head all rep (the
# trap joints sit right under it); the back label is short, top right, its
# leader passing right of the head down to the spine. The depth label sits
# left under the plates on the 0.64 row, short so it ends before the left
# calf, its leader up to the chest; knee and hips take the bottom row,
# under both feet.
ex(name=GM, var="goodMorning",
   overrides={"bar": (0.14, "leading"), "back": (0.14, "trailing"), "depth": (0.68, "leading"),
              "knee": (0.86, "leading"), "hips": (0.86, "trailing")},
   annotations=[
       ("bar", "Bar on the traps", "hand_L"),
       ("back", "Neutral spine", "spine"),
       ("hips", "Push the hips back", "pelvis"),
       ("knee", "Soft knees, fixed", "patella_L"),
       ("depth", "Hinge to a stretch", "chest"),
   ],
   cues={
       "bar": GM_BAR,
       "back": GM_BACK,
       "hips": ("Hip Hinge",
                "The hips travel back as the chest tips forward.",
                "Pushing the hips back keeps the weight over the middle of the feet and puts the bend at the hip joint, which stretches the hamstrings under load. In one study the hamstrings in a good morning were estimated to stretch further than at any point of a sprint.",
                "The hips staying over the heels while the chest tips out over the toes, so the fold comes at the waist and the hamstrings barely stretch.",
                "Push the hips straight back as if closing a drawer behind you, and let the chest lower only as far as the hips go back."),
       "knee": ("Knee Angle",
                "The knees keep a soft, fixed bend for the whole rep.",
                "A slight, fixed bend keeps the knees from locking back while the hips do the moving: in one study, good mornings done with the knees almost straight pushed the knees toward straightening. As loads get heavier, lifters tend to bend the knees further, which shortens the hamstrings: in another, the knee bend grew from about 17° to 25° as the bar went from half to 90% of the maximum.",
                "The knees bending more and more on the way down, the hips sinking toward a squat.",
                "Unlock the knees a little before the first rep and hold that angle down and up; if they start to bend further, the load is too heavy."),
       "depth": ("Depth",
                 "Each rep lowers until the hamstrings are stretched, then pauses.",
                 "The load on the hips is greatest at the bottom, where the trunk is closest to level and the bar furthest out in front of them. The studied good mornings went down to about level with the floor; this model stops about 25° above level, holds for half a second and stands back up.",
                 "Stopping after a short nod forward, the chest barely tipping, so the hamstrings never reach a real stretch.",
                 "Lower until you feel a strong stretch in the hamstrings or the back is about to round, pause, then drive the hips forward to stand tall."),
   },
   # Painted: hamstrings and erector spinae bright, glutes dim. The erectors
   # rank first as a house choice: at 90% 1RM they reached 66.6-70.9 %MVIC
   # and the hamstrings 30.4-39.9 (Vigotsky 2015), but the MVIC tests
   # differed by muscle (prone knee flexion at 45° vs a prone superman the
   # authors say may not be a true MVIC for everyone), so the numbers do not
   # rank the two; both HIGH as the model paints them. The hamstrings sit
   # under the RDL and stiff-leg deadlift's 0.88: hamstring activity was
   # highest in the RDL and glute-ham raise (McAllister 2014) and the good
   # morning's 43 %MVIC was the stiff-leg deadlift's 49 or less (Ebben 2009).
   # The gluteus maximus a MODERATE secondary, not higher: modelled gluteal
   # forces were highest in the good morning and the split squat's front leg
   # (Jaeggi 2024; 8 women, 25% BW), but the gluteus medius was lowest in the
   # good morning of four lifts (McAllister 2014: concentric 43.1 µV vs
   # 194.1-220.7 in the prone leg curl and glute-ham raise), and no gluteus
   # maximus EMG of this lift was found.
   activation=[("Erector Spinae", P, HI, 0.80), ("Hamstrings", P, HI, 0.76),
               ("Gluteus Maximus", S, MOD, 0.48)],
   stabilisers=["core", "upper back", "adductors", "calves"],
   comparison=("BACK ROUNDING", "Flat back, bend at the hips", "Lower back rounds at the bottom",
               "A braced, flat back keeps the bend at the hips, so the hamstrings take the stretch and the back muscles only hold the trunk still.",
               "When the lower back rounds, the depth comes from the spine instead of the hips and the load moves from the hamstrings onto the back."),
   glows=gm_glows(GM))

SETUP[GM] = [
    "Set the bar in a rack at about shoulder height.",
    "Step under it and rest it high across your upper traps, hands well outside your shoulders.",
    "Lift it off, step back and set your feet about hip-width, toes nearly straight ahead.",
    "Unlock your knees slightly and brace before the first rep.",
]

# ---------------------------------------------------------------- seated good morning

# From behind the lifter's left, seated: the plates sweep both edges from v
# 0.29 to 0.48, the bench fills the right half below v 0.55 and the left leg
# the left below v 0.53. The range label tracks the head from the top left
# (the only joint a top-left leader reaches without crossing the head); the
# bar label sits top right and points at the far hand on the bar, right of
# the head. The back label sits left at 0.56, short so it ends before the
# left knee, its leader across to the spine; feet and hinge take the bottom
# row, the hinge leader up through the bench to the hips.
ex(name=SEATED, var="seatedGoodMorning",
   overrides={"range": (0.14, "leading"), "bar": (0.14, "trailing"), "back": (0.59, "leading"),
              "feet": (0.86, "leading"), "hinge": (0.86, "trailing")},
   annotations=[
       ("bar", "Bar high on the traps", "hand_R"),
       ("back", "Back set tight", "spine"),
       ("hinge", "Fold at the hips", "pelvis"),
       ("feet", "Feet wide and flat", "foot_L"),
       ("range", "Go as far as the back holds", "head"),
   ],
   cues={
       "bar": ("Bar Position",
               "The bar rests high across the upper traps, the hands wide.",
               "Seated, the whole trunk is the lever and the upper back holds the bar in place as the chest tips toward the knees. Set on the upper traps with the shoulder blades squeezed, the bar has a shelf of muscle to sit on and stays put through the lean.",
               "Letting the bar slide down onto the backs of the shoulders, where the hands end up holding it in place.",
               "Set the bar across the upper traps, squeeze the shoulder blades together and pull the bar down into your back before each rep."),
       "back": ("Back Position",
                "The lower back stays arched and braced for the whole lean.",
                "Weightlifting coaches use the seated good morning mainly to strengthen the back's hold on its arch: the pelvis is fixed on the bench, so the erector spinae hold the trunk as one rigid lever while it tips. Once the lower back rounds, the lean comes from the spine instead of the hips.",
                "The lower back rounding as the chest nears the bottom of the lean.",
                "Sit tall, set a slight arch in the lower back, take a big breath and brace before each rep, and keep that arch all the way down and up."),
       "hinge": ("Hip Hinge",
                 "The trunk folds forward from the hips while the pelvis stays planted on the bench.",
                 "Folding at the hips keeps the spine still and lets the hips do the bending. With the knees bent, the hamstrings help less with straightening the hip than when the knees are nearly straight, so the glutes take a bigger share: in isometric hip-extension tests, the hamstrings contributed most with the knee straight, and the glutes' share grew as the knee bent.",
                 "Curling the upper back and dropping the head to lean further, while the hips hardly fold.",
                 "Tip the pelvis forward on the bench as the chest lowers, as if pointing the belly button at the floor, and keep the head in line with the back."),
       "feet": ("Foot Position",
                "The feet sit wide and flat on the floor, the knees apart.",
                "A wide, planted stance astride the bench gives the seat a stable base, so the pelvis stays put and only the trunk moves. Here the ankles sit about 60 cm apart, a little in front of the knees.",
                "Sitting with the feet close together or tucked under the bench, so the body rocks on the seat as it leans.",
                "Straddle the bench near its end with the feet flat, wider than the shoulders and a little in front of the knees."),
       "range": ("Range of Motion",
                 "Each rep leans forward as far as the back can stay arched; here the trunk tips about 55°.",
                 "The hips and back work hardest at the bottom, where the trunk is furthest from upright and the bar's lever is longest. How far you go is set by the arch, not a target angle: bend forward as far as you can without losing the back's extension.",
                 "Stopping after a small nod forward, well short of where the back could still hold its arch.",
                 "Lean slowly until you feel the back or hamstrings about to give up the arch, pause, then sit back up tall."),
   },
   # Same paint as the Good Morning. The erectors lead: the lift is chiefly
   # for the back's arch (Catalyst Athletics) and the house ranks them first
   # in the standing good morning too. The hamstrings drop to a MODERATE
   # primary with the knees bent ~62°: in maximal isometric hip extension the
   # hamstrings' share was highest with the knee straight and fell as it
   # bent, the glutes' share rising (Liu 2022, hip at 0° and 45°; Kwon & Lee
   # 2013, prone, BF and ST activity falling past ~60° of knee flexion). The
   # hamstrings are not slack here: the hip folds to ~123° of flexion at the
   # bottom (the trunk-thigh angle 110° to 57°) against ~89° standing, which
   # lengthens them at the hip by roughly what the bent knee takes up.
   # Total hip-extensor strength did not change with knee angle at 0-90° of
   # hip flexion (Németh 1983), and no test used ~120° of hip flexion, so
   # 0.62 is an estimate. The gluteus maximus stays the dim secondary it is
   # painted, MODERATE. No EMG study of the seated good morning was found.
   activation=[("Erector Spinae", P, HI, 0.80), ("Hamstrings", P, MOD, 0.62),
               ("Gluteus Maximus", S, MOD, 0.50)],
   stabilisers=["core", "upper back", "adductors"],
   comparison=("LEANING FROM THE UPPER BACK", "Fold at the hips, head in line", "Upper back curls, head drops",
               "Tipping the pelvis forward on the bench lets the hips do the folding while the back holds its arch, the hold this lift trains.",
               "Curling the upper back and dropping the head makes the lean look deeper, but the hips hardly fold and the pelvis barely tips on the bench."),
   glows=[glow(SEATED, ["spine", "chest"], A, 0.55, rx=0.07, ry=0.07),
          glow(SEATED, ["thigh_L", "patella_L", "thigh_R", "patella_R"], A, 0.45, rx=0.11, ry=0.05),
          glow(SEATED, ["pelvis"], SOFT, 0.30, rx=0.07, ry=0.05)])

SETUP[SEATED] = [
    "Set a flat bench lengthwise in a rack, with the bar at a height you can take it from while seated.",
    "Straddle the end of the bench with your feet flat, wider than your shoulders.",
    "Take the bar high across your upper traps, hands wide, and lift it off the hooks.",
    "Sit tall, set a slight arch in your lower back and brace before each rep.",
]

# ---------------------------------------------------------------- smith machine good morning

# Three-quarter from the front-left, with the Smith frame filling the
# picture: plates sweep the top corners (left u < 0.25, v 0.19-0.42; right
# u > 0.74, v 0.04-0.38), the head sits left of centre at the top of the
# body all rep, and the body spans u 0.25-0.80. Every leader from the top
# left would cross the head, so the labels sit low and short: back on the
# left at 0.465 (ends 0.23, the body's edge at 0.29, above the rack's orange
# pin), hips and knee below it on the left, the bar label on the right at
# 0.64 (starts 0.79, the far leg's back edge at 0.73) pointing up to the far
# hand on the bar, feet on the right of the bottom row. Pills over the
# rack's uprights are unavoidable in this framing; none covers the lifter,
# the bar or the plates.
ex(name=SMITH, var="smithMachineGoodMorning",
   overrides={"back": (0.483, "leading"), "hips": (0.68, "leading"), "knee": (0.86, "leading"),
              "bar": (0.68, "trailing"), "feet": (0.86, "trailing")},
   annotations=[
       ("bar", "High bar", "hand_L"),
       ("feet", "Feet under bar", "foot_L"),
       ("hips", "Push hips back", "pelvis"),
       ("back", "Flat back", "spine"),
       ("knee", "Knees stay soft", "patella_R"),
   ],
   cues={
       "bar": ("Bar Position",
               "The bar sits high across the upper traps, the hands well outside the shoulders.",
               "The rails fix the bar's path straight up and down, so where it sits on your back decides how you have to lean under it. High on the traps, it rests on muscle and the hips can travel back while the bar stays over the feet.",
               "Setting the bar low on the back of the shoulders, so the hands have to hold it there and the chest tips further forward under the fixed bar.",
               "Set the hooks just below shoulder height, step under and let the bar rest across the upper traps; squeeze the shoulder blades and pull the bar into your back."),
       "feet": ("Foot Position",
                "The feet sit back under the bar: it runs over the front of the feet, the ankles well behind it.",
                "The bar can only move straight up and down, so the feet set the whole lift. With the feet set back under the bar, the hips have room to travel back behind it while you stay balanced over the feet.",
                "Standing with the feet out in front of the bar, as for a Smith squat, so the hips run out of room to move back and you hang on the bar.",
                "Before unhooking the bar, stand so it is over the balls of your feet, feet hip-width and toes straight ahead."),
       "hips": ("Hip Hinge",
                "The hips travel well back as the chest lowers under the fixed bar.",
                "With the bar locked on its track, the chest can only come down if the hips move back behind it, and that backward hinge is what stretches the hamstrings. Here the hips travel about 40 cm back while the bar comes down only about 20 cm.",
                "Bending the knees and sinking the hips straight down, so the bar slides down the rails in a squat and the hamstrings barely stretch.",
                "Push the hips straight back toward the wall behind you and let the chest lower only as the hips go back; stop when the hamstrings are tight."),
       "back": ("Back Position",
                "The back stays flat and braced, the chest proud under the bar.",
                "The rails steady the bar, not your spine: the back muscles still hold a long trunk against the load. In free-bar good mornings the lower-back muscles worked at about 70% of their own maximum at heavy loads, and keeping the back flat leaves the bend at the hips.",
                "The upper back rounding at the bottom, the chest caving and the head dropping.",
                "Brace before unhooking the bar, keep the chest up and the neck in line, and stop the rep before the back starts to round."),
       "knee": ("Knee Angle",
                "The knees start soft and bend a little more as the hips go back.",
                "A small knee bend lets the hips travel back under the fixed bar, and locked knees stop the hinge short. The bend should stay small: in free-bar good mornings, more knee bend came with shorter hamstrings. Here the knees go from about 16° to 30° bent.",
                "Locking the knees straight and keeping them locked, so the hips cannot travel back far under the bar.",
                "Unlock the knees before you start and let them soften a little more as the hips go back, without letting the rep become a squat."),
   },
   # Same paint as the free-bar good morning, a step lower on both
   # primaries, from the model: at the bottom the trunk tips 52° here
   # against 64° and the hip closes to 98° against 91°, so the bar's lever
   # about the hips and back is shorter and the hamstrings stretch less. In
   # squats (n = 6, 8RM), biceps femoris activity was about a fifth lower
   # with the Smith bar and the lumbar erectors did not differ (Schwanbeck
   # 2009); no EMG study of a Smith good morning was found.
   activation=[("Erector Spinae", P, HI, 0.76), ("Hamstrings", P, HI, 0.72),
               ("Gluteus Maximus", S, MOD, 0.48)],
   stabilisers=["core", "upper back", "calves"],
   comparison=("FEET OUT IN FRONT", "Feet set back under the bar", "Feet set out ahead of the bar",
               "With the feet set back under the bar, the hips travel back behind it and the hamstrings stretch while you stay balanced.",
               "With the feet out in front, the hips run out of room, the weight goes to the heels and the rep turns into leaning on the bar."),
   glows=gm_glows(SMITH))

SETUP[SMITH] = [
    "Set the Smith bar hooks just below shoulder height and the safety stops just below the lowest point of your rep.",
    "Step under the bar and rest it high across your upper traps, hands well outside your shoulders.",
    "Set your feet hip-width, back under the bar so it sits over the balls of your feet, toes straight ahead.",
    "Unlock your knees, brace and turn the bar off the hooks.",
]

# ---------------------------------------------------------------- nordic hamstring curl

# Side-on, facing screen-left, the top half of the frame empty: the head
# swings from the top centre (u 0.69) down to the lower left (u 0.19, v
# 0.58), with the chest, hips and hands inside that arc, and the base and
# anchor post fill the band v 0.60-0.73 on the right. A top-left leader
# reaches only the head without crossing it at some moment, so the range
# label (the head traces the range) sits there; the anchor label is short,
# top right, its leader passing right of the head to the ankle. The hands
# label sits left on the 0.64 row, short so it ends before the head and
# hands at the bottom, its leader up to the near hand; the line and lower
# labels take the bottom row below the base, their leaders up to the hips
# and the knee.
NORDIC_OVERRIDES = {"range": (0.14, "leading"), "anchor": (0.14, "trailing"), "hands": (0.68, "leading"),
                    "line": (0.86, "leading"), "lower": (0.86, "trailing")}

ex(name=NORDIC, var="nordicHamstringCurl",
   overrides=NORDIC_OVERRIDES,
   annotations=[
       ("line", "Knees to shoulders in line", "pelvis"),
       ("lower", "Lower slowly, no drop", "shin_L"),
       ("range", "Go as far as you control", "head"),
       ("anchor", "Ankles locked", "foot_L"),
       ("hands", "Hands ready", "hand_L"),
   ],
   cues={
       "line": NORDIC_LINE,
       "lower": ("Lowering Control",
                 "Lower slowly and evenly, fighting the fall all the way.",
                 "The hamstrings do their work by braking the fall. In one study, lifters who fell faster showed lower hamstring activity, and the drop usually comes as a sudden speed-up, the point where the hamstrings can no longer hold the body. Programmes that include the Nordic have about halved hamstring injuries in athletes.",
                 "Letting go near the bottom and dropping the last part toward the floor.",
                 "Resist the whole way: lower slowly and evenly, and catch yourself on your hands only when you can no longer slow down."),
       "range": ("Range of Motion",
                 "Lower as far as you can still control, here until the body is about 15° above the floor, then curl back up.",
                 "Stronger hamstrings control the lowering to a straighter knee: after 6 weeks of Nordics, lifters controlled the fall to a straighter knee and their eccentric strength rose. Working to the point you control and building from there is how the lift progresses; lowering onto a stack of mats in front of you shortens the range while you build up.",
                 "Only leaning a little way forward before coming back up, so the hamstrings never work at the straighter knee angles.",
                 "Lower until just before you lose control, pause, then curl back up with the hamstrings; if you cannot yet, catch yourself on your hands and push back up."),
       "anchor": NORDIC_ANCHOR,
       "hands": NORDIC_HANDS,
   },
   # Painted: hamstrings bright; calves and glutes dim. The standard floor
   # Nordic peaks near or above maximum (Šarabon 2019: ST 106.7, BF 99.7
   # %MVC; Ditroilo 2013: BF 134% of a maximal eccentric contraction): 0.95,
   # above the leg curls' 0.90-0.92 and the glute-ham raise's 0.93 (Ebben
   # 2009's 98 %MVIC Russian curl was done on a glute-ham machine, so it
   # backs that row, not this one; the ACE study's floor version raised ST
   # above the prone leg curl and its machine version did not). The
   # gastrocnemius MODERATE at the bottom of the leg curls' 0.40-0.46 and
   # the gluteus maximus LOW just under it: Murakami 2023 has the two level
   # in the eccentric phase (medial gastrocnemius 28.7 ± 9.0, gluteus maximus
   # 30.8 ± 41.6 %MVIC), so the order rests on Šarabon 2019 (gluteus maximus
   # relatively low in every variation) and the gastrocnemius crossing the
   # knee. The erector spinae (~65% in Šarabon 2019) and the obliques
   # (Narouei 2018) hold the trunk: stabilisers, as the model does not paint
   # them.
   activation=[("Hamstrings", P, HI, 0.95), ("Gastrocnemius", S, MOD, 0.40),
               ("Gluteus Maximus", S, LOW, 0.34)],
   stabilisers=["erector spinae", "obliques", "core"],
   comparison=("BENDING AT THE HIPS", "Straight line, knees to shoulders", "Hips bend, backside pushes back",
               "Held in one straight line, the body lowers as one piece around the knees, so the hamstrings brake the whole fall at the knee.",
               "When the hips bend, the body no longer lowers as one piece around the knees, so it is no longer the version tested and trained in the studies."),
   glows=kneeling_glows(NORDIC))

SETUP[NORDIC] = [
    "Kneel on a thick pad with your knees about hip-width apart.",
    "Hook your ankles under the padded anchor, or have a partner hold your lower calves down.",
    "Kneel tall with your hips straight and your hands loose in front of your chest.",
    "Squeeze your glutes and brace before each rep.",
]

# ---------------------------------------------------------------- assisted nordic curl

# The Nordic's picture plus the band's tower on the right edge (u 0.91-0.95
# from v 0.19 down, its top bar at v 0.19-0.22) and the band itself, from
# the chest to the anchor at v ~0.41: level at the top, rising from the
# lower left at the bottom. Same rows as the Nordic: the head's label (the
# lowering) top left, the short anchor label top right above the tower's top
# bar, the hands label left at 0.64, the band label bottom left with its
# leader up to the chest, the line label bottom right to the hips. The band
# crosses the anchor leader but no pill.
ex(name=ASSISTED, var="assistedNordicCurl",
   overrides={"lower": (0.14, "leading"), "anchor": (0.14, "trailing"), "hands": (0.68, "leading"),
              "band": (0.86, "leading"), "line": (0.86, "trailing")},
   annotations=[
       ("band", "Band high on the chest", "chest"),
       ("line", "Knees to shoulders in line", "pelvis"),
       ("lower", "Lower slowly, no drop", "head"),
       ("anchor", "Ankles locked", "foot_L"),
       ("hands", "Hands ready", "hand_L"),
   ],
   cues={
       "band": ("Band Set-Up",
                "An elastic loop runs from an anchor behind and above you, around the front of the chest.",
                "The band pulls the chest up and back, taking part of the load off the hamstrings. It stretches far more at the bottom than at the top, so it helps most where the hamstrings have the hardest job. In a youth football trial, assisted Nordics going from heavy to light bands built as much Nordic strength as regular ones, about 20% in 8 weeks, with less soreness and effort.",
                "Using a band so strong that you hang in it and barely lean, so the hamstrings are hardly loaded.",
                "Loop the band high across the chest, under the armpits, and pick the lightest band that lets you lower slowly almost to the floor; move to lighter bands as you get stronger."),
       "line": NORDIC_LINE,
       "lower": ("Lowering Control",
                 "Lower slowly and evenly, the band sharing the load, not taking it over.",
                 "The hamstrings still do the braking; the band only lightens it, which lets you keep the lowering slow over more of the range. In one study, lifters who fell faster in a Nordic showed lower hamstring activity.",
                 "Relaxing into the band and letting it catch you, the body dropping the last part.",
                 "Resist the whole way down as if the band were not there, and let it take only what you cannot hold."),
       "anchor": NORDIC_ANCHOR,
       "hands": NORDIC_HANDS,
   },
   # Painted: hamstrings bright; calves and glutes only faint (0.11). The
   # band takes part of the load, so the hamstrings sit under the
   # unassisted Nordic's 0.95 at 0.85, a house estimate for the submaximal
   # assisted rep the model shows: no EMG study of a band-assisted Nordic at
   # a matched, submaximal effort was found. In one all-out repetition,
   # assisted versions reached higher torque and higher EMG integrals for
   # BF, ST and both gastrocnemius heads (Demeusoy 2026), put down to a
   # longer range and time under tension; integrals grow with duration, so
   # they do not measure intensity, and that result is kept out of the copy.
   # The training effect matched the unassisted Nordic (Ishøi 2025). The
   # faint secondaries are LOW, under the Nordic's.
   activation=[("Hamstrings", P, HI, 0.85), ("Gastrocnemius", S, LOW, 0.32),
               ("Gluteus Maximus", S, LOW, 0.22)],
   stabilisers=["erector spinae", "obliques", "core"],
   comparison=("HANGING IN THE BAND", "Band helps, hamstrings brake", "Band holds you near upright",
               "A band just strong enough to slow you lets the hamstrings brake the fall through the whole range, which is how the assisted version builds strength.",
               "A band that does the holding keeps you near upright, so the hamstrings barely work and the reps build little."),
   glows=kneeling_glows(ASSISTED, soft=0.22))

SETUP[ASSISTED] = [
    "Set the band's anchor behind you, a little higher than your chest when you kneel tall.",
    "Kneel on the pad and hook your ankles under the padded roller.",
    "Loop the band around your chest, high under your armpits.",
    "Kneel tall with your hips straight and your hands loose in front of your chest.",
]

# ---------------------------------------------------------------- glute-ham raise

# Side-on on the machine, the figure small (zoom 0.46): the head swings from
# the top centre (u 0.57, v 0.27) to the left (u 0.14, v 0.49), the rollers
# and footplate sit right of the knees (u 0.63-0.78, v 0.48-0.58), the round
# pad's stand below the knees (u 0.48-0.55) and the base rails down to v
# 0.76. The range label tracks the head from the top left; the short lower
# label sits top right, its leader passing right of the head to the chest;
# the feet label below it on the right at 0.32, clear of the upright body
# (its back edge at u 0.63); the line label left at 0.64, short so it ends
# before the pad's stand; the pad label on the bottom row, right, its
# leader up to the knee.
ex(name=GHR, var="gluteHamRaise",
   overrides={"range": (0.14, "leading"), "lower": (0.14, "trailing"), "feet": (0.32, "trailing"),
              "line": (0.68, "leading"), "pad": (0.86, "trailing")},
   annotations=[
       ("pad", "Knees just behind the pad", "patella_L"),
       ("feet", "Feet press plate", "foot_L"),
       ("line", "Hips locked straight", "pelvis"),
       ("range", "Lower until nearly level", "head"),
       ("lower", "Lower slowly", "chest"),
   ],
   cues={
       "pad": ("Pad Position",
               "The lower thighs rest on the pad with the knees just behind it.",
               "With the kneecaps clear of the pad, the knees are free to bend and straighten while the pad carries the thighs as you lower. The studies set the knees just behind the pad; one put them about 4 cm behind its top.",
               "Setting up with the knees on top of the pad, so it presses on the kneecaps and gets in the way of the knees bending.",
               "Adjust the footplate so that, with your ankles locked in, your knees sit just behind the pad and your lower thighs rest on it."),
       "feet": ("Foot Position",
                "The balls of the feet press into the footplate, the ankles locked between the rollers.",
                "The footplate gives the feet something to push against. The calf muscle crosses the knee and helps bend it: in one study of a loaded glute-ham raise, the gastrocnemius worked almost twice as hard coming up as in a lying leg curl. Pressing through the feet also keeps the ankles seated between the rollers.",
                "Letting the feet go loose, the toes pulling away from the plate as you lower.",
                "Before each rep, drive the balls of your feet into the plate and keep pressing as you lower and curl back up."),
       "line": ("Body Line",
                "The knees, hips and shoulders stay in one line; the hips never bend.",
                "In this version the whole body swings around the knees, so the hamstrings bend and straighten the knee against the body's weight. In one study of a loaded version done this way, with the hips held straight, it drew more hamstring activity on the way up than a lying leg curl, and more lower-back activity than the good morning or RDL, the back holding the body in line.",
                "Bending at the hips at the bottom and on the way up, the backside pushing back and the trunk swinging up.",
                "Squeeze the glutes and brace before each rep, and hold the straight line from the knees to the head throughout."),
       "range": ("Range of Motion",
                 "Each rep lowers until the body is nearly level with the floor, then curls back up to upright.",
                 "The knees open by about 85°, from kneeling upright to nearly straight, much like the lab versions, which went from upright to about level. The last part near level is the hardest, because the body's weight is furthest from the knees there.",
                 "Stopping halfway down and coming back up, so the hamstrings never work near a straight knee.",
                 "Lower until the body is about level with the floor, or as far as you can control, pause, then pull yourself back up to upright with the hamstrings."),
       "lower": ("Lowering Speed",
                 "Take the lowering slowly and under control.",
                 "The lowering is where the hamstrings brake the body's weight; in Nordic-style lowering, lifters who fell faster showed lower hamstring activity. A steady speed also keeps the body line from breaking at the bottom.",
                 "Dropping quickly into the bottom and bouncing out of it.",
                 "Lower smoothly, about as long as it takes to curl back up, stop at the bottom without a bounce, then pull up."),
   },
   # Painted: hamstrings bright; calves and glutes dim. The knee-only
   # glute-ham raise, loaded, drew more concentric BF and ST activity than
   # the prone leg curl (McAllister 2014), and the same movement on a
   # glute-ham machine (Ebben 2009's Russian curl, a plate at the chest) gave
   # 98 %MVIC, significantly above the seated leg curl's 81: 0.93, above the
   # app's seated leg curl (0.92). A step under the floor Nordic's 0.95: in
   # the only direct comparison (ACE 2018), the floor version raised ST
   # above the prone leg curl and the machine version did not (BF lower in
   # both). The gastrocnemius a MODERATE secondary above the lying leg
   # curl's 0.46: medial gastrocnemius 260.7 vs 139.7 µV on the way up
   # (McAllister 2014, loaded). The gluteus maximus LOW, holding the hips
   # straight as in the Nordic (Šarabon 2019); McAllister measured only the
   # gluteus medius (concentric 220.7 µV, level with the prone leg curl's
   # 194.1), and no gluteus maximus EMG of this lift was found. The
   # erectors, most active in this lift of the four (McAllister 2014) but not
   # painted, are stabilisers.
   activation=[("Hamstrings", P, HI, 0.93), ("Gastrocnemius", S, MOD, 0.50),
               ("Gluteus Maximus", S, LOW, 0.30)],
   stabilisers=["erector spinae", "obliques", "core"],
   comparison=("KNEES ON THE PAD", "Knees just behind the pad", "Kneecaps on top of the pad",
               "With the knees just behind the pad, they bend freely and the pad carries the thighs, so the hamstrings work through the whole swing.",
               "With the kneecaps on the pad, it presses into the knees and gets in the way of them bending, and it no longer carries the thighs."),
   glows=kneeling_glows(GHR))

SETUP[GHR] = [
    "Set the footplate so your knees sit just behind the pad when your feet are against the plate.",
    "Step onto the plate and lock your ankles between the rollers.",
    "Rest your lower thighs on the pad and kneel up tall, hips straight, hands in front of your chest.",
    "Press the balls of your feet into the plate and brace before each rep.",
]
