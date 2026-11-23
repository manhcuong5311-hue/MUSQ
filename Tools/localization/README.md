# Localization (Vietnamese, 2026-11-02)

MUSQ ships in English and Vietnamese. It follows the iPhone's language; the
Language row in Settings opens iOS Settings, where a language can be picked
for MUSQ alone. The owner's rules: everything is Vietnamese except **exercise
names, which stay English everywhere**, and muscles use Vietnamese
**anatomical** names. `vi_glossary.md` holds the style rules and terms every
translation follows.

## Where the text lives

| What | Source of the English | Translations |
|---|---|---|
| UI written in code | `Text("…")`, `String(localized:)`, any `String.LocalizationValue` parameter | `GymWorkout/Localization/Localizable.xcstrings` |
| Coaching copy, muscle/equipment names, stance labels/notes, x-ray demos | `Models/SampleData.swift`, `Models/XRayDemos.swift` | `GymWorkout/Localization/vi.lproj/Content.strings` |
| ATT prompt | `Info.plist` | `GymWorkout/Localization/InfoPlist.xcstrings` |

Data strings stay English in the data (they are matched in English by
`MusclePart(muscleName:)`, equipment checks and the x-ray label checks) and
are translated only where they are shown: `L10n.content(x)` /
`x.localizedContent` (`GymWorkout/Localization/L10n.swift`). The table is keyed
by the English string, so a sentence edited in SampleData shows in English
until it is translated again; nothing breaks.

## After changing or adding content

```
python3 Tools/localization/content.py check --list     # what has no Vietnamese yet
python3 Tools/localization/content.py extract --out /tmp/en.json   # ids, fields, exercises
python3 Tools/localization/content.py merge new_vi.json   # {English or id: Vietnamese}
```

`merge` rewrites `Content.strings` in source order with a comment per entry
(exercise · field); entries whose English is gone stay at the bottom until
`--drop-stale`. Muscle and equipment names come from `vi_names.json` (merge it
like any other file); new names need a row there, in all three casings the data
uses (Title Case activation rows, lower-case stabilisers, UPPER CASE library
meta).

## After changing UI code

Build the app (the lab build: `Tools/lab/build.sh --no-install`), then

```
LAB=<lab folder> python3 Tools/localization/ui.py audit    # literals that look shown but are not localizable
LAB=<lab folder> python3 Tools/localization/ui.py keys --out keys.json
LAB=<lab folder> python3 Tools/localization/ui.py catalog ui_vi.json   # {key: Vietnamese}
```

`catalog` rewrites `Localizable.xcstrings` from the keys the compiler extracted,
keeping translations already there and adding the file's. Keys with format
specifiers (`%lld`, `%@`) keep the same specifiers in Vietnamese.
Same English, different meaning (the muscle group "Back" vs a back button):
give one a key of its own, `String(localized: "muscleGroup.back", defaultValue: "Back")`.

## How the 2026-11-02 round was made

The UI code was made localizable by agents (one per group of screens; shared
components first, so a literal passed to `SectionEyebrow`, `WideButton`,
`FilterChip`… localizes by itself through a `String.LocalizationValue`
overload, while a `String` argument is shown as it is). The coaching copy
(13,477 strings, 230k words) was translated in 35 batches by one agent each and
re-read by a second, checked by script for kept exercise names, numbers,
UPPER CASE and label length, then decimals were switched to the Vietnamese
comma (0,16 m). The UI (855 keys) went the same way with the code around each
key as context. The owner approved the style on a Barbell Bench Press sample
first; the app was then checked in Vietnamese on the harness simulator
(onboarding, paywall, all four tabs, Settings, trainer labels, the mistake
sheet). Launch arguments `-AppleLanguages "(vi)" -AppleLocale vi_VN` show
the app in Vietnamese without changing the simulator's language; system
prompts (ATT) follow the device language.

## The 2026-11-23 round (Today, plan, Health, Balance, AI, goal photo)

1,629 new UI keys were translated (2,466 keys, all with Vietnamese), plus
the permission prompts in `InfoPlist.xcstrings` (camera, Apple Health,
microphone, speech recognition, photo saving). Terms and tone for these
features: `vi_glossary_features.md`.

- **Components take literals again.** With Swift 6.4 the `@_disfavoredOverload`
  `init(text: String)` beat the `String.LocalizationValue` init for many
  literal calls (a lone literal, a trailing closure, a computed size), so
  those eyebrows, meta lines, buttons and banners were never extracted and
  showed English; 11-02 translations such as LỖI THƯỜNG GẶP, LỊCH SỬ and
  NHÓM CƠ ĐƯỢC TẬP sat unused. The as-given inits in `Components.swift` are
  now generic over `StringProtocol`, the shape of SwiftUI's `Text`, so a
  literal localizes and a String still shows as given.
- `ui.py keys` keeps every comment of a key (sorted, joined by a newline, as
  Xcode merges them); `ui.py catalog` writes the file in Xcode's own layout
  and key order (`localizedStandardCompare`), so a later Xcode build doesn't
  rewrite it. `--keep-stale` keeps keys no longer in the code as Xcode would.
- `make_batches.py KEYS.json OUTDIR` splits the keys without Vietnamese into
  batches with the code around each use; `check_vi.py TRANSLATIONS.json
  BATCH.json…` checks a translation: specifiers, `%%`, no-break spaces,
  exercise names, UPPER CASE, label length, decimal points, spelling.
- Literal percent: a key with arguments writes `%%`, one without writes `%`;
  Vietnamese must do the same. Keep U+00A0 between a number and its unit.
- Keep "%@ + %@" as it is in Vietnamese: the quick log's DEBUG self-test
  compares a meal title with that pattern and would assert.
- `NSHealthUpdateUsageDescription` has different English in Debug and
  Release (build settings); its Vietnamese follows the Release text.
- Checked on the harness simulator with `-AppleLanguages "(vi)" -AppleLocale
  vi_VN`: Today (all three layouts), quick log, Profile and Settings,
  Progress, the paywall (`-paywall.samplePlans YES`), the AI sign-in sheet and
  the whole onboarding. `-today.layout dial` shows a layout for one launch
  without changing the saved one. The harness keyboard is Vietnamese Telex,
  so typed ASCII words can come out with marks.
