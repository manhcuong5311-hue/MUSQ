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

401-500 folder (2026-10-04): the 30 new exercises got pose times and square
framings (`posetime.py` / `thumbsolve.py` with their names) and were shot on
the harness simulator; the library now has 357 exercises, all with a
thumbnail. `thumbsolve.py` gained `CROP`, held parts a lift lets crop (the
landmine chest press's 1.9 m bar); the Rope Hammer Curl joins the cable curls
in `BODY_ONLY`, and the Landmine Chest Press and Smith Machine Seated Calf
Raise too, where the bar and the Smith frame left the lifter a third of the
tile. The app's slot names turn "21s" into a dash, so the two 21s tiles are
`lib--s-curl` and `lib-ez-bar-s`.

Second round, 415-444 (2026-10-04): the 30 new calf, tibialis and core
exercises got pose times and square framings the same way and were shot on
the harness simulator; the library now has 387 exercises, all with a
thumbnail. The floor lifts keep the whole mat in the tile, like the
library's Crunch and Reverse Crunch, and the cable crunches the whole tower,
like the Cable Crunch.

Third round, 445-474 (2026-10-05): the 30 new exercises got pose times and
square framings the same way, shot with `Tools/lab/shots.sh photo`; the
library now has 417 exercises, all with a thumbnail. The Toe-to-Bar was set
by hand: the solver over-zoomed its folded top pose (as the trainer solver
did for compact poses), so its tile is framed like the Hanging Leg Raise and
held at 1.0 s, mid-swing with the legs out level. The app's slot name turns
"Landmine 180" into `lib-landmine-`.

Desktop "1-100" folder (2026-10-10): 33 of the 34 re-exported models were
re-shot with `Tools/lab/shots.sh photo` (Cable Glute Kickback came back
looking the same). The fourteen whose motion changed most (the twelve, the
Bench Dip and the Landmine Squat) and four that moved the hands a few cm took
new pose times (`posetime.py <names…>`). The new exports' skeletons add
`toe_L/R` and `FF_` foot joints that `framer_still.py` counts as body, so
`thumbsolve.py` zooms the body-framed standing lifts (the squats) out 5-8%
even where nothing moved; framings bounded by a mat or a machine come out
unchanged. So the models whose motion and equipment held kept their
framings; only the six with a rebuilt bench or slant board (Skull Crusher,
Bench Dip, Close-Grip Bench Press, Barbell Hip Thrust, Decline Crunch,
Heel-Elevated Squat) and the Dumbbell Overhead Triceps Extension, whose arms
now straighten further overhead, took the solver's new square framing. The
081 export went to the Hip Abduction Machine (Lean), which keeps its framing;
the upright Hip Abduction Machine keeps its model and tile.
The folder's five new exercises got pose times and square framings
(`posetime.py` / `thumbsolve.py` with their names) and were shot the same way;
the library now has 422 exercises, all with a thumbnail. The Smith Machine
Front Squat joins `BODY_ONLY` (the rack left its lifter a third of the tile),
and the Hip Adduction Machine's tile holds the open start (0.02 s): at the
pose time the solver picks, the closed knees hide the lit inner thighs.
The five formerly red-named replacements (Assisted Dip, Bulgarian Split
Squat, Smith Machine Squat, both RDLs) took new pose times and framings,
except the Assisted Dip, which keeps its hand-tuned one; the Smith Machine
Squat joins `BODY_ONLY`, since its new rack left the lifter a third of the
tile.
The female model's lifts (2026-10-10): Hack Squat (Stances) and Pendulum
Squat (Stances) show their standard stance; with Cable Step-Down they got
pose times and square framings the usual way, and the Ab Wheel Rollout's
tile was re-shot on its female model. The library now has 425 exercises.
The Cable Step-Down was renamed Cable Knee-Drive Kickback (its tile is now
`lib-cable-knee-drive-kickback`).
