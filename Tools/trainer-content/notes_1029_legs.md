# Model-only batch (2026-10-29): legs family

Content: `spec_1029_legs.py`. Two exercises that were in the library with a
model but no `ExerciseContent`:

| Exercise | Model | Framing |
|---|---|---|
| Barbell Standing Calf Raise | `Legs/BarbellStandingCalfRaise` | yaw -0.8, zoom 0.686, offset [-0.025, 0.012, 0.026] |
| Dumbbell Lying Leg Curl | `Legs/DumbbellLyingLegCurl` | yaw -1.35, zoom 0.518, offset [-0.011, 0.066, 0.049] |

No ghosts yet, as for the arms and glutes families: each mistake view falls
back to the red ring.

## How this family was written

Unlike the first two families of the round, this one went through the
README's full agent process: for each lift one agent measured the rig and
one swept the literature, a third drafted the entry from both, two
independent reviewers audited it (evidence; model fidelity and labels), a
reviser worked through every finding, and a final skeptic re-measured and
re-read every citation before the entry was accepted. Each lift's complete
finding log - what was applied, what was applied with a change and what was
disproved, with the proof - is kept beside this file in the round folder
(`drafts/<slug>_rev_log.md` and `drafts/<slug>_final_log.md`). The
measuring scripts are the round's own (`brief.py`, `summ.py`, `props.py`,
`nearest.py`, `gaps.py`, `palm.py`, `trainer_shot.py`, `overlay.py`).

What the process caught, as examples: a stretch-range study quoted with its
ranges reversed (the growth advantage was below a flat foot, which this
model has no block to reach), an EMG paper used to rank two muscles when it
normalised each to its own maximum, a header bullet that put the camera
behind the lifter when it is in front, a glow that sat off the painted
muscle, and several figures that were right to two decimals in a script
printout but wrong at full precision.

## Barbell Standing Calf Raise

