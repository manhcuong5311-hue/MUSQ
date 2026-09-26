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
