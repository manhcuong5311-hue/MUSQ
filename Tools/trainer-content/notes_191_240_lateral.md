# Batch 191-240: lateral and Y raises, rotator cuff (2026-09-26)

Content: `spec_191_240_lateral.py` (validate prints OK; `gen.py` emits all nine).
Ghosts: `Tools/fault-review/faults_191_240_lateral.swift.txt` (a scratch copy of
`FaultPoses.swift` with the pieces and entries spliced in passes
`swiftc -typecheck`).

How the models were read: joint angles, body-frame arm directions and the
dumbbell handle axis (end cap to end cap) sampled across each clip from the
converted `.usdc`, the cable handles and pulleys located from their prims, and
the bench pads' angles fitted from their meshes. Ghost views were chosen with a
small emulator of `FaultGhost.solve` that reports how much of each ghost's
displacement shows on screen for each extra turn (numbers below are that
share, 1.00 = all of it in the screen plane).

## Sources and what each supports

| Key | Source | Used for |
|---|---|---|
| Larsen 2025 | Larsen S, Wolf M, Schoenfeld BJ, et al. Front Physiol 16:1611468, doi:10.3389/fphys.2025.1611468 | The dumbbell raise has an ascending resistance profile with little torque in the lengthened position; cable and dumbbell raises grew the lateral deltoid alike. |
| Coratella 2020 | Coratella G, Tornatore G, Longo S, Esposito F, Ce E. Int J Environ Res Public Health 17(17):6015, doi:10.3390/ijerph17176015 | Neutral humerus gives the most medial deltoid; internal rotation raises posterior deltoid and upper trapezius; external rotation raises anterior and medial deltoid. |
| Wickham 2010 | Wickham J, Pizzari T, Stansfeld K, Burnside A, Watson L. J Electromyogr Kinesiol 20(2):212-222, doi:10.1016/j.jelekin.2009.06.004 | Abduction 0-166° with a light dumbbell: supraspinatus and middle deltoid are the prime movers (first on, highest %MVC). |
| Escamilla 2009 | Escamilla RF, Yamashiro K, Paulos L, Andrews JR. Sports Med 39(8):663-685, doi:10.2165/00007256-200939080-00004 | Cuff abducts best at low angles, deltoids at high angles; abduction torque shares (middle deltoid 35-65%, supraspinatus 25%, anterior deltoid 2%); scapula rotates up 45-55° in full elevation, serratus central. |
| Ekstrom 2003 | Ekstrom RA, Donatelli RA, Soderberg GL. J Orthop Sports Phys Ther 33(5):247-258, doi:10.2519/jospt.2003.33.5.247 | Prone overhead arm raise in line with the lower trapezius: most lower trapezius, and (with horizontal extension in ER) the most middle trapezius; abduction in the scapular plane above 120° (and a diagonal): most serratus anterior. |
| Arlotta 2011 | Arlotta M, LoVasco G, McLean L. J Electromyogr Kinesiol 21(3):403-410, doi:10.1016/j.jelekin.2010.11.006 | Caveat: an isometric prone V-raise was not the top lower-trapezius exercise in either sex (modified prone cobra and prone row were; in men the posterior fly too). |
| Cools 2007 | Cools AM et al. Am J Sports Med 35(10):1744-1751, doi:10.1177/0363546507303560 | Side-lying ER, side-lying forward flexion, prone horizontal abduction with ER and prone extension have the lowest upper-to-middle/lower trapezius ratios. The Powell raise itself was not tested. |
| Reinold 2004 | Reinold MM, Wilk KE, Fleisig GS, et al. J Orthop Sports Phys Ther 34(7):385-394, doi:10.2519/jospt.2004.34.7.385 | ER exercises: infraspinatus 62% and teres minor 67% MVIC highest in side-lying ER; prone horizontal abduction at 100° with full ER highest for supraspinatus 82%, middle deltoid 87%, posterior deltoid 88%. |
| Reinold 2009 | Reinold MM, Escamilla RF, Wilk KE. J Orthop Sports Phys Ther 39(2):105-117, doi:10.2519/jospt.2009.2835 (full text read) | Reports from Reinold 2004 that a towel roll raised infraspinatus and teres minor EMG by 20-25% in standing ER at 0° and helps keep the form; in IR at 0° abduction the subscapularis is assisted by the pectoralis major, latissimus dorsi and teres major, and IR at 90° gave less pectoralis major activity (Decker 2003); the scapula rotates up ~1° for every 2° of arm elevation up to 120°. |
| Townsend 1991 | Townsend H, Jobe FW, Pink M, Perry J. Am J Sports Med 19(3):264-272, doi:10.1177/036354659101900309 | Horizontal abduction with the arms externally rotated was one of four exercises consistently among the most challenging for every glenohumeral muscle studied (with scaption thumbs down, flexion and press-up). |
| Decker 2003 | Decker MJ, Tokish JM, Ellis HB, Torry MR, Hawkins RJ. Am J Sports Med 31(1):126-134, doi:10.1177/03635465030310010601 | Subscapularis (upper and lower) with latissimus, teres major and pectoralis major recorded; upper subscapularis above lower in every exercise except IR at 0° abduction; push-up plus and diagonal beat plain IR for the subscapularis. |
| Schoenfeld 2013 | Schoenfeld B, Sonmez RG, Kolber MJ, Contreras B, Harris R, Ozen S. J Strength Cond Res 27(10):2644-2649, doi:10.1519/JSC.0b013e318281e1e9 | Reverse fly machine: a neutral (thumbs-up) grip gave more posterior deltoid and infraspinatus activity than a pronated grip. |
| Stokdijk 2003 | Stokdijk M, Eilers PH, Nagels J, Rozing PM. Clin Biomech 18(4):296-302, doi:10.1016/s0268-0033(03)00017-2 | About 55° of humeral external rotation accompanies elevation in every plane. |
| NSCA 2016 | McBride JM, Biomechanics of resistance exercise, ch. 2 in Haff GG, Triplett NT (eds), Essentials of Strength Training and Conditioning, 4th ed., Human Kinetics | Resistive torque = load x horizontal distance (moment arm) from the joint; used for every where-is-it-hardest statement. |
| ExRx | ExRx.net: Dumbbell Incline Lateral Raise; Dumbbell Lying Lateral Raise; Dumbbell Lying Rear Lateral Raise; Dumbbell Side Lying Rear Delt Raise; Dumbbell Incline Y Raise; Cable Y Raise; Cable Standing Shoulder External Rotation; Cable Standing Shoulder Internal Rotation (read through search snippets; the site blocks direct fetches) | Setups, ranges and target/synergist lists named below. |
| Practitioner | NFPT (Bovee R, 2025) incline side lateral raises; Rehab Hero: Lean In Lateral Raise, Powell Raise (30-45° incline, abduction to 90°), Lu Raises; The Prehab Guys: Powell Raise - Dumbbell (side-lying on an inclined bench, palm down, pull with the shoulder blade, no rocking or shrugging); BOXROX (Hudson R, 2026) Lu raise | Technique details for the less-studied variations. |

