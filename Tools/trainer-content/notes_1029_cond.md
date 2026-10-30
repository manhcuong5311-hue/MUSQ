# Round 2026-10-29, cond family — Sled Push, Sled Drag, Rowing Machine, Battle Rope
# Alternating Waves, Battle Rope Slams, Medicine Ball Chest Pass, Medicine Ball Slam

Seven model-only lifts given `ExerciseContent`. This is the last family of the round:
with it, **36 of 36** are written and `spec_1029.py` reports `OK (36 exercises)` with
nothing left unwritten.

## Framing

| lift | folder | frames | duration | load meshes |
|---|---|---|---|---|
| Sled Push | Legs/SledPush | 192 | 7.958 s | 9 (6 cylinders, 3 cubes, 1 032 pts) |
| Sled Drag | Legs/SledDrag | 192 | 7.958 s | sled + strap |
| Rowing Machine | Back/RowingMachine | 192 | 7.958 s | 18 |
| Battle Rope Alternating Waves | Shoulder/BattleRopeAlternatingWaves | 192 | 7.958 s | rope |
| Battle Rope Slams | Shoulder/BattleRopeSlams | 192 | 7.958 s | rope |
| Medicine Ball Chest Pass | Chest/MedicineBallChestPass | 192 | 7.958 s | Sphere + Cube |
| Medicine Ball Slam | Abs/MedicineBallSlam | 192 | 7.958 s | Sphere |

All seven are 192 frames at 24 fps, unlike the jump family's two 384-frame clips.

**Off-screen geometry is the trap of this family.** Four of the seven carry load that
runs far outside the frame, so every distance figure in the module is the CLIPPED one
and says so:

* Sled Push: raw u −0.4105..+0.2957 (0.7062 of frame width). 58% of that span is off
  the left edge; clipped it is u 0.0110..0.2957 = **108.8 px of 382** (not 113, which
  is max-u × 382). Per mesh: both posts 100% visible, the three plates 33.3% each,
  the two runners and the deck 50% each, and the centre pin (raw −0.0859..−0.0516)
  never visible at all.
* Rowing Machine: raw u −0.480..0.998. Four of the 18 meshes are never visible.
* Battle Rope: the rope reaches u −6.77.
* Medicine Ball Chest Pass: the ball leaves the left edge at f11 and is entirely off
  frame for 11 frames of every rep.

## How the models were read

