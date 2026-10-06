# 401-500 folder, round 2: cable, machine and ab coaster crunches (2026-10-04)

Four loaded crunches from the builder's 432-435 exports: 432 Standing Cable Crunch, 433 Oblique Cable
Crunch, 434 Machine Crunch and 435 Ab Coaster Crunch (models `Abs/<Resource>.usdc`).
`spec_500_cablecrunch.py` holds the copy and setup steps (its header lists what each model shows and
the full citations), `Tools/fault-review/faults_500_cablecrunch.swift.txt` the ghosts and
`Tools/fault-review/fault_moments_500_cablecrunch.json` the moment each ghost is stilled. This file
maps the copy's claims to their sources and records the model facts the copy relies on.

## How the models were read

- The arm and leg briefs (`SCRATCH/briefs2/<Resource>.md`, `SCRATCH/briefs2_legs/<Resource>.md`),
  `tiers2.txt`, `joints.json` and the trainer stills at 0/1/2/3/5 s (`SCRATCH/stills`). The briefs'
  trunk lean is the neck-over-pelvis line, which mixes a pelvic tilt with a spinal curl, so the rigs
  were read directly with Blender's Python + pxr (scripts in `SCRATCH/cablecrunch/`):
  - `bones.py`: each bone's orientation change from the start of the clip as an axis-angle, split
    into flexion (about the lifter's left), turn (about up) and side bend (about forward); the
    lumbar bend is the spine bone against the pelvis, the thoracic bend the chest bone against the
    spine bone.
  - `body.py`, `rel.py`: joint positions, knee and elbow angles, hands against the head.
  - `eq.py`: world bounds of every `HG_*` / `GYM_*` prim at two moments, which ones move.
  - `skin.py`: skinned muscle, shoe and hand meshes, for contacts (chest on the pads, back against
    the back pad, roller on the shoes, hands on the handles).
  - `orange.py`: centroid and spread of the lit (painted) pixels in the five stills, where the
    glows sit; `occ.py` / `occ2.py`: which screen bands the lifter and the equipment cover, for the
    labels.
- Ghosts: `SCRATCH/cablecrunch/ghost.py` (the round-1 Python port of `FaultGhost.solve`, with
  these four framings) and `proto.py` (the pieces as Python, sized on the rigs at each fault's
  moment, bone lengths and elbow / knee angles printed), `draw.py` for quick drawings.
- Labels: `preview_500.py cablecrunch` plus `SCRATCH/cablecrunch/overlay.py` (pills ~24 + 6.4 pt
  per character, 28 pt tall, leaders drawn over the five stills), then the lab shots.
- Sources: Europe PMC REST records (abstracts) and full texts where noted; ExRx through the Wayback
  Machine (`SCRATCH/cablecrunch/exrx/*.txt`); the Stenger thesis PDF from MINDS@UW via the Wayback
  Machine, its figures rendered with PDFKit (`stenger_f*.png`).

## Shared facts about the models

- One body (torso, neck to pelvis, 0.592 m). Every clip is 7.96 s with two reps: the curl ~1.3-1.5 s
  (deepest at ~1.5 s), held ~0.5 s to ~2.0 s, the return ~1.5 s to ~3.5 s, ~0.5 s rest, then again
  (the oblique crunch's second rep turns the other way). The copy's "hold for a moment", "about a
  second and a half" and "about as long" describe that.
- Curl (fault_times `curlup`): trunk-to-thigh angle smallest at 1.50 s on the cable and machine
  crunches, 1.67 s on the ab coaster; largest at 0 / 4.0 s. The fault stills ("top" = most curled)
  are at those moments.
- Highlight tiers (`tiers2.txt`): RectusAbdominis bright on all four. Dim: DeltoidPosterior,
  ExternalOblique, InternalOblique on the standing cable crunch; DeltoidPosterior on the oblique
  one, whose ExternalOblique and InternalOblique are bright; ExternalOblique and InternalOblique on
  the machine crunch; on the ab coaster DeltoidPosterior, both obliques, Sartorius (the rig's hip
  flexor paint, written "Hip Flexors", legend-only) and the three triceps heads. Bright rows are
  PRIMARY and dim rows SECONDARY (house rule). All names pass `part_of()`.
- Legend width: one line per rank, ~43 characters of names. The ab coaster's four dim muscles would
  read OBLIQUES · HIP FLEXORS · TRICEPS BRACHII · POSTERIOR DELTOID (58), so the posterior deltoid
  is named with the stabilisers (as the calfstand family did with the rhomboids); the three rows
  kept are 40 characters.
- No EMG study of a standing, facing-away or twisting cable crunch was found (Europe PMC searches
  for cable crunch, standing crunch, twisting curl-up and abdominal machines; web searches). The two
  cable rows anchor on the library's Cable Crunch (rectus abdominis 0.86, obliques 0.52), whose
  content gives no source. The machine and ab coaster rows lean on Sundstrup 2012 and Stenger 2013,
  but their numbers are normalised EMG (or bar heights relative to a crunch), not the app's
  fraction, so every value here is a judgement call; each is said so in the spec's code comment.
- Rejected source: a web page summarising an "ACE study of 50 trained athletes" on cable crunches
  (publishnews.com.br) could not be traced to any journal record and was not used.

## Sibling and library check

- Library: Cable Crunch (kneeling facing the stack, rope beside the head; cues rope, curl, hips,
  knees, feet), Crunch, Decline Crunch, Reverse Crunch, Hanging Knee Raise. The standing crunch
  borrows the Cable Crunch's rope / curl / hips themes (the same faults: arms pulling, flat-back
  hinge, sitting back) but is written fresh for standing facing away; its comparison is BOWING FROM
  THE HIPS (the library's is HINGING AT THE HIPS) with different notes.
- No sentence of cue, setup or comparison copy repeats word for word between the four, or with any
  string in SampleData.swift (checked by script).
- Round-2 siblings, read 2026-10-05 as drafts while they were being written: the crunch family's
  twisting crunches put the obliques first and the rectus abdominis close behind (Bicycle Crunch
  0.84 / 0.82, Cross-Body Crunch 0.80 / 0.78), in line with the Oblique Cable Crunch's 0.80 / 0.72;
  its Stability Ball Crunch (rectus abdominis 0.84, obliques 0.50) and the stability family's hollow
  holds (0.82 / 0.52) sit with the straight crunches here (0.80-0.86, obliques 0.52-0.64). Their
  final values may differ.

## Standing Cable Crunch

Model facts: back to a dual-pulley cable station (`GYM_M29`); its right-hand carriage sits at the
centre behind the lifter, set high (pulley ~1.85-1.99 m), ~55 cm behind the heels. A rope
(`HG_RopeStrand*`, knobs, grips, clip) runs from the clip behind the head over it; the hands hold
the ends beside the forehead (wrists level with the head joint, palms ~1.65-1.69 m, ~13 cm in front
of the head joint, 16 cm either side, palms facing in), elbow angle 47° (sharply bent) throughout, held in front
at shoulder height (elbow 2 cm below the shoulder, 29 cm ahead). Feet: ankles 26 cm apart, toes out
~9°; knees 169° upright. The curl: neck-over-pelvis line 0° -> 35°; chest bone 47° (pelvis 9°
forward tilt, lumbar 19°, thoracic 19°), the neck and head move with the chest (no neck bend); the
hands stay at the same place against the chest (rel.py), the elbows drop ~32 cm (1.41 -> 1.09 m);
the pelvis goes ~3.5 cm back and ~1 cm down, the knees 169° -> 160°. The stack rises ~21 cm.

| Claim | Source |
|---|---|
| Rope ends stay beside the forehead; with the hands fixed the trunk has to move the weight; ExRx counts the lats, rear shoulders and triceps long head among the stabilisers of cable crunches held at the head, holding the arms still; pulling with them moves the stack with the arms | The model (hands fixed to the chest frame, elbow 47°); ExRx Cable Standing Overhead Crunch and Cable Kneeling Crunch (stabilizers: latissimus dorsi, teres major, deltoid posterior, triceps long head, and others; wrists against the head); Ingleby 2025 (Mirafit: contract with the core rather than pulling with the arms) |
| The rectus abdominis runs from the pubic bone up to the rib cartilages and the bottom of the breastbone and works by curling the spine; ExRx: the movement happens at the waist, not the hips; a flat-back bow lowers the rope with body weight | ExRx Rectus Abdominis (origin pubic crest; insertion 5th-7th rib cartilages and xiphoid; movement: lumbar flexion); ExRx Cable Standing Overhead Crunch ("Note movement occurs in waist, not hips"); the last clause is mechanics |
| ExRx describes the curl as the elbows travelling toward the middle of the thighs; in a lab study of trunk-curl sit-ups the abdominals were more active the further the trunk curled | ExRx Cable Standing Overhead / Kneeling Crunch ("flex waist so elbows travel toward middle of thighs"); Andersson 1997 abstract ("In trunk flexion sit-ups an increased activation of the abdominal muscles was observed with increased flexion angle"). The copy's "so a short nod leaves out the deeper part of the curl, where that study found them most active" attributes the reading to that study (verification: it no longer says where the abdominals work hardest in a cable crunch) |
| Elbows dropped well below the shoulders; back fully rounded; hold a moment | The model (elbows 22 cm below the shoulders at the bottom, held ~0.5 s) |
| Pushing the hips back and bending the knees lets body weight drop the rope; ExRx keeps the knees and hips still and moves only at the waist | ExRx Cable Standing Overhead Crunch ("With knees and hips stationary, flex waist"); mechanics; the model's hips move ~3.5 cm |
| Facing away, the cable pulls you up and back; hip-width base, soft knees; ExRx sets up its standing cable crunches with the knees slightly bent | The model (pulley behind and above the head); ExRx Cable Standing Crunch ("Position back against back pad with knees slightly bent") and Standing Overhead Crunch ("Squat down slightly"); Ingleby 2025 (facing away from the machine, rope over the shoulders, crunching from a stable stance) |
| Setup: high pulley above head height, a step in front of the machine; rope over the head; feet hip-width, toes out a little; elbows to shoulder height | The model (pulley ~1.9 m, heels ~55 cm in front of the carriage, ankles 26 cm apart, toes out 9°, elbows at shoulder height) |

Activation: Rectus Abdominis 0.86 PRIMARY, Obliques 0.52 SECONDARY (the library's Cable Crunch;
ExRx: target rectus abdominis, synergist obliques; Moraes 2009: heavier crunch loads recruited the
abdominals more, which is why a loaded cable crunch sits at the top of the library's crunch values),
Posterior Deltoid 0.20 LOW SECONDARY (painted dim; it only holds the arms against the cable, an ExRx
stabiliser; paint-led judgement). Stabilisers: latissimus dorsi, teres major, triceps long head
(ExRx), hip flexors (ExRx lists iliopsoas, rectus femoris, sartorius, tensor fasciae latae among the
overhead crunch's stabilisers).

## Oblique Cable Crunch

Model facts: the same station, rope, stance, hand position and timing as the standing crunch. Each
rep curls and turns: the first (0-4 s) to the right, the second (4-8 s) to the left. At the bottom
of the first the chest bone has flexed ~46° and turned ~32° to the right with ~4° of side bend
(axis-angle components +45.6 / -32.2 / +3.6); the head is 13 cm right of centre; the left elbow
travels from (0.22, 1.41, 0.36) down and across to (-0.02, 1.07, 0.55), just past the midline toward
the right hip, the right elbow out to x -0.40. The pelvis tilts 9° forward exactly as in the standing
crunch but does not turn or bend sideways, so the hips stay square; knees 169° -> 160°. A straight
crunch (the twist ghost) lands within ~3 cm of the standing crunch's bottom pose.

| Claim | Source |
|---|---|
| Each rep curls and turns one shoulder across toward the opposite hip; first the left elbow toward the right hip, then the right toward the left | The model (above) |
| Turning right uses the left external and right internal oblique, turning left the reverse | ExRx Obliques (movement: rotation right [left external, right internal], rotation left [right external, left internal]; flexion both sides; lateral flexion same side) |
| With fine-wire electrodes in twisting curl-ups, the internal oblique worked harder turning toward its own side, the external turning away, the rectus abdominis the same either way | Crommert 2021 abstract (right-side electrodes: OI and TrA higher in right twist, OE the opposite, RA no change between directions). The copy generalises the one side measured to "the internal oblique" |
| ExRx's twisting cable crunch flexes and twists the spine in one movement; the obliques help curl as well as turn; turning upright leaves out the shared curl | ExRx Cable Standing Twisting Crunch (2018 snapshot: "Flex and twist spine ... twisting one shoulder to forward center"; target obliques, synergist rectus abdominis); ExRx Obliques (flexion) and Rectus Abdominis (flexion) |
| The obliques run from the lower ribs to the pelvis and the sheath around the rectus abdominis, so they turn the ribcage against the pelvis; hips swinging round move the turn to the hips and feet | ExRx Obliques attachments (ribs 5-12, thoracolumbar fascia, iliac crest, inguinal ligament, pubic crest, rectus abdominis fascia, linea alba); the consequence is mechanics; the model's pelvis does not turn |
| Fixed hands; hauling the rope down moves the stack with the shoulders and arms and shrinks the curl and turn | As the standing crunch; mechanics |
| Alternate every rep; each turn pairs one side's external with the other's internal oblique; ExRx's standing twisting crunch alternates | The model (right, then left); ExRx Obliques; ExRx Cable Standing Twisting Crunch ("Repeat alternating twists with opposite sides") |

Activation: Obliques 0.80 and Rectus Abdominis 0.72, both PRIMARY (both painted bright; ExRx makes
the obliques the target and the rectus abdominis the synergist of the twisting crunch, so the
obliques lead; Crommert 2021: rectus abdominis activity did not change with the twist direction, so
it stays high; no EMG of this lift, both judgement calls), Posterior Deltoid 0.20 LOW SECONDARY (as
the standing crunch). Stabilisers: latissimus dorsi, triceps long head (ExRx), transverse abdominis
(Crommert 2021: it worked with the internal oblique in the twist), hip flexors. The library row's
OBLIQUES fits.

## Machine Crunch

Model facts: a seated crunch machine (`GYM_M26`): seat pad top 38 cm up, a back pad behind
(front face 17 cm behind the pelvis joint; the back's muscles start ~5-7 cm in front of it, so the
setup says "close to the back pad", not against it), two chest pads on a lever arm that rotates on
hubs (`HG_PivotHub`, `HG_PivotHub_001`) at the sides of the seat back, 70-76 cm up, between the
lumbar and thoracic joints (about level with the lower ribs). The pectoral meshes overlap the pads'
backs at both ends of the rep, so the chest stays on the pads. Hands on two handles (`Handle_L/R`,
1.21-1.27 m, running front to back) at about head height (wrists 1.15 m, 12 cm above the shoulders
and ~5 cm below the head joint), palms facing in (wrists 29 cm from the midline, ~9 cm outside the shoulder joints, 26 cm ahead of the shoulders), elbow angle 67°, held. Knees 98°, thighs about level, feet flat on the floor (shoe
soles at 1 mm) and tucked under the front foot roller (`FootRoller`, its underside 2 mm above the
shoe tops). The curl: chest bone 34° (lumbar 10°, thoracic 24°), neck-over-pelvis 0° -> 21°; the
pelvis and thighs do not move at all. The stack rises ~35 cm.

| Claim | Source |
|---|---|
| Hands on the handles at about head height (setup: in front of the shoulders); the chest on the pads moves the lever; ExRx's chest-pad version only has the hands placed on the lever and lists the abdominals alone as working muscles | The model; ExRx Lever Seated Crunch, chest pad ("Place hands on outside of lever pad"; target rectus abdominis, synergist obliques, "No significant stabilizers"). Verification: the copy used to cite the lats, rear shoulders and triceps long head as stabilisers, which is ExRx's arm-pad Lever Seated Crunch (handles above, back of arm against pads), not the chest-pad machine the model shows; those three stay in the stabilisers list as a judgement for the arms holding the handles |
| ExRx: flex the waist into a C shape with the hips stationary; the lever pivots about level with the lower ribs, so it follows a curl of the upper and middle back; a flat-back tip leaves the spine nearly still | ExRx Lever Seated Crunch (chest pad: "With hips stationary, flex waist in C shape so shoulders travel forward and downward"); the model (hubs at 0.70-0.76 m between the spine and chest joints; the curl is all spinal); the last clause is mechanics |
| The seat holds the hips still and ExRx keeps them stationary; lifting or sliding them lets the legs and hip flexors help drive the pads, leaving less for the abdominals (softened in verification from "in place of your abdominals") | ExRx Lever Seated Crunch, chest pad ("With hips stationary"); the model (pelvis still); mechanics |
| 42-person study, seated crunch machine with the feet behind ankle rollers: rectus femoris 65% of its maximum against 27% in a ball crunch; the authors pointed to the bent hips and the fixed feet; in a sit-up study bent and supported legs raised hip flexor activity without generally changing the abdominals' | Sundstrup 2012 full text (Table 2: RF 65 vs 27% nEMG; Discussion: the near-90° hip and knee flexion and "the hold and fixation of the feet by the ankle bar can contribute to additional rectus femoris activity"); Andersson 1997 abstract ("flexed and supported legs increased hip flexor activation, whereas such modifications did not generally alter the activation level of the abdominals") |
| Feet tucked under the roller, heels on the floor | The model (soles on the floor, roller on the shoe tops) |
| In a curl-up study abdominal activity did not differ between curling up and lowering, so the return is half of every rep | Ha & Shin 2020 abstract ("There was no significant difference between eccentric and concentric contractions") |
| Curl over about a second and a half, pause, about as long back | The model (~1.5 s, ~0.5 s, ~1.5 s) |
| Setup: chest pads across the upper chest; ExRx sets the seat so the chest meets the pad | The model (pads 0.85-1.07 m on the upper chest); ExRx chest-pad version ("Position seat so chest is same height of padded lever") |

Activation: Rectus Abdominis 0.84 PRIMARY (Sundstrup 2012: 84% nEMG on the machine at 10RM),
Obliques 0.62 MODERATE SECONDARY (Sundstrup: external obliques 79 / 71% nEMG, below the rectus
abdominis; dim in the paint, so secondary and kept in the moderate band, the library's crunch rows
sitting at 0.45-0.52; a judgement call). The rectus femoris (65% there) is not painted, so the hip
flexors lead the stabilisers, with latissimus dorsi, triceps long head and posterior deltoid
(ExRx's arm-pad Lever Seated Crunch; its chest-pad version, the model's machine, lists no
stabilisers, so these three are a judgement for the arms holding the handles). The library row's
MACHINE / beginner fits.

## Ab Coaster Crunch

Model facts: an ab coaster: a carriage (`HG_Carriage`, 49 x 44 cm) on two curved rails
(`HG_CurvedRail*`, lowest near the middle, rising ~19 cm to the front), a handlebar
(`HG_Handlebar`, 1.04 m up, ~95 cm ahead of the hips at the start) on two uprights. The lifter kneels with the shins on
the carriage pad and the feet hanging off its back end (ankles ~7 cm behind it, toes pointed back),
hands palms down on the bar's grips, 48 cm apart (shoulders 39 cm), elbows 143° -> 136°, the trunk
tipped ~53° forward. Over ~1.5 s the carriage rolls ~41 cm forward and ~5 cm up the curve; the
knees travel ~35 cm forward and ~7 cm up, the pelvis ~15 cm forward and ~7 cm down. The pelvis
rolls under (the bone tilts ~40° back), the spine bone ~22° and the chest only ~4.5°, so the lower
back rounds ~36° between pelvis and chest while the shoulders move ~2 cm. The thighs swing ~31° up
in the room but the pelvis rolls ~40°, so the angle between them opens ~9°: the knees climb by the
pelvic curl, not by folding at the hips. Knees 70° -> 62°. At the start the thighs are ~20° off
upright and the hips ~15 cm behind the knees, at the top the thighs ~52° off upright and the hips
~35 cm behind the knees (above the ankles); the lower back is long at the start, slightly rounded,
not arched.

| Claim | Source |
|---|---|
| The knees come up because the pelvis rolls under and the lower back rounds | The model (above) |
| Knees forward with a flat lower back is hip flexion, the hip flexors' job; the abdominals curl the spine; ExRx asks for a deliberate C shape; in a small study of abdominal exercises and gadgets the ab coaster drew much more rectus femoris than a floor crunch | ExRx Sled Leg Hip Raise (Ab Coaster) ("Deliberately attempt to flex waist in a 'C' shape"; iliopsoas, rectus femoris, sartorius, tensor fasciae latae synergists); ExRx Rectus Abdominis (lumbar flexion; "controls the tilt of the pelvis and curvature of the lower spine"); Andersson 1997 (hip flexors highly active only in exercises with hip flexion); Stenger 2013 (Figure 4: Ab Coaster RF ~350% of the crunch's, significant; 14 subjects) |
| Arms hold the bar long with the elbows only softly bent; ExRx lists lats, rear shoulders, triceps long head as stabilisers on this machine, holding the upper body steady; pulling with the arms is on one coaching guide's list of common mistakes for the machine | The model (elbows 136-143°, shoulders ~2 cm); ExRx Sled Leg Hip Raise stabilizers (pectoralis major sternal, latissimus dorsi, teres major, deltoid posterior, triceps long head); Motra Ab Coaster guide (common mistakes: pulling with arms). ExRx's version rests the forearms on pads; the model holds a bar with the hands, and the copy follows the model |
| ExRx's version slides forward and up by pulling the knees up high; the lower back keeps rounding all the way up the track | ExRx Sled Leg Hip Raise ("Slide forward and up by pulling knees up high"); the model (pelvis tilt, lumbar rounding and knee travel rise together, about linearly, from the bottom to the top: at mid-track the pelvis has rolled 48% of its range for 50% of the knee travel) |
| Keep rolling until the knees are under the shoulders | The model (knees end ~7 cm ahead of the shoulders' line, about under them) |
| A coaching guide asks for a full return at the bottom without arching; turning around mid-track trims reps and lets momentum start the next; roll back until the thighs are nearly upright | Motra (range of motion: "Full extension at the bottom without arching the back"; mistakes: using momentum); ExRx's return line ("arching spine in opposite direction while keeping hips bent") asks for more extension than Motra; the model's bottom is long, not arched, so the copy follows the model and Motra; the thighs ~20° off upright at the bottom against ~52° at the top (the model) |
| One coaching guide lists using momentum and moving too fast among the common mistakes; the carriage rolls freely, so a quick drop can swing into the next rep with less work from the abdominals (softened in verification from "without your abdominals doing the lift", which no source measured) | Motra (common mistakes: using momentum, moving too fast; tempo 2-1-2); the model (carriage on rails); the last clause is mechanics |
| About a second and a half each way, a brief hold | The model |
| Setup: kneel with the shins on the pad and the feet off the back end; hands palms down just outside the shoulders; thighs almost upright and the back long at the bottom | ExRx Sled Leg Hip Raise ("Place shins on padded sled with knees forward and feet hanging off of back end"); the model |

Activation: Rectus Abdominis 0.80 PRIMARY (Stenger 2013: upper and lower rectus abdominis not
different from a floor crunch, bars ~85 and ~90% of it; the library's Crunch value), Obliques 0.64
MODERATE SECONDARY (Stenger: external obliques significantly higher than a crunch, bar ~145%; the
library's crunch obliques 0.45 x 1.45 = 0.65; the library's Hanging Knee Raise uses 0.64, and
Stenger's captain's chair crunch had a similar bar), Hip Flexors 0.50 MODERATE SECONDARY (Stenger:
rectus femoris far above a crunch; ExRx synergists; but painted dim, and in the model the hip angle
opens as the pelvis curls, so below the Hanging Knee Raise's 0.76 primary), Triceps Brachii 0.25 LOW
SECONDARY (painted dim; holds the arms long on the bar, ExRx stabiliser). All judgement calls; the
bars are read off the thesis's figures, not tables. Stabilisers: posterior deltoid (painted dim,
legend width), latissimus dorsi, teres major, pectoralis major (ExRx). The library row's MACHINE /
beginner fits (Motra rates it beginner).

## Labels

All rows below are on-screen rows (the spec writes them with `ov()`). Pills were drawn over the five
stills with `overlay.py`; the lifter's and the equipment's extents per screen band came from
`occ.py` / `occ2.py` (the equipment is bluish grey, the lifter neutral grey).
- Standing (yaw -1.35): free space top left (above the hands at the bottom of the curl), left of the
  belly below the elbows, and a narrow strip right of the back and hips (lifter to u ~0.71-0.75),
  so the two right-hand pills are 10 characters. Rope 0.16 left to the near hand (level leader);
  range 0.45 left to the near elbow (Elbows toward thighs since the review; the pill ends at u 0.39,
  the lifter's front edge in that band at u >= 0.52 in all five stills); knees 0.64 left to the near knee; curl 0.34 right into the
  back to the chest joint; hips 0.58 right into the hip.
- Oblique (yaw -0.4): the cable tower fills the right half behind the lifter; the lifter's left side
  reaches u ~0.72 (0.80 at the left elbow in the second rep), so the right pills are short and sit
  over the tower's static right post. Rope 0.13 left to the right hand; turn 0.44 left to the right
  lower chest; hips 0.52 left to the right hip; curl 0.47 right to the lumbar spine; alternate 0.20
  right, above the elbows and right of the moving cable, to the left shoulder (the one that crosses
  first).
- Machine (yaw -1.35): the machine fills the right and the bottom; the lever (moving) runs from the
  hub to the handles. Arms 0.14 left to the near hand; tempo 0.44 left to the far elbow; curl 0.53
  left, the leader passing under the elbows to the chest joint; feet 0.70 left of the shins to the
  ball of the near foot; hips 0.70 right over the seat's frame (static), up to the hip.
- Ab coaster (yaw -1.35): the whole top band is free, as are the right above the feet and the band
  below the base. Arms 0.20 left to the near hand; tempo 0.16 right (below the eye button) to the
  lower back; curl 0.40 right into the hip; return 0.66 right to the near toes; range 0.80 left, its
  leader up past the rails to the near knee.

## Ghosts

Sizes and checks are in the table comments of the faults file (from `proto.py`, and for the seven
ghosts the review rebuilt, `SCRATCH/cablecrunch/review/final.py`). Since the review every drawn
segment keeps its length at the fault's moment (turns are rigid, knees and elbows are re-seated
with `resolve`, and the shift-built coaster ghosts are sized on the rig; within ~0.5 cm through
the rest of the rep), except the library's `squareLockedStance`, which shortens each leg ~1 cm as
it locks the knee. No knee or elbow bends backwards (checked by the side of the hip-ankle or
shoulder-wrist line each joint sits on): the knees re-seat forward (standing hips 160° -> ~139°,
machine hips 98° -> ~102°, oblique left knee ~162°), the elbows keep 47° / 67° where the arms are
turned, and the coaster's elbows bend the way they already bend (136° -> ~91°).
- Strengths: the cable and machine faults grow with the curl (neck-to-knee distance: 1.76 -> 1.68
  torso lengths standing, 1.32 -> 1.12 on the machine), so they vanish upright; the oblique crunch's
  turn faults read the left elbow's distance to the right hip (1.11 -> 0.96 in the first rep, ~1.10
  in the second), so the rightward-turn ghosts show in the first rep only, where they are stilled;
  the ab coaster's top faults grow as the knees near the hands (1.51 -> 1.07), the return fault the
  other way.
- Standing: rope (arms 35° down about the shoulders), curl (flat-back hinge: the 19° lumbar and
  19° thoracic curl undone by turns and the trunk tipped 36° about the hips, ~10° past the model's
  trunk line), range (the upper trunk 25° back up
  about the lumbar spine), hips (sat back ~9 cm and down ~5 cm, knees re-seated), stance (the
  library's `squareLockedStance`, seen from the front).
- Oblique: twist (the turn taken out: ~3 cm from the standing crunch's own bottom pose), curl (the
  curl undone 18° at the chest joint and 18° at the lumbar joint with the turn kept, the trunk line
  31° -> ~7°), hips (the hips swung round on planted feet, pivoting on the right hip: the left hip
  ~11 cm forward and ~3.7 cm in, the hip line keeping its length, the left knee forward and in;
  seen from the lifter's left side, where the line of the hips opens front to back; with the knees
  nearly straight they can only swing a few centimetres, so a front view showed little: the
  round-1 shot at -0.4 read as no change), rope (as standing). "sides" has no ghost.
- Machine: arms (35° down), curl (flat back: the 24° thoracic and 10° lumbar curl undone, the trunk
  tipped 32° about the hips), hips (lifted ~7 cm, forward ~5 cm). "feet" (a pull
  against the roller is a force) and "tempo" have no ghost.
- Ab coaster: curl (the hips-to-neck line made straight, with a ~3 cm dip at the lumbar joint,
  where the model's back is rounded 7-9 cm off that line; the hips ~3 cm down the trunk's line so a
  straight back of the same segment lengths reaches the same shoulders), arms (the trunk turned 14°
  forward about the hips, the shoulders ~12 cm down and toward the bar, elbows ~91°), range and
  return (the legs turned about the hips and moved with the hips, the lumbar joint sized so the
  lower-back segments keep their lengths: close to the model's own mid-track pose, knee angle
  kept). "tempo" has no ghost.

## Lab rounds

- Compile check (`lab500.sh check cablecrunch`): built on the first run.
- Round 1 (`shoot cablecrunch "0,1.5,3,5.5"`, kept in `SCRATCH/cablecrunch/round1/`): every trainer
  still had its five pills clear of the lifter and of moving equipment (the oblique crunch's two
  right-hand pills sit over the tower's static post; the machine's hips pill and the coaster's
  return pill over static frame), the legend on one line for all four (the coaster's three
  secondary names fit). The ghosts read as their mistakes except two: the oblique crunch's hips
  ghost (seen from -0.8, the hips moved ~10 pt and the knees ~12 pt, indistinguishable from the
  lifter) and the coaster's flat-back ghost (an ~11 cm lumbar dip, faint inside the torso).
- Round 2 (`shoot cablecrunch "1.5" "Oblique Cable Crunch" "Ab Coaster Crunch"`): the hips ghost seen
  from the lifter's left side with the hips ~7 cm forward and back, the hip line now open front to
  back and the far knee ~13 cm back; the coaster's lumbar dip ~14 cm, a clear V in the back line.
  Both read. The final full shoot is in `SCRATCH/lab/cablecrunch/`.

## Open points

- The ab coaster's posterior deltoid (painted dim) is in the stabilisers, not the legend, for width.
- No EMG for the standing, facing-away or twisting cable crunches; their rows rest on the library's
  Cable Crunch, which itself cites nothing.
- (Review) The oblique hips ghost reads only moderately even from the side; the coaster's flat-back
  ghost is a straight line inside a visibly rounded back, which reads as flat but is subtle (~17 pt).

## Review (independent, 2026-10-05)

Two passes after the author finished, sources and claims, then fidelity to the models; scripts and
evidence in `SCRATCH/cablecrunch/review/` (the author's last lab output kept in
`review/before_review/`, the four files as the author left them in `review/*_before*`).

Sources. Every study re-read on Europe PMC (records saved as `epmc_<PMID>.json`): Sundstrup 2012
(and its PMC full text: Table 2, the machine set-up with the feet behind the ankle rollers and the
hands on handles at shoulder level, the Discussion's flexed hips and fixed feet), Moraes 2009,
Andersson 1997, Crommert 2021 and Ha & Shin 2020; all exist with the authors, journals, volumes,
pages, DOIs and PMIDs cited. The Stenger 2013 thesis: the MINDS@UW handle 1793/67303 resolves (title,
author, advisor Porcari) and the Wayback copy of its PDF is byte-identical to the one the author
read; 14 subjects completed it, the Ab Coaster set-up is as quoted, and the bars read as stated
(URA ~85%, LRA ~90%, EO ~145%, RF ~350% of the crunch; EO and RF significant). ExRx re-read at the
cited Wayback snapshots (Cable Standing Overhead Crunch 2025-08-15, Kneeling 2026-02-06, Standing
2025-08-28, Standing Twisting Crunch 2018-02-10, Lever Seated Crunch 2023-12-12, chest-pad version
2024-02-01, Sled Leg Hip Raise 2025-08-16, Rectus Abdominis 2025-10-26, Obliques 2025-04-21); the
Mirafit post (Wayback 2025-10-02/16) and Motra's Ab Coaster page (re-fetched live, same text). Each
says what the notes quote. Fixed:
- Ab coaster, one source made general: the return, arm and tempo cues said coaching or the machine's
  list in general, but only Motra's guide was read (and ExRx asks for the opposite on the return,
  an arch); they now say a or one coaching guide.
- Stenger was described as a study of abdominal machines; it compared 15 exercises and gadgets
  (floor, ball, plank and machine work) with the crunch. Now: abdominal exercises and gadgets.
- Ab coaster curl cue: a flat-back knee drive "is mostly the hip flexors' work" became "is hip
  flexion, the hip flexors' job", and the comparison's "leaves most of the lift" became "more of
  the lift": no source measured the share.
- Rectus abdominis anatomy: "to the lower ribs and breastbone" became "to the rib cartilages and the
  bottom of the breastbone" (ExRx: 5th-7th costal cartilages and xiphoid, which are not the lower
  ribs).
- Left as they were, checked: the Sundstrup numbers and wording, Andersson's two uses (trunk-curl
  sit-ups more active with more flexion; flexed, supported legs raising hip flexor but not
  abdominal activity), Crommert (right-side fine wire; the copy's own-side / away-side reading
  matches), Ha & Shin (concentric = eccentric), the ExRx muscle roles and set-ups. The activation
  fractions are all marked as judgement calls in the spec comments and Shared facts, the levels
  match the fractions, and the primaries match the bright paint (the coaster's dim posterior deltoid
  is in the stabilisers for legend width, as noted).

Model fidelity (rigs re-sampled from the author's frame dumps with `review/m1.py`-`m4.py`, the
projection checked against `joints.json` to the third decimal; ghosts re-solved with the author's
port in `review/final.py`, which also checks every drawn segment's length and the side each knee
and elbow bends to). Confirmed: the standing crunch faces away from a ~1.9 m pulley, hands fixed at
the forehead, chest bone 47° (pelvis 9°, lumbar 19°, thoracic 19°), pelvis 3.5 cm back, knees
169° -> 160°; the oblique crunch's first rep turns right (shoulder line +30°, the left elbow to
x -0.02, past the midline), the second left, the hip line square throughout; the machine's pelvis
never moves; the coaster's pelvis rolls ~40° with the knees ~34 cm forward and the shoulders still.
Fixed:
- Ab coaster bottom position: the return cue, its correct line and setup step 4 cued the bottom by
  the hips being behind the knees, but the hips are behind the knees all the way (15 cm at the
  bottom, 35 cm at the top). The bottom is now cued by the thighs, ~20° off upright there against
  ~52° at the top.
- Ab coaster range cue: "your lower back rounds most near the top" overstated the model, where the
  pelvic roll and the knee travel rise together about linearly; now the back keeps rounding all the
  way up, so turning back early cuts the curl short.
- Machine crunch hands: "beside your head" (cue intro, setup) became "at about head height" / "in
  front of your shoulders at about head height": the wrists are 26 cm in front of and 29 cm out from
  the shoulders, 12 cm above them.
- Standing crunch: the curl's correct line said to round the upper and middle back, but the model
  rounds the lumbar spine as much as the thoracic (19° each); now "round your back from the
  shoulders down". The range label "Elbows to thighs" overstated the model (the elbows end ~59 cm
  from the middle of the thighs); now "Elbows toward thighs", as in ExRx and the library's Cable
  Crunch.
- Ghosts, lengths and knees: the draft's note that every move keeps bone lengths did not hold for
  seven of the sixteen ghosts. The coaster's flat back stretched the lumbar-thoracic segment
  15.7 -> 22.5 cm (and drew an L-shaped hump rather than a flat back), its arm pull 15.7 -> 19.3 and
  11.4 -> 12.9 cm, its range and return ghosts changed the two lower-back segments by 1-1.5 cm, the
  standing and machine flat backs shortened the lumbar segment ~2 cm, and the oblique hips ghost
  stretched the hip line 18.3 -> 22.7 cm and bent the right knee slightly backwards. Rebuilt: the
  flat backs from turns that undo the measured lumbar and thoracic curl and then tip the trunk
  (standing 19/19/36°, machine 24/10/32°); the oblique's upright-turn ghost likewise uncurls the
  spine 18° + 18° with the turn kept (the draft turned the whole curled trunk 30° about the hips,
  which leaned the upper back behind upright); the oblique hips swing on the right hip (left hip
  ~11 cm forward and ~3.7 cm in, the hip line keeping its 18.3 cm, both knees bending forward); the
  coaster's flat back as one straight hips-to-neck line with a ~3 cm lumbar dip, sized on the rig so
  the segments keep their lengths; the coaster's arm pull as a 14° turn of the trunk about the hips
  with the elbows re-seated (136° -> ~91°); its range and return ghosts with the lumbar joint sized
  so the lower back keeps its lengths. The library's squareLockedStance (standing stance) still
  shortens each leg ~1 cm as it locks the knee; it is the library's piece and was left.
- Review lab round (`lab500.sh shoot cablecrunch "0,1.5,3,5.5"`, log
  `SCRATCH/cablecrunch/review/lab_review1.log`, output `SCRATCH/lab/cablecrunch/`, copied to
  `review/review_round1/`): BUILD SUCCEEDED, all 16 trainer stills and 16 ghosts shot, the app never
  fell back to the home screen. Before and after for the eight ghosts touched:
  `review/before_after_changed.png` (top the author's, bottom the review's). The coaster's flat back
  now reads as one straight line from the hips to the neck through the rounded back instead of an
  L-shaped hump; its arm pull bends the elbows down and out with the shoulders dropping toward the
  bar; the oblique's upright turn stands straight with the shoulders turned instead of leaning
  back; the standing and machine flat backs look as before (straight, tipped trunk); the oblique
  hips ghost still reads only moderately (the near hip and leg forward of the far one, ~29 pt), as
  the author recorded; the coaster's range and return ghosts look as before. Elbows toward thighs
  sits clear of the lifter at every still. No further round was needed.
- Left as they were, checked: the other labels and rows (every pill clear of the lifter and of
  moving equipment; the machine's Arms only hold on leader skims the left of the head at the
  bottom of the curl and the far handle at the top, the best of the left-side rows, since the
  right is machine), the glows, the moments (top 1.50 s for the cable and machine faults, the
  oblique's first, rightward rep; 1.67 s top and 4.0 s bottom on the coaster), the other eight
  ghosts (lengths kept, joints bending the right way), the activation rows and the library rows.

## Verification (final skeptic, 2026-10-05)

Every claim and number in the cue intros, whys, mistakes, corrects, comparison notes, setup steps,
the activation comments and the source table was checked again against the sources and the rigs.
Sources re-fetched independently: the five Europe PMC records (REST, `SCRATCH/cablecrunch/skeptic/
epmc_*.json`: authors, journals, volumes, pages, DOIs, PMIDs and abstract wording as cited); the
Sundstrup 2012 PMC full text (methods: feet behind the ankle rollers, hands on handles at shoulder
level; Table 2: RA 84, EO 79 / 71, RF 65% on the machine against 104, 86 / 79, 27% on the ball;
Discussion: near-90° hip and knee flexion and the fixation of the feet); the Stenger thesis
(14 completers, the Ab Coaster set-up, Figures 1-4: URA ~85%, LRA ~90%, EO ~145% and RF ~350% of
the crunch, EO and RF significant, the captain's chair EO also ~145%; the traditional crunch on the
floor); ExRx Lever Seated Crunch (2023-12-12), its chest-pad version (2024-02-01), Sled Leg Hip
Raise (2025-08-16) and the 2018-02-10 Cable Standing Twisting Crunch re-fetched from the Wayback
Machine; the saved ExRx muscle and cable pages, Mirafit and Motra re-read. The rigs were re-sampled
straight from the USD files with Blender's Python (`skeptic/s1.py`, `a1.py`-`a3.py`, not the
earlier frame dumps). Confirmed on the rigs: standing pelvis 9°, lumbar 19°, chest bone 47°; hands
13 cm in front of the head joint and 16 cm out, palms in; elbows from 2 cm below to 22 cm below the
shoulders; ankles 26 cm apart, toes out 9°; knees 169° -> 160°; pulley ~1.9 m, ~55 cm behind the
heels; stack 21.5 cm; oblique shoulder line turned +30° (first rep right, second left), the left
elbow to x -0.024, the hip line square; machine pelvis still, knees 98°, thighs ~5° below level,
elbow angle 67°, hubs 0.70-0.76 m between the lumbar and chest joints, stack ~35 cm, palms in;
coaster pelvis 40.5°, thighs 20.5° -> 51.7° off upright, hip angle opening 9°, knees ending ~6.5 cm
ahead of the shoulders, shoulders 2.5 cm, palms down, hands 48 cm apart, elbows 143° -> 136°; all
four clips curl in ~1.5 s, hold to ~2 s and return by 3.5 s. The library values quoted (Crunch
0.80 / 0.45, Cable Crunch 0.86 / 0.52, Hanging Knee Raise obliques 0.64, hip flexors 0.76) and
the sibling values in "Sibling and library check" still match.

Changed (text only; no label, cue id, tracked joint, ghost or moment changed, so no lab round):
- Machine Crunch arms why: it cited ExRx's lats, rear shoulders and triceps long head as stabilisers
  of "its seated crunch machine", but that list is ExRx's arm-pad Lever Seated Crunch; the
  chest-pad version, which is the model's machine, lists no stabilisers. Now: ExRx's chest-pad
  version only has you place your hands on the lever and lists the abdominals alone as the working
  muscles. The spec header and the machine's activation comment say where the three arm
  stabilisers come from.
- Machine Crunch hips why: the hips lifting let the legs and hip flexors drive the pads "in place
  of your abdominals" became "help drive the pads down, leaving less for your abdominals" (no
  source measured a full hand-over).
