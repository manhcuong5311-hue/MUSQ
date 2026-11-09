# Burpee (497): notes for `burpee_content.swift` (2026-11-09)

Inputs: `brief.md` (model measurements and paint), `frames.json` (re-read for the figures below),
`burpee_sources.md` (research; nothing re-researched; the NASM, CrossFit and NSCA local copies in
`src/` were opened only to confirm wording). Short names below: **B** = brief.md, **S** = burpee_sources.md
(section number), **F** = frames.json, rep 1.

What the file holds: 5 annotations and 5 cues in rep order (ids `down`, `back`, `push`, `in`, `jump`),
9 rows, 1 stabiliser, 4 setup steps, a HIPS SAGGING comparison, 4 glows (section 7, F5). Every `labelPoint` is the
0.5/0.5 placeholder and `labelSide` is left at its default for the layout tools. After the revision it still
typechecks against the real type shapes (`xcrun swiftc -typecheck`, stubs copied from `AnatomyModels.swift`,
`Effects.swift` and `Theme.swift`: `rev_tools/stubs.swift`); labels are 9-25 characters, setup steps 76-100,
no double quotes or backslashes.

Vietnamese: `burpee_vi.json` (section 8), all 50 shown strings, keyed by the exact English.

Not done here: the `"Burpee": burpeeContent` map entry, label layout, the ghost, the tile.

---

## 1. Cue choice and order

| # | id | Title | Rep 1 window (B) | Why this phase gets a cue |
|---|---|---|---|---|
| 1 | down | Squat Down | 0.00-0.96 s, hands land 0.96 s, feet leave 1.29 s | NASM step 3, Gist Fig. 1, StrengthLog step 2 all start with a squat and hands down; NSCA puts the weight shift before the kick back (S 1.1, 1.2) |
| 2 | back | Jump Back to a Plank | 1.29-1.54 s airborne, plank from ~1.58 s | NASM mistake 3 (sagging hips in the plank), the comparison's fault; Podstawski 3-MBT plank rule (S 1.2, 2) |
| 3 | push | Chest to the Floor | 1.58-3.08 s, bottom 2.50 s | NASM mistake 2 (sloppy or no push-up), CrossFit fault 2 (S 2) |
| 4 | in | Jump the Feet In | 3.12-3.38 s airborne, lands 3.42-3.50 s | CrossFit fault 1, knees caving on the jump-in (S 2) |
| 5 | jump | Jump and Land | hands up ~3.54 s, take-off ~4.35 s, lands 4.75 s, stands by ~5.29 s | NASM mistake 1 (straight-knee landing), CrossFit fault 3 (short jump), NASM mistake 5 (no reset) (S 2) |

The jump and the landing share cue 5 because the four floor phases each carry a named fault. The
landing is taught in cue 5's `correct`, `why` and `mistake`; the label goes to the arms (section 2).

## 2. Labels and joints

Near side: the trainer yaw -0.8 turns the lifter's left (+x) toward the camera (`proj.py`: depth
z' = 0.717x + 0.697z). So where either side would do, the left joint is used.

