# App Store screenshots (1.4, 2026-11-23)

Six screenshots per device and language, in the style of the 1.0-1.3 set
(white ground, heavy two-line headline with the second line in orange, grey
subtitle, black device with an orange glow):

1. All-in-one Today ("Your day": water, weigh-in, workout, steps, sleep)
2. Meal scan, Cal AI style (a phở photo over the AI's read meal), MUSQ Pro
3. Ask MUSQ, the AI coach, Premium or Pro
4. Meals + the calorie and macro plan
5. A lift in 3D with key tips (Back Squat; Dumbbell Romanian Deadlift for the iPhone VI shot, where squat and bench tips overlap at 402 pt)
6. Progress › Strength (estimated 1RM, records)

Output sizes: iPhone 1290x2796 (6.9"), iPad 2064x2752 (13", portrait).
The finished set from 2026-11-23 is on the owner's Desktop in
"MUSQ 1.4 - Anh App Store".

## Shooting

- Build: `build_adhoc.sh [SIM]`. It is ad-hoc signed, so the simulator app
  keeps its HealthKit entitlement. A `CODE_SIGNING_ALLOWED=NO` build (lab
  `build.sh`) gets "Missing com.apple.developer.healthkit entitlement", and the
  Steps and Sleep rows never show.
- Data: copy `fixtures/daily_<lang>.json` to
  `Library/Application Support/Daily/daily.json` and
  `fixtures/coach_<lang>.json` to `Library/Application Support/Chat/coach.json`
  in the app's data container (`xcrun simctl get_app_container SIM
  com.SamCorp.GymWorkout data`). Meal names are stored in the language they
  were logged in, which is why there are two daily files. Workouts come from the
  harness sim's own history.
- Apple Health: launch once with `-health.seed -health.reseed`, and allow
  Health. `-health.seedDays 2` tops up only the last two days on a sim that was
  seeded earlier.
- Meal scan: put a food photo at `Documents/pho.jpg` in the data container,
  then launch with `-mealscan.preview phoBowl -mealscan.photo pho.jpg`. The
  2026-11-23 photo is Pexels 29305882 ("Delicious Vietnamese Pho Bo with Fresh
  Herbs", free Pexels license). It is not in the repo.
- Coach chat: `-coach.open` opens the chat a second after launch (DEBUG),
  so a simulator the session can't tap still gets the shot. To hide the
  "Connect Apple Health" card on a sim without Health access, set
  `today.healthInvite.dismissed` true in the app's preferences plist.
- `shoot.sh SIM en|vi OUT.png WAIT [launch args]` relaunches with Pro (no
  ads) in that language and saves a screenshot. Set the clock first:
  `xcrun simctl status_bar SIM override --time 9:41 --batteryState discharging
  --batteryLevel 100` (iPhone; the 2026-11-23 iPad set used `charged`), and
  clear it after. The screens say "Good evening" after 17:00, so a full
  re-shoot is better done with the clock near the real time.
- Save the raw shots as `raw/iphone_<lang>_<n>.png` and
  `raw/ipad_<lang>_<n>.png` (gitignored).

## Composing

    python3 compose.py iphone.json out
    python3 compose.py ipad.json out          # or name some outputs to redo only those

- Fonts: SF Pro Display Heavy (EN, as in the old set) and Black (VI, upper
  case, with extra line pitch for the marks). Medium for subtitles.
- `upper: true` makes a headline upper case, like the old Vietnamese set.
- `erase` paints boxes of the raw shot with the colour just right of them: the
  iPad status bar's English date and the "MUSQ" label, so the VI set doesn't
  show an English date.
- Paid features say so in the subtitle (guideline 2.3.2): "With MUSQ Pro",
  "With Premium or Pro".
