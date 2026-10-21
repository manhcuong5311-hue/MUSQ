# Room for the grip-and-lats pill (2026-10-21)

The 2026-10-20 tools (`../label_space_1020/`, whose README has the method
and the knobs) re-pointed at the 11 lifts that got the deadlift set-up's cue
`lats` ("Grip & lats tight"): Deadlift, Sumo, Deficit and Snatch-Grip
Deadlift, Rack and Block Pull, Trap Bar Deadlift, Romanian, Stiff-Leg, Smith
Machine Romanian and Barbell Single-Leg Romanian Deadlift. What changed from
the 1020 copy:

- The lift lists (`names`, `SLUGS`, `JOBS`) name these 11; `search.py`
  reads `joints11.json`, which is `proj_at.json`'s dense joints (every
  0.25 s) rather than the 8 probe samples.
- `parse_anns.py` also reads the Deadlift's `backAnnotation(...)` helper
  calls (slot constants over 382 x 567).
- `proj_at.py` also projects `thigh_L` and `shin_L/R`, which some of these
  lifts' callouts track.
- `apply_lats.py` (was `apply_shelf.py`) writes the `lats` callout after the
  spine callout and the cue after the spine cue (`spine`, or `back` on the
  Romanian deadlifts), and keeps three decimals on every point: rounding a
  moved pill to two put its leader back across the new one.

`place_v1.json` is the plan that went in. "Grip tight, lats engaged"
(161 pt) found no room on four lifts, so the label is "Grip & lats tight"
(115 pt). Two old pills moved to make room: the Snatch-Grip Deadlift's
"Upper back tight, flat" 55 pt right on the top row, and the Barbell
Single-Leg Romanian Deadlift's "Hips back, leg back" 16 pt. `checkall.py`
finds every new pill clean over the dense samples.