| Label | Chars | Library | Joint | Why this joint |
|---|---|---|---|---|
| Hands to the floor | 18 | new (no hands-down label in the library) | hand_L | The cue is the hands' placement; near-side hand. The parent's layout test used the same label and joint (`layout.json`). |
| Body in one straight line | 25 | reused, x7, every use on `pelvis` (Push-Up and others) | pelvis | The hips are what sag or pike. This label goes with the comparison (HIPS SAGGING). |
| Chest to the floor | 18 | new; the library's push-up depth label "Chest to just above the floor" (x2) is a different depth | chest | The cue is the chest's depth, which is where Push-Up's depth label sits. The parent's test had it on `forearm_L`, but the house rule puts it on the body part named. |
| Knees out | 9 | reused, x9 (squats), 7 on `patella_R` and 2 on `patella_L` | patella_L | The knees tracking out on the jump-in landing; near-side knee. |
| Arms overhead | 13 | new (the closest, the Medicine Ball Slam's "Reach tall", is a ball reach) | hand_R | The wrists finish 31 cm above the head. `hand_L` is taken by cue 1. The parent's layout test placed this label on `hand_R`. |

Why "Chest to the floor" and not the reused push-up label: B and the task call it a chest-to-floor push-up.
F shows the chest joint at 24.3 cm above the floor at 2.50 s, 20 cm above the wrists. In the render
`occ/v_2.52.png` the pecs are down at floor level. StrengthLog's step 4 says to take the chest down to the floor.

## 3. Claim-to-source map (user copy)

### Cue 1, down
- Squat by bending the knees and hips; hands flat in front of the feet. Sources: NASM step 3 (hands just outside the feet);
  Gist et al. 2014 Fig. 1 (hands in front of the feet); StrengthLog step 2 (S 1.1). Model: knees 89 and hips 53 at
  the touch; hands 27 cm in front of the toes and 54 cm apart against ankles 24 cm (B).
- Heels on the floor: B (heels flat at 0.96 s); F, `foot_L` height 0.069 m, the same as standing.
- A little wider than your shoulders: wrists 54 cm against 39 cm shoulder-joint centres (B). CrossFit says about
  shoulder-width, which matches only roughly (S 1.1), so CrossFit is not cited.
- Already where the plank needs them: the hands do not move from 0.96 s to 3.54 s (F, `hand_w` stays 0.54 m) and sit
  under the shoulders in the plank (B).
- NSCA's coaching has you shift your weight onto your hands before you kick back: Smith 2021, NSCA Coach 7(4), which
  lists the phases as squat; shift the weight and kick back; return to the squat; explode up (`src/nsca_coach_7_4_4.txt`,
  lines 137-140). Model: 0.33 s with the hands down before the feet leave, with the pelvis rising from 0.640 to 0.682 m
  at 1.25 s (F).
- Mistake, straight legs instead of squatting: this inverts the squat instruction above. No source names it as a burpee
  fault. The model squats deeply, so it shows the correct form. The other half of the mistake (feet back before the
  hands are set) inverts the NSCA order.
- Not written: any flat-back cue, since the model's back rounds about 30 degrees at the bottom (S 5.1).

### Cue 2, back
- Jump both feet back together into a high plank on straight arms. Sources: NASM step 3; Podstawski et al. 2019,
  3-MBT rule (straight arms, legs fully straight, no arched back) (S 1.2). Model: both feet together, 0.25 s
  airborne, landing 27 cm apart; knees about 168-171; elbows 173 in the plank (B, F).
- Shoulders over the hands, hips in line, head to heels. Sources: ACE #41 Push-Up (shoulders over hands, no sag, no
  hike, head in line) (S 1.3). Model: shoulder-hip-ankle 179-180; hips within 0.5 cm of the line; 0 cm offset
  between hands and shoulders; head in line (B).
- NASM lists sagging hips as a common mistake (less core engagement and spinal stability): NASM Squat
  Thrust Burpees, common mistake 3. Confirmed in `src/nasm_squat_thrust_burpees.html`. NASM's list is headed
  Common Mistakes and holds five unranked items, so the copy says "a common burpee mistake", never "most common" (F4).
- Land on the balls of your feet: in the plank the feet are on the toes (F: toe 0.016-0.017 m, ankle 0.156 m).
- Mistake (sag, pike, bent knees): NASM mistake 3; ACE #41, hips must not hike; Podstawski, legs straight (S 2).
- Not written: stepping back (the model jumps, S 1.2), squeezing the glutes (glutes unlit, S 3.3).

### Cue 3, push
- One full push-up per rep: NASM step 3; Gist Fig. 1 (S 1.3).
- Chest to the floor: StrengthLog step 4 (S 1.3); the render at 2.50 s (section 2).
- A push-up lifts roughly two-thirds to three-quarters of body weight: Ebben et al. 2011 (peak 0.64 of body mass);
  Suprak et al. 2011 (69% at the top, 75% at the bottom); StrengthLog, Richter 2024, about 70% (S 1.3, S 6).
- NASM lists a sloppy or skipped push-up as a common mistake: NASM mistake 2 (S 2); unranked, as in cue 2 (F4).
- Slow down rather than cut the depth: CrossFit fault 2 fix, potentially slow down to reach full range (S 2).
  CrossFit is not named because its floor-contact standard differs (below).
