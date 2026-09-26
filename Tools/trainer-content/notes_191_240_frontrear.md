# Batch 191-240 — front raises, rear-delt rows, upright rows (2026-09-26)

Files: `spec_191_240_frontrear.py` (copy, activation, setup, glows, label
overrides), `../fault-review/faults_191_240_frontrear.swift.txt` (ghosts).
`python3 spec_191_240_frontrear.py` prints OK, `python3 spec_191_240.py`
prints OK (46 exercises), and a `gen.py` dry run renders all nine entries.
The Swift pieces and table entries type-check against the current
`FaultPoses.swift` (`swiftc -typecheck` on a scratch copy with them pasted
in, nothing in the repo touched).

How the model was read: the briefs, the framing shots, and passes over each
USD (joint angles, hand-to-pelvis distances in torso lengths, where the
bar/plate/handles sit relative to the hands, dumbbell handle axes, machine
parts). Torso length (neck to pelvis) is 0.59 m in every model. New and
changed ghosts were checked with a Python port of `FaultGhost.solve` on the
rig at the moment the still is taken.

Every label layout is pinned with `overrides` and checked by drawing the
pills and leaders to all eight probed joint positions: two cues never share a
joint, no leaders cross at any probed moment, no leader runs through another
cue's pill (the pill drawn 29 pt tall, as `CalloutPill` renders it in the
382x655 viewport), and every dot stays at least about 11 pt clear of every
pill edge, its own included (tightest: the Cable Upright Row elbow dot at the
top of the pull, 11 pt below its pill).

## For the lead: equipment drifts out of sync with the lifter (all nine)

`USDZViewport.playAnimations` loops each animated entity's first clip on its
own (`clip.repeat()`), and in this batch the clips have different time-sample
spans. The skeleton runs frames 7-187 (rotations 1-192 in Rear Delt Row), the
equipment 1-187, barbell collars and sockets 1-182/185/186, cable parts
1-184/190, and the Alternating Dumbbell Front Raise's left dumbbell only 1-91
(the right one 1-187). The older shoulder models are 1-192 throughout. The
framing shots show the result: the Alternating left dumbbell floats in front
of the face while the right arm lifts, and the Cable Front Raise and Cable
Upright Row bars sit at the hips while the hands are at the chest. Every
other model drifts about 6 frames a loop. In the USD itself the bar, plate,
handles and dumbbells follow the hands. The fix belongs in the converter
(`Tools/model-pipeline/convert_all.py`, not touched here): hold every
time-sampled attribute's first and last values at the stage start (1) and
end (192) on the output layer, re-convert 213-216, 220, 221, 223, 225 and 226
(probably the whole 190-240 batch), and re-shoot after a couple of minutes of
looping. The Alternating Dumbbell Front Raise and the two cable entries
should wait for that.

## Sources

