# Room for one more pill (2026-10-20)

How the back-bar lifts' grip and shoulder-blade callout (`shelf`) was placed
without sitting on the lifter, the bar or the rack and without crossing
another leader. The scripts name the 13 back-bar lifts directly (`SLUGS`,
`JOBS`, `names`); change those lists to reuse them. Scratch output goes to
`$LAB` (set it per session, as for the other lab scripts).

1. Shots, from the harness app (`zsh Tools/lab/build.sh` first):
   - `zsh shoot_views.sh`: the label-free viewport (`HARNESS_VIEW`) at
     0-3 s into `$LAB/occ/`. Also shoot one empty viewport into
     `$LAB/occ/empty.png` (`HARNESS_VIEW` with
     `HARNESS_RESOURCE=NoSuchModelXYZ`); `masks.py` blends its "model failed
     to load" text out.
   - `zsh shoot_trainer.sh $LAB/shots_before`: the trainer with its pills,
     at 0 s and at each lift's bottom (`Tools/fault-review/bottoms.json`).
2. Data (system `python3` has PIL; Blender's `python3.13` has pxr and numpy):
   - `python3 parse_anns.py GymWorkout/Models/SampleData.swift $LAB/anns.json`
   - `python3 masks.py $LAB`: per lift, `occ` = anything the model or its
     equipment covers in any still; `ui` = the trainer's own overlay
     (trainer shot minus view shot), used for the legend and buttons and to
     size pills.
   - `python3 widths.py $LAB "<label>" ...`: pill widths (SF text width,
     calibrated on the real pills).
   - `python3.13 Tools/trainer-content/probe.py $LAB/joints13.json <names>`
     (8 samples) and `python3.13 proj_at.py $LAB` (every 0.25 s, plus the
     finger joints).
3. Search: `python3.13 search.py $LAB "<label>" hand_L,hand_R,...` lists
   free spots per lift. Environment knobs: `OCC_MAX` (share of the pill
   allowed over the lifter/equipment), `BAD_MAX` (leader conflicts allowed),
   `WL`/`WO` (weights of leader length and overlap), `TOPY`/`TOPPEN` (prefer
   the top row), `YMIN`, `ONLY="Lift A|Lift B"`. `search2.py` re-places one
   existing pill with everything else fixed.
4. `python3 preview.py $LAB placements.json out.jpg` draws a plan onto the
   trainer shots; `python3 apply_shelf.py SampleData.swift placements.json`
   writes it (re-runnable); `python3.13 checkall.py $LAB anns_now.json`
   (after `parse_anns.py` on the edited file) re-checks the new pill over the
   dense samples. `place_v4.json` is the plan that went in.
5. Verify on the app's own shots (`shoot_trainer.sh` again).

Pitfalls met: `hand_L` sits at the wrist, so a grip pill tracks the
knuckles (`CTRL_finger_middle_01_L`, a deform bone every model has); a
near plate can hide the fist (the barbell split squat seen at yaw -1.3), so
that one tracks the elbow; a leader from the top row to the trap passes
over the head unless the pill is anchored right of the head.
