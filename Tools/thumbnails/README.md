# Library thumbnails (2026-09-24)

White-background stills for every exercise with a model, installed as
`Assets.xcassets/lib-<slug>.imageset` (the `Exercise.slotID` name, 400px,
1x-only universal). 77 of 78 library exercises; `Biceps Curl` has no model.

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