`_A.json` per lift (26 joints world xyz, 26 projected UV, 10 angle channels, load
centroids, per-mesh boxes and projected points), `_SIL.npz` (skinned silhouette, 655
rows per frame) and `_HEAD.npz` (the head's own silhouette). Layout was measured, not
drawn: `room.py` for all ten slots at any label length, `lead.py` for leader-vs-head,
`chk.py` for the installed module end to end.

**The metric conventions matter and are easy to get wrong.** Every period/lag figure
here is the Euclidean per-joint distance, max over the 26 joints and all frames,
circular. That convention was calibrated against a known value before anything was
trusted: it reproduces Rowing Machine's lag 48 at 914.203232 mm exactly, where the
max-abs-component metric gives 912.894222. Freeze sweeps use a 0.001 mm tolerance
(1e-9 finds nothing). Frame counts are inclusive, and every seconds figure says
whether it is a frame COUNT or a count of frame INTERVALS.

## Label geometry — the result

`chk.py` on the installed module, all 35 pills:

* **35 of 35 pills clear of the skinned lifter on every one of the 192 frames.**
* **35 of 35 leaders zero frames on the head's own silhouette.**

One declared trade, the only one in the family:

| lift | cue | row | what it costs |
|---|---|---|---|
| Sled Push | `drive` "Legs do the pushing" | 0.64 leading | the pill covers the sled's base strip on **all 192 frames** (load 0.0 px) |

Rows 0.64 and 0.80 both hold the sled for the whole 8.00 s, so no low slot on the
five-row grid is free of it. The measured alternative is real but costs more than it
buys: at 19 characters **0.80 trailing is clean of both the lifter and the sled**
(load 125.3 px, 0 frames inside, and `lead.py` shows patella_L clear of the head
0/192) — but row 0.80's leading half already holds `steps` "Short steps", whose
leader runs right across to foot_L at u 0.730–0.845, straight through where the moved
pill would sit. Taking it means moving `steps` off its natural slot too. Recorded as
an open point rather than decided here.

Everything else is clean: Rowing Machine, which looked like the family's Clean-and-Jerk
problem (its machine fills drawn rows 0.48, 0.64 and 0.80 for the whole clip), was
solved by sending its low row trailing — `swing` sits at 0.80 trailing with 13.8 px of
daylight and 0 frames inside.

## Activation rows

Every entry carries exactly **one `Gluteus Maximus` row**, the copy says "glutes", and
no entry names the gluteus medius anywhere — not in a row, not in a stabiliser list.
The rig lights the three glutes as one unsplit group.

| lift | rows | lead row |
|---|---|---|
| Sled Push | 7 | Quadriceps 0.84 |
| Sled Drag | 12 | Quadriceps 0.84 |
| Rowing Machine | 10 | Posterior Deltoid 0.67 |
| Battle Rope Alternating Waves | 11 | Anterior Deltoid 0.84 |
| Battle Rope Slams | 15 | Anterior Deltoid 0.80 |
| Medicine Ball Chest Pass | 8 | Middle Pectoralis 0.88 |
| Medicine Ball Slam | 12 | Rectus Abdominis 0.86 |

cond paints far heavier than jump, so the tables are long and the legend's
`lineLimit(1)` truncation bites: the stills show it on every lift (Sled Push's primary
line ends "GLU…", Rowing's "RHOMBOIDS…"). Open point 5.

## What this session changed in the draft

The drafting workflow produced a module that validated and whose pill geometry
reproduced. It was then attacked from two sides, and **every disputed number was
re-measured here from the raw data rather than taken from the reports** — which was
the right call in both directions, because the reports were wrong in both directions.

**58 fixes applied: 22 to public strings, 36 to gated prose.**

### Public strings (what an unsubscribed reader sees)

`instructions()` shows the SETUP steps and each cue's `title` and `correct`, and
nothing else; `intro`, `why`, `mistake`, the pill labels, `comparison` and
`stabilisers` are all gated, and `mistake` is behind the paywall as well. So these
fourteen were the ones that could actually reach a beginner:

1. **Medicine Ball Slam aimed a beginner's slam ball 10 cm from their own shoes.**
   That number was the rig's, promoted to an instruction. Now "about 20 cm in front of
   your toes" — measured from the toe joint, which sits inside the shoe, so a reader
   pacing it off their shoe tip lands further out still. The only string in the family
   that could have broken a toe.
2. **Medicine Ball Chest Pass had no bail-out for a bad catch** — not in any of the
   entry's 25 strings, while `[catch] correct` actively pushed the reader into it
   ("the rep is not finished until you have absorbed it"). It now says to step aside
   and let an off-line pass go.
3. **Sled Drag's setup described a position the model never holds** ("sit your hips
   back into a quarter squat", against a measured hip angle of 169.7–172.6° and a
   trunk frozen 13.7° *behind* vertical). Now a knee bend with the hips under you.
4. **Battle Rope Slams** forbade at the top what the model does at the top, and
   described a rope landing the clip does not contain. Both rewritten to the picture.
5. **Battle Rope Alternating Waves' only named fault lived in `comparison`**, which no
   view in the app reads. "Shoulders down away from your ears" moved into
   `[torso] correct`.
6. **Rowing Machine never said it is timed**, though `ExerciseCatalog` lists it in
   `timedExercises`. Step 4 now ends on the house phrase.
7. Four setup steps repeated a cue almost word for word a screen apart; three were
   shortened. Chest Pass gained a real throwing distance (two to three metres) instead
   of "a distance you have tried first". Alternating Waves asked for two body lengths
   of floor for a rope that needs three.
8. Eight cue titles named a body part rather than an instruction (`The Arms`,
   `The Feet`, `The Steps`, `The Bent Knees` …) — now `Arms Hang Long`,
   `Feet Stay Set`, `Short Steady Steps`, `Knees Stay Bent` and four more.

Step counts stay 4/4/5/5/4/5/5 and every changed step is under 135 characters.

### Gated prose — 36 corrected numbers

The substantive ones: the sled's clipped width (113 → 108.8 px) and all four per-mesh
visibility shares; "40% of it off screen" was the ON-screen share; Rowing's lag 48 is
beaten by 89 of 191 lags, not 62; Battle Rope Slams' lag 12 is in the top band but is
not the sweep's maximum (16 lags are larger); Sled Drag's lag 16 likewise; the trunk
crosses vertical between f3 and f4, not f2 and f3; Rowing's phase C is f7..f24 (18
frames, 17 intervals, 0.7083 s); the Chest Pass turnaround leaves RISING at 1.559 m/s,
not 1.166 — the draft had paired the arrival with the wrong interval; Medicine Ball
Slam's phases 6–8 are 28 of 48 frames / 27 intervals / 1.1250 s / 58%, three figures
that now agree; the chain's clipped band is 10.7 pixel rows deep, not 1.4; the seat
slip is 6.23 mm (0.308420 − 0.302194), not 6.28; the cycle residual is 7.451e-06 mm on
the Euclidean metric; the head is held 35.267° off the neck-to-chest trunk line; the
ball settles 0.1847 m in front of the toes, not 0.1947; the gluteus medius is the
library's ninth-commonest stabiliser (46 blocks), not its fourth; 5 timed entries end
a setup step on "for the set time", not 11; `timedExercises` runs :130-138.