| Claim in the copy | Source |
|---|---|
| The framing is a front three-quarter taken from the lifter's left, with the joints the rig names _L on the right of the frame | Model and render, re-measured this round (`proj_depth.py`, which reproduces `trainer_shot.py`'s transform chain at this entry's own yaw -0.8, zoom 0.686, offset -0.025,0.012,0.026 and lands hand_L at u 0.640, matching the header). Camera depth at t0: support_PectoralisMajor_Sternal_L 2.0045 against support_LatissimusDorsi_L 2.0570, and toe_L 1.9928 against foot_L 2.0334, so chest and toes are the near surfaces; the bar centre is 2.0674 against the neck at 2.0395, so the shaft is on the far side of the neck; hand_L 1.9635 against hand_R 2.1807 puts the camera on the lifter's left. `Tools/model-pipeline/facing.py` prints this lifter facing +0 deg at every sampled frame, i.e. yaw 0 is the front, so -0.8 rad is a 46 degree front three-quarter. The re-shot still at the entry's framing shows pectorals, rectus abdominis, clavicles and the neck straps, with the shaft emerging from behind each deltoid. The draft, and both reviews, called this a back view; it is a front one, and the header bullet and the layout comment are corrected |
| The bar is racked across the top of the back, below the neck | Model (`allframes_bscr.py`, an all-frame rewrite of `nearall.py`, re-run this round): the shaft axis sits 0.088 m from scapula_L and scapula_R, 0.098 m from both upper-trap supports and 0.109 m from the neck, in every one of the 192 frames; bar z 0.0985 against neck z 0.2036, so it rides 0.105 m behind the neck, not a front rack. StrengthLog's page for this lift also puts the bar on the shoulders |
| The bar axis sits 9 cm from each shoulder blade, equal on the two sides, and 11 cm from the neck joint, and it holds there in every one of the 192 frames | Model (`allframes_bscr.py`): scapula_L 0.0883-0.0885 m and scapula_R 0.0883-0.0885 m (spread 0.15 mm), trap supports 0.0977-0.0979 (0.01 mm), neck 0.1092-0.1093 (0.11 mm), neck-to-bar z offset 0.1046-0.1054 (0.79 mm). The draft rested the never-shifts claim on five sampled times out of 192 frames, which left the back half of rep 2 unsampled; it is now the whole clip. The equal-on-both-sides clause is made for the shoulder blades only, since the neck is a single midline joint |
| The hands hold the bar overhand, 0.79 m apart against shoulders 0.39 m apart (about twice shoulder width) | Model (`summ.py`): handgap 0.79 m and shouldergap 0.39 m, both min = max. Overhand from `palm.py`: hand_L local X [0.97, -0.26, 0.04] points outward like the pronated `Biceps/ReverseCurl` reference [0.79, 0.21, 0.58] and opposite the supinated `Biceps/CableCurl` [-0.97, -0.24, 0.1]; its Y axis points up where both references point down, so there is no clean hand-frame match. The stills add less than the draft claimed. Read as the front three-quarter they are, a per-mesh id render counts 662 visible pixels of the near hand against 178 of the far one, which is mostly behind the torso and the deltoid, so the picture settles one hand at a size where no palm direction reads on its own; the call rests on the X sign |
| Wrists just under the bar | Model (`allframes_bscr.py`): the bar axis is 0.095 m above and 0.019 m in front of hand_L and hand_R, 0.097 m away, at every frame (spreads 0.49 mm, 2.49 mm and 0.00 mm). The lifter faces +z (toe_L z 0.199 against foot_L z 0.097), so hand z minus bar z of -0.019 m puts the hand behind the bar and the bar in front of the hand; the header bullet had this reversed and now says behind |
| The whole body rises straight up: the trunk stays within 1.5 degrees of vertical and the head and hips rise 6.5 cm with the heels | Model (`summ.py`): trunk -0.42 degrees at 7.80 s to +1.08 at 1.04 s. `ankle.py`: pelvis y 0.907 to 0.973 m and head y 1.600 to 1.666 m, each printed as a 0.065 m range |
| The bar travels 0.13 m bottom to top (0.068 m up, 0.107 m forward); five barbell meshes, a 2.04 m shaft, two 0.37 m plates and two collars at x +/-0.79 | Model: `brief.py` (13 cm for all five meshes), `props.py` (five prop meshes, all barbell parts: shaft 2.04 x 0.028 m, plates 0.37 x 0.08 m, hubs at x +/-0.79), `nearall.py` (bbox per frame); `allframes_bscr.py` re-prints bar y spread 68.05 mm and bar z spread 107.64 mm. `props.py`'s own travel figure is not used - see the last row |
| 7.96 s at 24 fps, 192 frames, two reps, one every 4.0 s | Model (`summ.py` and `ankle.py` headers; `phase.py` mid-range crossings at 0.54, 2.75, 4.54 and 6.75 s) |
| The gastrocnemius crosses the knee as well as the ankle, so it is at full length only with the knee straight | Anatomy, and the premise of Cresswell 1995 (Exp Brain Res 105(2):283-290, PMID 7498381, PubMed page and the Europe PMC core record both fetched 2026-10-29): 10 men; as the knee bent, plantar flexor torque and twitch torque fell and gastrocnemius EMG fell while soleus RMS held, and the authors credit the gastrocnemius with at least 40% of plantar flexor torque with the leg straight. The abstract also reports knee angle changed in 30 degree steps from 180 degrees (extended) to 60 degrees (extreme flexion), with torque falling sigmoidally to 60% of the maximum torque at 180 degrees; this row uses the library's own wording for the same PMID in `spec_500_calfstand.py` so the two notes files agree, and the copy uses only the anatomy premise. The previous revision said that 60% figure was absent from the abstract, which was false about the record it cited |
| In a 12-week study of untrained adults, the leg trained standing with the knee straight grew its lateral gastrocnemius 12.4% against 1.7% for the leg trained seated with the knee bent, and its medial head 9.2% against 0.6%, while the soleus grew about the same either way | Kinoshita 2023 (Front Physiol 14:1272106, PMID 38156065, Frontiers full text read 2026-10-29): 14 untrained adults, one leg standing with the knee at 0 degrees on an IMH703 machine and the other seated with the knee at 90 on a GSCR349, 70% 1RM, 10 reps x 5 sets, twice a week; MRI volume; lateral p = 0.001, medial p = 0.002, soleus +2.1% vs +2.9%, p = 0.410. The two conditions used two different machines in two body positions, so the copy says trained standing and trained seated rather than presenting it as a pure knee-angle manipulation, and makes no claim that a bent knee is the soleus exercise (Hebert-Losier 2012 puts the knee-angle difference at 4-5 percentage points of MVIC). The study never tested dipping the knees mid-rep, which is what the cue coaches against. Its 20 degrees dorsiflexed to 30 plantarflexed ankle range comes from the OpenSim figure caption, not the training protocol, so it is not used |
| Both knees held at about 175 degrees with no change across the two reps | Model (`summ.py`, re-run): knee_L 174.69 and knee_R 176.00 degrees, min = max on both sides |
| The ankle opens 36.6 degrees, the same on both sides | Model (`ankle.py`, re-run): ankle_L 103.545 to 140.164 degrees (range 36.620) and ankle_R 104.181 to 140.797 (range 36.616); peaks at 1.00 s on both sides |
| The heels come about 7 cm up while the toes stay where they are | Model (`ankle.py`): foot_L y 0.071 to 0.139 m (0.069 m) and 0.067 m forward, right identical; toe_L and toe_R y 0.015 m with zero range |
| The top is held about 1.2 seconds on each rep | Model (`phase.py`, re-run): ankle_L within 1 degree of its maximum from 0.92-2.12 s and 4.92-6.12 s |
| The model returns to exactly the ankle angle it started from and waits there over half a second | Model (`ankle.py`, `phase.py`): minimum 103.545 degrees at 7.75 s, equal to the 0.00 s start value; bottom windows 0.00-0.08 s, 3.38-4.08 s (0.70 s) and 7.38-7.96 s (0.58 s) |
| Standing with the balls of the feet on a block lets the heels drop below level, and in an eight-week study of young women, training only that stretched range below a flat foot grew the medial gastrocnemius 15.2%, against 6.7% for the full range and 3.4% for the range above flat that this version works in | Kassiano 2023 (J Strength Cond Res 37(9):1746-1753, PMID 37015016, abstract re-read 2026-10-29): 42 young women, 8 weeks, 3 days a week, 3 sets of 15-20RM on a pin-loaded horizontal leg press, with 0 degrees defined as 90 degrees of the foot to the tibia; INITIAL -25 to 0 = +15.2% medial gastrocnemius, FULL -25 to +25 = +6.7%, FINAL 0 to +25 = +3.4%, p <= 0.009. The stretched condition lies entirely below flat, so the draft had this backwards: it told the reader that lowering to the floor delivers the 15.2% condition, when the floor is that range's upper end. The lateral head's advantage over the full range was not significant (p = 0.060) and is not claimed. The library's Bodyweight and Dumbbell Standing raises word the same point the same way |
| On the floor the heels can only come down to level, so touching down every rep is the least to aim for | Model (`props.py`): five prop meshes, all barbell parts, with no platform, block or step; toe_L and toe_R stay at y 0.015 m while the heel lifts, and each rep returns to its starting ankle angle. So this version's range runs from flat to 36.6 degrees of plantar flexion - Kassiano's FINAL range, the one that grew the medial gastrocnemius least - which is why the cue words the floor as the least to aim for and names the block as the progression rather than as the stretched range itself |
| A quick dip before the push leaves the calf fibres nearly the same length while the tendon stretches and springs back, and the push comes out stronger | Kawakami 2002 (J Physiol 540(2):635-646, PMID 11956349, abstract read 2026-10-29): 6 men, maximal supine plantar flexion with and without a countermovement, against a load set at 40% of maximal voluntary force (the 40% is the load, not the effort); peak force, average power and work at the tendon all significantly greater with it, fascicles near-isometric. It was supine machine-controlled plantar flexion, so the copy calls it an ankle push, never this lift, and never says the bounce makes the rep weaker |
| So a slow lowering and a pause keep the work on the muscle; do not bounce, control the lowering | Mechanical inference from Kawakami above (marked as such, not a trial result), plus Tumminello 2021 (NSCA Personal Training Quarterly 8(4):16-19, PDF read 2026-10-29), which instructs not to bounce and to control the lowering; StrengthLog's page for this lift asks for a dead stop at the bottom of every rep. Practice copy, no numbers; the same pairing the library's standing neighbours use. No tempo or pause length is presented as research-backed |
| The rise takes about 0.9 seconds and the lowering about 1.3 | Model (`phase.py`): rise 0.00-0.92 s, lower 2.12-3.38 s |
| Feet about hip-width apart, toes forward, on a flat floor | Model (`gaps.py`, `summ.py`, both re-run): ankle separation 0.202 m at the bottom and 0.217 m at the top, knees 0.182-0.188 m; the stills show both feet parallel. Toes forward is coached as a default, not as better: Nunes 2020 (J Strength Cond Res 34(8):2347-2351) found toes out favoured the medial head and toes in the lateral, with toes forward between the two, and Arnsdorff/Riemann 2011 (Int J Exerc Sci 4(1):13-21) found no difference between foot positions in ankle range of motion (p = .129) or ankle mechanical energy expenditure (p = .590). No foot-direction claim is made in the copy |
| Rows: Gastrocnemius .primary 0.86, Soleus .primary 0.66 | Paint for the ranks (both bright on both legs); fractions and ranks taken from `SampleData.swift`, which is the shipped library and is newer than the spec files: the Standing, Leg Press, Single-Leg, Smith Machine and Dumbbell Standing raises all carry Gastrocnemius .primary 0.86 and Soleus .primary 0.66, and the Bodyweight Standing and Elevated raises the same ranks at 0.78 / 0.60 (re-parsed this round across all 443 ExerciseContent blocks). (`ACT_STRAIGHT` in `spec_legs30_calf.py` still ranks the soleus secondary, but that file predates the re-paint rounds and no longer matches what ships, so it is not the reference.) Gentil 2020 (Int J Environ Res Public Health 17:9487, PMC7765981, full text re-read 2026-10-29) is NOT used for the rank: its EMG was normalised per muscle to that muscle's own maximum in the test with no MVC taken, and the paired tests compared leg press against calf raise within each muscle, never muscle against muscle, so soleus 51.34% and medial gastrocnemius 52.19% are fractions of two different references. What it does support is that a straight-knee standing raise (knees fully extended throughout, 22 trained men) drives the soleus as hard as a leg press does. The 0.86 / 0.66 gap is a house convention, not a measured ratio |
| Row: Hamstrings .secondary 0.15 | Paint (biceps femoris, semimembranosus and semitendinosus dim on both legs, `tiers.py`) and the library's Bodyweight Standing, Dumbbell Standing and Elevated raises, which all carry Hamstrings .secondary 0.15. Pure estimate: no EMG study measures a hamstring in any calf-raise variant, searched for directly this round and found empty. No cue mentions the hamstrings |
| Tibialis posterior and peroneals as stabilisers, not rows | Paint: this model lights nothing below the knee but the triceps surae, and the rows follow the paint. That is not a divergence from the library - the Dumbbell Standing Calf Raise carries exactly these three rows and keeps tibialis posterior and peroneals in its stabilisers too. Five calf raises row a lower-leg muscle: Fibularis Longus 0.30 on the Standing raise, Tibialis Posterior 0.30 on the Leg Press raise, both at 0.30 on the Single-Leg raise, both at 0.25 on the Smith Machine raise, and Fibularis Longus 0.30 plus Tibialis Posterior 0.25 on the Seated raise. The first four sit on the same Gastrocnemius .primary 0.86 / Soleus .primary 0.66 pair this entry uses; the Seated raise inverts the pair (Soleus 0.86 / Gastrocnemius 0.30). (Parsed from `SampleData.swift` this round: Standing line 32961, Seated 33063, Leg Press 33164, Single-Leg 33266, Smith 33372. The earlier revision said three, and the review it answered said two.) Both muscles are genuinely active - Kulig 2004 (Med Sci Sports Exerc 36(5):862-867) measured MRI signal up 57% in the peroneus longus and 27% in the tibialis posterior after a unilateral heel raise, and Akuzawa 2017 (Phys Ther Sport 28:23-28) confirms both with fine-wire EMG - but neither gives a normalised figure, and MRI T2 signal is a metabolic marker, not activation |
| Stabilisers: tibialis posterior, peroneals, toe flexors, upper back, core | The lower-leg three as above; upper back and core carried from the library's Standing and Smith Machine raises, a modelling judgement for a bar held on the back (the hands never move relative to it, `allframes_bscr.py`), not a finding. No copy claims the barbell works them more than a machine would |
| Both reps move both legs together | Model (`ankle.py`, `phase.py`): left and right heel heights identical to the millimetre at every sample; the constant 0.6 degree ankle and 1.3 degree knee difference between sides is a rig offset, not asymmetric movement |
| Glows: one bright on the R calf, one soft on the L | Re-shot stills at the entry's own framing (`trainer_shot.py`, yaw -0.8, zoom 0.686, offset -0.025,0.012,0.026), plus a flat-colour per-object id render of the same frames that gives each painted pixel to the mesh it belongs to, so the two legs can be counted without guessing a seam. Both calves show: R 956 px (u 0.393-0.463) against L 726 px (u 0.458-0.552) at the bottom of the rep, 986/723 at the top and 971/732 in the lowering, and every one of those mesh pixels reads red in the shaded still. The previous revision said the yaw hid most of one calf behind the other and credited 1115 px to R and 185 to L; that was a u-split at 0.50 against a real seam at about 0.46, and it is wrong. What actually differs is shape: at the glow row v 0.665 the R calf is one 19 px run (u 0.406-0.453) while the L calf is a 4 px strip at u 0.458-0.466 plus an 8 px strip at u 0.531-0.550, split by its own unpainted shin, so the shin_L/foot_L mean (u 0.4737) that `glow()` centres on falls in the gap. The pair is `spec_500_calfstand.calves(dy=-0.02)` read line for line, with the full glow on the leg it can centre on: R (0.414, 0.660) has its centre on paint at t0, t1 and t3 and covers 43% / 57% / 51% red; L (0.489, 0.665) covers 40% / 29% / 37% with its centre on no paint at any of them, and a sweep of dx 0-0.040 against dy -0.03 to +0.01 finds nothing in that family centred on paint at all three, so the far-side ellipse is kept at SOFT 0.32 for the pair rather than made a second bright glow. The paint spans v 0.618-0.747 with centroid v 0.678 against shin-to-ankle midpoints of 0.685 (L) and 0.680 (R), which is what the -0.02 dy is for. No hamstring glow: the dim thigh paint is never wider than 8 px on a row (near thigh u 0.453-0.518, far thigh u 0.390-0.435), and the draft's third ellipse at (0.447, 0.595) measures 16% / 27% / 22% red with its centre off paint, 413 of its 521 red pixels at t0 being calf paint its lower edge dips into. The Dumbbell Standing raise carries the same Hamstrings 0.15 row with no hamstring glow |
| Not used, and why | `summ.py` counts reps off the first elbow, whose range here is 0.01 degrees, and prints 22 spurious crossings - the reps were counted from the ankle instead (`phase.py`). `props.py` compares t = 0 against 0.4 x clip (3.18 s), near the bottom of rep 2, and so reports 1.6 cm of bar travel against the real 13 cm (`brief.py`). `nearest.py` searches lower-body joints only and returned pelvis 0.57 m for a bar on the back, which is why `nearall.py` was written; `nearall.py` in turn samples only five times out of 192 frames, which is why `allframes_bscr.py` was written for the fixed-bar claims. Pixel figures are measured on renders with the DARK_Floor plane hidden, because with the floor in, every band below v 0.505 is filled edge to edge and the subject cannot be told from the plane by colour; the previous revision's u 0.673 for the tempo row came from that confusion. None of those numbers are in the copy. Also: `joints.json` stores normalised 0-1 coordinates for this exercise, converted here by x 382 and x 655, and reproducing the trainer projection by hand matches it to the third decimal (hand_L 0.641 against 0.640) |