## Leaning Lateral Raise (`leaningLateralRaise`)

Model: standing side-on to a rack upright ~0.7 m away, feet ~14 cm apart,
right hand on the upright at 1.18 m with the elbow at ~95°. The trunk is
tilted 14° toward the rack (neck 14 cm to the rack side of the pelvis, legs
vertical). Only the left arm raises: elbow 165-166°, from 10° off the trunk
(the dumbbell then hangs ~24° out from vertical) to ~89° off the trunk, ~12°
above horizontal in the room, ~20° in front of the body, palm in at the
bottom and palm down at the top.

Claims:
- Tilting away from the working arm gives the dumbbell leverage at the
  bottom (NSCA 2016 moment arm; the model's numbers: ~0.41 of peak torque at
  the bottom vs ~0.17 upright with the same arm angle). An upright dumbbell
  raise has little torque in the lengthened position (Larsen 2025).
- This is the lean-in version (Rehab Hero Lean In Lateral Raise: lean 20-30°
  toward the support, free arm raises). Popular lean-away write-ups (feet by
  the post, support arm straight, body tilted away from the post) tilt the
  trunk the other way, which by the same torque rule moves load toward the
  top. The copy follows the model and never says lean away.
- Stopping at shoulder height, soft fixed elbow, no shrug: as the existing
  Dumbbell Lateral Raise.

Activation: Lateral Deltoid P 0.86 > Supraspinatus 0.46 > Anterior Deltoid
0.44 > Upper Trapezius 0.40. Ranking from Wickham 2010 (middle deltoid and
supraspinatus the prime movers of abduction) and Escamilla 2009 (supraspinatus
~25% of abduction torque vs ~2% anterior deltoid; the cuff is most effective at
low angles, which this lean loads). The anterior deltoid and upper trapezius
values follow the existing Dumbbell/Cable Lateral Raise entries (the arm path
is ~20° forward of the frontal plane). No study measured the leaning raise.

Ghosts (all in the default near-front framing, yaw -0.3; no turns):
- lean: `leftArmTrunkTipped(-14)`: the trunk, both shoulders and the left arm
  tipped 14° to the lifter's left about the pelvis (the chest's axis), the
  trunk back upright. Any; 1.58 s (top).
- traps: `leftShrugged`: the left shoulder and arm 0.12 torso lengths up.
  Any; 1.58 s.
- elbow: `elbowsFolded(.forward, -60, side: "L", strength: .between("hand_L",
  "thigh_L", from: 0.6, to: 1.0))`: the left hand folded 60° about the elbow
  (hand to hip ~0.38 at the bottom, ~1.4 at the top: none at k0-3, all of it
  k6-16). 1.58 s (top).
- range: `leftRaiseShortAtBottom` (`armsTurned(.forward, 30, side: "L")`:
  the arm held 30° out; all of it with the hand 0.45 torso lengths from the
  hip, none by 0.9, mid-rep). BOTTOM only: 3.83 s.
