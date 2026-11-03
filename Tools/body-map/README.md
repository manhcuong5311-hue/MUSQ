# Body map

The flat front/back muscle map (`GymWorkout/Components/BodyMap.swift`) used
by the trainer's Muscles Worked panel, the Muscles tab, history and the
group glyphs.

- `convert.js` turns react-native-body-highlighter's `bodyFront.ts` /
  `bodyBack.ts` (MIT, `LICENSE`) into `GymWorkout/Components/BodyMapPaths.swift`
  (absolute M/L/C/Z paths in a 724 x 1448 box).

## Chest by head (2026-10-22)

The owner's chest-series models paint the pectoralis major's three heads
apart (`FF_Highlight_UpperChest` / `MidChest` / `LowerChest` on the
clavicular, sternal and abdominal meshes), so an incline press lights the
upper chest and a decline the lower. The map follows:

- `BodyMapShapes` cuts the source's whole pecs (`BodyRegion.chest`, never
  drawn) into `upperChest`, `midChest` and `lowerChest`: cuts at y 352 and
  401 by the sternum, dropping 10 units out to each armpit.
- `chest_paint.py` (Blender's Python) reads the three heads off every model
  with the `tiers.py` rule and writes `GymWorkout/Models/ChestPaint.swift`
  (bright = primary, dim or faint = secondary, unlit = nil). Re-run it after
  the owner re-paints a model.
- Trainer panel: when the muscle list has the chest, the bands take the
  live model's paint (the picked stance's model). Row names map too:
  "Upper / Middle / Lower Pectoralis" light one band, "Pectoralis Major" all
  three.
- Muscles tab: `MuscleActivityCalculator.chest` counts each completed set
  of a lift that works the chest in full for a bright head and half for a
  dim one (the primary and secondary row weights), and levels each band on
  the period's group cut-offs. A model that paints no chest falls back to
  the heads its chest rows name ("Upper Pectoralis" the upper band alone,
  "Pectoralis Major" all three), as the trainer panel does. A logged
  exercise keeps the heads it was trained with (`WorkoutExercise.chestHeads`);
  older history looks the exercise up again. Recovery and the Chest group itself
  are unchanged (one `MusclePart.chest`).
- History's iPad band lights only the heads a chest exercise's model lights.
- Stances: the trainer follows the picked stance; logged volume counts the
  exercise's default model, since a logged exercise records no stance.

## Lats apart from the upper back (2026-11-03)

The source's `upper-back` takes in the latissimus dorsi with the
infraspinatus and teres on the shoulder blade, so a Rhomboids or Rotator
Cuff row lit the lats at its own rank: on 48 muscle lists the lats showed
primary although their row says secondary (36, nearly every row) or lit
up with no lats row at all (12: Face Pull, Reverse Pec Deck, the rear-delt
flies, …). `BodyMapShapes` now takes the upper back's two long shapes
(those reaching below y 450, down to y 583) as `BodyRegion.lats`, lit only
by "Latissimus Dorsi" / "lats" rows; rhomboids, teres, infraspinatus and
the rotator cuff keep the shoulder-blade shapes. Lat-led lists change the
other way: on 27 (pull-ups, pulldowns, pullovers) the shoulder blade now
follows its own Rotator Cuff row, or stays idle, instead of the lats'
rank. The Back group (`MuscleGroup.bodyRegions`, the library glyph) lights
both, so the Muscles tab, history and onboarding draw as before.
