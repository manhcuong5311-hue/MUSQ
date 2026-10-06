# Lab tools (2026-10-05)

Scripts for the 401-500 batch's model checks, framing picks, reference
stills, thumbnails and content-family labs. They used to live in a session
scratchpad, which was wiped between rounds; they live here now. `env.sh`
holds the settings (REPO, LAB scratch folder, the harness simulator SIM,
Blender's Python); set `LAB` per session. Nothing here writes to the repo
except `add_rows_r3.py` (one-off) — mirrors, builds and shots go to `$LAB`.

- `ContentView.harness.swift.txt` — the harness ContentView swapped into
  mirrors (never into the repo): `HARNESS_VIEW` / `HARNESS_PHOTO` (viewport
  alone, `HARNESS_FRAMING`, `HARNESS_STILL`), `HARNESS_EXERCISE` (trainer),
  `HARNESS_FAULT` + `HARNESS_CUE` (a mistake; launch with `DEBUG_PREMIUM=1`).
  It injects Purchases, Ads and Paywall, which Exercise3DView reads from the
  environment.
- `build.sh` — mirror the repo to `$LAB/src`, swap in the harness, build for
  SIM, install.
- `lock.sh` — sourced by the shooting scripts: one simulator/build user at a
  time across agents.
- `shots.sh view|stills|photo` — viewport stills at a framing (for picking
  framings), the 0/1/2/3/5 s reference stills content writers use, and the
  400 px library thumbnails (framing and pose time from
  `Tools/thumbnails/thumbs.json` / `posetimes.json`).
- `family.sh check|shoot <family>` — integrate one content family into a
  mirror (`integrate_500.py --only`), set its fault stills, build, and shoot
  the trainer and every ghost into `$LAB/<family>/` with contact sheets.
- `sheet.py` — contact sheets.
- `AGENT_BRIEF.md` — the brief content agents work from (house rules, inputs,
  files to write, tools, process).

Model-side helpers sit in `Tools/model-pipeline`: `integrity.py` (raw
export check), `facing.py` (facing and posture), `tiers.py` (highlight paint
per muscle), `solve_pick.py` (framing candidates with per-job overrides).