- support: inline hauling on the upright: the trunk, both shoulders and the
  left arm tipped a further 12° toward the rack (to the lifter's right) about
  the pelvis, the dumbbell arm carried up with the trunk, and the rack (right)
  elbow shifted 0.04 back and 0.08 down, then re-seated, so it bends. Any;
  1.58 s.

## Incline Lateral Raise (`inclineLateralRaise`)

Model: lying on the right side against an incline backrest measured at 32°,
bottom hip on the seat, knees ~106°, right foot on the floor and the left on
top, right hand holding the top of the backrest. Left arm only, elbow ~165°,
from beside the hip (dumbbell in front of the hip, palm in) to 90° from the
trunk (54° above horizontal in the room), ~10° in front of the body.

Claims:
- The incline flips the resistance curve: torque ~0.91 of peak at the bottom,
  peak ~35° off the trunk, ~0.59 at the top (NSCA 2016 moment arm from the
  model's angles). A standing raise carries 0 to ~0.71 of its peak over the
  first 45° (~0.57 at 35°), so the range why calls it light there, not
  almost weightless. ExRx Dumbbell Incline Lateral Raise: 30-45° incline, arm
  over the bench, raise until the upper arm is perpendicular to the torso;
  lying at 45° puts peak torque nearer mid-range than the upright raise.
- Lead with the elbow, no shrug (NFPT 2025).
- Supraspinatus is listed because ExRx names it a synergist of the lying
  lateral raise and because the load sits at low abduction angles, where the
  cuff abducts best (Escamilla 2009).

Activation: Lateral Deltoid P 0.84 > Supraspinatus 0.52 > Anterior Deltoid
0.40 > Upper Trapezius 0.30 (LOW, since the top, where the upper trapezius
works most, is the lightest part here). Evidence is indirect; no EMG study of
the incline side-lying raise was found.

Ghosts (framed at yaw 1.0):
- body: `leftRolledBack(35).seen(-0.8)` (rolling back off the pad): the trunk,
  both shoulders and the left arm turned 35° about the pelvis around the
  trunk's long axis, the chest rolling back; the shoulder line turns ~0.19
  torso lengths at each end, so the roll shows and not only the arm sweep of
  the path ghost. Total 0.2, looking along the body. Any; 1.58 s (top).
- traps: `leftShruggedLying`: the left shoulder and arm 0.2 torso lengths up,
  toward the ear, with the head and neck drawn. No turn. Any; 1.58 s.
- elbow: `elbowsFolded(.forward, -60, side: "L", strength: .between("hand_L",
  "thigh_L", from: 0.6, to: 1.0))`: shown from mid-rep up, none at the bottom
  (where the fold would turn the forearm into the hip). No turn. 1.58 s (top).
- range: `leftRaiseShortAtBottom` (the arm held 30° out). No turn. BOTTOM
  only: 0.0 s.
- path: `armsTurned(.up, -25, side: "L").seen(-0.8)` (the arm swept 25° back
  about the shoulder, around the trunk's long axis); default 0.58 at the top,
  1.00 at -0.8. Any; 1.58 s (top).

## Chest-Supported Lateral Raise (`chestSupportedLateralRaise`)

Model: kneeling on the seat of an incline bench (backrest measured at 37°),
chest on the pad, trunk 52° forward of vertical, chin at the pad's top edge.
Both arms, elbows ~164°, from hanging straight down (palms facing each other)
to straight out to the sides, horizontal in the room, thumbs toward the head
(palms toward the floor).

Claims:
- The pad removes leg and hip swing (as the existing Reverse Pec Deck and
  chest-supported rows).
- Load peaks as the arms reach level (arms horizontal in the room: maximum
  moment arm, NSCA 2016). Above level the dumbbells lose leverage and the
  scapular upward rotators take a larger share (Escamilla 2009; Ekstrom
  2003); the deltoid and supraspinatus keep working through full elevation
  (Wickham 2010), so the height why no longer says the effort moves onto the
  upper trapezius.
- Pulling the arms behind the shoulders becomes a rear-delt fly; bending the
  elbows becomes a row (as the existing Reverse Dumbbell Fly's cues).

Activation: Lateral Deltoid P 0.82 > Posterior Deltoid 0.68 > Middle
Trapezius 0.46 > Upper Trapezius 0.34. Reasoning: with the trunk 52-53°
forward and the arms level and straight out to the sides at the top, the
gravity moment splits in the trunk's frame into ~0.8 (sin 53°) horizontal
abduction and ~0.6 (cos 53°) abduction, so much of the top half is a
rear-delt action (NSCA 2016 moment arm). Reinold 2004's prone horizontal
abduction at 100° with ER (arms out from a face-down trunk) drove the middle
(87%) and posterior (88%) deltoid to essentially equal MVIC, and ExRx files
the flat, chest-down Dumbbell Lying Rear Lateral Raise under the posterior
deltoid. The lateral deltoid stays first because the arms travel straight
out to the sides in the trunk's frontal plane (pure 90° abduction relative
to the trunk) and ExRx files the Dumbbell Lying Lateral Raise under the
lateral deltoid with the posterior deltoid as a synergist; Coratella 2020
shows humeral rotation moving work between the heads. Upright raise < this
< prone raise for the posterior deltoid. Extrapolated, not measured. The
path cue says the rear delts share the work because of the lean.

Ghosts (framed at yaw -2.8, from behind-left; every still 1.58 s, the top):
- pad: `leanedBack(15).seen(1.2)`: the trunk and both arms turned 15° back
  about the pelvis, rising off the pad, a wedge opening between chest and pad
  (neck 0.26, head 0.31 torso lengths). Total -1.6, left side view. Any.
- traps: `proneShrugged`: both shoulders and arms 0.2 torso lengths up (more
  than `shrugged`'s 0.12), with the head and neck drawn so the closing gap
  shows; the piece carries `.seen(0.9)` (total -1.9, rear-left). Any.
- elbow: `elbowsFolded(.up, 60, strength: .between("hand_L", "pelvis", from:
  1.1, to: 1.4))`: the hands folded 60° about the elbows, hanging below them,
  a row (hand to pelvis ~0.98 hanging, ~1.56 level). No turn. Top. Gated
  because with the arms hanging the fold crossed the forearms under the chest.
- path: `armsTurned(.up, -25, strength: .between("hand_L", "pelvis", from:
  1.1, to: 1.4)).seen(0.9)` (arms pulled 25° back toward the ceiling, behind
  the shoulders). Total -1.9, rear-left: from straight behind, back toward
  the ceiling runs up the screen like the height ghost; here the hands go up
  and toward the hips, the height ghost's up and toward the head. Top. Gated
  because with the arms hanging (53° of flexion against the leaning trunk)
  the same turn swings them out to the sides, which is the correct path. Both
  show none at k0-3, 0.79 at k6, all of it k7-15, none from k20.
- height: `armsTurned(.forward, 25, ...between hand_L-pelvis 1.3..1.55)`:
  the arms swung 25° above shoulder level. No turn. Top only.

## Y-Raise (`yRaise`)

Model: same kneeling chest-supported position and bench. Both arms, elbows
~170°, from hanging straight down (palms in) to a Y ~35° out from the line of
the head (~145° elevation, ~30° above horizontal in the room), thumbs up
throughout the lift.

Claims:
- The overhead arm raise in line with the lower trapezius produced the most
  lower trapezius activity and, together with horizontal extension in ER,
  the most middle trapezius activity (Ekstrom 2003, flat prone). This model
  is on a ~37° incline, which keeps the top of the Y close to horizontal
  (~0.87 of the flat-prone torque) but lowers the load there; no study
  measured this incline.
- Caveat: Arlotta 2011 found an isometric prone V-raise below the modified
  prone cobra and prone row for the lower trapezius in both sexes (and, in
  men, below the posterior fly too). The height cue now says so: it gave the most lower
  trapezius activity in one EMG study, though another ranked the prone row
  and prone cobra higher. It does not claim the Y is the best lower-trap
  exercise.
- ExRx Dumbbell Incline Y Raise (45° incline) raises until the elbows are
  beside the ears and files it under the lateral deltoid. This model stops
  at ~145°, the elbows level with the ears but ~30 cm out to the sides, so
  the copy says level with the ears.
- Neck neutral (as the existing Reverse Dumbbell Fly). The why only says a
  neutral neck keeps the neck muscles out of it; the upper trapezius is an
  upward rotator in overhead elevation and is not quiet.

Activation: Lower Trapezius P 0.78, Lateral Deltoid P 0.72, Middle
Trapezius S 0.70 (HIGH), Posterior Deltoid 0.46. Two primaries because Ekstrom
2003 has the lower trapezius at its maximum here, ExRx names the lateral
deltoid as the target, and Reinold 2004 shows the deltoid heads highly active
in nearby prone positions. Ekstrom 2003 reports the prone overhead raise as a
maximal exercise for both the middle and lower trapezius, so the middle
trapezius is high too; the 37° incline lowers the load at the top, and no
study measured this incline. %MVIC values across muscles are not directly comparable, so the
order between the two primaries is a choice (library primary is lower
trapezius).

Ghosts (framed at yaw -2.8, from behind-left; every still 1.58 s, the top):
- pad: `leanedBack(15, arch: 0.06).seen(0.9)`: the chest and head lifting off
  the pad, the trunk and arms turned 15° back about the pelvis and the lower
  back arching toward the pad (spine 0.06, chest 0.027 torso lengths), the
  arms rising with the trunk. Total -1.9, rear-left, so the overhead arms
  stay in frame. Any.
- traps: `proneShrugged` (0.2 up, `.seen(0.9)` built in). Any.
- neck: inline, the head craned up: head and `head.tip` turned 40° about the
  neck (side-to-side axis), drawn chest-neck-head-crown, so the crown moves
  ~0.25 torso lengths rather than the skull base's 0.12. `.seen(1.2)`, total
  -1.6. Any.
- elbow: `elbowsFolded(.lateral, -50, strength: .between("hand_L",
  "pelvis", from: 1.2, to: 1.6))` (the hands folded 50° about the elbows,
  dropping toward the floor; hand to pelvis ~0.91 hanging, ~1.84 at the top).
  No turn. Top.
- height: `overheadShort` (`armsTurned(.forward, -50)`: the arms lowered 50°
  out to the sides to about shoulder level, a T instead of a Y, both arms in
  the trunk's plane; none until hands-to-pelvis 1.5, all of it at the top,
  ~1.8). No turn. Top only.

## Cable Y-Raise (`cableYRaise`)

Model: standing between the two low pulleys of a crossover, facing the
machine; pulleys at floor height ~0.45 m ahead and ~1.04 m to each side;
cables crossed (the left hand holds the cable from the right-hand pulley).
Feet 0.3 m apart, knees straight, trunk ~10° forward. Hands start crossed in
front of the hips and sweep up and out to a Y (~140° elevation), elbows
165-170°, thumbs up through the middle of the lift.

Claims:
- Setup and range (crossed low cables, raise until the elbows are about level
  with the ears): ExRx Cable Y Raise.
- The crossed cables load the bottom of the rep: from the model's handle and
  pulley positions, the cable's perpendicular share of force is ~0.5 at the
  bottom and ~0.54 at the top (NSCA 2016 moment arm). A standing dumbbell at
  the same ~140° would still carry ~0.64 of its peak (sin 140°), so the
  cable's advantage is at the bottom (~0.5 vs 0 hanging and ~0.37 at the
  model's 22° start), which the cross cue says. The height cue's why is about
  carrying on into the Y: past shoulder height the shoulder blades must
  rotate up, bringing in the serratus anterior and trapezius (Ekstrom 2003;
  Escamilla 2009), and the cables still pull at the top (~0.54).

Activation: Lateral Deltoid P 0.80 > Serratus Anterior 0.56 > Lower
Trapezius 0.50 > Supraspinatus 0.46. ExRx lists the lateral deltoid as
target with supraspinatus, lower/middle trapezius and serratus anterior
among the synergists, unranked. Ekstrom 2003 found the serratus anterior
maximal in scapular-plane abduction above 120°, which is the top of this Y
(141° elevation in a plane ~52° from the front, about the scapular plane),
so it ranks ahead of the lower trapezius, whose maximum there was the prone
overhead raise, not a standing one. Wickham 2010 (deltoid and supraspinatus
the prime movers of abduction) places the supraspinatus. No EMG study of the
cable Y exists; values are modest.

Ghosts (framed at yaw -2.5):
- torso: `leanedBack(12, arch: 0.06).seen(0.4)`: trunk and arms 12° back,
  spine 0.06 and chest 0.027 forward. Total -2.1, a rear-left three-quarter:
  from the true side the near tower hides the upper body and the lean. Any;
  1.58 s (top).
- traps: inline shrug, both shoulders and arms 0.18 torso lengths up (bigger
  than `shrugged`'s 0.12: with the arms overhead the shoulders have to rise
  clearly above the neck point to read). No turn. Any; 1.58 s.
- elbow: `elbowsFolded(.lateral, -50, strength: .between("hand_L", "pelvis",
  from: 0.7, to: 1.4))`: none with the hands crossed at the hips (0.22),
  where the fold swung the forearms behind the thighs. No turn. 1.58 s (top).
- height: `overheadShort` (arms lowered 50° out to shoulder level). No turn.
  Top only: 1.58 s.
- cross: `armsTurned(.forward, 20, ...between hand_L-pelvis 0.6..0.25)`
  (the arms swung 20° out: the handles taken uncrossed, the hands starting at
  the sides). No turn. BOTTOM only: 3.5 s.

## Lu Raise (`luRaise`)

Model: standing, feet 0.3 m apart, knees straight. Both arms from the sides
(palms in) out to the sides ~10° in front of the body and all the way
overhead (~168°), elbows 166-172°; the handles turn so the palms face forward
and in overhead; the shoulders rise ~3.5 cm only near the top.

Claims:
- Sides to overhead with near-straight arms, neutral start: BOXROX 2026,
  Rehab Hero Lu Raises. (The luxiaojun.com shop blog describes an ordinary
  raise to shoulder height and was not used.)
- The shoulder blades rotate up through most of the raise, ~1° for every 2°
  of arm elevation up to 120° (Reinold 2009) and 45-55° in all at full
  elevation (Escamilla 2009), driven by the trapezius and serratus (Ekstrom
  2003), so the traps why says they rotate up more and more as the arms rise
  and work hard overhead. Rehab Hero allows natural shrugging; the copy
  allows the shoulders to rise only as the arms go overhead, as the model
  does, and flags shrugging before the arms leave the sides.
- About 55° of external rotation accompanies elevation (Stokdijk 2003), hence
  the palms turning forward and in overhead (the model's palm at the top is
  ~49° from forward, turned in).
- Lower-back arching is a common Lu raise fault (BOXROX 2026).

Activation: Lateral Deltoid P 0.84 > Supraspinatus 0.60 > Serratus Anterior
0.54 = Upper Trapezius 0.54 (Wickham 2010 prime movers; trapezius and
serratus as scapular rotators, Escamilla 2009). Ekstrom 2003 found the
serratus anterior maximal in abduction above 120°, and this model reaches
~168°, while Rehab Hero names the upper trapezius as a target, so the two
are listed as equal (serratus first); nothing measured supports ranking
either clearly above the other here. Above ~120° the dumbbells' moment arm
shrinks toward zero, so the top is light.

Ghosts (framed at yaw -0.25):
- traps: inline shrug, both shoulders and arms 0.12 torso lengths up, with
  `.between("hand_L", "head", from: 0.95, to: 1.25)`: full with the arms at
  the sides, gone overhead. No turn. BOTTOM: 0.0 s.
- elbow: `elbowsFolded(.forward, 40, strength: .between("hand_L", "head",
  from: 1.25, to: 0.95))`: the hands fold 40° in over the head like a press,
  from shoulder height up (none at k0-5, 0.67 at k7, all of it k8-14). The
  first draft's `(.forward, -60)` tipped the forearms outward and down
  overhead and crossed them in front of the pelvis at the bottom. No turn.
  1.58 s (top).
- torso: `leanedBack(12, arch: 0.08).seen(-1.2)` (trunk and arms 12° back,
  spine 0.08 and chest 0.036 forward; total -1.45; 0.99 vs 0.26). Any;
  1.58 s (top).
- height: `armsTurned(.forward, -70, ...between hand_L-head 1.15..0.85)`
  (the arms turned 70° back down to shoulder height; none at 1.15, all of it
  at 0.85). No turn. Top only: 1.58 s.
- path: `armsTurned(.up, 30).seen(-1.2)` (the arms swung 30° forward about
  the trunk's long axis, into a front raise; total -1.45). Any. Best seen
  mid-rep: with the arms nearly vertical at the top, a turn about the trunk's
  long axis moves the hands only ~0.08 torso lengths, so its still is set
  mid-rep, 0.8 s.

## Cable External Rotation (`cableExternalRotation`)

Model: pulley at 1.13 m (elbow height) 0.42 m to the lifter's right, a single
handle in the left hand, elbow 86-95° against the side (upper arm 2-5° from
vertical), thumb up; the forearm turns from ~35° across the stomach to ~58°
out. Right hand on the hip. No towel roll.

Claims:
- Setup (elbow-height pulley, far arm, elbow against the side, forearm across
  the belly, fixed 90°): ExRx Cable Standing Shoulder External Rotation.
- Infraspinatus and teres minor are the external rotators the exercise loads;
  a pinned elbow keeps the deltoid out (Reinold 2004; ExRx synergists).
- Towel roll: Reinold 2004 tested standing ER at 0° with and without a towel
  roll, and Reinold 2009 reports from it a 20-25% rise in infraspinatus and
  teres minor EMG with the towel, which also helps keep the form. The model
  has no towel, so the elbow cue's correct step offers one as optional (a
  small rolled towel there helps if you have one).

Activation: Infraspinatus P 0.80, Teres Minor P 0.76, Posterior Deltoid S
0.26. Reinold 2004 found the teres minor at least as active as the
infraspinatus in external rotation at 0° abduction (side-lying 67% vs 62%
MVIC, the top ER exercise for both), so both are listed as prime movers.
Reinold also measured standing ER at 0° (with and without a towel), but the
abstract gives only the side-lying maxima and the full-text table was not
accessible. The infraspinatus stays first only as ExRx's named target. The
deltoid is kept low because the pinned elbow gives it little to do; the
fractions are not measured values.

Ghosts (framed at yaw -0.3; every still 1.58 s, the end of the turn with the
forearm furthest out):
- elbow: `armsTurned(.forward, 25, side: "L")` (the left arm swung 25° out
  about the shoulder, the elbow drifting out from the side). No turn. Any.
- angle: `elbowsFolded(.lateral, -35, side: "L")` (the hand turned 35° about
  the elbow: the elbow opening, the hand dropping). No turn. Any.
- shoulder: `leftShrugged` (the left shoulder and arm 0.12 up). No turn.
  Any.
- torso: `leftTwistedOpen.seen(-1.1)` (the trunk and arms turned 20° about
  the pelvis around the long axis, the left shoulder back; total -1.4; 0.95
  vs 0.37 at the end of the turn). Any.
- stance: `leftArmTrunkTipped(-12)` (the trunk, shoulders and left arm tipped
  12° to the lifter's left, leaning away from the stack on the right). No
  turn. Any.

## Cable Internal Rotation (`cableInternalRotation`)

Model: the mirror setup, pulley at elbow height 0.95 m to the lifter's left,
handle in the left (near) hand, elbow 86-95° at the side; the forearm turns
from ~58° out to ~40° across the stomach. Right hand on the hip.

Claims:
- The subscapularis is the target; the pectoralis major, latissimus dorsi and
  teres major are internal rotators themselves and assist even with the
  elbow pinned (ExRx Cable Standing Shoulder Internal Rotation synergists;
  Decker 2003 recorded them with the subscapularis in IR at 0°). The copy
  says so: the elbow cue has the subscapularis leading with the chest and
  lats assisting, and letting the elbow drift forward turns the rotation
  into a chest-led swing (shoulder flexion/horizontal adduction) instead.
  Reinold 2009 (reviewing Decker 2003) says the same: at 0° abduction the
  subscapularis is assisted by the pectoralis major, latissimus dorsi and
  teres major, and IR at 90° abduction gave less pectoralis major activity.
- Rolling the shoulder forward is scapular protraction: the shoulder blade
  carries the hand across, so the hand travels further while the
  glenohumeral joint turns less. (Earlier copy blamed the pectoralis major
  for this; that was dropped.)

Activation: Subscapularis P 0.78 > Pectoralis Major 0.48 > Latissimus Dorsi
0.36. Decker 2003 is the direct study (upper subscapularis above lower in
every exercise except IR at 0°, where Reinold 2009 reports the two portions
similar); its full-text values were not accessible, so these are rank
only. Note Decker's own finding that push-up plus and diagonal exercises load
the subscapularis more than plain internal rotation.

Ghosts (framed at yaw -0.3; every still 1.58 s, the end of the turn with the
forearm across the body):
- elbow: `armsTurned(.lateral, 25, side: "L").seen(-0.9)` (the left arm swung
  25° forward about the shoulder, the elbow drifting forward off the side).
  Total -1.2, a front-left three-quarter, where the pulley housing clears the
  shoulder. Any.
- angle: `elbowsFolded(.lateral, -35, side: "L")`. No turn. Any.
- shoulder: inline, the shoulder rolling forward: the left shoulder, elbow
  and hand 0.16 torso lengths forward, drawn from the neck and along the
  shoulder line, so the neck-to-shoulder segment tips forward past the neck.
  `.seen(-0.9)`, total -1.2. Any.
- torso: `leftTwistedIn.seen(-1.2)` (the trunk and arms turned 20° about the
  pelvis around the long axis, the left shoulder forward; total -1.5, with
  the real shoulders edge-on, so the twist fans them out instead of folding
  them onto the spine). Any.
- stance: `leftArmTrunkTipped(12)` (tipped 12° to the lifter's right,
  leaning away from the stack on the left). No turn. Any.

## Powell Raise (`powellRaise`)

Model: lying on the right side along a flat bench, knees bent (~101°) and
stacked, right arm stretched past the head. The left arm stays at right
angles to the trunk (elbow ~170°) and sweeps from about 35° below level in
front of the chest (the wrist 0.58 m off the floor, about level with the
0.47 m bench top; it never hangs toward the floor) to pointing at the
ceiling (~12° short of vertical, tilted back): side-lying horizontal
abduction, palm toward the feet. The label, range cue and setup say low to
straight up, not floor to ceiling.

Claims:
- This model is on a flat bench, which matches ExRx's Dumbbell Side Lying
  Rear Delt Raise (lying on the side, dumbbell in front of the chest, upper
  arm kept perpendicular to the trunk with a slight elbow bend, raised from
  the floor until above the shoulder). The Prehab Guys (Powell Raise -
  Dumbbell) use an inclined bench but the same arm path: arm lifted toward
  the ceiling pulling with the shoulder blade, felt at the back of the
  shoulder and between the shoulder blades, no rocking, no shrugging. Rehab
  Hero uses the Powell name for an incline (30-45°) abduction to 90° aimed
  at the lateral deltoid and supraspinatus, a different movement.
- Lying on the side, the load is highest with the arm pointing forward and
  zero at vertical (NSCA 2016 moment arm); at the model's bottom it is still
  cos 35° ~0.83 of the peak.
- Cools 2007 found low upper-to-middle/lower trapezius ratios in two
  side-lying exercises (external rotation and forward flexion), prone
  horizontal abduction with ER and prone extension; side-lying horizontal
  abduction (the Powell raise) was not tested, so this only supports the
  no-shrug cue indirectly.

Activation: Posterior Deltoid P 0.80 > Lateral Deltoid 0.54 > Infraspinatus
0.50 > Middle Trapezius 0.48. ExRx's target/synergist list for the
side-lying rear delt raise (target posterior deltoid; lateral deltoid,
infraspinatus, teres minor, middle/lower trapezius synergists). Reinold 2004's
prone horizontal abduction at 100° with ER drove the posterior (88%) and
middle (87%, its highest of all seven exercises) deltoid to near-equal MVIC,
while the infraspinatus peaked in side-lying ER (62%) instead, so the lateral
deltoid is moderate, not low (it was 0.36 LOW in the first draft). It stays
below the posterior deltoid because the lift is horizontal abduction at
~80° elevation with no gravity load on the elevation itself (lying on the
side, gravity acts across the body) and ExRx names the posterior deltoid as
the target. Grip: the model's handle lies across the body (no component
toward the head; checked from the dumbbell mesh's long axis), palm toward
the feet, which is the pronated-grip equivalent of a reverse fly, not the
neutral thumbs-up grip. Schoenfeld 2013 found the neutral grip raised
posterior deltoid and infraspinatus activity over the pronated one, so with
this hand position the infraspinatus is kept moderate and just below the
lateral deltoid. (ExRx's side-lying version has the palm facing down with
the arm reaching forward, which reads as the neutral, thumb-toward-the-head
grip; the copy follows the model.) Townsend 1991 lists horizontal
abduction with ER among the four exercises consistently most challenging for every
glenohumeral muscle, but this model is not externally rotated. The library's
primary muscle is ROTATOR CUFF; the panel leads with the posterior deltoid
(see concerns).

Ghosts (framed at yaw 0.8):
- body: `leftRolledBack(30).seen(-0.3)` (rolling back to throw the weight
  up: the trunk, shoulders and left arm turned 30° about the pelvis around
  the long axis, the chest rolling back toward the ceiling; the shoulder line
  turns ~0.15 torso lengths at each end). Total 0.5, seen from the feet at a
  three-quarter. Any; 1.33 s (top).
- scapula: `leftShruggedLying.seen(0.6)` (the left shoulder and arm 0.2 up,
  toward the ear along the bench, ending between the neck and head points,
  the head and neck drawn). Total 1.4. Any; 1.33 s.
- elbow: `elbowsFolded(.up, 50, side: "L").seen(-0.6)` (the hand folded 50°
  about the elbow; total 0.2; 0.99 vs 0.72-0.77). Any; 1.33 s.
- path: `armsTurned(.forward, -22, side: "L").seen(0.6)` (the arm drifting
  toward the hip: swung 22° in the trunk's plane at full length, the hand
  ~0.34 torso lengths at the top, almost none at the bottom where the arm
  points forward). Total 1.4. Any; 1.33 s (top).
- range: `armsTurned(.up, -30, side: "L", ...between hand_L-hand_R
  1.2..0.85)` (the arm swung 30° back, stopping about level with the
  shoulder instead of angling down in front of the chest; none once the
  hands are 1.2 torso lengths apart, all of it at the bottom, ~0.85). No
  turn. BOTTOM only: 0.08 s.

## Fault-review stills

`fault_times.py` reads each fault's still from the fault_moments below
(bottom / top / any; for a raise top = hands highest and any = top, for the
rotations top = end of the turn). Faults drawn only at the other end of the
rep are marked bottom: `Leaning Lateral Raise|range`,
`Incline Lateral Raise|range`, `Cable Y-Raise|cross`, `Powell Raise|range`,
`Lu Raise|traps`. The elbow faults of the raises are now gated to the upper
part of the rep, so they are top. `Lu Raise|path` shows best mid-rep and is
small at the top (see above), so its still is set mid-rep. The times are in
`bottoms.json` as "Exercise|cue".

| Exercise | Moments (still, s) |
|---|---|
| Leaning Lateral Raise | lean any, traps top, elbow top, support any (1.58); range bottom (3.83) |
| Incline Lateral Raise | body any, traps top, elbow top, path top (1.58); range bottom (0.0) |
| Chest-Supported Lateral Raise | pad any, traps top, elbow top, path top, height top (1.58) |
| Y-Raise | pad any, traps top, neck any, elbow top, height top (1.58) |
| Cable Y-Raise | torso top, traps top, elbow top, height top (1.58); cross bottom (3.5) |
| Lu Raise | elbow top, torso top, height top (1.58); traps bottom (0.0); path mid-rep (0.8) |
| Powell Raise | body top, scapula any, elbow any, path top (1.33); range bottom (0.08) |
| Cable External Rotation | elbow, angle, shoulder, torso, stance at the end of the turn (1.58) |
| Cable Internal Rotation | elbow, angle, shoulder, torso, stance at the end of the turn (1.58) |

## Layout

All nine carry `overrides`. The arms sweep rows 0.32-0.50 on their side of
the frame, so arm labels sit at 0.14 or below the hands. Some joints were
chosen to keep dots apart: Y-Raise traps on `scapula_R` (the trapezius
anchor sat on the head's dot) and elbow on `forearm_R`; Chest-Supported
elbow on `forearm_R`; Lu Raise traps on `attachment_TrapeziusUpper_R`.
Pass 2 moved four layouts after a leader/pill crossing check over the eight
probed samples: the Leaning range pill to row 0.68 (at 0.50 it covered the
dumbbell at the bottom); the two cable rotations to elbow 0.32 / torso 0.50
leading / angle 0.68 (the angle leader ran through the elbow pill with the
hand out); the Cable Y-Raise to height 0.32 / elbow 0.50 / cross 0.68 /
torso 0.86 trailing (the cross leader was long and the torso pill sat on
the knees). The checker now finds no crossings except the Cable Y-Raise's
elbow and height leaders at two of eight samples, the best of a search over
rows and sides; the cross leader still reaches across the trunk at the top,
since it tracks hand_R. Check in the simulator.

## Glows

Single-arm lifts: one activation glow on the working deltoid (or cuff) and
one soft. The bilateral raises put an activation glow on each deltoid (as
the existing Dumbbell Lateral Raise) with a soft one on the traps; the
Y-Raise puts the activation glow on the lower trapezius between the shoulder
blades and soft ones on the deltoids.