- Machine Crunch feet why: Andersson's "flexed and supported legs ... did not generally alter the
  activation level of the abdominals" was written "bending the legs and anchoring the feet ...
  without raising the abdominals'"; now "bent and supported legs ... without generally changing
  the abdominals'" (the abstract does not say how the legs were supported).
- Standing Cable Crunch range why: "so a short nod leaves out the part of the rep where they work
  hardest" applied a sit-up finding to the cable crunch as fact; now "leaves out the deeper part of
  the curl, where that study found them most active". (Andersson's full text could not be reached;
  the abstract's "increased flexion angle" is read as the trunk curl, as before.)
- Ab Coaster arms: "elbows almost straight" / "nearly straight" overstated the model's 136-143°
  elbow angle; now "the elbows only softly bent" (intro and correct). Its why said ExRx's
  stabilisers "hold you steady on the bar", but ExRx's version rests the forearms on pads; now
  "stabilisers on this machine: they hold your upper body steady".
- Ab Coaster tempo why: a quick drop swings you into the next rep "without your abdominals doing
  the lift" became "can swing you into the next rep with less work from your abdominals".
- Spec header and notes model facts: the machine's wrists are 29 cm from the midline, ~9 cm
  outside the shoulder joints, not 29 cm out from the shoulders (the Review section above repeats
  the earlier figure; the copy, in front of your shoulders at about head height, was right). The
  elbow figures 47° and 67° are joint angles (sharply bent), not degrees of bend, and are now
  written so. The coaster's knees travel ~35 cm forward and ~7 cm up (was ~33 / ~8). Andersson's
  supported legs are no longer glossed as anchored. The standing crunch's activation comment now
  notes that Sundstrup 2012 cites earlier work where added crunch load raised hip flexor rather
  than rectus abdominis activity, so the Moraes-based ordering is a judgement.
- Left as they were, checked: every other cue, comparison and setup line; Crommert (right-side
  fine wire; the copy's own-side / away-side generalisation matches the fibre-orientation reading
  in the abstract); Ha & Shin (no concentric / eccentric difference; their decrease in abdominal
  activity from 30° to 90° curl-ups involves sit-up hip flexion and is not used); Motra's mistakes,
  tempo and range wording; Stenger's bars; the thighs "nearly upright" at the coaster's bottom
  (~20° off upright against ~52° at the top), a fair description that the review chose.
- `python3 spec_500.py cablecrunch` prints OK (4 exercises).