- Elbows angled back about 45 degrees: library convention ("Elbows ~45° from the body" x5, "Elbows ~45°" x11). It is
  not a cited finding (S 1.3). Model: 49 degrees between the upper arm and the trunk at 2.50 s, elbows at 47 (B, F).
- Hips still in line at the bottom: body line 180 at 2.50 s (B, F).
- Mistake (partway; hips sag and reach the floor first): NASM mistake 2 and mistake 3; ACE #41, no sag; CrossFit fault 2
  for short reps (S 2).
- Not written: CrossFit's standard that the chest, hips and thighs all touch the floor. The model holds a rigid
  plank (S 1.3).

### Cue 4, in
- Jump both feet forward together toward the hands into a deep squat. Sources: NASM step 3; StrengthLog step 5; Gist
  Fig. 1 (S 1.4). Model: the feet travel about 100 cm together and land 26 cm behind the hands; knees 89, hips 53 (B).
- CrossFit: the knees cave in and the weight tips onto the toes, usually when the feet come in very close together;
  land with the whole foot down and the knees tracking the feet. Source: CrossFit, The Burpee, fault 1 (confirmed in
  `src/crossfit_the_burpee.html`). Model: toes at 3.42 s, heels down by 3.50 s; knees 35 cm apart against ankles
  24 cm (S 5.3).
- About hip-width apart: the model's feet land 24 cm apart, the same as its standing stance (B, F).
  This is not attributed to CrossFit, whose width rule (feet as wide as the hands) the model does not follow (S 1.4).
- Keep your hands down until you have landed: the hands are still on the floor at 3.50 s and leave at about
  3.54 s (S 5.4; F, hand height 0.042 m at 3.50 s and 0.126 m at 3.62 s).
- Mistake, staying on the toes after landing with the heels off the floor, or the knees falling in: CrossFit fault 1
  (pressure too far forward on the front of the feet; knees caving in). Worded as staying on the toes, not as landing
  on them, because the model touches toes first: at 3.42 s the toe joint is on the floor (0.022 m) with the ankle
  joint 4 cm above its standing height (0.108 m against 0.069 m), and the heels are down by 3.50 s (A1, section 7).
- Not used: LESS for stance width (S 1.6).

### Cue 5, jump
- Lift the hands and bring the chest up, then jump. Model: after the hands leave, the trunk comes up to 13-18 degrees
  forward with the knees at about 122 before take-off (S 5.4; F, 4.00 s, trunk 18 and knee 122). The copy does not
  say "jump out of the deep squat".
