# Compile check for the 1-50 redo's fault ghosts (2026-09-29): pastes every
# faults_1_50_<family>.swift.txt that exists (PIECES after the
# "Exercises 1-50 redo pieces" marker, TABLE after the "Exercises 1-50 redo" marker) into a
# mirror of the project and builds it for the simulator. One build at a time
# (a lock directory), since the families are checked in parallel.
#   python3 check_faults_1_50.py
import glob, os, re, subprocess, sys, time
REPO = "/Users/sammanhcuong/Developer/GymWorkout"
WORK = "/private/tmp/claude-501/-Users-sammanhcuong-Desktop-GymWorkout-GymWorkout/e2f350d0-c237-4996-b3d9-7145ba4cd804/scratchpad/s150/fcheck"
LOCK = WORK + ".lock"
os.makedirs(WORK, exist_ok=True)
while True:
    try:
        os.mkdir(LOCK); break
    except FileExistsError:
        if time.time() - os.path.getmtime(LOCK) > 1200: os.rmdir(LOCK)  # stale
        time.sleep(3)
try:
    subprocess.run(["rsync", "-a", "--delete", "--exclude", "SourceExports", "--exclude", ".git", REPO + "/", WORK + "/src/"], check=True)
    fp = WORK + "/src/GymWorkout/Models/FaultPoses.swift"
    # Once integrate_1_50.py has run, the repo's FaultPoses.swift already
    # holds the families; start from its pristine copy instead.
    pristine = os.path.join(os.path.dirname(WORK), "pristine", "FaultPoses.swift")
    s = open(pristine if os.path.exists(pristine) else fp).read()
    pieces, table = [], []
    for f in sorted(glob.glob(REPO + "/Tools/fault-review/faults_1_50_*.swift.txt")):
        t = open(f).read()
        a, b = t.index("// MARK: PIECES"), t.index("// MARK: TABLE")
        pieces.append(t[a + len("// MARK: PIECES"):b].strip("\n"))
        table.append(t[b + len("// MARK: TABLE"):].strip("\n"))
        print("pasted", os.path.basename(f))
    pm, tm = "    // MARK: Exercises 1-50 redo pieces (2026-09-29)\n", "        // MARK: Exercises 1-50 redo (2026-09-29)\n"
    s = s.replace(pm, pm + "\n".join(pieces) + "\n")
    s = s.replace(tm, tm + "\n".join(table) + "\n")
    open(fp, "w").write(s)
    r = subprocess.run(["xcodebuild", "build", "-project", WORK + "/src/GymWorkout.xcodeproj", "-scheme", "GymWorkout",
                        "-destination", "generic/platform=iOS Simulator", "-derivedDataPath", WORK + "/dd",
                        "-disableAutomaticPackageResolution", "CODE_SIGNING_ALLOWED=NO"], capture_output=True, text=True)
    errs = sorted(set(l for l in r.stdout.splitlines() if " error: " in l))
    lines = open(fp).read().split("\n")
    for e in errs[:40]:
        print(e.replace(WORK + "/src/", ""))
        m = re.search(r"FaultPoses.swift:(\d+):", e)
        if m:
            n = int(m.group(1)); print("    > " + lines[n - 1].strip())
    print("BUILD SUCCEEDED" if r.returncode == 0 else f"BUILD FAILED ({len(errs)} errors)")
finally:
    os.rmdir(LOCK)