LABEL PLAN
LABEL PLAN
The plates make the top half of the frame unusable: between v 0.23 and 0.38 the ink runs u 0.068-0.929 across the clip (u 0.068 at the top of the rep, u 0.929 at the bottom), so the 0.32 row has no gutter that survives the clip - 43 px of clear column on the left at the bottom of the rep but only 26 px at the top, and 43 px on the right at the top but 26 px at the bottom, so the column that is clear at every probed moment is 26 px either side, against 97 px for even the shortest label. That row carries no pill. One reading note: the rows quoted here are the screen rows, while the overrides dict on the next line holds the pre-squeeze values that spec_1029.row() maps onto them (0.14 / 0.50 / 0.68 / 0.86 in the code become 0.16 / 0.48 / 0.64 / 0.80 on screen).

Bar pill, row 0.16 leading, u 0.035-0.318. At the bottom of the rep that row is clear right across the frame - the topmost subject pixel is v 0.1985 - but the pill has to survive the top of the rep as well, where the body rises 6.5 cm (topmost pixel v 0.1725) and ink enters the row from u 0.332. The 15-character label ends at u 0.318, so it clears by 5 px; nothing longer fits on the left there. (The draft's u 0.33 figure was right, but described as the bottom-of-rep state, where there is no ink in that row at all.)

Tempo pill, row 0.48 trailing, u 0.624-0.965: the subject's ink in that band reaches only u 0.534 at the bottom of the rep (0.503 at the top, 0.524 in the lowering, 0.534 over all eight probed moments), 34 px clear of the pill, and the pill's lower edge at v 0.502 lands just above the floor line at v 0.505, so it stays on the light background. The 0.673 figure the previous revision gave is not the subject at all: it came from a render with the DARK_Floor plane in, where that band is filled edge to edge below v 0.505. Knee pill, row 0.64 trailing, u 0.609-0.965: the ink reaches u 0.552, so the pill clears by 22 px, and the free column beside the calves is 170 px at every probed moment. The knee pill and both foot pills sit over the opaque floor plane, which runs from v 0.505 down; CalloutPill carries its own glass backing, so they stay legible on dark ground, but it is the tempo pill alone that was placed for the light field.

The two heel pills share the bottom row at 0.80 either side of the shoes (ink u 0.309-0.539): the 13-character one ends at u 0.288, 8 px to their left, and the 23-character one starts at u 0.565, 10 px to their right, which is how the library's Standing Calf Raise places its two foot pills too (top leading and bottom trailing, both on row 0.80). Rasterised at all eight probed moments against that moment's own render, no pill box overlaps a single pixel of ink. Leaders run bar 75-97 px, tempo 88-110, knees 54-69, top 60-61 (Heels up high to foot_R) and bottom 35-51 (Heels down to the floor to foot_L) - not under 50 px as the draft said. Neither heel leader crosses the bright calf paint: of 3208 sampled points per leader across the eight moments, zero fall on paint for either foot pill, and each ends on its own foot joint; only the knee leader runs over paint, in its last quarter, where it terminates on patella_L.

Glows. Two, not three, and both calves are visible - the previous revision's claim that this yaw hides most of one calf behind the other does not hold. A flat-colour per-object render credits 956 painted pixels to the R calf and 726 to the L at the bottom of the rep (986/723 at the top, 971/732 in the lowering). What differs is shape: at v 0.665 the R calf is one 19 px run (u 0.406-0.453) while the L calf is a 4 px strip at u 0.458-0.466 and an 8 px strip at u 0.531-0.550 either side of its own unpainted shin, so the shin_L/foot_L mean at u 0.4737 that glow() centres on lands between them. The full glow therefore goes on R (0.414, 0.660): centre on paint at t0, t1 and t3, 43-57% red. The soft one on L (0.489, 0.665) covers 29-40% with its centre on no paint at any of them, and a dx 0-0.040 by dy -0.03 to +0.01 sweep finds no offset in the calves() family that centres it at all three, so it is kept at SOFT 0.32 as the far-side half of the house pair. The bright paint spans v 0.618-0.747 with its centroid at v 0.678, against shin-to-ankle midpoints of 0.685 (L) and 0.680 (R), so the -0.02 dy keeps each ellipse over the belly of the paint rather than sliding onto the shoe. The hamstring glow is gone: the dim thigh paint is never wider than 8 px on a row (near thigh u 0.453-0.518, far thigh u 0.390-0.435), and the ellipse the draft put there measures 16/27/22% red with its centre on unpainted thigh, most of that red being the calf paint its lower edge dips into.

OPEN POINTS
OPEN POINTS
Two. (1) There is no block, plate or step in the scene and the toes never leave y 0.015 m, so the heels can only come down to the floor. The copy handles that the way the library's Bodyweight and Dumbbell Standing raises do - the floor is this version's whole range, a block is the progression - so no model change is needed for the text to be true, and this is no longer a copy question. What is left for the owner is only whether this lift is meant to be shot with the forefeet on a plate: StrengthLog's page for the barbell standing calf raise has you stand with the toes and the balls of the feet on a step, and the library's own Smith Machine Calf Raise setup opens with a calf block under the bar. If so, the model needs one. (2) The grip test is not unanimous. palm.py's X axis says overhand - hand_L local X points outward like the pronated Biceps/ReverseCurl reference and opposite the supinated Biceps/CableCurl - but its Y axis matches neither, so there is no clean hand-frame match, and the stills settle less than the draft claimed. They were read on the back-view premise; read as the front three-quarter they are, the near hand shows 662 pixels and the far one only 178, mostly behind the torso and the deltoid, and at that size neither reads a palm direction on its own. So overhand in the setup and the bar cue rests on the X sign, with the near hand in the stills as corroboration rather than proof.

Dropped after re-checking: the lower-leg row question (the three rows and both lower-leg stabilisers already match the Dumbbell Standing raise exactly, so there is nothing to decide), and the Hamstrings 0.15 estimate (true, but it matches the neighbours exactly and offers no alternative to weigh - it stays disclosed in its notes row).

## Dumbbell Lying Leg Curl

| Claim in the copy | Source |
|---|---|
| Prone along a flat bench, hips and thighs on the pad, knees just past its end | Model (`contact.py`, `pad2.py`, re-run 2026-10-29): pelvis joint 14.48 cm, spine 18.1 cm and chest 20.00 cm above the back-pad box; the pad's world AABB is [-0.1353, 0.3567, -0.3898] to [0.1353, 0.4264, 0.3974] and patella_L sits at [0.086, 0.523, -0.4376], i.e. 4.78 cm past the rear end and 9.66 cm above the pad top. The 10.8 cm `contact.py` prints is the 3-D box distance, not a height: sqrt(4.78^2 + 9.66^2) = 10.78. Trunk +84.08 degrees constant (`summ.py` neck-pelvis, re-run) |
| One dumbbell hangs between the feet, its top end on the toes and the handle trapped between them | Model (`allmesh.py`, `contact.py`): Cylinder_102 (shaft) on the mid-line with x 0.00 at every sample, Cylinder_103 the upper head, Cylinder_104 the lower head. The copy no longer says *upright*: the dumbbell is 29.03 degrees off vertical at the bottom of the rep |
| The toes stay within 1.4 cm of the top end | Model (re-run over all 192 frames): toe_L/toe_R to Cylinder_103's box runs 0.44 cm (t 3.29, bottom) to 1.43 cm (t 1.50, top) |
| The ankles stay a steady 14 cm apart, about the width of the dumbbell heads | Model (re-run): foot_L to foot_R 0.1407 m, range 0.00000 over 192 frames, against the head meshes' 0.144 m x-extent. Replaces the draft's *a hand width*, which is nearer 8-10 cm, and the library's own phrase is *a hand's width* (16 uses in SampleData.swift) |
| Neither hand ever comes closer than 1.2 m to the weight | Model (re-run over all 192 frames, not the 9-moment grid): hand_L/hand_R to the three dumbbell meshes, minimum 1.2074 m surface (box) and 1.2958 m centre, both at t 1.50, the top of the rep. `nearfull.py`'s 1.304 m is a 9-moment sample that misses the clip minimum, so the copy says 1.2 m and the header gives both measures (1.20 m surface, 1.29 m centres) |
| toe_L and foot_L are the closest BODY joints to all three dumbbell meshes, at centre distances that do not change | Model (`nearfull.py`, re-run): Cylinder_102 -> toe_L 0.0933 m, Cylinder_103 -> toe_L 0.0939, Cylinder_104 -> foot_L 0.1534, each with range 0.00000 across all 192 frames. Over the full 228-joint set the nearest joints are the rig's own controls (FF_ball_pivot_L/R, FF_ankle_target, CTRL_foot_ik), so the claim is about body joints only. `nearest.py` cannot carry this: it searches six joints at four fractions of the clip and no hand is in its candidate list |
| The ankle travels about 53 degrees as the knee curls, from fully pointed to flat under the shin | Model (re-run): ankleAng_L/R (shin-foot-toe) 165.166 at t 3.92 down to 111.743 at t 1.50, range 53.42, left = right to 0.0000. README 292-294 records that these rigs read a flat foot under a vertical shin as about 112 degrees and that no copy quotes angles from that convention, so the cue gives the swing and the two ends in words; the raw 165.2 / 111.7 stay here and in the header |
| The dumbbell turns upright with the foot, 29 degrees off vertical to 2.5 | Model (re-run): axis tilt 29.03 degrees at the bottom, 2.50 at the top. It is the foot's own angle, not gravity: the foot-to-dumbbell-axis angle is 65.73 degrees at every one of the 192 frames (range 0.0001) and the toe-to-upper-head and ankle-to-lower-head centre distances are constant to 0.0 mm, so the prop is rigid with the foot and the tilt tracks foot pitch exactly. Given in the copy as description only - no demand is hung on it |
| 167 degrees down to 87, an 80-degree arc | Model (re-run): knee_L/knee_R max 166.682 at t 3.88, min 86.584 at t 1.50, range 80.098 |
| The left and right knees are equal in every frame | Model (re-run): both sides give the same min, max and times, and ankleAng_L = ankleAng_R to 0.0000 |
| The load on the knee is heaviest while the shin is level and fades as the shin comes up toward vertical | Model, measured rather than asserted (re-run): the horizontal (gravity) lever from the knee joint shin_L to the dumbbell's combined mesh centre runs 50.1 cm at the bottom down to 13.4 cm at the top (sagittal component alone 49.6 to 11.1 cm). Written in the copy as the lever, not a study |
| The most knee-flexion torque at about 30 degrees of bend in general, and with the hip straight right at the straight end | Kellis & Blazevich 2022, BMC Sports Sci Med Rehabil 14(1):166, PMCID PMC9446565 (re-fetched and re-read 2026-10-29, Discussion): *Irrespective of hip flexion angle, the maximum knee flexion torque is centered around 30 degrees of knee flexion* and *peak knee flexion torque was observed at 0 degrees of knee flexion when the test was performed at 0 degrees hip angle*. The draft's *30 to 40 degrees* is not in the paper |
| A prone curl is not where the hamstrings make their best torque | Same review, Conclusions (re-read 2026-10-29): *from the prone or supine position the hamstrings work at a less optimal range for torque development*; the Implications section adds that tests at ~0 degrees of hip flexion, naming prone leg curls, *correspond to a less optimum range for knee flexion torque production*, and the abstract puts hip angles of 45-90 degrees as promoting more optimal force generation. This replaces the draft's *the bottom half is the half that counts here*, which no source supports |
| The calves pull on the knee hardest with the leg straight and barely at all past 90 degrees | Li, Landin, Grodesky & Myers 2002, J Electromyogr Kinesiol 12(5):385-390, PMID 12223171: flexion moment greatest at 180 degrees at every ankle angle, little knee-flexion moment at 90 and 75 degrees |
| A longer range pays off where there is real load in the stretched position | Pedrosa, Pereira & Kassiano 2026, Sports Med Int Open 10:a27337605, PMCID PMC12951042: a long range is *necessary but not sufficient*, *particularly when there is significant external torque in the lengthened position* |
| The pelvis sits at one height and the hip at one angle from the first frame to the last, barely short of straight at 158 degrees | Model (re-run): pelvisY 0.5712 m with range 0.00000; hip_L/hip_R (chest-thigh-shin, summ.py's definition) 157.558 degrees with min = max = start over all 192 frames. The copy leads with the stillness, which is the load-bearing claim; the 22 degrees short of straight is the rig convention (the chest joint sits 20.0 cm above the pad against the pelvis's 14.5) |
| The hip never moves and the knee and the ankle do all of it | Model (re-run): hip, trunk, elbow, pelvis height and the hand, shoulder and ankle separations all have range 0.00000, and the knee joint itself does not translate (shin_L y 0.5445, range 0.000); the knee and ankle angles are the two series that do move |
| The hips or the lower back starting to move is the sign you have reached the end of your range, and a light brace stops the hips hiking and the back arching | ACE exercise library, Prone (Lying) Hamstring Curl page (practice source, no numbers) |
| Over twelve weeks the MACHINE version of this curl done seated grew the hamstrings about 14% against 9% for the prone one | Maeo et al. 2021, Med Sci Sports Exerc 53(4):825-837, PMID 33009197, PMCID PMC7969179: 20 adults, one leg each on a modified Life Fitness seated leg curl machine (hip ~90 degrees) and a Toredo prone leg curl machine (hip ~30 degrees), 5x10 at 70% 1RM twice a week for 12 weeks; whole hamstrings +14.1% vs +9.3%. Both arms were machines, so the copy says so: nothing in the study involved a dumbbell held by the feet |
| About a second and a half down against about a second up | Model (re-run knee series at 24 fps): bottom hold to t ~0.25, concentric to the top at t 1.38-1.50 (~1.1 s), top hold 1.25-2.00 s, eccentric 2.00 to 3.5-3.9 s (~1.5 s), ~0.7 s at the bottom, on a 4.00 s cycle. Given in the copy as the model timing, not a prescribed tempo |
| Thirteen men six months clear of heavy resistance training did six sets of ten lowering-only reps at 120% of what they could lift, with the weight raised back up for them, and ten of the thirteen ended with severe damage through the whole semitendinosus | Carmona et al. 2018, Front Physiol 9:54, PMCID PMC5807877 (re-fetched and re-read 2026-10-29): *Thirteen healthy male students*, who *had not performed systematic heavy-resistance strength training for at least 6 months*, performed *six sets of 10 unilateral hamstring ELCs* at *120% of their concentric 1-repetition maximum*, with *The weight was raised after each eccentric repetition by two examiners*; 10 high responders with severe T2 rises in proximal, middle and distal semitendinosus. Both the activity levels (two sedentary, eleven moderately to physically active, 2-5 days a week) and the six-month resistance-training statement are in the paper, so the reviewer's *men new to heavy training* was defensible; the copy now states it as the paper does, because it is what makes the Carmona-to-Maeo contrast work. The 120% intensity is named because it is what makes the result inapplicable to a foot-squeezed dumbbell |
| Lifters who had already trained a leg curl twice a week for twelve weeks barely showed it | Maeo 2021 part 2: trained legs showed far smaller semitendinosus T2 rises at 72 h than untrained control legs (a large rise in the controls against a few per cent in both trained legs), with no difference between the seated and prone legs |
| Soreness in the first few sessions is normal, so ease into the slow lowering | Practice conclusion, marked as such: it does NOT follow from Maeo, whose protection came from twelve weeks of twice-weekly training at 70% 1RM, not from a short ramp-in. The draft's *so* made that false inference; the copy breaks the sentence in two and prescribes no tempo or volume |
| The elbows hold 59 degrees and the hands never move | Model (re-run): elbow_L/elbow_R 58.794 degrees and hand_L [0.1696, 0.3964, 0.6400], every series with range 0.00000 |
| The hands sit 2.2 cm from the pad at the head end, 0.34 m apart | Model (re-run): hand_L [0.170, 0.396, 0.640] with hand_R mirrored, 2.2 cm from the seat-pad box ([-0.1476, 0.3567, 0.4548] to [0.1476, 0.4264, 0.7500]), x +/-0.170 against the pad's +/-0.148 half-width and 3.00 cm below pad height; hand gap 0.3392 m constant |
| The head sits just past the end of the bench, level with the chest, neck in line | Model: head 21.4 cm above the nearest seat pad and projecting past the pad's end in all four trainer stills; `joints.json` head v 0.507, neck 0.509, chest 0.510 against pelvis 0.524 |
| Rows: Hamstrings primary 0.90, Gastrocnemius secondary 0.46, Soleus secondary 0.30 | Paint for the ranks (`tiers_legcurl.json`: BicepsFemoris, Semimembranosus, Semitendinosus bright; GastrocnemiusLateral, GastrocnemiusMedial, Soleus dim; nothing faint) under the README rule *bright group = primary row, dim = secondary* (README 716). The first two fractions are carried unchanged from the library's Lying Leg Curl (SampleData.swift lines 9992, 9994), the machine version of the same prone curl, which places them below the Seated Leg Curl (0.92) and above the Cable Standing Leg Curl (0.86). No study has ever measured a dumbbell prone curl, so none is an independent estimate |
| 0.46 ties the top of the leg-curl rows, under the Glute-Ham Raise's 0.50 | SampleData.swift, every Gastrocnemius secondary row: lyingLegCurl 0.46 (line 9992), singleLegCurl 0.46 (10177), gluteHamRaise 0.50 (35867), seatedLegCurl / standingLegCurl / kneelingLegCurl / nordicHamstringCurl 0.40, slidingLegCurl / singleLegSlidingCurl 0.36, cableStandingLegCurl 0.34, assistedNordicCurl 0.32, swissBallLegCurl 0.30. So 0.46 is tied, not top, and it is not the family's highest calf value |
| The soleus takes a LOW secondary row rather than a stabiliser slot | README 716 (*bright group = primary row, dim = secondary*) and the round-2 precedent the draft cited backwards: the bright tibialis posterior and fibularis KEPT rows (*they stay LOW secondary rows, the one break of bright = primary*, README 287-289). Re-counted in SampleData.swift 2026-10-29: that round-2 family carries them at tibialisRaise 0.20, singleLegTibialisRaise 0.30, wallTibialisRaise 0.20, machineTibialisRaise 0.15 and bandedDorsiflexion 0.15, i.e. 0.15 to 0.30; the 0.25-0.30 values sit on five calf raises instead (standingCalfRaise, seatedCalfRaise, legPressCalfRaise, singleLegCalfRaise, smithMachineCalfRaise). The only muscle ever moved to the stabilisers was an unlit one, and `soleus` appears as a stabiliser string 0 times in SampleData.swift. 0.30 is an estimate at the TOP of that precedent range, pitched under the gastrocnemius 0.46 because the gastrocnemius does both jobs |
| The soleus is the muscle holding the ankle that carries the dumbbell | Mechanical plus the rig, against the review's suggestion of the tibialis anterior: with the lifter prone and the shin level, the front of the shin faces the floor, so a weight hanging from the toes pulls the forefoot toward it - a dorsiflexing moment, resisted by the plantar flexors. Measured over all 192 frames (2026-10-29), the weight hangs essentially the same distance from the ankle all the way through: horizontal lever foot_L to the dumbbell's combined mesh centre 12.49 cm at the bottom (its minimum, t 3.92) and 13.10 cm at the top, peaking at 13.14 cm (t 2.33), with the sagittal component 10.32 to 11.09 cm. The moment sign does not flip (z of the bell centre minus foot_L stays negative, -0.1032 to -0.1109), so the plantar flexors resist throughout, while the knee's own lever collapses from 50.1 cm to 13.4 cm. This corrects the earlier claim that the ankle's lever was longest at the bottom: it is marginally SHORTEST there. Separately true, and kept: the ankle sits fully pointed (165.2 degrees) at the bottom and only reaches 111.7 at the top (README notes these rigs read a flat foot under a vertical shin as about 112 degrees) |
| Stabilisers: gluteus maximus, core | The Lying Leg Curl's own list, carried unchanged (SampleData.swift line 9994), backed by ACE (the thigh stays down, a light abdominal brace) |
| The knees carry the whole 80-degree arc (comparison) | The knee range and hip rows above. The draft's *the knee is the only joint moving* is cut here, in the hips cue and in the header |
| Header: the dumbbell travels 54.1 cm, 0.38 m up and 0.39 m toward the head end | Model (re-run, mesh AABB centre on every one of the 192 frames): shaft 54.1 cm, upper head 58.0 cm, lower head 50.4 cm; shaft centre [0.00, 0.572, -0.948] at the bottom and [0.00, 0.952, -0.563] at the top, i.e. 0.380 m up and 0.385 m toward the head end. props.py's 7.4 / 7.0 / 6.7 cm is a sampling artefact (it compares t0 with 40% of the clip, where the bell is nearly back at the bottom) and is not used |
| Header: the dumbbell's lower end sits at y 0.425 at the bottom, level with the bench's pad top at 0.426 | Model (re-run): dumbbell mesh y-extent over the clip, minimum 0.4251 at the bottom; back-pad box top 0.4264. This is what setup step 1 is built on - see the setup rows below |
| Header: the ankle joints 5.7 to 6.0 cm off the lower head throughout | Model (re-run over all 192 frames): foot_L/foot_R to Cylinder_104's box runs 5.66 cm (t 2.58) to 6.05 cm (t 3.92). The draft's flat *6.0 cm throughout* overstated the constancy by 3-4 mm; reviewer 2 independently reported 5.7-6.0. The nearby *those centre distances do not change by a millimetre* is about the mesh-centre distances, which really are constant to 0.00000 |
| Header: two reps on a 4.00 s cycle, 7.96 s at 24 fps, 192 frames | Model (re-run): start 1.0, end 192.0, 24 fps, 7.958 s, 192 frames. 191 is the number of one-frame steps, not of frames. summ.py's rep counter is unusable here: it counts elbow mid-range crossings and the elbow never moves, so its 72 crossings are floating-point noise |
| Header: a flat bench, 19 static GYM_Bench_* meshes, motionless | Model (re-run): 19 GYM_ meshes, largest centre travel 0.000 cm over the clip; back pad [-0.1353, 0.3567, -0.3898] to [0.1353, 0.4264, 0.3974], seat pad [-0.1476, 0.3567, 0.4548] to [0.1476, 0.4264, 0.7500]. props.py missed all of them because it filters out names containing _Mesh |
| Header: the knees stay 0.150 m apart | Model (re-run): shin_L to shin_R 0.1499 m, range 0.00000 |
| Setup: the dumbbell is stood on a box or second bench at pad height, not on the floor | Model (re-run): the dumbbell is about 25.5 cm long along its axis (AABB y-extent 26.1 cm at the top, where it is 2.5 degrees off vertical), so stood on the floor its top end reaches about 0.26 m, while the toes never drop below y 0.600 and the knee joint is fixed at y 0.5445 - the feet cannot reach it, a shortfall of about 34 cm. Bending the knees moves the feet further away, not toward it: toe y runs 0.600 to 0.998 and heel y 0.612 to 0.943 as the knee closes. The weight's resting place in the model is y 0.4251, level with the bench's own pad top at 0.4264 |
| Setup: the pick-up happens with the legs straight, not with the knees bent | Model (re-run): the straight-leg end of the model's own rep IS where the weight rests - at the bottom the knee is 166.7 degrees, the dumbbell's lower end is at y 0.4251 against the pad top 0.4264, and the toes sit at y 0.600 with the heels at 0.612, right at the top of a pad-height dumbbell's shaft. At the knees-bent end the toes are at y 0.998 and the heels at 0.943, 33 to 37 cm above that resting weight, so a knees-bent pick-up would need a stand about 1.0 m high. This is why step 4 now reads *With your legs straight out behind you*: the draft's *With your knees bent* contradicted step 1's pad-height stand and this very row |
| Label plan: the tightest leader crossing passes about 6 px from the subject, 25 px along its own row | Measured 2026-10-29 two ways. Geometric: projecting all 432 dumbbell mesh vertices on every one of the 192 frames puts the lowering x hips crossing no closer than 23.9 px to the BELL. Rendered: on the round's own clean stills (`bmp/t0..t3.bmp`, silhouette by background-colour match) the crossing at the t 2 s still sits at u 0.608 / v 0.409 and the nearest subject pixel is at u 0.6204 / v 0.4153, 6.3 px away in two dimensions and 24.7 px along the crossing's own row. That pixel is on the raised lower leg, not the dumbbell (18-20 px from the bell's projected outline), and the skeptic's own t 1.42 render gives 4.9 px. So the earlier flat *25 px* was the row figure quoted without its qualifier |
| Label plan: glow 1 ships at (0.607, 0.517) | `glow()` re-run on the sandbox build: mean of thigh_L and shin_L over the eight probed moments is (0.5715, 0.5270), so dx=0.035, dy=-0.01 rounds to (0.607, 0.517), not the (0.606, 0.517) earlier drafts quoted. The alternative that lands on the measured bright centroid (0.630, 0.507) is dx=0.058, dy=-0.020; dx=0.055, dy=0.00 lands at (0.627, 0.527), 0.020 below it. Glow 2 reproduces (0.703, 0.498) |

LABEL PLAN
LABEL PLAN

Rows. The five overrides are written in slot space (0.14, 0.32, 0.86), which
spec_1029.row() remaps before gen.py sees them: 0.14 ships at v 0.160, 0.32
at v 0.320 and 0.86 at v 0.800 (reproduced on the sandbox build). Every
clearance below is argued against the shipped rows, not the slots.
CalloutPill is 12 pt text with 7 pt of vertical padding, so a pill is about
28.3 pt tall on a 655 pt frame: half-height 0.0217 in v.

The frame. The lifter and the bench fill one band at v 0.48-0.67 across the
whole width at every moment, and the subject's topmost pixel over the clip is
v 0.3985 (row 261 of 655, measured on the t 2 s still); projecting the
dumbbell's own mesh vertices on every frame puts its highest corner at
v 0.3997 at t 1.38 s, so the bell is what sets that edge. Both top rows are
therefore clear: the pill band at v 0.138-0.182 and the one at v 0.298-0.342
never touch the subject. The top row also clears the muscles/eye button
stack, which ends at v (12 + 32 + 8 + 32) / 655 = 0.128: the shipped row
centre at v 0.160 sits 21 pt below it and the pill's own top edge at v 0.138
leaves about 7 pt of air. Read against the unmapped 0.14 that top edge would
land at v 0.118, apparently inside the stack - which is why the clearance has
to be argued against the shipped row and not the slot.

Row 0.14 -> v 0.160. The dumbbell pill leads (u 0.035-0.464) and the chest
pill trails (u 0.594-0.965), 0.130 apart.

Row 0.32 -> v 0.320. The lowering pill leads (u 0.035-0.391) and the hips
pill trails. The hips label is capped at 13 characters, which is the one
change from the draft. The dumbbell pill's leader runs from its inner edge
(0.464, 0.160) to the live toe joint, and because the toes sweep right and
down it crosses row 0.32 well out into the frame: projecting toe_L on every
one of the 192 frames, the leader enters the band at u 0.599 at worst and
leaves it at u 0.690 at worst, at t 2.83 s. The draft's 22-character pill
starts at u 0.580, so the leader cut 42 px into its left end at every probed
moment - the defect the round's own standard forbids. width(text) =
(24 + 5.6 * len) / 382 gives the left edge of a trailing pill as
1 - 0.035 - w, so 14 characters start at u 0.697 (2.8 px of air, inside the
pill's 13 pt corner radius) and 13 start at 0.712 (8.4 px). Hence
"Hips stay put" (13). Re-tested on the sandbox build: with these five labels
no leader intersects any pill rectangle on any of the 192 frames. Swapping
the two sides of this row does not help: the dumbbell leader then cuts the
lowering pill instead. Moving the hips cue down to row 0.86 beside the curl
cue also works on paper, but its leader would then rise to the pelvis across
the bench frame from below.

Row 0.86 -> v 0.800. The knee cannot be labelled from the top: a leader
dropping to it crosses the raised shin and the dumbbell at the top of the
rep. So the curl pill trails at v 0.778-0.822, i.e. rows 509-538, which carry
zero subject pixels at all four stills - below row 480 (v 0.733) the frame is
completely empty in every still. Its leader runs up to patella_L clear of the
bench silhouette, whose right edge below the lifter stops at u 0.626 (rows
420-439) and u 0.175 (rows 440-459). The pill also clears the 100 pt
FaultRing the mistake view centres on patella_L (Exercise3DView.swift line
428; radius 50 pt around v 0.5357 = v 0.459-0.612) and sits well above the
bottom-left legend.

Sides. The two feet cues have to lead from the left edge, because the toe
(u 0.717-0.876) and the foot (0.661-0.817) sit right of any inner end a label
this long can reach from the right; the chest (0.364) and the pelvis (0.474)
have to trail from the right for the mirror-image reason.

Crossings. That forces four leader-leader crossings, one more than the draft
had, because the shortened hips pill moves its leader right: computed on
every frame, they sit at u 0.542-0.549 / v 0.229-0.240 (dumbbell x chest),
0.662-0.688 / 0.340-0.363 (dumbbell x hips), 0.467-0.470 / 0.349-0.354
(chest x lowering) and 0.601-0.616 / 0.402-0.415 (lowering x hips). None is
over the subject at any of the four stills. The tightest is lowering x hips
at the top of the rep: at the t 2 s still it sits at u 0.608 / v 0.409 and
the nearest subject pixel is on the raised lower leg at u 0.620 / v 0.415,
about 6 px away in two dimensions and 25 px along the crossing's own row (the
skeptic's own t 1.42 render gives 4.9 px). The dumbbell itself stays 24 px
off. So this crossing is over backdrop but tight: the earlier flat 25 px was
the row figure with its qualifier dropped.

Leaders over the body. Tested per moment, each leader against its own still's
silhouette with the matching joint sample: every leader first touches the
subject only on its final approach to its own joint - at 92% of the way for
the dumbbell leader, 94% for the chest, 84-91% for the lowering, 84% for the
hips and 98% for the curl. None crosses the lifter on the way. Re-rendered
with the corrected label at all four stills (fix_t0..fix_t3 in the round
folder), with the draft's pill drawn alongside for comparison.

OPEN POINTS
OPEN POINTS
1. The Soleus row is the library's first secondary one. All 24 Soleus rows in
SampleData.swift today are primary, on calf raises (0.48 to 0.86); this would
be the first secondary one, and its 0.30 is an estimate, not a measurement -
pitched under the gastrocnemius 0.46 because the gastrocnemius flexes the
knee as well as the ankle, and anchored to round 2's tibialis posterior and
fibularis rows, which run 0.15 to 0.30 (tibialisRaise 0.20,
singleLegTibialisRaise 0.30, wallTibialisRaise 0.20, machineTibialisRaise
0.15, bandedDorsiflexion 0.15; the same two muscles ride along on five calf
raises at 0.25-0.30). So 0.30 is the TOP of that precedent range, not inside
it - which is the part the owner is being asked to weigh. The house rule
(dim = secondary) and the mechanics are settled; the number is a judgement.

2. The two carried fractions. Hamstrings 0.90 and Gastrocnemius 0.46 are the
library's Lying Leg Curl values; no study has ever measured a dumbbell prone
curl. If the owner wants the dumbbell version to read as harder or easier
than the machine (the feet also hold the weight all set, which the machine's
roller does not ask for), that is a judgement call I did not make on my own.

3. The mistake badge HIPS LIFTING repeats the library's Lying Leg Curl badge.
It is the fault ACE names for the prone curl and it matches the hips cue, but
if the owner wants every badge distinct in the family, LOSING THE DUMBBELL
(the feet softening at the top) is the other fault this lift has that the
machine does not.

4. No fault ghost. As with the arms and glutes families this round, nothing
was written for FaultPoses, so the mistake view falls back to the red ring.
The hips cue is the one position fault here that would carry a ghost well.

5. Glow 1 placement, for the owner to pick. The shorts cover the upper thigh,
so the hamstring paint only shows from u 0.555 in the stills and its
bright-pixel centroid across the four of them is (0.630, 0.507). The entry as
written (dx=0.035, dy=-0.01) ships at (0.607, 0.517), about 0.023 left and
0.010 low of that, with the left 0.03 of its span over shorts. The option
that lands exactly on the measured centroid is dx=0.058, dy=-0.020; the
dx=0.055, dy=0.00 pairing quoted in earlier drafts in fact lands at
(0.627, 0.527), 0.020 BELOW the centroid, so it is not the centred option it
was described as. Both of the real options are defensible, the overlays are
rendered side by side in the round folder, and this is a taste call, so the
entry is left as drafted rather than changed unasked.

6. Four leader crossings, up from three. Forced by the framing (lifter
head-left, feet-right, pills pinned to the edges) and by the shortened hips
pill, which moves its leader right. None sits over the subject at any still,
but the tightest - lowering x hips at the top of the rep - passes only about
5 px from the raised lower leg in two dimensions (6.3 px measured at the t 2 s
still, 4.9 px at t 1.42; 25 px if measured along the crossing's own row). If
the owner wants real air there, the only way to remove it is to drop one of
the two feet cues; I kept both because holding the dumbbell and controlling
the lowering are the two things this version adds to the machine lift.

## Checks run

- `python3 spec_1029.py legs` prints OK (validate + validate_library), and
  `preview_1029.py legs` prints the layout.
- `python3 integrate_1029.py <scratch>` wrote the setup steps, the
  content-map entries and the content block; FaultPoses untouched.
- `Tools/lab/build.sh --no-install` with `LAB` in the session scratchpad:
  BUILD SUCCEEDED.
- `Tools/lab/shoot_ex.sh` on the harness simulator at 0, 1.75 and 3 s: both
  screens show their five pills, the legend and the setup drawer, and no
  pill sits on the lifter or on a moving part.