- Drive until the hips and knees are straight, with the arms overhead. Sources: CrossFit, finishing the ascent; NASM
  step 3; StrengthLog step 6 (S 1.5). Model: take-off with knee 167 and hip 163 (the rig's straight) and ankle 146;
  wrists 31 cm above the head, elbows about 160 (B; F at 4.50 s, 2.183 - 1.867 m).
- Studies show an arm swing adds height. Sources: Lees et al. 2004 (+0.086 m with an arm swing, 20 men); Chiu et al.
  2014 (S 1.5).
- One analysis of the burpee found the knees most loaded at the landing. Source: Di Pietro and Di Puccio 2024, ISBS
  proceedings, from the abstract only, with predicted forces of about 3.5 body weights (S 1.6). Kept vague on
  purpose ("one analysis") because it is a conference abstract.
- A soft landing cuts peak force by about a third. Sources: Myers et al. 2011 (1.63 against 2.60 body weights, about
  37% lower); Guy-Cherry et al. 2018 (about 26% lower). This is the library's wording (S 1.6).
- Land on the balls of the feet, let the heels settle and the knees bend. Model: toes touch at 4.75 s with the knee
  at about 170; heels down about 0.17 s later; knees down to about 120 (S 5.2). The copy deliberately does not say
  to land with the knees already bent.
- Stand all the way up before the next rep. Sources: NASM step 4 and mistake 5 (S 1.6). Model: tall by about 5.29 s,
  next rep at 5.33 s.
- Mistake. Hips and knees still bent with the chest forward: CrossFit fault 3. Landing stiff, with the knees staying
  straight instead of bending to take the landing: NASM mistake 1 (landing with straight knees or poor shock
  absorption) (S 2). Worded as knees that stay straight, not straight knees at contact, because the model touches
  down on straight knees (170 at 4.75 s) and bends them at once (141 at 4.79 s, 120 at 4.96 s) (F1, section 7).
- Jump straight up: the feet land on the spot they left, with no drift (B).

### Setup
1. Feet hip-width, arms at the sides: NASM step 1. Model: 24 cm between the ankles, arms down (B).
2. A flat, non-slip floor about as long as you are tall, with room overhead: NASM step 1 (space overhead and around).
   The length comes from the plank's footprint: wrists to toe joints 1.28 m and head joint to toe joints 1.43-1.50 m
   (F, 1.75 s and 2.50 s); add the head and toe tips and it is roughly standing height.
3. Brace the trunk: NASM step 2.
4. A pace that keeps reps clean; stand balanced before the next rep. Sources: NASM mistakes 4 and 5 and its FAQ
   (quality before quantity, fatigue degrades form); ACE (McCall: speed is not needed) (S 4). Model: one rep every
   5.33 s with a full stand each rep.

No regression step (stepping back, dropping the push-up). S 1.2 says the model does not step, so a step would
describe motion the model never makes.

### Comparison: HIPS SAGGING
- The sources rate it the best-sourced ghost (S 2): NASM mistake 3, NASM push-up blog, ACE #41, Podstawski. The
  library uses the same badge on Push-Up and Plank. The model shows the correct form: line 179-180, hips within
  0.5 cm, through the plank and the push-up (B).
- correctCue "Straight line head to heels" and mistakeCue "Hips drop toward the floor" are reused word for word from
  the Push-Up comparison.
- mistakeNote, the lower back arches: ACE #41 (low back must not sag); Podstawski (no arching). The core does less of
  the work of holding you straight: NASM mistake 3 (sagging hips reduce core engagement and spinal stability), in the
  Plank mistakeNote's terms; not that the core stops working (F2). Creeps in as you tire: NASM FAQ (fatigue
  compromises form); ACE, Ross 2015 (form falls apart with fatigue).
- Ghost frames: the plank top (about 1.75-1.88 s or 3.00 s) or the push-up bottom (2.50 s). Hips are on the line in both.

## 4. Rows (paint per B: Chest and Quads bright; Abs, Obliques, FrontDelt, Triceps, HipFlexors, Hamstrings, Calves dim; Glutes off)

No burpee EMG exists (S 0.1, S 8; Gist 2014 says the same), so every row is a carry or an estimate, as the
Swift comment states. Bands: HIGH >= 0.70, MODERATE 0.40-0.69, LOW < 0.40.

| Row | Rank | Fraction | Band | Basis |
|---|---|---|---|---|
| Quadriceps | primary | 0.84 | HIGH | **Carried**: Squat Jump 0.84 and Box Jump 0.84, both carried from `squatContent` 0.84. They cover the squat down, the jump-in squat, the jump and the landing. No %MVIC exists for jumping (S 3.2). |
| Pectoralis Major | primary | 0.84 | HIGH | **Carried**: the Push-Up's chest row was 0.84 before the 11-08 split and is now Middle Pectoralis 0.84. One full push-up every rep. Context: Youdas 2010, 95-105% MVIC; Freeman 2006, 61.2% MVC; Kang 2014, 64.5-79.1% MVIC. These use different normalisations, so they are context and not a value. Single row because the paint is the whole `Chest` group (B). |
| Triceps Brachii | secondary | 0.60 | MODERATE | **Carried**: Push-Up 0.60. Freeman 66.0% MVC; Youdas 73-109% MVIC. The rank follows the dim paint; the fraction stays where the push-up EMG put it (house practice, Push-Up comment). |
| Anterior Deltoid | secondary | 0.52 | MODERATE | **Carried**: Push-Up 0.52; Freeman 42.0% MVC. |
| Hip Flexors | secondary | 0.45 | MODERATE | **Estimate**. Both legs jump in once per rep, the hip going from straight (164) to 53 (S 3.2; F 3.12-3.50 s). Below Mountain Climber 0.66 and Plank Knee to Elbow 0.50, which drive a knee in on every stroke; above the Box Jump's 0.24 and the 0.40 floor of Step-Up Jump and Bear Crawl. 0.40 is the library's most common hip-flexor value; 0.45 is new. NASM names the hip flexors as secondary; StrengthLog's text names them too. No measurement exists. "Hip Flexors" is a legend-only name (B). |
| Rectus Abdominis | secondary | 0.40 | MODERATE (floor) | **Estimate**. Push-up RA is only 20.1-24.9% MVC (Freeman) and 21.8% MVIC (Kang); the Push-Up lists it as a stabiliser. The burpee adds the trunk catching the jump back and the pelvis held while both legs jump in. As context only, Freeman's clapping push-up drew RA 41.0-56.7% MVC. Kept far under the bright Plank 0.78 and Mountain Climber 0.76. |
| Obliques | secondary | 0.36 | LOW | **Estimate**. Push-up EO 22.5-24.7% and IO 21.6-26.6% MVC (Freeman), about level with the RA. As context only, Freeman's clapping push-up drew EO 55.8-63.0% and IO 56.4-66.6% MVC (Table 1), so the Swift comment's clapping range for the abs and both obliques is 41-67% (F3). Kept under the abs as the library does where both are lit (Plank 0.56 against 0.78, Mountain Climber 0.48 against 0.76). |
| Gastrocnemius | secondary | 0.30 | LOW | **Carried**: the Box Jump's dim calves 0.30. The Squat Jump's 0.78 is for bright calves. Work comes at take-off, the landing, and on the toes in the plank. |
| Hamstrings | secondary | 0.25 | LOW | **Carried**: the jump family's estimate (Squat Jump, Box Jump, Step-Up Jump all 0.25). |

