# Library thumbnails (2026-09-24)

White-background stills for every exercise with a model, installed as
`Assets.xcassets/lib-<slug>.imageset` (the `Exercise.slotID` name, 400px,
1x-only universal). All 90 library exercises (Biceps Curl, Squat, Lunge and
Lunge (Lean) were shot on 2026-09-24 after their re-export).

Run the Python steps with Blender's Python (`pxr`), from this folder:

1. `posetime.py` — per exercise, the clip time whose pose is furthest from
   frame 1 (bottom of a squat, top of a curl) → `posetimes.json`.
2. `thumbsolve.py thumbs.json [names…]` — square (aspect 1) framing fitted to
   that one pose (`framer_still.py`), not the whole clip, so figures fill the
   tile; machines crop only if showing them costs >40% of the lifter's size.
   Leg Press is forced to show the whole machine; T-Bar Row and Assisted Dip
   were hand-tuned after solving (already in `thumbs.json`).
3. Swap `ContentView.swift` for the temp harness (below), build, install.
4. `python3 make_shoot.py > shoot.sh && zsh shoot.sh`, review with
   `sheet.py`, copy `out/*.png` into the imagesets. Restore ContentView.

Harness branch (never commit):

    let env = ProcessInfo.processInfo.environment
    if let name = env["HARNESS_PHOTO"],
       let ex = SampleData.exercises.first(where: { $0.name == name }),
       let m = SampleData.model(for: ex) {
        let f = env["HARNESS_FRAMING"]?.split(separator: ",").compactMap { Float($0) } ?? []
        let framing = f.count == 5
            ? ModelFraming(yaw: f[0], zoom: f[1], offset: [f[2], f[3], f[4]]) : m.framing
        ZStack {
            Color.white.ignoresSafeArea()
            Viewport(slot: "", model: m.resource, framing: framing, speed: m.speed,
                     still: env["HARNESS_STILL"].flatMap { TimeInterval($0) },
                     inner: .white, outer: .white, cornerRadius: 0) { EmptyView() }
                .frame(width: 380, height: 380)
        }
    }

`still:` (USDZViewport/Viewport) freezes every clip at that time — that is
what makes the pose deterministic instead of whatever frame the load lands on.

`posetime.py` and `thumbsolve.py` both take exercise names to limit a run to
new exercises (posetime merges into the existing `posetimes.json`). Cable
Crunch joins Leg Press in always showing the whole machine.

To shoot only some exercises, filter the generated script, e.g.
`python3 make_shoot.py | grep -E '^#!|^U=|HARNESS_PHOTO="(Squat|Lunge)"' > shoot.sh`.

Chest batch 101-131 (2026-09-25): the 28 new chest exercises were added with
`posetime.py <names…>` and `thumbsolve.py thumbs.json <names…>`, shot and
installed the same way; the library now has 118 exercises, all with a
thumbnail.

Batch 133-160 (2026-09-25): the 27 new exercises were added the same way; the
library now has 145 exercises, all with a thumbnail. The six new pulls (rack,
block, sumo, trap bar, snatch-grip, deficit) are shot at the start of the pull
(`posetimes.json` time 0) instead of the furthest pose, which is lockout: at
lockout they all look the same, at the start the stance and grip tell them apart.

Batch 161-190 (2026-09-25): the 30 new back exercises were added the same way;
the library now has 175 exercises, all with a thumbnail. The six cable
pulldowns are in `thumbsolve.py`'s `BODY_ONLY` set: framed on the lifter with
the 2.3 m tower allowed to crop, since fitting the tower left the lifter a
sliver.

Batch 191-240 (2026-09-26): the 46 new exercises were added the same way
(`posetime.py` / `thumbsolve.py` with their names); the library now has 221
exercises, all with a thumbnail. The plate, straight cable bar and trap bar
count as held; the landmine bar is left to crop. Four cable lifts, the cable
external rotation and the rear-delt machine joined `BODY_ONLY`, where the
tower or machine left the lifter a corner of the tile.

Legs 300-350 (2026-09-26): the 11 new leg exercises were added with
`posetime.py <names…>` and `thumbsolve.py thumbs.json <names…>` and shot on a
separate harness simulator. The Smith lifts and the rear-foot-elevated split
squat show their machine or bench (showing it cost the lifter under 40%).

Late additions (2026-09-27): the four new exercises (Seated Dumbbell Lateral
Raise, Cable Rear Delt Row, Dumbbell Upright Row, Barbell Hip Thrust) got a
pose time and a framing, and the fifteen re-exported models (knee and toe-out
fixes, the rebuilt 191/199 presses, the upright abduction machine) were
re-solved and re-shot; the library now has 236 exercises, all with a thumbnail.

Batch 241-300 (2026-09-27): the 26 curls, wrist curls and holds were added the
same way; the library now has 262 exercises, all with a thumbnail. The EZ bar,
pinch plates and towels count as held; the four cable curls seen from the side
joined `BODY_ONLY`. The wrist curls are pinned to the working end of the wrist
range (1.67 s) and the finger curl to the bar on the fingertips (1.33 s), since
their displacement barely changes.

Exercises 1-50 redone (2026-09-29): the 26 re-exported models and the nine
new ones (Pendlay Row, Dumbbell, Incline Dumbbell, Preacher, Cable, Bayesian
Cable and Reverse Curls, Wrist Curl, Close-Grip Bench Press) got fresh pose
times (`posetime.py <names…>`; the Wrist Curl pinned to 1.5 s, its wrists'
fullest curl) and framings (`thumbsolve.py thumbs.json <names…>`), and were
shot from a scratch mirror build with the harness. T-Bar Row keeps its
hand-tuned framing (its motion did not change); the Chest-Supported Row
Machine joins Leg Press and Cable Crunch in always showing the whole machine
(its raised knees had tipped it into cropping). The EX_* EZ bars count as
held (`EZ_Bar`). `framer_still.py` leaves the skeleton's `root` bone out (the
row machine parks it under the floor). The library now has 299 exercises.

Exercises 151-190 and gated redone (2026-09-30): the 36 re-exported models
that changed (Biceps Curl came back identical) kept their pose times; their
square framings were re-solved with the current `thumbsolve.py` (the pull-ups,
pulldowns and cable/machine rows zoom in a little, since `framer_still.py`
now leaves the root bone out) and re-shot. The assisted and machine pull-ups
lost their floating guide rails in the redo, so their tiles look cleaner.

Redone 190-280 folder (2026-09-30): the 21 re-exported models and the new
Machine Preacher Curl were re-solved and re-shot. The dumbbell and landmine
presses, whose arm paths changed, took new pose times; the others kept
theirs. The spider curls, Cable Y-Raise and Rear Delt Row keep their earlier
(hand-set) square framings, which the solver would otherwise move. The
library now has 300 exercises.

351-400 folder (2026-09-30): the 27 new hamstring, glute and hip exercises
got pose times and square framings (`posetime.py` / `thumbsolve.py` with
their names) and were shot the same way; the library now has 327 exercises,
all with a thumbnail. Back Extension was re-shot from its new behind-left
view (-1.9) at the bottom of the rep, so the tile shows the rounded spine of
the lower-back variant the model performs.
