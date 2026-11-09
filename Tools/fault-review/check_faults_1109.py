# Compile check and integration for the 2026-11-09 round's fault ghosts: the
# model-only lifts of 2026-10-29 (and the Burpee), which shipped with coaching
# but no ghosts. Each family writes faults_1109_<family>.swift.txt with a
# "// MARK: PIECES" section (private static helpers, prefixed by family) and a
# "// MARK: TABLE" section ("Exercise": [ "cue": FaultPose, ... ], entries).
#
#   python3 check_faults_1109.py [--only <family>]  paste every family (or one) into the lab
#                                                mirror and build it (no install)
#   python3 check_faults_1109.py --integrate     write them into the repo's
#                                                FaultPoses.swift between the
#                                                "Model-only lifts (2026-11-09)" markers
#
# The lab is the session's harness mirror ($LAB, default below): its src/ is
# re-synced from the repo, so the check never pastes a family twice, and its
# dd/ is reused, so the build is incremental. One build at a time ($LAB/lock,
# the same lock as Tools/lab/lock.sh).
import glob, os, re, subprocess, sys, time

REPO = "/Users/sammanhcuong/Developer/GymWorkout"
LAB = os.environ.get("LAB", "/private/tmp/claude-501/-Users-sammanhcuong--claude-spares-spare-nyEbiw/"
                     "e062f03c-4651-4a9f-9046-0df73e802e09/scratchpad/lab")
SIM = os.environ.get("SIM", "B69AA4C4-2630-4503-8EF8-8C31832587B4")
PM = ("    // BEGIN Model-only lifts (2026-11-09) pieces\n", "    // END Model-only lifts (2026-11-09) pieces\n")
TM = ("        // BEGIN Model-only lifts (2026-11-09)\n", "        // END Model-only lifts (2026-11-09)\n")


ONLY = sys.argv[sys.argv.index("--only") + 1] if "--only" in sys.argv else None


def families():
    pieces, table, names = [], [], []
    for f in sorted(glob.glob(REPO + "/Tools/fault-review/faults_1109_*.swift.txt")):
        if ONLY and os.path.basename(f) != "faults_1109_%s.swift.txt" % ONLY:
            continue
        t = open(f, encoding="utf-8").read()
        a, b = t.index("// MARK: PIECES"), t.index("// MARK: TABLE")
        pieces.append(t[a + len("// MARK: PIECES"):b].strip("\n"))
        table.append(t[b + len("// MARK: TABLE"):].strip("\n"))
        names.append(os.path.basename(f))
    return pieces, table, names


def paste(src, pieces, table):
    for (a, b), body in ((PM, pieces), (TM, table)):
        i, j = src.index(a) + len(a), src.index(b)
        src = src[:i] + ("\n".join(body) + "\n" if body else "") + src[j:]
    return src


pieces, table, names = families()
if "--integrate" in sys.argv:
    p = REPO + "/GymWorkout/Models/FaultPoses.swift"
    new = paste(open(p, encoding="utf-8").read(), pieces, table)   # read before opening for writing
    open(p, "w", encoding="utf-8").write(new)
    print("integrated:", ", ".join(names) or "(none)")
    sys.exit(0)

lock = LAB + "/lock"
os.makedirs(LAB, exist_ok=True)
while True:
    try:
        os.mkdir(lock)
        break
    except FileExistsError:
        if time.time() - os.path.getmtime(lock) > 2400:
            os.rmdir(lock)
        time.sleep(5)
try:
    subprocess.run(["rsync", "-a", "--delete", "--exclude", "SourceExports", "--exclude", ".git", "--exclude", "*.slim.tmp.usdc",
                    "--exclude", "*_OLD.usdc", REPO + "/", LAB + "/src/"], check=True)
    # Keep the mirror a harness build (as the lab's mirror script makes it), so this
    # check and the shooting builds share one incremental DerivedData.
    subprocess.run(["cp", REPO + "/Tools/lab/ContentView.harness.swift.txt", LAB + "/src/GymWorkout/ContentView.swift"], check=True)
    ev = LAB + "/src/GymWorkout/Features/Exercise3DView.swift"
    s = open(ev, encoding="utf-8").read()
    s = s.replace("    @State private var stance = 0\n",
                  '    @State private var stance = Int(ProcessInfo.processInfo.environment["HARNESS_STANCE"] ?? "") ?? 0\n')
    open(ev, "w", encoding="utf-8").write(s)
    fp = LAB + "/src/GymWorkout/Models/FaultPoses.swift"
    new = paste(open(fp, encoding="utf-8").read(), pieces, table)   # read before opening for writing
    open(fp, "w", encoding="utf-8").write(new)
    print("pasted:", ", ".join(names) or "(none)", flush=True)
    r = subprocess.run(["xcodebuild", "-project", LAB + "/src/GymWorkout.xcodeproj", "-scheme", "GymWorkout",
                        "-sdk", "iphonesimulator", "-destination", "platform=iOS Simulator,id=" + SIM,
                        "-derivedDataPath", LAB + "/dd", "build", "CODE_SIGNING_ALLOWED=NO"],
                       capture_output=True, text=True)
    out = r.stdout + r.stderr
    if "BUILD SUCCEEDED" in out:
        print("BUILD SUCCEEDED")
    else:
        errs = sorted(set(l.replace(LAB + "/src/", "") for l in out.splitlines() if " error: " in l))
        print("\n".join(errs[:60]) or out[-3000:])
        print("BUILD FAILED")
        sys.exit(1)
finally:
    try:
        os.rmdir(lock)
    except OSError:
        pass