Order: primaries first, Quadriceps before Pectoralis Major to match the library entry "QUADS + CHEST"; then the
secondaries from the highest fraction down.

No glute row: NASM and StrengthLog name the glutes as primary and CrossFit names them (S 3.1), but the owner turned
the glutes off on 2026-11-08. The comment says so. The copy also avoids any "squeeze your glutes" cue.

**Stabilisers: `["transverse abdominis"]`.** The task's rule is "no unlit muscle in the stabilisers". On this rig
almost every muscle has a paint group (`Tools/lab/paint_rows.py` GROUP_ROWS), and B says every group except the lit
nine is off. That leaves only names that map to a lit group without being a row. The transverse abdominis maps to
`Abs` (lit dim). It is the library's plank stabiliser (Plank, Mountain Climber, Bear Crawl, RKC Plank).
- **If the rule was meant only for the glutes**, these are the evidence-backed unlit candidates that were left out:
  - latissimus dorsi: 10.6-14.1% MVC in push-ups (Freeman);
  - erector spinae: 2.7-4.6% MVC (Freeman);
  - serratus anterior: the library's push-up stabiliser, though its push-up EMG is above 20% (Kang 45.5% MVIC, Youdas 67-87%);
  - tibialis anterior: recorded in landings (Guy-Cherry 2018), with no level.
- Library practice elsewhere does list unlit muscles. For example, the RKC Plank moved `gluteus maximus` into its
  stabilisers when the owner turned the glutes off, and the Mountain Climber lists the owner-disabled triceps. The
  11-09 review, on the other hand, removed the owner-disabled hip flexors from 466's stabilisers.

## 5. Deliberately not written (S 5, S 8)

Each item names the source or measurement that rules it out.

- **Flat back on the way down**: the model rounds about 30 degrees at the bottom, and no organisation lists it as a burpee fault.
- **CrossFit's chest, hips and thighs to the floor**: the model holds a rigid plank.
- **CrossFit's feet-as-wide-as-the-hands rule; LESS for stance width or a bent knee at first contact**: the model lands hip-width, toes first on nearly straight knees.
- **Landing with the knees already bent**: same reason.
- **Jumping straight out of the deep squat**: the model rises to a half squat first.
- **Stepping back or in, clapping, tuck jumps, travelling forward**: the model does none of these.
- **Numbers kept out of user copy**: energy-cost figures (Gist, Ratamess, Poulios), the 3-MBT rates, Compendium METs, and the Batterson injury data. None is needed for technique copy.
- **Les Mills' EMG claim**: unpublished.

## 6. Open points for whoever integrates

1. Stabilisers: confirm the strict reading (section 4) or add the unlit candidates.
2. Vietnamese: done in `burpee_vi.json` (section 8). Merge it with `Tools/localization/content.py merge` after the
   block is in SampleData.swift; the 16 keys already in Content.strings carry their existing Vietnamese, so the merge
   changes nothing for them.