### Four claims where the critique was wrong and the draft was right

Re-measured and **rejected**, so the draft's text stands:

* **Label count.** 2 323 shipped labels with a median of 18 — the draft's figure
  reproduces exactly; the proposed 2 277 does not.
* **The loop seam.** The seam at i191 is 73.3728 mm and 79.58% of the 191 interior
  steps are strictly below it. The draft's "79.6th percentile" is the standard
  strict convention; the proposed 81.2 is the at-or-below one.
* **Sled Drag's screen scale.** foot_L is **4.5547** mm per pixel row on
  range-over-range — the same convention under which the pelvis gives 4.7608, where
  all four conventions agree. The proposed 4.6426 matches none of them.
* **Peak screen speed of the slam ball.** 84.7 px per frame between f19 and f20, which
  is what the draft already said.

Two further proposed corrections were themselves wrong in detail and were applied with
measured values instead: the held Chest Pass ball is **84.6–87.4 px across** (the
critique quoted 42.3–43.7, which is the radius), and the sled's centre pin spans raw
u **−0.0859..−0.0516**.

And one correction the module now carries that neither side had right: **93** shipped
blocks name the gluteus medius (the draft said 89, the critique 88).

## Checks run, in this order

1. `FAM=cond val.py <draft>` → `OK (7 exercises)`
2. `FAM=cond chk.py` on the draft → 35/35 pills clear of the lifter, 35/35 leaders
   clear of the head, one load crossing
3. 58 fixes applied by assert-once patch scripts (each replacement must match exactly
   once or nothing is written)
4. `val.py` and `chk.py` re-run → unchanged geometry, `OK (7 exercises)`
5. `spec_1029.py cond` → `OK (7 exercises)`; `spec_1029.py` → **`OK (36 exercises)`**
6. `integrate_1029.py` → 36 exercises integrated, 0 fault families
7. `Tools/lab/build.sh` → BUILD SUCCEEDED; `shoot_ex.sh` → 21 stills at t0/t2/t4

## Open points for the owner

1. **Sled Push's `drive` pill sits on the sled for all 192 frames.** The clean
   alternative (0.80 trailing) costs `steps` its natural slot — see the table above.
2. **The Rowing Machine's `swing` pill has 13.8 px of daylight from the machine.** It
   is clean, but it is the tightest load clearance in the family.
3. **Medicine Ball Chest Pass row order.** `Quadriceps, Biceps Brachii, Serratus
   Anterior` — the three dim rows are in a defensible but not obvious order.
4. **The `ov()` override population.** 112 of the 290 shipped override dicts route
   through `ov()` rather than writing raw slots literally, and 134 of the remaining
   178 repeat a raw slot. Worth a sweep of its own some time.
5. **Legend truncation.** The legend's two name lines are `lineLimit(1)` (~40
   characters at 375 pt, ~43 at 393). On this family that hides names on every lift.
   A second line, or a shorter joining character, would recover them.
6. **No fault ghosts** have been written for any family in this round, cond included,
   so the mistake view still falls back to the red ring. Flagged every round; still
   outstanding.
7. **Hip Flexors** remains unresolvable by `part_of()`/`MusclePart` and is dropped
   from TARGET MUSCLES wherever it appears.
