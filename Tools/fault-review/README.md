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