3. Layout: run the label layout with these five strings and joints. The widths differ from the test labels in
   `widths.json`: "Body in one straight line" and "Knees out" are new there.
4. Hip Flexors 0.45, Rectus Abdominis 0.40 and Obliques 0.36 are judgment calls with no data behind them. Any owner preference wins.

## 7. Revision log (2026-11-09, review round 1)

Every finding was re-checked against the brief, `frames.json`, the local source copies in `src/` or the app code
before it was applied. All five were applied; none was rejected. One further change (A1) is the author's own and
applies the same model-fidelity test as F1.

| Id | Decision | What changed | Checked against |
|---|---|---|---|
| F1 jump mistake | **Applied** | Cue `jump` mistake: "...or landing on straight, locked knees." became "...or landing stiff, with your knees staying straight instead of bending to take the landing." | F rep 1: knee_L 168.4 at 4.708 s, touchdown at 4.750 s with knee 170.1 (toe_L y 0.016, foot_L y 0.130 against 0.069 standing, so the heels are about 6 cm up), then 141.4 at 4.792 s, 126.2 at 4.833 s, 120.2 at 4.958 s. The model touches down on straight knees and bends them right after, so the old text described its own touchdown. NASM mistake 1 reads "landing with straight knees or poor shock absorption"; the fault is knees that never bend to absorb the landing, which the new text names. Matches the library's STIFF-LEG LANDING copy ("Knees stay straight on the box"). |
| F2 mistakeNote | **Applied** | "your core stops holding its share of the load; NASM lists it among the most common burpee mistakes" became "your core does less of the work of holding you straight; NASM lists it as a common burpee mistake". | `src/nasm_squat_thrust_burpees.html`, Common Mistakes item 3: sagging hips reduce core engagement and spinal stability. "Stops" overstated that; "does less of the work" is the Plank mistakeNote's framing. The superlative is removed at the same time (F4). |
| F3 comment range | **Applied** | Swift comment: clapping push-up range "41-63% MVC" became "41-67% MVC". | `src/freeman2006.txt` Table 1, clapping: RA 56.7 R / 41.0 L, EO 55.8 R / 63.0 L, IO 56.4 R / 66.6 L, so 41.0-66.6 for the abs and both obliques. The line above already counts the IO in the standard push-up's 20-27% (RA 24.9/20.1, EO 22.5/24.7, IO 21.6/26.6). The 63 came from S 3.2, which lists only RA and EO for the clapping push-up. Section 4's Obliques row now gives the EO and IO clapping values. |
| F4 "most common" | **Applied** | Cue `back` why and cue `push` why: "among the most common burpee mistakes" became "as a common burpee mistake" (the mistakeNote's instance went with F2). The notes (section 3) say "a common mistake" too. | NASM's page heads the list Common Mistakes, five items, unranked; the phrase "most common" does not occur anywhere on the page (grep of the local copy: 0 hits). Only S 6's copy-safe phrasing had added it. |
| F5 glows | **Applied** | `glows: []` became four glows: chest + both upper arms, activation 0.55 (rx 0.10, ry 0.06, cx 0.43, cy 0.57); thighs + shins, activation 0.55 (0.10, 0.07, 0.53, 0.67); spine + pelvis, activationSoft 0.30 (0.08, 0.06, 0.52, 0.61); shins + feet, activationSoft 0.26 (0.07, 0.05, 0.57, 0.75). | Recomputed independently with `rev_tools/glow_check.py` (Blender's python 3.13 with pxr), the way `Tools/trainer-content` builds them: `probe.py`'s eight clip fractions 0-0.875 over the 1-384 clip (times 1, 48.875, 96.75, 144.625, 192.5, 240.375, 288.25, 336.125), projected through the trainer framing (yaw -0.8, zoom 0.651, offset -0.017/-0.074/0.017, aspect 382/655), mean position per joint set as in `glow()` of `common_*.py`. Result (0.428, 0.566), (0.530, 0.671), (0.519, 0.613), (0.572, 0.749), so the reviewer's centres round the same. Library check: 457 ExerciseContent blocks, none with `glows: []`. Runtime: `Exercise3DView.swift` lines 340 and 833 draw `content.glows` only without a live model, and SampleData maps Burpee to one (line 2978), so nothing changes on screen today. |
| A1 jump-in mistake (author) | **Added** | Cue `in` mistake: "Landing on your toes with your heels up and your knees falling in toward each other." became "Staying on your toes after you land, with your heels off the floor, or letting your knees fall in toward each other." | Same test as F1, applied to the jump-in landing. F rep 1: at 3.417 s the toe joint is on the floor (0.022 m) while the ankle joint sits 4 cm above standing (0.108 m against 0.069 m); 0.088 m at 3.458 s; flat by 3.500 s (S 5.3). The model touches toes first, so "landing on your toes with your heels up" described its first contact. CrossFit's fault 1 (`src/crossfit_the_burpee.html`) is pressure left too far forward on the front of the feet, with the knees caving, and its fix is the full foot down; the new text names that, joined by "or" as CrossFit's heading does ("and/or"). The cue's why and correct already said this and are unchanged. |

Checks after the revision:
- `xcrun swiftc -typecheck rev_tools/stubs.swift rev_tools/block_check.swift`: OK.
- Labels 9-25 characters, unchanged; setup steps 76-100; no double quotes or backslashes in any string; mistakeBadge
  upper case; "most common" no longer appears in the Swift.
- The project's extractor (`Tools/localization/content.py`'s `extract()`, run on a scratch copy of the block under
  `rev_tools/fakeapp`) finds the same 50 strings as `burpee_vi.json`, all filed under Burpee.

## 8. Vietnamese (`burpee_vi.json`)

50 keys, each the exact English of the Swift: 5 labels, 5 titles, 20 intro/why/mistake/correct strings, 9 muscle
rows, 1 stabiliser, 4 setup steps, 6 comparison strings. Written to `Tools/localization/vi_glossary.md` (exercise
names English; lift nouns burpee, plank, push-up and squat left in English lower case; anatomical muscle names;
UPPER CASE kept; sentence-case titles; NASM, NSCA, CrossFit and 45° kept as they are).

Kept exactly as in `Content.strings` (16 keys shared with other lifts): "Body in one straight line" (Thân thành một
đường thẳng), "Knees out" (Gối mở ra), "CORRECT FORM", "HIPS SAGGING", "Straight line head to heels", "Hips drop
toward the floor", "transverse abdominis" (cơ ngang bụng) and the nine row names (Cơ tứ đầu đùi, Cơ ngực lớn, Cơ tam
đầu cánh tay, Cơ delta trước, Nhóm cơ gấp hông, Cơ thẳng bụng, Cơ chéo bụng, Cơ bụng chân, Nhóm cơ đùi sau).