| # | Source | Used for |
|---|---|---|
| 1 | Coratella G, Tornatore G, Longo S, Esposito F, Cè E 2020. *Int J Environ Res Public Health* 17(17):6015. doi:10.3390/ijerph17176015 | Frontal raise (thumb-to-thumb, elbows almost straight, to 90°): anterior deltoid and clavicular pectoralis higher than in every lateral-raise variation; medial deltoid and upper trapezius lower. Authors: the front raise mainly works the anterior deltoid and the clavicular pectoralis. |
| 2 | Demirtaş B, Çakır O, Çetin O, Çilli M 2023. *Kinesiologia Slovenica* 29(1):73-87. doi:10.52165/kinsi.29.1.73-87 | One-arm dumbbell front raise to 90°, 14 resistance-trained men, 80% 1RM, EMG normalised to the 1RM effort. Anterior deltoid concentric 51.6% with a pronated grip vs 43.4% with a hammer (palms-in) grip, p<0.05 (supinated 47.0%, not different). The eccentric and medial deltoid differences (medial 27 vs 21% concentric) were not significant. Used to scale the palms-facing plate raise below the overhand raises. |
| 3 | Sweeney S, Porcari JP, Camic C, Kovacs A, Foster C. ACE-sponsored EMG study (UW-La Crosse), *Dynamite Delts: ACE Research Identifies Top Shoulder Exercises*, ACE ProSource, September 2014; reprinted in the ProSource Research Special Issue 2015. https://acewebcontent.azureedge.net/certifiednews/images/article/pdfs/ACEShoulderStudy.pdf (PDF read; tables 1-3). **Not peer reviewed.** | Dumbbell front raise, anterior/medial/posterior deltoid 57/36/9 %MVC. Barbell upright row 33/73/31. 45° incline row (prone on a 45° bench, arms perpendicular to the body, forearms hanging) medial 84, posterior 69. Seated rear lateral raise posterior 73. |
| 4 | McAllister MJ, Schilling BK, Hammond KG, Weiss LW, Farney TM 2013. *J Strength Cond Res* 27(1):181-187. doi:10.1519/JSC.0b013e31824f23ad | Upright row at 50/100/200% of biacromial breadth, one load for all grips (85% of the 1RM at 100%). Significant pairwise differences mainly between 100% and 200%: concentric lateral and posterior deltoid (50 vs 200, 100 vs 200); eccentric lateral deltoid and upper trapezius (all pairs) and middle trapezius (50 vs 200, 100 vs 200). Concentric upper trapezius, anterior deltoid, middle trapezius and biceps did not differ. Biceps fell significantly only eccentrically, 50% vs 200%. Authors' summary: more deltoid and trapezius and correspondingly less biceps as the grip widens. The bar was raised no higher than the xiphoid to keep the humerus from going above horizontal. |
| 5 | Schoenfeld B, Kolber MJ, Haimes JE 2011. *Strength Cond J* 33(5):25-28 | The upright row targets the middle deltoid and upper trapezius. Raising the arms above shoulder height while internally rotated risks subacromial impingement, which peaks at about 70-120° of elevation; MRI and surgical studies found it greatest at 70-90° when the arm is raised without external rotation. Pull the bar as close to the body as possible, pull through the elbows rather than the wrists, raise to just below shoulder height if free of symptoms, and lower, to a pain-free height, if the shoulder hurts. The evidence is anatomical, imaging, surgical and expert opinion, not injury rates. Cites Andersen 2008 for upper trapezius 85% and middle deltoid 78% MVC. |
| 6 | Andersen LL, Kjaer M, Andersen CH, Hansen PB, Zebis MK, Hansen K, Sjøgaard G 2008. *Phys Ther* 88(6):703-711 | 12 women with trapezius myalgia. Upright row upper trapezius 85 ±5% MVC with light loads (3-10 kg); shrug 102 (20-30 kg), lateral raise 97. |
| 7 | Vasconcelos CMWA, Lopes CR, Almeida VM, Krause Neto W, Soares EG 2023. *Int J Strength Cond* 3(1). doi:10.47206/ijsc.v3i1.190 | Seated cable row (21 recreationally trained adults): upper and middle trapezius and posterior deltoid activity rose as shoulder abduction increased (highest at 60° and 90°). Latissimus activity and peak force were higher with the elbows near the sides. |
| 8 | Reinold MM, Wilk KE, Fleisig GS et al. 2004. *J Orthop Sports Phys Ther* 34(7):385-394 | Prone horizontal abduction at 100° with full external rotation: posterior deltoid 88%, middle deltoid 87%, supraspinatus 82% MVIC (fine-wire EMG). |
| 9 | Escamilla RF, Yamashiro K, Paulos L, Andrews JR 2009. *Sports Med* 39(8):663-685 | Rowing-type exercises and prone horizontal abduction show high cuff, deltoid and scapular activity. Scaption with internal rotation (the empty can) increases scapular internal rotation and anterior tilt, which narrow the subacromial space, compared with the full can. The serratus anterior drives scapular upward rotation. |
| 10 | ExRx.net: Dumbbell Rear Delt Row (https://exrx.net/WeightExercises/DeltoidPosterior/DBRearDeltRow); Barbell, Cable and Smith Upright Row (…/DeltoidLateral/BBUprightRow, …/CBUprightRow, …/SMUprightRow); Barbell Front Raise (…/DeltoidAnterior/BBFrontRaise); Cable Bar Front Raise (…/DeltoidAnterior/CBBarFrontRaise). Direct fetches of exrx.net returned Cloudflare 403 on 2026-09-26, so the wording was checked through search-result text of those pages. | Rear delt row: the upper arm stays perpendicular to the trunk with the elbow directly out from the shoulder; closer than perpendicular brings in the lats; a 45° torso is not enough to target the rear delts, keep it near horizontal. Synergists: infraspinatus, teres minor, lateral deltoid, middle/lower trapezius, rhomboids. Upright row: overhand grip, elbows leading, wrists allowed to flex, stand close to the pulley. ExRx pulls the bar to the neck; this copy stops at the upper chest, following 4 and 5. Front raises: overhand, elbows straight or slightly bent, upper arms raised to horizontal or just above. Synergist: clavicular pectoralis. The cable model matches the Cable Bar Front Raise (earlier versions of these notes cited the Cable One Arm Front Raise). |

## Plate Front Raise
**The model:** stands tall with the feet about 0.3 m apart and the knees
about 174°. One plate, about 45 cm across, is held at 3 and 9 o'clock with
the palms facing. The elbows stay soft (153-159°). The plate rises from in
front of the thighs until the upper arms are about 95°, just past parallel.
At the top the plate centre is about 1.53 m high, upright in front of the
face. The torso stays still. Yaw -0.55, so the left arm is on screen right.

**Claims:**
- Activation: anterior deltoid HIGH 0.72, upper pectoralis MODERATE 0.56,
  lateral deltoid MODERATE 0.40. No study of the plate version was found. The
  palms-facing grip is closest to 2's hammer grip, where anterior deltoid
  concentric EMG was about 16% lower than overhand (43.4 vs 51.6%, p<0.05),
  so the anterior deltoid is scaled down from the overhand raises' 0.84. The
  medial deltoid showed no significant grip effect in 2 (21 vs 27%,
  p>0.05), so it keeps the overhand raises' 0.40 rather than being scaled
  down on a difference the study did not show. The clavicular pectoralis has
  no grip data; it keeps the overhand value, still below the anterior
  deltoid (1, ExRx).
- "Where the weight pulls hardest": mechanics. The moment arm is greatest
  with the arm level.
- "Traps and serratus rotate the shoulder blade up" when swinging higher: 9,
  and ExRx's "just above horizontal".
- Grip, shrug and lean cues: technique convention (ExRx and the existing
  front-raise copy). The shared torso why no longer claims a "dead stop"; it
  says a still torso lifts without help from momentum.

**Uncertain:** 1 may show the clavicular pectoralis about as active as the
anterior deltoid (own-MVIC normalisation). Kept secondary and MODERATE,
following ExRx's target/synergist split.

**Labels:** the torso label moved to row 0.32 (its leader crossed the height
leader at the bottom), and the shoulder label is now "Shoulders stay down" so
its pill clears the left hand at the top of the raise. The grip label is now
"Grip at 3 and 9 o'clock" (was "Hands at 3 and 9 o'clock"): at the top of the
raise the height leader, running up to the left hand, grazed the longer grip
pill's lower right corner. The torso pill sits over the lifter's left elbow
at mid-rep (it covers no dot); check in the simulator.

**Fault stills:** all at the TOP, when the hands are highest: 1.58 s.
- `height` (`armsTurned(.lateral, 35)`: the arms swung 35° on past the face
  toward overhead), `elbow` (`elbowsFolded(.lateral, 50)`: the hands folded
  50° about the elbows) and `grip` grow with `frontRaiseRising`: none below
  mid-raise, all of it near the top. `grip` (wrists bent, the plate tilting
  back toward the face: the hand tips turned 48° about the wrist, side-to-side
  axis) was `wristBentBack`, which has no strength and drew the hands
  flicking forward at the thighs; it is now the same move, inline, gated to
  the top.
- `shoulder` (`hunched()`: shoulders and arms 0.07 torso lengths forward and
  0.1 up) and `torso` (`leanedBack(12)`: trunk and arms 12° back about the
  pelvis, no arch) show throughout.
- All five are turned to about -1.35 (`.seen(-0.8)`, or `view: -0.8` for the
  inline grip).

## Barbell Front Raise
**The model:** stands tall with the feet about 0.3 m apart. Overhand grip,
hands about 0.48 m apart (about shoulder-width). Elbows about 170°. The bar
rises from the thighs to shoulder height (upper arms about 89°). Yaw -1.0,
nearly side-on from the left front.

**Claims:** as the overhand front raise (1, 3; anterior deltoid 0.84, upper
pectoralis 0.56, lateral deltoid 0.40). ExRx's barbell front raise matches the
model. The grip-width why is mechanical only: each arm rises in front of its
own shoulder and the bar stays level; bunching the hands angles the arms in
and makes the bar harder to balance. It no longer implies that a narrow grip
works the front deltoid less, which no EMG shows (a narrow grip mostly adds
horizontal adduction, which the anterior deltoid and clavicular pectoralis
both do).

**Labels:** height now points at the right hand from row 0.50 and grip at the
left hand from 0.68 (the two leaders crossed at the top before). The height
label reads "Bar to shoulder level", the same as the cable raise.

**Fault stills:** TOP (1.58 s), except `grip` at the bottom (0.0 s).
- `height` (`armsTurned(.lateral, 50)` with the bar: swung on to about 139°,
  the bar well above the head; this framing leaves room above the head,
  unlike the plate and cable) and `elbow` (`elbowsFolded(.lateral, 50)`) use
  `frontRaiseRising`. The top is about 1.26 torso lengths, so `to` is 1.25
  and the barbell shows the full fault. Both `.seen(-0.35)` (total -1.35).
- `grip` (`gripBunched`: hands and bar 0.22 torso lengths in each side,
  elbows 0.1; always) is turned toward face-on (`.seen(0.6)`, total -0.4) so
  the width shows; read at the bottom, the arms hanging in a V.
- `shoulder` (inline: shoulders, arms and bar 0.07 forward and 0.15 up;
  always) is also turned toward face-on (`view: 0.6`, total -0.4), so the
  shoulder line rises past the neck.
- `torso` (`leanedBack(12)` with the bar; always) is at `.seen(-0.35)`
  (total -1.35).

## Cable Front Raise
**The model:** back to a low pulley, the cable running between the legs to a
straight bar. Feet about 0.36 m apart, knees about 172°, trunk held about 15°
forward from the hips for the whole clip. Overhand grip about 0.47 m, elbows
about 170°. The bar rises until the hands are level with the shoulders. That
is about 105° to the leaning trunk, level with the floor. It matches ExRx's
Cable Bar Front Raise.

**Claims:**
- "The cable resists from the first centimetre, where a dumbbell barely loads
  the deltoid": mechanics. With the pulley behind and below, the cable's
  moment about the shoulder at the bottom is about twice a dumbbell's per unit
  of load, and flatter through the range.
- The slight forward lean and wide base counter the backward pull: mechanics
  plus the model.
- Activation: as the overhand front raises. No cable-specific EMG was found.

**Labels:** height now points at the right hand and stance at the right foot
(it pointed at the right kneecap, not the feet). The torso leader crossed the
height leader at the bottom before; with this layout nothing crosses. At the
bottom the right hand sits just past the end of the height pill, so the
label is "Bar to shoulder level" (21 characters, was "Bar to shoulder
height"): the shorter pill leaves the dot about 12 pt clear instead of 8.

**Model quirk:** the bar left at the hips in the framing shot is the clip
drift described above.

**Fault stills:** TOP, 1.58 s.
- `torso` (`leanedBack(20)` with the bar; always) rocks back 20° from the
  model's 15° forward lean, so it reads as past upright. `.seen(-0.8)`.
- `stance` (inline: feet 0.18 torso lengths in each side, ankles about 15 cm
  apart instead of 36, knees straightened, the trunk and head tipped back 10°
  about the pelvis; always) keeps the default view so the foot width shows.
- `height` (`armsTurned(.lateral, 35)` with the bar), `elbow`
  (`elbowsFolded(.lateral, 50)`), both with `frontRaiseRising`, and
  `shoulder` (`hunched()`, always) are at `.seen(-0.8)` (total -1.35).

## Alternating Dumbbell Front Raise
**The model:** stands tall with the feet about 0.3 m apart. Overhand grip,
with the handles across and the palms to the thighs. Elbows about 170°. The
LEFT arm raises to shoulder height (about 89°) during the first half of the
clip, then the right. The resting dumbbell stays at the thigh.

**Claims:**
- Activation: as the overhand front raise (1, 3).
- Trunk control: a dumbbell out in front of one shoulder pulls the trunk
  forward and toward the working side (mechanics); it does not twist the trunk
  by itself. The twist the copy warns against is the lifter's own cheat, the
  working shoulder swinging forward to throw the dumbbell up, which is what
  the ghost draws. No EMG study of the alternating version was found; the
  obliques are listed as stabilisers only.

**Ghosts:**
- `height` (`armsTurned(.lateral, 35, side: "L")`: the left arm swung 35° on
  above shoulder height) is left-arm only, gated by `frontRaiseRising` on
  `hand_L`, `.seen(-0.8)`. It shows during the left arm's rep only; the
  stills scan the first 4 s, the left rep, so the still works.
- `shoulder` (`shrugged`: shoulders and both arms 0.12 torso lengths up,
  always, no turn) and `elbow` (`elbowsFolded(.lateral, 50)`: both hands
  folded 50°, working and resting arm alike, always, `.seen(-0.8)`) are
  two-sided on purpose, and the labels point at the right shoulder and elbow.
- `alternate`: the trunk, head, shoulders and both arms turned 24° about the
  pelvis around the long axis, so the working (left) shoulder swings forward
  to throw the dumbbell up; the hip line stays square. No turn: the default
  3/4 front view shows the shoulder line turning against the hips and the
  raised hand swinging across. It was `.always`, which drew the left shoulder
  forward during the right arm's rep too; it is now gated by
  `frontRaiseRising`, so it shows only during the left rep and never twists
  the wrong way while the right arm lifts.
- `torso`: `leanedBack(12)` (trunk and arms 12° back; always), `.seen(-0.8)`.

**Fault stills:** TOP of the left rep, 1.58 s.

## Rear Delt Row
**The model:** dumbbells, hinged about 50° forward from upright (hip angle
about 113°, trunk about 40° above horizontal). Knees about 156°, feet about
0.34 m apart. Overhand grip, with the handles lined up with the shoulders
(the dumbbell axis is side-to-side all clip). Both arms row with the elbows
flared: from straight (177°) to about 76°. The upper arms finish square to
the trunk (about 87°) and just past the line of the back, and the hands go
from 0.47 to 0.97 m apart. Seen from behind-left (yaw -2.3).

**Claims:**
- Elbows out at about 90° shifts work to the rear delts and mid-back, and
  tucked shifts it to the lats: 7, plus ExRx's comment.
- Activation, both deltoid heads HIGH (0.78 each): 3's 45° incline row is
  the closest studied lift. It matches the model's roughly 45-50° torso, arms
  perpendicular and forearms hanging, and gave medial 84 and posterior 69 %MVC.
  8 also shows middle and posterior deltoid about equal in horizontal
  abduction. %MVC across muscles is not strictly comparable, so the two heads
  are set equal; rear delt is listed first to match the library entry.
- Middle trapezius MODERATE: 7. Rhomboids MODERATE 0.45: an estimate; surface
  EMG in these studies did not measure the rhomboids, ExRx lists them as a
  synergist.
- Range: the dumbbells' moment on the shoulder is greatest when the upper
  arms are level (mechanics), near the end of the rear deltoid's shortening.
  The copy no longer says the position is fully shortened (the posterior
  deltoid keeps shortening behind the trunk) or that stopping short leaves a
  range untrained.
- Hinge: ExRx says a 45° torso is not enough to target the rear delts and to
  keep it near horizontal; 3's 45° incline row still gave posterior 69 and
  medial 84 %MVC, so 45° works but hands a lot to the side delts. The copy
  now asks for past halfway to parallel, flatter if the hamstrings allow, and
  the why is phrased as mechanics (standing taller turns it toward an upright
  row).

**Uncertain:** the torso is more upright than ExRx's ideal. The copy is
written so that the model is acceptable but not the best case.

**Labels:** the back label is "Flat back" (the longer pill's corner
touched the left elbow's dot at the top of the row); the neck is covered in
the cue text. Its dot is now on the chest joint, the middle of the upper
back seen from behind, instead of the head, so it sits on the part the cue
is about; nothing crosses. The height cue's dot is on the far (right) elbow:
it shows at the back line at the top of the row, but in the lower half of
the rep it projects onto the hips, behind which that arm hangs; check it in
the simulator.

**Fault stills:** TOP, elbows most bent: 1.58 s for all five.
- `elbow` (`rearDeltElbowsTucked`: the arms swung 50° down toward the hips
  about the shoulders, around the chest axis, upper arms about 43° from the
  trunk instead of 87°) grows with elbow bend. `.seen(-0.84)`, total -3.14,
  straight behind, where the tucked arms read against the wide grey ones.
- `height` was `rowedShort`, whose forward shift points at the floor on a
  50° hinge; it moved the elbows only 3 cm. It is now the upper arms turned
  40° toward the chest about the trunk axis, the hands lowered 0.25 and moved
  0.15 ahead (torso lengths, room directions), the elbows re-seated, with
  elbow bend, no turn. At the top the elbows drop about 15 cm, from 8 cm above
  to 7 cm below the shoulders, stay flared (upper arm 93° to the trunk), the
  forearms still hang vertically and the elbow opens from 76° to about 103°.
  It stays clearly different from the tucked-elbow ghost.
- `hinge` (inline: the trunk and head only turned 20° more upright about the
  pelvis, drawn as the spine line alone so it stands out against the grey
  back), `traps` (inline: shoulders and arms 0.16 torso lengths up, sliding
  along the back toward the ears) and `back` (inline: the upper back rounding
  at the chest joint, spine 0.04 and chest 0.11 back, neck 0.04 and head 0.18
  forward, the head dropping) show throughout and are turned to the left side
  (`view: 0.75`, total -1.55).

## Machine Rear Delt Row
**The model:** seated on a chest-supported row machine, chest on the pad,
trunk about 8° forward. Feet flat on the floor (ankles 0.07 m, toes 0.02 m
high), just behind the foot decks; the forefoot clips the decks' front edge.
Knees about 115°. Overhand grip on wide horizontal handles (the Q191
wide-grip bars) level with the shoulders; hand height is constant at
1.15-1.16 m. The elbows travel at shoulder height (upper arms 81-93°) from a
forward reach (elbows about 159°) back to just behind the line of the
shoulders (plane about 102°, elbows about 87-94°). Seen from behind-right
(yaw 2.4).

**Claims:**
- Posterior deltoid primary, middle trapezius and rhomboids secondary: 7 (the
  seated row at 90° abduction is the closest studied lift) plus ExRx.
- Lateral deltoid HIGH 0.70, secondary: 8's prone horizontal abduction loads
  the same horizontal-abduction direction as this machine (gravity does not
  load abduction there either) and shows the middle deltoid about equal to
  the posterior (87 vs 88%); 3's 45° incline row has medial at or above
  posterior. It stays secondary because no study of this machine exists and
  it is sold as a rear-delt lift. (The earlier 0.60 rested on the wrong
  argument that gravity does not load abduction here.)
- Pad cue: the pad takes the trunk out of the lift, so the rear deltoids move
  the handles without a body swing (it no longer says every rep starts from a
  dead stop).
- Seat and shrug cues: technique convention, the same as the existing
  Reverse Pec Deck copy.

**Uncertain:** no EMG study of this machine was found.

**Fault stills:** all at 2.58 s, the most-bent moment of the first pull.
- `seat` (inline: pelvis, hips, trunk, head and shoulders raised 0.2 torso
  lengths, about 12 cm, while the hands stay on the handles; the elbows
  re-seat below the shoulders, so the upper arms slope down to the handles;
  always, no turn).
- `elbow` (inline: elbows 0.16 down and 0.08 in, then re-seated, with elbow
  bend, no turn): the Face Pull's elbow fault.
- `range` was `squeezeSkipped`, which shifts shoulders and elbows forward
  together and changed the upper-arm plane only from 89° to 86°. It is now
  the upper arms turned 35° forward about the trunk axis, the hands 0.2 torso
  lengths forward on the handles, the elbows re-seated, with elbow bend: the
  elbows sit about 30° in front of the torso line (plane 89° to 61°), the
  elbow opens to about 116°, and the hands sit 12 cm further forward at the
  same width and height, which is the model's own mid-rep position.
  `view: -0.8` (total 1.6).
- `traps` (inline: shoulders 0.06 back and 0.16 up, about 9 cm toward the
  ears, the hands staying on the handles and the elbows re-seated; always, no
  turn).
- `chest` (inline: leaning back off the pad straight from the hips: trunk,
  head and shoulders turned 14° back about the pelvis, the head about 17 cm
  back, the forearms and hands 0.21 back at handle height with the
  shoulders, the elbows re-seated; always), `view: -0.8` (total 1.6).

## Upright rows: model vs guidance (all three)
In all three models the correct rep finishes with the upper arms about 110°
from the sides, the elbows about 10 cm (about 20°) above the shoulder joints,
while the wrists stop about 5 cm below the shoulders. That is a little past
5's "just below shoulder height" and 4's xiphoid limit. The copy follows the
guidance without endorsing more height: the label is "Stop near shoulder
level" (24 characters; the earlier "Elbows near shoulder height" was 27 and
its pill ran over the top of the head on the cable and Smith rows), the
comparison says "Elbows near shoulder height", the text says around
shoulder height and no higher, and to stop lower if the shoulder pinches.
The `uprightRowHigh` ghost (bar to the chin, elbows about 130°) is still
clearly worse. A re-export that stops at about 90-95° would match the copy
exactly; that is for the lead to decide.

## Barbell Upright Row
**The model:** stands tall with the feet about 0.3 m apart. Overhand grip,
hands 0.42-0.50 m apart (about 100-125% of the rig's shoulder breadth). The
bar rises close to the body (hands 0.17-0.24 m in front of the shoulder
joints) from the thighs to the upper chest. The elbows lead and finish as
above; the elbows are about 55°. The rig does not shrug.

**Claims:**
- Grip width: 4. Side-delt and trap activity rose as the grip widened, most
  clearly at about twice shoulder-width, and biceps activity fell; a very
  narrow grip gives more of the pull to the arms. The copy no longer says a
  narrow grip "turns the pull into an arm curl". ExRx says shoulder width or
  slightly narrower; the copy follows 4 and 5: about shoulder-width or a
  little wider.
- Elbows lead and wrists bend: 5 and ExRx.
- Bar close to the body: 5. The front-of-shoulder and lower-back loading is
  mechanics.
- Height: 5 and 9. Raising the arms well above shoulder height while turned
  in narrows the space under the point of the shoulder and can irritate
  sensitive shoulders; stopping around shoulder level limits that squeeze.
  The copy no longer says it removes the pinch, nor that chin height is "the
  position most likely" to pinch the tendons (5 rests on imaging, surgical and
  expert evidence, not injury data), and it now tells lifters to stop lower if
  it pinches.
- Activation, lateral deltoid and upper trapezius both HIGH (0.80 each): 3
  (medial 73 %MVC), 5 and 6 (upper trapezius 85, middle deltoid 78). Anterior
  deltoid LOW 0.36: 3 (33 %MVC). Biceps LOW 0.30: 4 shows biceps involvement
  that falls as the grip widens; the size is an estimate.

**Labels:** grip (right hand) moved from row 0.50 to 0.68 on the left, and
torso (pelvis) from 0.68 on the left to 0.68 on the right. At 0.50 the grip
pill ran under its own dot at the bottom of the rep (the right hand at v 0.47,
inside the pill's width), so the leader was hidden and the dot sat on the
pill's top edge. At the bottom the torso dot (pelvis) and the bar-path dot
(left hand) nearly coincide on screen; that is the model's pose and stays.

**Fault stills:** TOP, elbows most bent (1.58 s), except `grip` at the
bottom (3.83 s).
- `height` (`uprightRowHigh`) and `elbow` (`uprightRowElbowsLow`) grow with
  elbow bend; no turn (see New fault pieces).
- `grip` (`gripBunched`: hands and bar 0.22 torso lengths in each side,
  elbows 0.1) shows always, no turn; clearest at the bottom, where the
  hanging arms form a V against the parallel grey arms.
- `barpath` (`barDrifting(0.25, 0.12)`: hands and bar 0.25 ahead, elbows
  0.12, the bar about 15 cm out in front of the body; always) and `torso`
  (`bodySwung` with the bar: hips 0.06 ahead, trunk and arms 15° back about
  the pelvis; with elbow bend) are turned to -1.0 (`.seen(-0.2)`), where the
  near plate sits clear of the chest.

## Cable Upright Row
**The model:** the same pull, facing a low pulley a short step away; the
cable runs about 20-30° off vertical. Straight bar, overhand 0.47-0.54 m,
elbows 153° down to 55°, upper arms to about 111°. Yaw +0.6, right side
toward the camera. The bar left at the hips in the framing shot is the clip
drift described above.

**Claims:**
- As the barbell version.
- "Stand close to the pulley": ExRx. Pulling mostly downward keeps the bar
  near the body: mechanics.
- Lean-back cue: mechanics, since the cable pulls toward the stack.
- No cable-specific EMG was found.

**Fault stills:** TOP (1.58 s), except `grip` at the bottom (3.83 s).
`grip`, `elbow` and `height` are the barbell row's pieces, no turn.
- `stance` (inline, standing a big step back: feet, legs, pelvis, trunk and
  shoulders 0.4 torso lengths, about 24 cm, further from the pulley, the
  hands and bar 0.15 back, so the bar is dragged out about 15 cm further in
  front of the chest, the elbows re-seated; always) and `torso`
  (`leanedBack(14)`, bar carried, which a cable allows; always) are turned to
  the right side (`view: 0.9` / `.seen(0.9)`, total 1.5).

## Smith Machine Upright Row
**The model:** the same pull on a Smith bar. The bar sits 16-18 cm in front
of the ankle joints, just in front of the thighs; at the bottom it is at about
0.84 m, the top of the thighs (hip 0.91 m, knee 0.47 m; the nearest hook peg
below is at 0.79 m). Overhand grip 0.42-0.51 m, elbows 178° down to 45°, upper
arms to about 110°. Yaw -0.5.

**Claims:**
- As the barbell version. Nothing Smith-specific is claimed beyond the fixed
  vertical path and where to stand.
- Setup: the bar is set at the top of the thighs (it said mid-thigh, which is
  not where the model's bar sits; ExRx's Smith Upright Row racks it at
  mid-thigh, but the copy follows the model).
- No Smith upright row EMG was found.

**Labels:** the height cue points at the right elbow from the left and the
elbow cue at the left elbow from the right; with the shorter height label the
pill now ends at u 0.45, clear of the head (0.52).

**Fault stills:** TOP (1.58 s), except `grip` at the bottom (3.83 s).
`grip`, `elbow` and `height` are the barbell row's pieces, no turn.
- `torso` was `leanedBack(12, withBar: true)`, which carried the hands and
  the bar line back about 10 cm with the trunk, something the rails cannot
  allow. It is now the trunk, head and shoulders turned back 12° about the
  pelvis with the hands left on the bar and the elbows re-seated, with elbow
  bend: at the top the bar stays put, the trunk leans back 12° and the elbow
  opens from 45° to 70°. `view: -0.4` (total -0.9).
- `stance` was `barDrifting`, which moved the bar 7 cm ahead of the body and
  so off the rails. It is now the reverse of `crowdingTheStack`: the whole
  body (feet, legs, pelvis, trunk, shoulders) stands 0.25 torso lengths
  (about 15 cm) further back while the hands stay on the bar, which the
  rails hold in place, so the arms reach forward to it; the elbows are
  re-seated, always on. Turned to -0.9 (`view: -0.4`), where the near plate
  sits clear of the chest.

## New fault pieces
- `frontRaiseRising`: a `between("hand_L", "pelvis", 0.9 -> 1.25)` strength
  for faults of the top of a front raise. Bottom is about 0.45-0.56 and top
  1.26-1.49 in these four models. It now also gates the plate's wrist fault
  and the alternating raise's twist.
- `rearDeltElbowsTucked`: upper arms turned -50° about the chest axis (toward
  the hips, about 43° from the trunk instead of 87°), with elbow bend.
- `uprightRowHigh`: hands and bar up 0.45 and elbows up 0.3 and out 0.03
  torso lengths, the elbows re-seated between the shoulders and the raised
  hands, with elbow bend: the bar (palms) up to the chin, about 10 cm above
  the shoulder joints instead of 17 cm below, the elbows about 18 cm above the
  shoulders.
- `uprightRowElbowsLow`: elbows shifted 0.45 down and 0.25 in, then re-seated
  between the shoulder and the fixed hand (the shift only picks the
  direction), with elbow bend: the elbows trail about 25 cm below the
  shoulders and below the bar, curled up with the wrists.
- `gripBunched`: hands and bar 0.22 in each side, elbows 0.1, always: the
  hands about 16-22 cm apart instead of 42-48. Used by the barbell front
  raise and all three upright rows.
- The rear-delt short-rep, hinge, traps and back; the machine seat, elbow,
  short-range, traps and chest; the barbell front raise shoulder; the cable
  front raise and cable upright row stance; the Smith lean-back and
  stand-back; the plate-wrist and alternating-twist faults are written inline
  in their table entries, each with a comment, since each is used once.

Every cue has a ghost. None of the mistakes are about speed alone.

## Review round (2026-09-26): what changed and what did not
Applied from the two reviews: the upright-row height copy and comparison
(safety wording, "near shoulder height", stop lower if it pinches), the
McAllister grip why and source line, the alternating twist copy and its gated
ghost, the plate's hammer-grip activation (Demirtaş 2023; the lateral deltoid
was first set to 0.35, then put back to the suggested 0.40 in the second
round, below), the rear-delt row range and hinge copy, the machine's lateral
deltoid (HIGH 0.70) and pad why, the barbell front raise grip why, the
citation details (Escamilla, ExRx Cable Bar Front Raise and upright-row
height, Andersen subjects and loads, ACE date), the Plate, Barbell and Cable
Front Raise label layouts, the Smith lean-back, rear-delt short-rep and
machine short-range ghosts, the gated plate wrist ghost, the machine's feet
(flat on the floor) and the Smith bar height in setup. The rear-delt
short-rep ghost also moves the hands ahead so the forearms stay vertical
(the suggested version tilted them about 26°). Also: the rear-delt back label
and the plate shoulder label were shortened, and the Smith height/elbow
labels swapped sides, so no pill sits on a cue's dot.

Not done here: the clip-span fix (converter, for the lead) and any re-export
of the upright rows to stop at 90-95° (for the lead).

## Second review round (2026-09-26)
Every finding from both reviews was re-checked against the current files;
all but one were already in. Changed in this round:
- Plate Front Raise: lateral deltoid back to MODERATE 0.40, as the evidence
  review proposed. The first round's 0.35 scaled it down on a medial-deltoid
  grip difference that Demirtaş 2023 found not significant.
- Smith Machine Upright Row: the stance ghost keeps the bar on the rails and
  moves the body back (see above).
- Upright rows: the height label is now "Stop near shoulder level" (24
  characters), clearing the head on all three.
- Rear Delt Row: the back label's dot moved from the head to the chest joint.
- ExRx: the sources table now says the pages were checked through search
  text (direct fetches were blocked), instead of "read".
Checks: `python3 spec_191_240_frontrear.py` OK, `python3 spec_191_240.py` OK,
the gen dry run renders all nine, the eight-probe layout check finds no
crossings and no pill over a dot, and the family Swift spliced into a
scratch copy of `FaultPoses.swift` passes `swiftc -typecheck`.

## Third review round (2026-09-26)
The full findings of both reviews (and the first reviser's report) were
checked again, one by one, against the current files; every applicable one
was already in. The sources were re-opened: Coratella 2020 (PMC full text),
Demirtaş 2023 (PDF: hammer 43.36 vs pronated 51.57% anterior deltoid, p<0.05;
medial 21.11 vs 26.82%, not significant), the ACE PDF (tables 1-3), McAllister
2013 and Schoenfeld 2011 (full text), and the Andersen 2008, Reinold 2004 and
Escamilla 2009 abstracts (PubMed); the ExRx pages again only through search
text. The family's pieces and table in `FaultPoses.swift` are identical to
`faults_191_240_frontrear.swift.txt` (already integrated); no ghost changed
in this round. The clip spans were re-read: still unequal (skeleton 7-187,
Alternating left dumbbell 1-91, cable parts 1-187), so the lead's converter
fix is still needed. Changed:
- Barbell Upright Row labels: grip to 0.68 leading, torso to 0.68 trailing
  (the grip pill ran under its own dot at the bottom of the rep).
- Plate Front Raise: grip label "Grip at 3 and 9 o'clock" (the height leader
  grazed the longer pill at the top).
- Barbell and Cable Front Raise: height label "Bar to shoulder level" (the
  cable raise's dot sat 8 pt from its pill at the bottom).
- Sources: URLs for the ExRx pages and the ACE PDF; the Vasconcelos line
  reads "rose as abduction increased (highest at 60° and 90°)" in both the
  spec header and this table.
Checks: `python3 spec_191_240_frontrear.py` OK, `python3 spec_191_240.py` OK,
the gen dry run renders all nine, and the eight-probe layout check (pills
29 pt tall) finds no crossings, no leader through another pill, and every dot
at least 11 pt from every pill edge.
