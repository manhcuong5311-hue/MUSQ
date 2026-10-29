# Male shorts refit and glute zone (2026-10-28)

The male bodies' shorts (`/root/Anatomy_MasterRig/Anatomy_Shorts/Anatomy_Shorts_Surface`)
were exported as the raw base mesh: in Blender only render-only modifiers
(Subsurf, a 16 mm Shrinkwrap onto a geometry-nodes muscle envelope, Solidify)
keep them outside the muscles, and none of that reaches USD. So in the app the
glutes showed through the shorts as red patches, standing and more so in hip
hinges, and the adductors showed through the crotch.

All three scripts run inside Blender (they need `mathutils`), read fresh raw
bodies from `share_body.py body` (never already-refit ones: the push is not
idempotent) and write to a folder outside `Resources/`.

- `fix_shorts.py` (+ `slib.py`):
  `Blender -b --factory-startup --python fix_shorts.py -- --v2 AnatomyBodyV2.usdc --v1 AnatomyBody.usdc --outdir OUT`.
  Pushes the shorts' rest points out to about 5-6 mm over the outermost muscle
  (smoothed; the front of the leg hems moved up to ~5 cm), except the crotch
  gusset, which the master's `CLOTH_Contact` mask leaves alone. Each vertex
  within 20-50 mm of a muscle takes that muscle's skin weights (pelvis / spine
  / thigh_L / thigh_R only, at most 4). jointIndices stay slot for slot as they
  were, so the 273 slim models that re-index the shorts keep working. Only the
  shorts' points, normals, jointWeights and extent change. Red glute pixels
  through the shorts fell 99% over 12 lifts.
- `fix_crotch.py`, on top of it:
  `Blender -b --factory-startup --python fix_crotch.py -- --v2 RAW/AnatomyBodyV2.usdc --v1 RAW/AnatomyBody.usdc --phase1 OUT/shorts_fix.npz --outdir OUT2`.
  Moves only the gusset (mostly down; sideways it runs into the other leg) to
  4 mm clear of the adductors, gracilis and hamstring tops, at most 25 mm; the
  rest of the shorts and all weights stay as `fix_shorts.py` left them. Shorts
  vertices inside a muscle in the crotch fell 81% summed over 12 lifts (309 to
  34 standing; deep hip flexion still folds some in at the front crease).
- `make_mask.py`:
  `Blender -b --factory-startup --python make_mask.py -- OUT2/AnatomyBodyV2.usdc ShortsGluteMask.png 512 0.045`.
  Bakes where the refit shorts cover the glutes (rays from the fabric to the
  first glute within 45 mm, smoothed) into two masks over the shorts' own UVs,
  red the left side and green the right: `ShortsGluteMask.png` the gluteus
  maximus, run down the back of the shorts to the hem (a deep hinge pulls the
  hem up over the lower buttock), and `ShortsGluteMaskMedius.png` the medius
  and minimus at the side of the hip. Both go to `Resources/Models/Shared/`;
  both male bodies give the same masks. `ShortsGluteZone.swift` tints the
  shorts toward each muscle's own paint through them, since the glutes no
  longer show through the fabric.

- `rebase_shorts.py`, plain Python with `pxr`:
  `python3 rebase_shorts.py Shared/AnatomyBodyV2.usdc <model.usdc>...`.
  Writes the body's refit shorts into converted male models: points,
  normals, extent and weights from the body, the joint indices renumbered by
  name into each model's own skeleton. Run it on every new male model after
  `convert_all.py` and `one_side_tiers.py`, before `pad_one.sh` and
  `slim_one.sh`. An export from an unpatched .blend carries the raw shorts,
  and one from a patched .blend has the same points and weights written 4 to
  a vertex (the body has 5) with recomputed normals; neither slims cleanly
  without it.

`share_body.py slim` refuses a male model whose shorts still differ from the
body's (it names the rebase command), so the raw shorts cannot come back as
overrides. Triceps/AssistedDip plays its own embedded rig and keeps the raw
shorts. 124 of the male leg lifts on the SSD carry the refit in their .blend
files (2026-10-28, navy shorts and a glute-zone material that stays out of
USD exports); the Blender master (`Male_Fitness_EnhancedRig.blend`) does not
yet. Re-run `fix_shorts.py`, `fix_crotch.py` and `make_mask.py` after any new
male `share_body.py body` export. Equipment fitted
against the old shorts can sit a little into the refit ones (hip-thrust pads,
a plate held at the thighs; up to ~19 mm). Work, metrics and before/after
stills are on the SSD in `BLENDER/_cai_thien_nam_20261028/` (README_VI.md).