Choices for the new strings:
- Labels: "Hands to the floor" = "Chống tay xuống sàn" (19 characters against 18; the usual Vietnamese burpee phrase,
  and the hands take the weight). "Chest to the floor" = "Ngực hạ xuống sàn" (17), parallel to the Push-Up's
  "Ngực hạ xuống sát sàn" for "Chest to just above the floor", without "sát" because this push-up goes all the way
  down. "Arms overhead" = "Tay qua đầu" (11), the library's Vietnamese for "Arms Overhead" (Hollow Body Rock title).
- Titles: "Squat xuống", "Bật chân ra sau thành plank" (27; the library's titles run to 29), "Ngực hạ xuống sàn",
  "Bật chân về phía tay", "Bật nhảy, tiếp đất" (built like Step-Up Jump's "Tiếp đất, đứng dậy").
- Terms reused from the library's Vietnamese: gồng chặt (brace), cơ lõi (core), phần trước bàn chân (balls of the
  feet), gối đổ vào trong (knees caving in), gối hướng ra ngoài theo mũi chân (knees out over the toes), tiếp đất mềm /
  tiếp đất cứng and "khoảng một phần ba" (Squat Jump, Box Jump), lỗi thường gặp (common mistake), plank cao (high plank),
  đẩy sàn ra xa / đạp sàn ra xa (press / drive the floor away).
- F1 and A1 keep their meaning in Vietnamese: "gối giữ thẳng thay vì gập lại để đón lực tiếp đất" (knees that stay
  straight) and "Vẫn trụ trên mũi chân sau khi tiếp đất" (staying on the toes), not the moment of contact.
