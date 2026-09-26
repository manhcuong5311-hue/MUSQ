# Fault review (2026-09-24)

Stills of every authored common-mistake ghost (`GymWorkout/Models/FaultPoses.swift`),
held at the bottom of the rep, for checking them side by side.

1. `bottoms.py <exercise…>` (Blender's Python) — the second each clip bottoms
   out: where the elbow bends most, or for flys where the hands are furthest
   apart; legs, raises, hinges, bridges and abductions have rules of their
   own (see the sets at the top) → `bottoms.json`. Faults of the other end of
   the rep are stored as `"Exercise|cue"` (`AT_TOP`, `AT_LOCKOUT`); holds and
   the core lifts were set by hand from joint timelines.
2. Swap `ContentView.swift` for the harness below, build, install.
3. `python3 make_shoot.py [exercise…] > shoot.sh && zsh shoot.sh` — one still
   per fault into `faults/`.
4. `python3 sheet.py faults sheet.png [slug…]` — one row per exercise, cropped
   to the viewport. Restore ContentView.

Harness branch (never commit):

    let env = ProcessInfo.processInfo.environment
    if let name = env["HARNESS_FAULT"],
       let ex = SampleData.exercises.first(where: { $0.name == name }) {
        NavigationStack {
            Exercise3DView(exercise: ex, cue: env["HARNESS_CUE"], showingMistake: true,
                           still: env["HARNESS_STILL"].flatMap { TimeInterval($0) })
        }
        .environment(WorkoutStore())
        .environment(RestTimer())
    }

Moves are in the lifter's own axes, so a move straight along the camera's line
of sight disappears in the default framing. A fault can carry a `view` (a turn
of the model, in radians, eased in while the mistake shows) to bring it round
to a side that shows it: negative brings the lifter's left side to the camera.
Work out the turn from the model rather than by eye — the facing of each clip
(including the prims above its skeleton) and the turn to a true left-side view
come from a quick pass over the USD, as in the 2026-09-24 session. While a
mistake shows, the viewport also shrinks and lifts the model (`roomBelow`) so
the feet clear the mistake bar; the stills include both.

Faults that are about speed or force rather than a position (tempo, bouncing,
pulling on pads) have no ghost and fall back to the red ring.

Chest batch 101-131 (2026-09-25): every new chest exercise has a ghost for
each cue. `bottoms.py` treats the new cable flies as flys and the pullovers
by the overhead stretch (hands furthest from the pelvis); the landmine
press's short-lockout fault is read at lockout. Pieces shared with the
original chest lifts (decline feet, bounced bar, seated arch, cable-fly
folds) were pulled out of their entries unchanged. The single-arm lifts work
the left arm, so their ghosts move only `_L` joints; Incline Push-Up reuses
the push-up's faults.

Batch 133-160 (2026-09-25): every new exercise has a ghost for each cue. The
new pulls from the floor, pins and blocks bottom out by the knee rule, and
their lockout faults (`Rack Pull|lockout`, `Block Pull|lockout`,
`Trap Bar Deadlift|lockout`) are read at the top. The push-up variants reuse
the push-up's faults and the three inverted rows share one set, so
`make_shoot.py` (which reads inline entries) skips them; shoot them by hand.

Batch 161-190 (2026-09-25): every new exercise has a ghost for each cue. The
pull-up, chin-up and pulldown pieces (`elbowsForward`, `chinCraned`,
`hangingShort`, `pulledBehindNeck`, `pulledPastChest`) and `rowedLow` were
pulled out of the Pull-Up, Chin-Up, Lat Pulldown and Wide-Grip Barbell Row
entries unchanged; `bottoms.py` treats the two new pullovers by the overhead
stretch.

Batch 191-240 (2026-09-26): every new exercise has a ghost for each cue,
written per family in `faults_191_240_<family>.swift.txt` (a PIECES and a
TABLE section) and pasted under `// MARK: Batch 191-240 pieces` and at the
end of the table. `fault_times.py <fault_moments.json>` sets each fault's
still from the families' notes (bottom / top / lockout / any), read by the
kind of lift: the top of a press is lockout, of a raise the hands highest,
of a curl or row the elbows most bent, of a shrug the shoulders highest.
`bottoms.py` also gained rules for the new raises, shrugs, cable rotations
and carries.

Legs 300-350 (2026-09-26): `fault_times.py` classes lunges and split squats as
`legs`: bottom = lowest pelvis, top = highest. The ghosts are in
`faults_300_350_{splitsquat,lunge}.swift.txt` (integrated under
`// MARK: Legs 300-350` in FaultPoses.swift); the alternating lunges use the
`_front` / `_back` leg tokens like the Walking Lunge.

Late additions (2026-09-27): `fault_times.py` classes hip thrusts as `legs`
too (top = highest pelvis, which is lockout). Ghosts in
`faults_0927_{shoulders,hipthrust}.swift.txt`, integrated under
`// MARK: Late additions` in FaultPoses.swift.
