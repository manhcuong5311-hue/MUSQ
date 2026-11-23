# Vietnamese glossary: Today, plan, Health, Balance, AI and goal photo (2026-11-23)

The terms and tone for the features added 2026-11-21 → 11-23, settled by a
glossary agent from all 1,629 strings of that round, then used by seven
translators and checked by seven reviewers and a consistency pass. It sits
next to `vi_glossary.md`, which still binds (exercise names stay English,
anatomical muscles, hiệp / lần). New copy for these features follows it.

Changed after review (what shipped wins over the tables below):
- "✓ Today" on the Dial weight tile → "✓ Xong" (✓ HÔM NAY overflows the tile).
- "Step on the scale." → "Bước lên cân thôi." ("lên cân" alone reads "gain weight").
- "Muscle" over the goal photo's muscle picker and on the Goal page → "Lượng cơ",
  so it differs from the level "Muscular" → "Cơ bắp".
- "%lld in" (inches) → "%lld inch" ("in" also means "print"); "Tenths" (the
  weight wheel's decimal digit, VoiceOver) → "Phần thập phân".
- A macro row too tight for the full names falls back to "Đạm / Béo / Bột"
  (keys macro.short.*), the words of the one-line meal summary.
- "mình" is not used at all, the reflexive "của mình" included ("của họ" or a name).
- Literal percent: a key with arguments writes `%%`, one without writes `%`;
  keep it the same in Vietnamese ("25%% × %@ ÷ 9 = %lld g").

Features: Today tab, plan onboarding (calories, macros, safety), Apple Health,
Balance, quick logs, meal scan, Progress, Premium/Pro, Ask MUSQ, goal photo and
the Goal page. Built from glossary_v0.md (every v0 decision is kept below
unless §0 says otherwise), the owner's rules of 2026-11-02 in
`Tools/localization/vi_glossary.md`, the Vietnamese already in
`Localizable.xcstrings`, and the `en` + `comment` of all 1,629 keys in
batch_01 … batch_07.

How to use it

- `vi_glossary.md` still binds: exercise names stay English, muscles are
  anatomical, set = hiệp, rep = lần, imperatives without a pronoun, "bạn" only
  where a sentence needs a subject, UPPER CASE stays upper case.
- One rendering per term. When one English word has two meanings, §6 says
  which rendering goes with which meaning. The key's comment tells you which
  meaning you have.
- Anything the catalog already translates keeps its translation: Huỷ, Xoá,
  Xong, Lưu, Sửa, Đóng, Thử lại, Để sau, Hoàn tác, Bỏ qua, Tiếp tục, buổi tập,
  hiệp, lần, Preset, tab Tập, Cá nhân › Cài đặt, Tài khoản Apple, kỷ lục cá
  nhân, phục hồi, khối lượng…
- Copy the patterns below, not just the words: "Còn %@", "%lld/%lld",
  "%@/năm", "Đã thêm %@".

---

## 0. What changed from draft v0

| v0 | Now | Why |
|---|---|---|
| on track → đúng tiến độ | Balance word **On track** → **Đúng hướng**. "đúng tiến độ" stays for the weight result **On pace**. | A habit score is not a schedule. Three distinct words keep the Balance word, the weight pace and the goal course apart (§13, §16). |
| behind → chậm hơn | Goal tag **Behind** → **Chậm tiến độ**; week recap "Behind this week" → **Còn thiếu tuần này**; Balance part "Furthest behind" → **Thiếu nhiều nhất** | "Chậm hơn" needs something to compare with. As a tag it reads unfinished. |
| weigh-in → lần cân | Kept for the event and counts. As a habit title (Today ring/row/tile "Weigh-in") → **Cân nặng** | A ring or row titled "Lần cân" reads oddly. |
| asleep → ngủ | Kept in sentences ("ngủ 7 giờ"). The labels "Asleep" (chart) and "Time asleep" → **Thời gian ngủ** | "Ngủ" alone as a label reads as a verb. |

Everything else in v0 is unchanged. New entries are not marked.

---

## 1. Hard format rules (check_vi.py checks most of these)

1. **Specifiers**: keep the same set with the same types (`%@` stays `%@`,
   `%lld` stays `%lld`). To reorder, use positional forms (`%1$@`, `%2$lld`)
   and number every specifier in that string. Never drop or merge one.
2. **Percent**: if the English writes `%%` (strings with specifiers), write `%%`;
   if it writes `%` (strings without), write `%`. Copy the English.
3. **No-break spaces (U+00A0)**: keep every one the English has, in the same
   place, usually between a number and its unit (`%@` + U+00A0 + `kcal`,
   `%lld` + U+00A0 + `ml`, "Use the suggestion: `%lld` + U+00A0 + `%@`").
   Copy the character from the English value; do not retype it as a plain
   space, and do not add new ones. The checker counts them.
4. **Symbols**: keep `·` `→` `✓` `…` `“ ”` `×` `÷` `²` `≈` `–` `—` `›` `±` `+`
   exactly, the same number of times. `…` is one character, quotes are curly
   `“ ”`, ranges use the en dash with no spaces (`1–13`, `18,5–24,9`).
5. **Numbers written in the text** (numbers inside specifiers are formatted by
   the app, so leave them alone):
   - decimals take a **comma**, never a point: 18,5 · 0,8 g/kg · 2,5 L ·
     0,25% · 0,5–0,59;
   - thousands take the Vietnamese **grouping dot**, as the app's own
     Vietnamese numbers show them: 10.000 kcal · 3.000 g · 4.000 bước.
     check_vi.py reports "decimal point added" for these. That report is a
     false positive only when the dot is followed by exactly three digits;
     any other dot between digits is an error.
6. **Keep verbatim**: MUSQ, MUSQ Premium, MUSQ Pro, Premium, Pro, PREMIUM,
   PRO (tier names stay as they are in every language), Apple Health,
   HealthKit, Apple Watch, Watch, iPhone, iPad, iOS, OpenAI, AI, kcal, BMI,
   BMR, TDEE, 1RM, REM, EFSA, WHO, PAR-Q+, Mifflin-St Jeor, Epley, and in
   source lines every author, "et al.", journal, year, report number and
   published title (§11.6).
7. **End punctuation** follows the English: a period, question mark or colon
   where the English has one; none on buttons, chips, toggles, tags, segments,
   labels or titles that have none.
8. **UPPER CASE** stays upper case, with every diacritic: ĐÃ KẾT NỐI · CHỈ ĐỌC.
   Follow the case of the English value, not of the screen: when the comment
   says "shown in capitals" but the English is "Plan pace", "✓ Done" or
   "Goals", write sentence case ("Theo kế hoạch", "✓ Xong", "Mục tiêu"). The
   app does the upper-casing.
9. **Length**: labels, chips, tags, segments and words inside rings stay close
   to the English, at most about 25% longer. check_vi.py warns past 1.6 × + 4
   characters. A comment saying "keep it short" or "about 8 characters" is a
   hard limit. Prose may be as long as natural Vietnamese needs. Two length
   warnings are expected and accepted: "Recomp" → "Giảm mỡ tăng cơ" (v0's
   goal name, in rows with room) and "Ask MUSQ coach" → "Huấn luyện viên AI
   Hỏi MUSQ" (a paywall table title that wraps, like the catalog's "Lỗi thường
   gặp vẽ trên người tập" beside it).
10. No leading or trailing spaces unless the English has them.
11. Paths: " › " with a space on each side: Cài đặt › Quyền riêng tư & Bảo mật
    › Sức khỏe › MUSQ.

---

## 2. Tone and voice

- **Buttons, chips, toggles, segments, tags**: sentence case (capital first
  letter; the rest lower case except names), a bare verb, no "hãy", no
  "bạn", no period. Examples: "Ghi bữa ăn", "Kết nối Apple Health",
  "Đặt nhắc nhở", "Xem các gói", "Thêm 250 ml".
- **Titles and section headers**: sentence case, unless the English is UPPER
  CASE.
- **Instructions in prose**: an imperative without a pronoun ("Cân vào cùng một
  giờ mỗi ngày"). "Hãy" may open or close a piece of advice when it softens it,
  as the catalog does ("Hãy thử lại hoặc dùng Khôi phục giao dịch mua.",
  "…, hãy đi khám bác sĩ"). Short status lines use the bare verb ("Kiểm tra kết
  nối và thử lại."). Never put "hãy" on a button, and never write "Bạn hãy".
- **"bạn"**: use it only where the sentence needs a subject. Drop "của bạn"
  when it adds nothing ("Your daily calories" → "Lượng calo mỗi ngày"). A page
  title may keep it ("Your goal" → "Mục tiêu của bạn").
- **The member's own words use "tôi"**, as the catalog's FAQ questions and
  onboarding answers do. This covers onboarding answers, toggles and buttons
  with "my" or "I", the chat's suggested questions, the Balance question MUSQ
  pre-fills, and the age confirmation. Examples: "Tôi đang mang thai",
  "Gửi kèm giấc ngủ của tôi (Apple Health)", "Tạo ảnh mục tiêu của tôi",
  "Tôi có phục hồi đủ giữa các buổi tập không?".
- **"we"** → "chúng tôi" (as the catalog has it), or make MUSQ the subject when
  that reads better ("MUSQ sẽ bỏ các bài…"). Never use "mình" or "chúng ta".
- **Warmth**: "nhé", "nào" and "thôi" belong only in the Today coach and dial
  lines and in notifications, as in the catalog's motivational lines ("Cùng
  hoàn tất kế hoạch nhé."). Never use them in settings, privacy, purchase,
  medical or error text.
- **Errors**: say what happened, then what to do: "MUSQ không xác minh được
  thiết bị này. Hãy cập nhật MUSQ rồi thử lại."
- **VoiceOver**: labels must read naturally aloud. Hints are a verb phrase
  with no subject, as in the catalog ("Mở trang mục tiêu", "Thêm vào bữa ăn").
  Values: Expanded → Đã mở rộng, Collapsed → Đã thu gọn.
- **"X of Y"**: on screen, write "X/Y" ("2/4 buổi", "Xong 1/3", "Đạt 5/7
  ngày"). Spoken by VoiceOver, write "X trên Y" ("2 trên 4 buổi"), as the
  catalog does ("Câu hỏi %lld trên %lld").
- **Tabs inside a sentence** take "tab": ở tab Hôm nay, ở tab Tập, ở tab Tiến
  độ, tab Cá nhân (as in the catalog: "Tab Tập gợi ý…"). In › paths and titles
  there is no "tab": Cá nhân › Cài đặt.
- **Capitalised names in prose**: Cân bằng (the score), Hỏi MUSQ, Tập / Ăn /
  Ngủ (the pillars), Hôm nay / Tiến độ (the tabs), the Balance words (Rất tốt,
  Đúng hướng…), and goal and level names when quoted. Generic nouns stay lower
  case: ảnh mục tiêu, quét bữa ăn, ghi nhanh, trang mục tiêu, huấn luyện viên AI.
- **The member's device**: `%@` = iPhone or iPad. Write "trên %@ này" (on this
  device) or "%@ của bạn" (your device), and "điện thoại này" for "this phone"
  (as in the catalog).

---

## 3. Spelling (matches the existing copy)

| Write | Not |
|---|---|
| huỷ, Huỷ | hủy |
| xoá, Xoá | xóa |
| hoà | hòa |
| minh hoạ | minh họa |
| khoá (mở khoá), hoá | khóa, hóa |
| khỏe (sức khỏe, Sức khỏe) | khoẻ |
| tùy (tùy chọn) | tuỳ |
| hợp lý, kỹ thuật, kỷ lục, quý, Mỹ | hợp lí, kĩ thuật |
| micrô, gam, calo, email, Chủ nhật | micro, gram, calorie, e-mail, chủ nhật |

check_vi.py flags xóa, hủy, hòa, minh họa, khoẻ and tuỳ. The older catalog
strings with "Tuỳ chọn" (×2) and "khoẻ" (×1) were brought in line the same day.

---

## 4. iOS and Apple names (as Vietnamese iOS shows them)

| English | Vietnamese |
|---|---|
| Settings (the iOS app) | Cài đặt |
| iOS Settings (to tell it apart from MUSQ's own settings) | Cài đặt iOS |
| Open Settings (button that opens iOS Settings) | Mở Cài đặt |
| Settings › MUSQ | Cài đặt › MUSQ |
| Privacy & Security | Quyền riêng tư & Bảo mật |
| Settings › Privacy & Security › Health › MUSQ | Cài đặt › Quyền riêng tư & Bảo mật › Sức khỏe › MUSQ |
| Notifications | Thông báo |
| Tracking | Theo dõi |
| Settings › Apple Account › Subscriptions | Cài đặt › Tài khoản Apple › Đăng ký (as in the catalog) |
| the Health app | ứng dụng Sức khỏe |
| Open Health (button) | Mở Sức khỏe |
| Health app: tap your picture › Apps › MUSQ | ứng dụng Sức khỏe: chạm vào ảnh hồ sơ › Ứng dụng › MUSQ |
| Photos (the app and library) | Ảnh ("Lưu vào Ảnh", "Đã lưu vào Ảnh") |
| Camera | Camera |
| Microphone, mic | Micrô, micrô |
| Dictation, keyboard dictation | Đọc chính tả, đọc chính tả trên bàn phím |
| Sign in with Apple | Đăng nhập bằng Apple |
| Signed in with Apple | Đã đăng nhập bằng Apple |
| Apple Account | Tài khoản Apple |
| Apple Watch, Watch | unchanged |
| Allow notifications | Cho phép thông báo |
| Return (the quick-log field's key; the field uses a Done key) | Xong ("Nhấn Xong để ghi “%@” là calo…") |

**Apple Health or ứng dụng Sức khỏe?**

- **Apple Health** names the integration and its data: Kết nối Apple Health,
  từ Apple Health, "(Apple Health)", Apple Health không có dữ liệu, ĐÃ KẾT NỐI.
  English "Health" alone meaning that data ("never writes to Health") →
  Apple Health.
- **ứng dụng Sức khỏe** is for opening Apple's app or changing something in it:
  "Mở ứng dụng Sức khỏe", "đổi sau trong ứng dụng Sức khỏe". The short button
  "Open Health" → "Mở Sức khỏe".
- **Sức khỏe** alone is used as an element of a › path.
- "Apple's Health sheet" (the access sheet that opens on Connect) → "bảng cấp
  quyền Sức khỏe của Apple"; "Apple's sheet" → "bảng của Apple".
- **MUSQ's own settings** keep MUSQ's names: Cá nhân › Cài đặt › Apple Health,
  Cá nhân › Cài đặt › Cân bằng, "Settings › Balance" → Cài đặt › Cân bằng,
  "Off in Settings" (a Balance pillar) → Đã tắt trong Cài đặt, Edit Profile →
  Sửa hồ sơ (as in the catalog).
- "Off in iOS Settings" or "…are off in iOS Settings" → "… trong Cài đặt iOS".

---

## 5. Feature names

| English | Tiếng Việt |
|---|---|
| Today (tab) | Hôm nay |
| Progress (tab, was Muscles; also the Goal page section) | Tiến độ |
| Train / Exercises / Profile (tabs) | Tập / Bài tập / Cá nhân (as in the catalog) |
| Balance (the Eat · Sleep · Train score) | Cân bằng; "your Balance" (the number) → điểm Cân bằng |
| Eat · Sleep · Train | Ăn · Ngủ · Tập |
| pillar, part (Train, Eat or Sleep) | mảng ("mảng yếu nhất", "hai trong ba mảng") |
| Quick log | Ghi nhanh |
| Scan a meal, meal scan | Quét bữa ăn |
| meal scans (an allowance), scan (one use) | lượt quét bữa ăn, lượt quét |
| Goal photo | Ảnh mục tiêu |
| Goal (the page and the record) | Mục tiêu; "Goal page" in running text → trang mục tiêu (lower case, as in §2) |
| Goal physique | Vóc dáng mục tiêu |
| the look (muscle + body fat picked for the goal photo) | vóc dáng |
| Ask MUSQ | Hỏi MUSQ |
| coach (the AI chat) | huấn luyện viên AI |
| Ask MUSQ coach (paywall row title), the Ask MUSQ coach (in a sentence) | Huấn luyện viên AI Hỏi MUSQ / huấn luyện viên AI Hỏi MUSQ |
| coach (the Today coach lines, not AI) | huấn luyện viên |
| Apple Health | Apple Health |
| Premium, Pro, MUSQ Pro, MUSQ | unchanged |
| Today layout | Bố cục Hôm nay |
| Help & FAQ section BALANCE & LOGGING | CÂN BẰNG & GHI CHÉP |

---

## 6. Same English, different meaning

| English | Meaning (from the key or comment) | Vietnamese |
|---|---|---|
| plan | the member's calorie and training plan from onboarding | kế hoạch |
| plan | a subscription (Premium/Pro, monthly/yearly); "Pro keeps everything in your plan", "Goal photos need a plan" | gói |
| YOUR PLAN | onboarding (already in the catalog) / `paywall.yourPlan` | KẾ HOẠCH CỦA BẠN / GÓI CỦA BẠN |
| Strong | `balance.word.strong` (score 80+) / `goal.muscle.strong` | Rất tốt / Vạm vỡ |
| Done | the button (catalog) / `today.exercise.done`, `today.state.done` / `balance.grid.done` | Xong / Đã xong / Đạt |
| Not done | catalog (not trained) / `balance.grid.notDone` | Chưa tập / Chưa đạt |
| Close | the button (catalog) / `balance.checkIn.protein.close` | Đóng / Gần đạt |
| Core | the muscles (catalog) / `health.sleepStage.core` | Cơ lõi / Ngủ lõi |
| Not yet | `onboarding.cleared.notYet` / no weigh-in yet today | Chưa / Chưa cân |
| Start %@ | Today button ("Start Push day") / `goal.progress.start` | Bắt đầu %@ / Ban đầu %@ |
| On track · On pace · On course | Balance word / weight result / goal tag | Đúng hướng · Đúng tiến độ · Đúng lộ trình |
| check-in | Balance: the member rates their own day | tự đánh giá |
| check-in | Goal: the weekly Sunday note | cập nhật (hằng tuần) |
| check-up | the after-birth medical visit | khám sau sinh |
| Lean | the gain pace "Lean · 0.25% a week" / goal body-fat level | Ít mỡ / Rõ múi |
| Same | goal muscle and body-fat level (one key) | Giữ nguyên |
| Ring / Rings | card style (one key, Balance and Goal) / Today layout | Vòng / Vòng |
| Bar / Bars | Goal card style / Balance card style (horizontal bars) | Thanh / Thanh |
| bar (in a chart) | "Bar = the week's lever" | cột |
| Note | Balance part (a caution) / meal-scan note | Lưu ý / ghi chú |
| read | the parser reading words ("Read as…") / the AI reading a photo / Apple Health data | đã hiểu là / nhận diện / đọc |
| recommended | the workout or day MUSQ picks / a health amount from guidelines | đề xuất (catalog) / khuyến nghị |
| suggest, suggested | MUSQ's suggestion | gợi ý |
| target / goal | both | mục tiêu |
| Sleep | one key: the pillar, the colour row, the estimate sheet's title, the Today tile | Ngủ |
| Settings | the iOS app / MUSQ's own screen | see §4 |
| Health | Apple's app / the Apple Health data | see §4 |
| Today | the tab / the day | tab Hôm nay (in sentences) / hôm nay |
| Train | the tab / the pillar | tab Tập / Tập |

---

## 7. Logging and food

| English | Tiếng Việt |
|---|---|
| log (verb) / logged | ghi / đã ghi |
| log (noun): meal log, workout log | nhật ký ăn uống, nhật ký tập (as in the catalog) |
| Quick log tabs WATER / WALK / FOOD | NƯỚC / ĐI BỘ / ĐỒ ĂN |
| menu items Water / Walk / Food; "the Food tab" | Nước / Đi bộ / Đồ ăn; tab Đồ ăn |
| Log water, a walk or a meal | Ghi nước, đi bộ hoặc bữa ăn |
| meal | bữa ăn ("Meal" as the default name → Bữa ăn) |
| food (an item in a meal), foods | món |
| food table (MUSQ's) | bảng món ăn (của MUSQ) |
| MATCHING FOODS / FOODS FOUND / THIS MEAL | MÓN PHÙ HỢP / MÓN TÌM THẤY / BỮA ĂN NÀY |
| serving / piece (generic count) | phần / cái |
| %@ times (a multiple, VoiceOver) | %@ lần |
| glass (of water), cup, bottle | ly, cốc, chai |
| calories / kcal | calo / kcal (the unit kcal always stays kcal) |
| protein / carbs / fat (macro) / fibre / sugar | đạm / tinh bột / chất béo / chất xơ / đường |
| macros | macro (loanword, no plural; MACRO in upper case) |
| compact macro line "P %lld g · F %lld g · C %lld g" | Đạm %lld g · Béo %lld g · Bột %lld g |
| %lld%% of kcal | %lld%% tổng kcal (English "kcal" always stays "kcal"; English "calories" → "calo") |
| added fat / sauce / sugar (hidden in a food) | dầu mỡ thêm / nước sốt / đường |
| walk (the activity, a label) / a walk (one instance) | đi bộ / lần đi bộ |
| Add walk | Thêm đi bộ |
| steps / Steps (label) | bước / Số bước |
| MINUTES / STEPS (walk segments) | SỐ PHÚT / SỐ BƯỚC |
| weigh-in (the event) / weight | lần cân / cân nặng |
| Weigh-in (habit title on Today) / weigh in (verb) | Cân nặng / cân |
| Log weight / Weigh-in reminder / Morning weigh-in | Ghi cân nặng / Nhắc cân / Cân buổi sáng |
| Edit today's, Change today's (today's weigh-in) | Sửa hôm nay |
| body fat | mỡ cơ thể; % mỡ in tight spaces |
| body fat % (the number) | tỷ lệ mỡ cơ thể |
| lean mass | khối nạc |
| boiled or steamed / grilled / fried / stir-fried | luộc hoặc hấp / nướng / chiên / xào |
| little oil / lots of oil | ít dầu / nhiều dầu |
| type / say / enter (a value) | gõ / nói / nhập ("Nói hoặc gõ", "Nhập số phút") |
| typed in, by hand / add by hand | tự nhập / tự thêm |
| TYPED (badge) / Typed in (VoiceOver) | TỰ NHẬP / Tự nhập |
| Added by you | Bạn tự thêm |
| Custom amount… | Nhập lượng khác… |
| Fill in from this / Fill in a %lld-minute walk | Điền từ nội dung này / Điền %lld phút đi bộ |
| Read as food. / Read as %@ of water. | Đã hiểu là đồ ăn. / Đã hiểu là %@ nước. |
| closest match / check the amount / your numbers | món gần đúng nhất / kiểm tra lại lượng / số của bạn |
| Leave it out / Discard meal | Bỏ món này / Bỏ bữa ăn |
| Remove (a food from the meal) / Remove (a button, a meal) | bỏ … khỏi / xoá |
| Clear (typed words) | Xoá |
| Search foods… / Add food | Tìm món… / Thêm món |
| Optional | Không bắt buộc ("(không bắt buộc)") |
| Eaten (time of a meal) | Ăn lúc |
| Hold the mic / Let go / tap the mic | Giữ micrô / Thả tay / chạm vào micrô |
| press and hold | chạm và giữ |
| Listening… / Getting the mic ready… / Stop listening / Speak | Đang nghe… / Đang chuẩn bị micrô… / Dừng nghe / Nói |
| heard on your %@, never recorded or sent | được nhận dạng ngay trên %@, không bao giờ được ghi âm hay gửi đi |
| Undo: %@ / Logged %@ / Added %@ | Hoàn tác: %@ / Đã ghi %@ / Đã thêm %@ |

---

## 8. Example phrases the member is told to type or say

They must be Vietnamese the app's parsers read (`QuickLogParser.swift`,
`FoodPhraseParser.swift`). Each one below was run through the app's own parser
code on 2026-11-23 and read as shown. Use exactly these, in “ ”.

| English | Vietnamese | Tab | Read as |
|---|---|---|---|
| “2 glasses” | “2 ly” | Water | 500 ml |
| “500 ml” | “500 ml” | Water | 500 ml |
| “walked 30 minutes” | “đi bộ 30 phút” | Walk | 30 min, 3.000 bước |
| “30 minutes” | “30 phút” | Walk | 30 min |
| “4,000 steps” | “4.000 bước” | Walk | 4.000 bước |
| “phở bò” | “phở bò” | Food | Phở bò tái |
| “2 eggs” | “2 quả trứng” | Food | 2 × Trứng gà luộc |
| “phở 450 kcal” | “phở 450 kcal” | Food | phở, 450 kcal |
| “2 eggs and a bowl of rice” | “2 quả trứng và một chén cơm” | Food | 2 trứng + 1 chén Cơm trắng |
| “500 ml water” (FAQ) | “500 ml nước” | Water | 500 ml |
| “walked 30 minutes” (FAQ) | “đi bộ 30 phút” | Walk | as above |
| “chicken rice 650 kcal” (FAQ) | “cơm gà 650 kcal” | Food | cơm gà, 650 kcal |

- Use "chén" for the rice bowl: it is the food table's own unit for rice and
  goes with v0's "ly" and "chiên". "bát" and "tô" parse too.
- Keep "kcal" in examples (a protected word). "calo" also parses.
- The meal-scan note example (“fried in butter” → “chiên bằng bơ”) is read by
  the AI, not the parser, so any natural Vietnamese works there.
- “Slept about…” is a name in the copy, not a visible label. Write it as
  “Ngủ khoảng…” wherever it is quoted (Balance settings ×2, FAQ ×1).
- Words the parsers know, for any other example: water: nước, uống, ly, cốc,
  chai, ml, lít, nửa, rưỡi. Walk: đi bộ, bước, phút, giờ, tiếng, km.
  Food: ăn, calo, kcal, đạm, béo, tinh bột, tô, bát, chén, đĩa, phần, quả,
  cái, miếng, lon, và. Numbers in digits or words (hai, ba, một…).

---

## 9. Meal scan

| English | Tiếng Việt |
|---|---|
| Scan a meal (chip and sheet title) | Quét bữa ăn |
| Read this meal / Reading your meal… | Nhận diện bữa ăn này / Đang nhận diện bữa ăn… |
| Log meal | Ghi bữa ăn |
| Meal photo / Try another photo | Ảnh bữa ăn / Thử ảnh khác |
| note (to the AI) / Add a note (optional), e.g. “…” | ghi chú / Thêm ghi chú (không bắt buộc), ví dụ “chiên bằng bơ” |
| AI estimate · high / medium / low confidence | Ước tính của AI · độ tin cậy cao / trung bình / thấp |
| portion(s) | khẩu phần |
| %lld scans left today / 1 scan left today | Còn %lld lượt quét hôm nay / Còn 1 lượt quét hôm nay |
| That's today's meal scans. More tomorrow. | Đã hết lượt quét bữa ăn hôm nay. Mai sẽ có thêm. |
| Meal scans need your OK first. | Quét bữa ăn cần bạn đồng ý trước. |
| Sign in with Apple to scan meals. | Đăng nhập bằng Apple để quét bữa ăn. |
| paused for now | đang tạm dừng |
| Includes about %@ | Đã gồm khoảng %@ |
| Search MUSQ's food table by name, in English or Vietnamese. | Tìm trong bảng món ăn của MUSQ theo tên, bằng tiếng Việt hoặc tiếng Anh. |
| Add “%@” by hand | Tự thêm “%@” |
| Edit meal / Delete meal / Meal name | Sửa bữa ăn / Xoá bữa ăn / Tên bữa ăn |
| %@ kcal left today / %@ kcal over today's plan | Còn %@ kcal hôm nay / Vượt %@ kcal so với kế hoạch hôm nay |
| Macros not logged / Macros from %lld of %lld meals | Chưa ghi macro / Macro từ %lld/%lld bữa |

---

## 10. Plan, goals and body

| English | Tiếng Việt |
|---|---|
| Lose fat / Build muscle / Recomp / Stay fit | Giảm mỡ / Tăng cơ / Giảm mỡ tăng cơ / Giữ dáng |
| calorie plan / daily target | kế hoạch calo / mục tiêu mỗi ngày |
| deficit / surplus / maintain | thâm hụt / dư thừa / duy trì |
| what you burn (maintenance) / eat what you burn | lượng calo bạn tiêu hao, mức tiêu hao / ăn bằng mức tiêu hao |
| calorie floor / the floor / held at / capped at | mức calo tối thiểu / mức tối thiểu / giữ ở / tối đa, giới hạn ở |
| Deficit capped at 25% / Surplus capped at 20% | Thâm hụt tối đa 25% / Dư thừa tối đa 20% |
| Recomp deficit / Adjustment / Capped | Thâm hụt khi giảm mỡ tăng cơ / Điều chỉnh / Đã giới hạn |
| Target reached / Time to target | Đã đạt mục tiêu / Thời gian đến mục tiêu |
| BMR, TDEE, BMI | unchanged; "At rest (BMR)" → "Khi nghỉ (BMR)"; "With your activity (TDEE, × %@)" → "Cộng vận động (TDEE, × %@)" |
| metabolism / activity factor | trao đổi chất / hệ số vận động |
| Underweight / Healthy weight / Overweight / Obese | Thiếu cân / Cân nặng hợp lý / Thừa cân / Béo phì |
| healthy range (BMI 18.5–24.9) | khoảng hợp lý (BMI 18,5–24,9) |
| BMI classes / Asian cut-offs / growth charts | phân loại BMI / ngưỡng cho người châu Á / biểu đồ tăng trưởng |
| Sedentary / Lightly / Moderately / Very / Extra active | Ít vận động / Vận động nhẹ / Vận động vừa / Vận động nhiều / Vận động rất nhiều |
| daily activity; the daily-activity question | mức vận động hằng ngày; câu hỏi về mức vận động hằng ngày |
| Mostly sitting / On my feet a lot / Heavy physical work | Chủ yếu ngồi / Đi lại nhiều / Lao động nặng |
| step bands: under %@ / %@–%@ / %@ and up | dưới %@ / %@–%@ / từ %@ trở lên |
| pace / PACE | tốc độ / TỐC ĐỘ |
| gain paces: Lean / Standard | Ít mỡ / Tiêu chuẩn |
| loss paces: Gentle / Steady / Faster | Nhẹ nhàng / Đều đặn / Nhanh hơn |
| on pace / slower / faster than plan | đúng tiến độ / chậm hơn kế hoạch / nhanh hơn kế hoạch |
| Plan pace (chart line label, shown in capitals) | Theo kế hoạch |
| target weight / That's %@ to lose / to gain | cân nặng mục tiêu / Cần giảm %@ / Cần tăng %@ |
| pregnant / breastfeeding / after the birth | đang mang thai / đang cho con bú / sau sinh |
| first / second / third trimester | 3 tháng đầu / 3 tháng giữa / 3 tháng cuối |
| give birth / midwife / cleared to exercise | sinh con / nữ hộ sinh / được cho phép tập lại |
| deep core / pelvic floor | cơ lõi sâu / cơ sàn chậu |
| check-in (Goal: the weekly Sunday reminder) | cập nhật (hằng tuần) |
| check-in (Balance: the member rates their own day) | tự đánh giá |
| waist / neck / hips (measurements), WAIST… | vòng eo / vòng cổ / vòng hông, VÒNG EO… |
| tape, Measure with a tape / smart scale / body scan | thước dây, Đo bằng thước dây / cân thông minh / máy đo thành phần cơ thể |
| navel / voice box | rốn / thanh quản |
| waist-to-height (ratio) | tỷ lệ eo/chiều cao |
| the US Navy tape formula | công thức thước dây của Hải quân Mỹ |
| health risk (raised / high) | nguy cơ sức khỏe (tăng / cao) |
| YOUR PLAN · BODY / · CALORIES / · MACROS / · WEEK | KẾ HOẠCH CỦA BẠN · CƠ THỂ / · CALO / · MACRO / · TUẦN |
| HOW IT'S CALCULATED / How it's calculated | CÁCH TÍNH / Cách tính |
| split three ways | chia làm ba phần |
| split (training) | lịch tập (as in the catalog; "lịch chia nhóm cơ" where it must be explicit) |
| Rest (a day in the week strip) | Nghỉ |
| Finish your plan / Answer the new questions | Hoàn tất kế hoạch / Trả lời các câu hỏi mới |
| Set a new goal | Đặt mục tiêu mới |

---

## 11. Health conditions, safety and medical wording

### 11.1 Joint issues and conditions (answers)

| English | Tiếng Việt |
|---|---|
| Knee pain / Lower back pain / Shoulder pain / Wrist or elbow pain | Đau gối / Đau thắt lưng / Đau vai / Đau cổ tay hoặc khuỷu tay |
| No pain or injuries | Không đau, không chấn thương |
| pain or injury, injuries | đau hoặc chấn thương |
| health condition(s) | bệnh lý |
| High blood pressure / Heart condition / Diabetes / Kidney disease | Huyết áp cao / Bệnh tim / Tiểu đường / Bệnh thận |
| Osteoporosis or low bone density / Osteoporosis | Loãng xương hoặc mật độ xương thấp / Loãng xương |
| Pregnant / Gave birth in the last year / Pregnancy / After the birth | Đang mang thai / Sinh con trong năm qua / Thai kỳ / Sau sinh |
| None of these / None of these apply to me | Không có mục nào / Không mục nào đúng với tôi |
| blood pressure (under control) | huyết áp (được kiểm soát) |
| blood sugar / insulin / fast sugar | đường huyết / insulin / đường hấp thu nhanh |
| bone density, fracture | mật độ xương, gãy xương |

### 11.2 Library tags and "not advised"

| English | Tiếng Việt |
|---|---|
| not advised (an exercise) | không nên tập |
| Not advised with knee pain / … during pregnancy | Không nên tập khi đau gối / … khi mang thai |
| Not advised yet after the birth | Chưa nên tập sau sinh |
| NOT ADVISED · %@%@ | KHÔNG NÊN TẬP · %@%@ |
| KNEE / LOWER BACK / SHOULDER / WRIST | GỐI / THẮT LƯNG / VAI / CỔ TAY |
| BLOOD PRESSURE / HEART / BONES / PREGNANCY / AFTER BIRTH | HUYẾT ÁP / TIM / XƯƠNG / THAI KỲ / SAU SINH |

### 11.3 Symptoms and advice

| English | Tiếng Việt |
|---|---|
| chest pain / dizziness / fainting / breathlessness | đau ngực / chóng mặt / ngất / khó thở |
| severe headache / blurred vision / racing heartbeat | đau đầu dữ dội / nhìn mờ / tim đập nhanh |
| numbness / weakness / swelling / bleeding | tê / yếu / sưng / chảy máu |
| (knee) locks / gives way / hot and red with a fever | kẹt khớp / khuỵu xuống / nóng đỏ kèm sốt |
| bladder or bowel problems / groin or buttocks | rối loạn tiểu tiện hoặc đại tiện / vùng bẹn hoặc mông |
| unexplained weight loss | sụt cân không rõ lý do |
| contractions / leaking fluid / calf pain or swelling | cơn co thắt tử cung / rỉ ối / đau hoặc sưng bắp chân |
| leaking urine / a bulge along the middle of your belly | rỉ nước tiểu / khối phồng dọc giữa bụng |
| blisters or sores / eye or nerve complications | phồng rộp hoặc vết loét / biến chứng mắt hoặc thần kinh |
| breath-holding / maximal lifts, maximal efforts | nín thở / nâng tạ tối đa, gắng sức tối đa |
| moderate effort / heart-rate limits | gắng sức vừa phải / giới hạn nhịp tim |
| See a doctor / Get urgent care / is an emergency | Hãy đi khám bác sĩ / Hãy đi cấp cứu ngay / là trường hợp cấp cứu |
| ask your doctor (or dietitian) | hỏi ý kiến bác sĩ (hoặc chuyên gia dinh dưỡng) |
| your doctor's or midwife's OK | sự đồng ý của bác sĩ hoặc nữ hộ sinh |
| a doctor's supervision / under medical supervision | sự theo dõi của bác sĩ / dưới sự giám sát y tế |
| diagnosis / medicine | chẩn đoán / thuốc |
| general guidance, not medical advice | chỉ mang tính tham khảo chung, không phải lời khuyên y tế |
| For pain or a health condition, see a doctor. | Nếu bị đau hoặc có bệnh lý, hãy đi khám bác sĩ. |
| Check with your doctor before you start | Hỏi ý kiến bác sĩ trước khi bắt đầu |

### 11.4 Exercises named in the safety texts

Follow vi_glossary rule 1: lift nouns stay English in lower case, in the
singular, with "bài" when the sentence needs it ("các bài good morning", as in
the coaching copy). Movement words are translated. Batch 1 (the short lines)
and batch 2 (the long ones) must match.

| English | Tiếng Việt |
|---|---|
| jumping / running | bật nhảy / chạy bộ |
| Olympic lifts | các bài cử tạ Olympic |
| deep single-leg squats | squat một chân sâu |
| forward lunges / twisting lunges | lunge bước tới / lunge xoay thân |
| squats, leg presses, bar-on-back squats, front squats | squat, leg press, squat vác tạ đòn sau lưng, front squat |
| bridges, hip thrusts, curls (knee list), hip abduction | bridge, hip thrust, cuốn chân, dạng hông |
| heavy barbell hinges / good mornings | gập hông với tạ đòn nặng / good morning |
| bent-over rows; rows bent over without chest support | kéo cúi người; kéo cúi người không tì ngực |
| standing barbell presses / overhead pressing | đẩy tạ đòn khi đứng / đẩy qua đầu |
| sit-ups, crunches, curl-ups | sit-up, crunch, curl-up |
| Russian twists / twists / side bends | Russian twist / xoay thân / side bend |
| side planks, planks, heavy planks / bird dogs / dead bugs | side plank, plank, plank gắng sức / bird dog / dead bug |
| back extensions / leg raises / rollouts / wall sits | back extension / nâng chân / rollout / wall sit |
| dips, weighted pull-ups or dips / upright rows / pullovers | dip, pull-up đeo tạ hoặc dip đeo tạ / upright row / pullover |
| behind-the-neck work / head-down positions | các bài sau gáy / tư thế chúc đầu |
| landmine press / face pulls / rotator-cuff work | landmine press / face pull / bài tập nhóm cơ chóp xoay |
| wrist curls / reverse or Zottman curls / skull crushers | cuốn cổ tay / reverse curl hoặc Zottman curl / skull crusher |
| diamond, archer or clap push-ups | diamond push-up, archer push-up hoặc clap push-up |
| neutral grips, machines and cables | cầm trung lập, máy và máy cáp |
| lying flat on your back or front | nằm ngửa hoặc nằm sấp |
| balance-heavy single-leg moves | động tác một chân cần giữ thăng bằng nhiều |
| Raise to shoulder height | Chỉ nâng đến ngang vai |

### 11.5 The PAR-Q+ safety questions

| English | Tiếng Việt |
|---|---|
| SAFETY / Before you start | AN TOÀN / Trước khi bắt đầu |
| Tick any that apply to you. | Đánh dấu những mục đúng với bạn. |
| I get chest pain at rest, in daily life or when I'm active | Tôi bị đau ngực khi nghỉ, khi sinh hoạt hằng ngày hoặc khi vận động |
| A doctor said I should only exercise under medical supervision | Bác sĩ nói tôi chỉ nên tập dưới sự giám sát y tế |

### 11.6 Source lines

"Sources:" → "Nguồn:", "Steps:" → "Số bước:". Keep author names, "et al.", "&",
journal abbreviations, years, report IDs and published titles as they are:
ACOG Committee Opinion 804, NICE guideline NG59, KDOQI, PROT-AGE, OARSI, ACSM,
Too Fit To Fracture, Low Back Disorders, "returning to running postnatal",
WHO Expert Consultation, US Navy. Translate the plain words around them:
"and" between years → "và", "position stand/statement" → "khuyến cáo",
"scientific statement" → "tuyên bố khoa học", "guideline(s)" → "hướng dẫn",
"Common rehabilitation practice." → "Thực hành phục hồi chức năng phổ biến.",
and topic labels in parentheses ("(training volume)" → "(khối lượng tập)",
"(sleep)" → "(giấc ngủ)"). Do not leave English "and", "the" or "protein".

---

## 12. Today

| English | Tiếng Việt |
|---|---|
| Today layouts: Classic / Rings / Dial / Coach | Cổ điển / Vòng / Mặt số / Huấn luyện |
| Your day / All done / %lld of %lld done | Ngày của bạn / Đã xong hết / Xong %lld/%lld |
| Daily goals / Goals (inside the dial, ≤ 8 characters) | Mục tiêu trong ngày / Mục tiêu |
| dial states: Day closed / Rest day / Recovery day / %lld to go | Đã hoàn tất / Ngày nghỉ / Ngày phục hồi / Còn %lld |
| rings and rows: Water / Workout / Weigh-in / Plan / Nutrition | Nước / Buổi tập / Cân nặng / Kế hoạch / Dinh dưỡng |
| Next (tag on the next habit) / Next up | Tiếp theo / Tiếp theo |
| Recommended (session state) | Đề xuất |
| Start workout / Continue workout / See workout / Train anyway | Bắt đầu tập / Tiếp tục buổi tập / Xem buổi tập / Vẫn tập |
| %@ day (`today.splitDay.title`, a heading) | Buổi %@ ("Buổi Đẩy") |
| Recovered: / Mostly recovered: | Đã phục hồi: / Gần phục hồi: |
| will be ready in about %lld h | sẽ sẵn sàng sau khoảng %lld giờ |
| A walk still counts. | Đi bộ vẫn có ích. |
| %@ steps so far | đã đi %@ bước |
| you can train any day | bạn có thể tập bất kỳ ngày nào |
| kcal above rest | kcal tiêu hao thêm (verb form: "tiêu hao thêm %lld kcal") |
| (estimate) / estimate from steps | (ước tính) / ước tính từ số bước |
| Not added to your target. | Không cộng vào mục tiêu. |
| ✓ Done / ✓ Today / ✓ Goal (badges, shown in capitals) | ✓ Xong / ✓ Hôm nay / ✓ Đạt |
| Not started / Not yet (weigh-in) / Not today | Chưa bắt đầu / Chưa cân / Hôm nay chưa cân |
| Not yet · reminder %@ / Weigh-in %@ / Daily at %@ | Chưa cân · nhắc lúc %@ / Cân lúc %@ / Hằng ngày lúc %@ |
| Reminders / Reminders off / Water every %lld h | Nhắc nhở / Đã tắt nhắc nhở / Uống nước mỗi %lld giờ |
| From / Until / Every (reminder pickers) | Từ / Đến / Mỗi |
| Water target & reminders / Water & reminders | Mục tiêu nước & nhắc nhở / Nước & nhắc nhở |
| Use the recommended %@ | Dùng mức khuyến nghị %@ |
| adequate intake (EFSA) | lượng nạp vào đầy đủ |
| Undo the last glass / Remove last glass | Hoàn tác ly vừa thêm / Bỏ ly vừa thêm |
| More water options | Tùy chọn nước khác |
| Pace mark: %@ by now | Mốc tiến độ: %@ đến giờ này |
| Walks / Trends (tile chips) | Đi bộ / Xu hướng |
| Tenths (decimal wheel, VoiceOver) | Số thập phân |
| Don't show again | Không hiện lại |
| Almost there / Around %@ | Sắp đạt / Khoảng %@ |
| Holding steady. / Trending down. / Trending up. | Đang ổn định. / Đang giảm dần. / Đang tăng dần. |
| Up / Down (a little) this month. | Tăng / Giảm (nhẹ) trong tháng này. |
| one salty dinner | một bữa tối mặn |
| wind-down, Wind-down reminder, Time to wind down | chuẩn bị đi ngủ, Nhắc chuẩn bị đi ngủ, Đến giờ chuẩn bị đi ngủ |
| Time for water / Time to weigh in / Step on the scale. | Đến giờ uống nước / Đến giờ cân / Lên cân thôi. |
| keeps you on track for %@ today | giúp bạn kịp đạt %@ hôm nay |
| keeps the trend honest / keep your Balance honest | giúp xu hướng chính xác / giúp điểm Cân bằng phản ánh đúng |

---

## 13. Balance

| English | Tiếng Việt |
|---|---|
| Balance words (inside a small ring, ≤ 13 characters): Strong / On track / Building / Getting going | Rất tốt / Đúng hướng / Đang tiến bộ / Đang bắt nhịp |
| "Strong 80+ · On track 65–79 · …" and "80 and up is Strong…" | use these four words, capitalised |
| pillars Train / Eat / Sleep | Tập / Ăn / Ngủ |
| Train parts: Showing up / Coverage / Furthest behind / Note | Chuyên cần / Độ phủ / Thiếu nhiều nhất / Lưu ý |
| Eat parts: Protein / Eating vs plan / Water / Source | Đạm / Ăn so với kế hoạch / Nước / Nguồn |
| Sleep parts: Average / Long enough / Bedtime spread | Trung bình / Ngủ đủ giấc / Độ lệch giờ ngủ |
| Your lever, the week's lever | Ưu tiên của bạn, ưu tiên của tuần |
| Bar = the week's lever: | Cột = ưu tiên của tuần: |
| scored / Not scored / Not tracked / tracked / Nothing to score | được chấm điểm / Không chấm điểm / Chưa theo dõi / đã theo dõi / Không có gì để chấm |
| Off in Settings / Paused this week (state) / Pause this week (switch) | Đã tắt trong Cài đặt / Đã tạm dừng tuần này / Tạm dừng tuần này |
| Paused (one key: Balance and the goal tag) | Tạm dừng |
| habit grid: Done / Partly / Not done / Rest day / No data | Đạt / Một phần / Chưa đạt / Ngày nghỉ / Chưa có dữ liệu |
| action buttons: Start / Check in / Set reminder / Log sleep / Connect | Bắt đầu / Tự đánh giá / Đặt nhắc nhở / Ghi giấc ngủ / Kết nối |
| check-in, Evening check-in, Eating check-in, Check-in time | tự đánh giá, Tự đánh giá buổi tối, Tự đánh giá ăn uống, Giờ tự đánh giá |
| protein answers: Hit it / Close / Missed | Đạt / Gần đạt / Chưa đạt |
| eating answers: About right / A bit off / Way off | Sát kế hoạch / Hơi lệch / Lệch nhiều |
| the same answers inside the scoring text ("hit 1, close 0.6…") | đạt 1, gần đạt 0,6, chưa đạt 0,3 … sát kế hoạch 1, hơi lệch 0,6, lệch nhiều 0,2 |
| sleep estimate options: Under 6 h / 6–7 h / 7–8 h / Over 8 h | Dưới 6 giờ / 6–7 giờ / 7–8 giờ / Trên 8 giờ |
| results: On pace / Slower than plan / Faster than plan / Holding | Đúng tiến độ / Chậm hơn kế hoạch / Nhanh hơn kế hoạch / Ổn định |
| Result: %@ | Kết quả: %@ |
| card styles: Bars / Triangle / Ring | Thanh / Tam giác / Vòng |
| Look (style row) / Card style / CARD STYLE / Show on Today / On Today | Giao diện / Kiểu thẻ / KIỂU THẺ / Hiện ở tab Hôm nay / Ở tab Hôm nay |
| volume targets: Auto / Maintain | Tự động / Duy trì |
| TRAINING VOLUME / WHAT COUNTS / HOW IT WORKS / REMINDERS / EAT COLOR | KHỐI LƯỢNG TẬP / MỤC ĐƯỢC TÍNH / CÁCH HOẠT ĐỘNG / NHẮC NHỞ / MÀU MẢNG ĂN |
| Score eating / Score sleep / Hide calorie numbers | Chấm điểm ăn uống / Chấm điểm giấc ngủ / Ẩn số calo |
| Eat colours: Wheat / Orchid / Mint | Lúa mì / Phong lan / Bạc hà |
| Worth knowing / Next step / Last 7 days | Nên biết / Bước tiếp theo / 7 ngày qua |
| How Balance works / Half your average, half your weakest. | Cách tính điểm Cân bằng / Một nửa từ điểm trung bình, một nửa từ mảng yếu nhất. |
| Ask MUSQ how to improve / What will be sent | Hỏi MUSQ cách cải thiện / Nội dung sẽ được gửi |
| Include my sleep (Apple Health) | Gửi kèm giấc ngủ của tôi (Apple Health) |
| deload (week) / ill, sick / travelling / shifts / a new baby | (tuần) giảm tải / ốm / đi xa / làm ca / mới có em bé |
| in a cut | khi giảm mỡ |
| rates what you do, never the scale / your results | đánh giá việc bạn làm, không dựa vào cân nặng / kết quả |
| Sleep score %lld / Eat score %lld | Điểm Ngủ %lld / Điểm Ăn %lld |
| Weight %@ kg/wk · plan %@ · %@ | Cân nặng %@ kg/tuần · kế hoạch %@ · %@ |
| Key lifts %@ in 8 weeks | Bài tập chính %@ trong 8 tuần |

---

## 14. Apple Health, steps and sleep

| English | Tiếng Việt |
|---|---|
| Connect Apple Health / Connect / Connecting… | Kết nối Apple Health / Kết nối / Đang kết nối… |
| connected / not connected / CONNECTED · READ ONLY / NOT AVAILABLE | đã kết nối / chưa kết nối / ĐÃ KẾT NỐI · CHỈ ĐỌC / KHÔNG KHẢ DỤNG |
| CONNECT / STATUS / NOW / OFF (meta lines) | KẾT NỐI / TRẠNG THÁI / HIỆN TẠI / ĐÃ TẮT |
| Read only / Last read at %@ / Reading Apple Health… | Chỉ đọc / Lần đọc gần nhất lúc %@ / Đang đọc Apple Health… |
| MUSQ never writes to Apple Health | MUSQ không bao giờ ghi vào Apple Health |
| WHAT MUSQ READS | MUSQ ĐỌC NHỮNG GÌ |
| steps / Steps / STEPS / STEPS TODAY | bước / Số bước / SỐ BƯỚC / SỐ BƯỚC HÔM NAY |
| walking distance / DISTANCE | quãng đường đi bộ / QUÃNG ĐƯỜNG |
| active energy / ACTIVE ENERGY | năng lượng hoạt động / NĂNG LƯỢNG HOẠT ĐỘNG (Apple's term) |
| a Watch workout | bài tập trên Apple Watch |
| last night / LAST NIGHT / Last night %@ | đêm qua / ĐÊM QUA / Đêm qua %@ |
| asleep (in a sentence) / Asleep, Time asleep (labels) | ngủ ("ngủ 7 giờ 12") / Thời gian ngủ |
| sleep stages: Deep / Core / REM | Ngủ sâu / Ngủ lõi / REM |
| No sleep recorded | Không có dữ liệu giấc ngủ |
| sleep goal / steps goal / GOALS | mục tiêu giấc ngủ / mục tiêu số bước / MỤC TIÊU |
| goal %@ (chart line) / avg %@ (chart line) | mục tiêu %@ / TB %@ |
| a night / a day / steps a day / steps today | mỗi đêm / mỗi ngày / bước mỗi ngày / bước hôm nay |
| Within an hour of the goal | Chênh không quá một giờ so với mục tiêu |
| 7 DAYS / 30 DAYS | 7 NGÀY / 30 NGÀY |
| chart labels: Night / Week / Line / End / Low / High / Max / Trend / Target | Đêm / Tuần / Đường / Kết thúc / Thấp / Cao / Tối đa / Xu hướng / Mục tiêu |
| COLORS / Steps colours: Teal / Lime / Aqua | MÀU SẮC / Ngọc lam / Xanh chanh / Xanh lơ |
| Sleep colours: Periwinkle / Moonlight / Indigo | Oải hương / Ánh trăng / Xanh chàm |
| CALORIE PLAN / Use my steps for my calorie plan | KẾ HOẠCH CALO / Dùng số bước của tôi cho kế hoạch calo |
| PRIVACY | QUYỀN RIÊNG TƯ |
| reminders / water reminders | nhắc nhở / nhắc uống nước |
| Notifications are off (for MUSQ in iOS Settings) | Thông báo đang tắt (cho MUSQ trong Cài đặt iOS) |

---

## 15. Progress

| English | Tiếng Việt |
|---|---|
| OVERVIEW / BODY / STRENGTH (section picker) | TỔNG QUAN / CƠ THỂ / SỨC MẠNH |
| BALANCE & RESULTS / YOUR WEEKS / Your weeks | CÂN BẰNG & KẾT QUẢ / CÁC TUẦN CỦA BẠN / Các tuần của bạn |
| Weight · 7-day average | Cân nặng · trung bình 7 ngày |
| Better-balanced weeks / Other weeks | Tuần cân bằng tốt hơn / Các tuần khác |
| so far (under this week's number) | đến nay |
| VS LAST WEEK, SAME DAYS | SO VỚI CÙNG KỲ TUẦN TRƯỚC |
| SAME / Same as last week / Up %@ on last week / Down %@ on last week | KHÔNG ĐỔI / Bằng tuần trước / Tăng %@ so với tuần trước / Giảm %@ so với tuần trước |
| new record(s), personal record | kỷ lục mới, kỷ lục cá nhân |
| %@ and %lld more | %@ và %lld bài khác |
| Behind this week | Còn thiếu tuần này |
| WEEKLY VOLUME / volume | KHỐI LƯỢNG MỖI TUẦN / khối lượng |
| CONSISTENCY / GOAL %lld× / WEEK | ĐỘ ĐỀU ĐẶN / MỤC TIÊU %lld× / TUẦN |
| week(s) in a row with a workout / week(s) in a row on goal | tuần liên tiếp có tập / tuần liên tiếp đạt mục tiêu |
| Trained, goal met | Đã tập, đạt mục tiêu |
| KEY LIFTS / key lifts | BÀI TẬP CHÍNH / bài tập chính |
| EST. 1RM · %lld WEEKS / estimated max | 1RM ƯỚC TÍNH · %lld TUẦN / mức tối đa ước tính |
| BODY WEIGHT / last weigh-in | CÂN NẶNG / lần cân gần nhất |
| All workouts / Groups this week | Tất cả buổi tập / Nhóm cơ tuần này |

---

## 16. Goal photo and Goal page

| English | Tiếng Việt |
|---|---|
| muscle levels: Same / Toned / Muscular / Strong | Giữ nguyên / Săn chắc / Cơ bắp / Vạm vỡ |
| body-fat levels: Same / Fit / Athletic / Lean | Giữ nguyên / Thon gọn / Thể thao / Rõ múi |
| Muscle / Body fat / Body (Male / Female picker) | Cơ bắp / Mỡ cơ thể / Cơ thể |
| course tags: First week / On course / Behind / Off course | Tuần đầu / Đúng lộ trình / Chậm tiến độ / Chệch hướng |
| course tags: No training days / Reached / Paused | Chưa có ngày tập / Đã đạt / Tạm dừng |
| Behind: every session counts | Đang chậm: buổi nào cũng đáng giá |
| on course / back on course / stay on course | đúng lộ trình / quay lại đúng lộ trình / giữ đúng lộ trình |
| by the estimate / Goal reached by the estimate | theo ước tính / Đã đạt mục tiêu theo ước tính |
| about a week / about %lld weeks / about %lld months / over 2 years | khoảng một tuần / khoảng %lld tuần / khoảng %lld tháng / hơn 2 năm (lower case) |
| %@ to go (time left; water left) | Còn %@ |
| of the way, of the way there (captions after the %) | chặng đường |
| %@ of the way, %@ of the way there (VoiceOver) | Đã đi được %@ chặng đường |
| %@ there (under a bar) / Start %@ / now / goal | đạt %@ / Ban đầu %@ / hiện tại / mục tiêu |
| badges on the photos: Goal / Now / Start · %@ | Mục tiêu / Hiện tại / Bắt đầu · %@ |
| Since %@ | Từ %@ |
| Time to goal / No date yet / Set training days | Thời gian đến mục tiêu / Chưa có ngày / Đặt ngày tập |
| Training (section) / session(s) this week | Tập luyện / buổi tuần này |
| of %lld (after the sessions done: "2 of 4") | / %lld |
| Show (picker over Goal / Now) | Hiển thị |
| of planned sessions | số buổi theo kế hoạch |
| Week of %@ / Sessions per week | Tuần từ %@ / Số buổi mỗi tuần |
| Lean mass / Weight now / Not measured yet | Khối nạc / Cân nặng hiện tại / Chưa đo |
| Already in your goal's range | Đã nằm trong khoảng mục tiêu |
| Goal check-in / Sunday evening check-in | Cập nhật mục tiêu / Cập nhật tối Chủ nhật |
| Get a Sunday check-in on this goal | Nhận cập nhật mục tiêu vào Chủ nhật |
| card styles on Today: Bar / Ring / Banner | Thanh / Vòng / Biểu ngữ |
| See your goal physique / Create my goal photo / Show my goal / See my goal | Xem vóc dáng mục tiêu của bạn / Tạo ảnh mục tiêu của tôi / Xem mục tiêu của tôi / Xem mục tiêu của tôi |
| Your goal / See your goal / Delete goal / New goal photo | Mục tiêu của bạn / Xem mục tiêu / Xoá mục tiêu / Ảnh mục tiêu mới |
| Take photo / Choose photo / Another photo / New photo | Chụp ảnh / Chọn ảnh / Ảnh khác / Ảnh mới |
| Save to Photos / Saved to Photos | Lưu vào Ảnh / Đã lưu vào Ảnh |
| Report this image / Delete it | Báo cáo hình ảnh này / Xoá |
| AI illustration; illustration, not a prediction | ảnh minh hoạ bằng AI; minh hoạ, không phải dự đoán |
| puts your own face back | ghép lại khuôn mặt thật của bạn |
| fitted clothes / mirror selfies / from the waist up | đồ ôm / ảnh selfie qua gương / từ thắt lưng trở lên |
| This is a photo of only me, and I'm 18 or older. | Đây là ảnh chỉ có tôi, và tôi từ 18 tuổi trở lên. |
| for adults / For adults | người trưởng thành / Dành cho người trưởng thành |
| Swipe up or down to move the divider | Vuốt lên hoặc xuống để di chuyển vạch chia |

---

## 17. Premium, Pro and the paywall

| English | Tiếng Việt |
|---|---|
| Premium Yearly / Premium Monthly / Pro Yearly / Pro Monthly | Premium Hằng năm / Premium Hằng tháng / Pro Hằng năm / Pro Hằng tháng |
| Pro Monthly (%@ a month) | Pro Hằng tháng (%@/tháng), as the catalog's "Hằng tháng (%@/tháng)" |
| … in prose | gói Premium hằng năm, gói Pro hằng tháng |
| Get Pro (button) / Get Pro · %@ a year | Nâng cấp Pro (as "Get Premium" → "Nâng cấp Premium") / Mua Pro · %@/năm |
| Get Premium · %@ a month | Mua Premium · %@/tháng |
| Upgrade to Pro / Upgrade to Pro · %@ a year | Nâng cấp lên Pro / Nâng cấp lên Pro · %@/năm |
| %@ free, then %@/month | Miễn phí %1$@, sau đó %2$@/tháng (as in the catalog) |
| free trial / subscription / lifetime / renew / refund | dùng thử miễn phí / gói đăng ký / trọn đời / gia hạn / hoàn tiền |
| Free (tier column) / included / not included | Miễn phí / có / không có |
| table units: A DAY / A YEAR / TO TRY | MỖI NGÀY / MỖI NĂM / DÙNG THỬ |
| %lld a day / %lld a year / %lld to try (VoiceOver) | %lld mỗi ngày / %lld mỗi năm / %lld lần dùng thử |
| allowance (a plan's AI uses) / one use | hạn mức / lượt |
| FULL AI ALLOWANCE / STARTER AI ALLOWANCE / UPGRADE FROM PREMIUM | HẠN MỨC AI ĐẦY ĐỦ / HẠN MỨC AI CƠ BẢN / NÂNG CẤP TỪ PREMIUM |
| up to %lld a day / %lld questions a day | tối đa %lld mỗi ngày / %lld câu hỏi mỗi ngày |
| %lld goal photos a year / Premium makes %lld a year | %lld ảnh mục tiêu mỗi năm / Premium tạo được %lld ảnh mỗi năm |
| Pro keeps everything in your plan | Pro có mọi thứ trong gói của bạn |
| Keep asking with Pro / Log meals with Pro / More goal photos with Pro / Get more with Pro | Hỏi tiếp với Pro / Ghi bữa ăn với Pro / Thêm ảnh mục tiêu với Pro / Nhiều hơn với Pro |
| That's today's %lld questions. | Bạn đã dùng hết %lld câu hỏi hôm nay. |
| %lld questions left today / 1 question left today | Còn %lld câu hỏi hôm nay / Còn 1 câu hỏi hôm nay |
| %lld of %lld goal photos left this year | Còn %lld/%lld ảnh mục tiêu năm nay |
| Your free goal photo is used. / Your first one is free. | Bạn đã dùng ảnh mục tiêu miễn phí. / Ảnh đầu tiên được miễn phí. |
| isn't on sale right now | hiện chưa mở bán |
| Pro is on / Pro is on. / Your Pro yearly plan is active. | Pro đã bật / Pro đã bật. / Gói Pro hằng năm của bạn đang hoạt động. |
| Train with Premium or Pro | Tập cùng Premium hoặc Pro |
| See plans / See Pro | Xem các gói / Xem Pro |

---

## 18. Ask MUSQ (AI), consent, account and privacy

| English | Tiếng Việt |
|---|---|
| Ask MUSQ / Ask MUSQ about your training / Ask about training | Hỏi MUSQ / Hỏi MUSQ về việc tập luyện / Hỏi về tập luyện |
| the coach, MUSQ's coach, the AI coach | huấn luyện viên AI |
| chat / the conversation / Clear chat / Chat options | cuộc trò chuyện / cuộc trò chuyện / Xoá cuộc trò chuyện / Tùy chọn trò chuyện |
| question / answer / Send / Thinking… | câu hỏi / câu trả lời / Gửi / Đang suy nghĩ… |
| You: %@ / MUSQ: %@ / MUSQ answered | Bạn: %@ / MUSQ: %@ / MUSQ đã trả lời |
| programming (training) | lên chương trình tập |
| powered by OpenAI | dùng công nghệ của OpenAI |
| MUSQ can be wrong. | MUSQ có thể sai. |
| What MUSQ shares / Before you ask / Stop sharing | MUSQ chia sẻ những gì / Trước khi hỏi / Ngừng chia sẻ |
| Also send my health answers / health answers | Gửi kèm câu trả lời sức khỏe của tôi / câu trả lời sức khỏe |
| goes to OpenAI through MUSQ's server | được gửi đến OpenAI qua máy chủ của MUSQ |
| server / coded ID made from your account (was "anonymous ID" until 2026-11-23: the ID is pseudonymous, not anonymous) / spot abuse | máy chủ / mã định danh được mã hoá từ tài khoản của bạn / phát hiện lạm dụng |
| your OK / consent / agree / Agree and continue | sự đồng ý của bạn / sự đồng ý / đồng ý / Đồng ý và tiếp tục |
| you're asked first | MUSQ hỏi bạn trước |
| Withdraw (consent) / WITHDRAW | Rút lại / RÚT LẠI |
| AI data sharing | Chia sẻ dữ liệu cho AI |
| ACCOUNT / SIGN IN / SIGN OUT / DELETE | TÀI KHOẢN / ĐĂNG NHẬP / ĐĂNG XUẤT / XOÁ |
| Delete account / Delete your MUSQ account? | Xoá tài khoản / Xoá tài khoản MUSQ của bạn? |
| Your email is hidden. / hide your email | Email của bạn được ẩn. / ẩn email |
| service logs / usage counts | nhật ký dịch vụ / số lượt đã dùng |
| on the device / stays on this %@ | ngay trên thiết bị / chỉ lưu trên %@ này |
| never saved / never sent to MUSQ or advertisers | không bao giờ được lưu / không bao giờ được gửi cho MUSQ hay nhà quảng cáo |
| backups / never in backups | bản sao lưu / không bao giờ có trong bản sao lưu |
| until you clear it | cho đến khi bạn xoá |
| Nothing is sent until you tap Send there. | Không có gì được gửi cho đến khi bạn chạm Gửi ở đó. |
| Sign in to ask the coach. | Đăng nhập để hỏi huấn luyện viên AI. |
| You're not signed in. | Bạn chưa đăng nhập. |

---

## 19. Training

| English | Tiếng Việt |
|---|---|
| workout, session | buổi tập (as in the catalog) |
| rest day / recovery day | ngày nghỉ / ngày phục hồi |
| new record | kỷ lục mới |
| trend / average / 7-day average | xu hướng / trung bình / trung bình 7 ngày |
| training days / weekly goal / streak | ngày tập / mục tiêu tuần / chuỗi |
| effective sets / sets a muscle a week | hiệp hiệu quả (catalog) / hiệp mỗi nhóm cơ mỗi tuần |
| presets | preset (Preset 1/2/3 capitalised, as in the catalog) |
| experience: Beginner / Intermediate / Advanced | as in the catalog |
| Train suggests the most recovered day | Tab Tập gợi ý ngày đã phục hồi tốt nhất (catalog) |

---

## 20. Units and time

min → phút, h → giờ, s → giây, wk → tuần (kg/wk → kg/tuần), a day → mỗi
ngày, a week → mỗi tuần, a night → mỗi đêm, a month / a year in prices →
/tháng, /năm (as in the catalog), WEEKS → TUẦN, DAYS → NGÀY. Durations: "%lld h
%@" (7 h 05) → "%lld giờ %@" (7 giờ 05).

kg, g, ml, L, cm, km, lb, ft, in (inches), kcal, % stay. "g" after a macro
stays "g". The label "Grams" → "Gam", "Calories" → "Calo".

× stays × ("× %@" activity factor; "GOAL 3× / WEEK" → "MỤC TIÊU 3× / TUẦN").
≈ stays ≈. EST. → ƯỚC TÍNH, avg → TB (chart labels only).

Numbers come from format specifiers and follow the locale. Literal numbers
follow §1.5: never a decimal point.

---

## 21. Recurring sentences (always the same Vietnamese)

| English | Tiếng Việt |
|---|---|
| … general guidance, not medical advice. (the plan, estimates, answers) | … chỉ mang tính tham khảo chung, không phải lời khuyên y tế. |
| Check your connection and try again. | Kiểm tra kết nối và thử lại. (catalog) |
| Try again later. / Try again in a moment. | Hãy thử lại sau. / Hãy thử lại sau giây lát. |
| If you've just bought it / upgraded, try again in a moment. | Nếu bạn vừa mua / nâng cấp, hãy thử lại sau giây lát. |
| … is paused for now. | … đang tạm dừng. |
| Something went wrong. Try again. | Đã xảy ra lỗi. Hãy thử lại. |
| Cancel anytime in Settings. | Huỷ bất cứ lúc nào trong Cài đặt. (catalog) |
| Change any of this later in Profile. | Bạn có thể thay đổi những điều này sau trong tab Cá nhân. (catalog) |
| Steps during your logged MUSQ workouts don't count, since your training days already do. | Số bước trong các buổi tập MUSQ đã ghi không được tính, vì ngày tập đã được tính rồi. |
| … in place of your answer to the daily-activity question | … thay cho câu trả lời của bạn ở câu hỏi về mức vận động hằng ngày |
| Read only; it stays on this device. | Chỉ đọc; dữ liệu chỉ ở trên thiết bị này. |
| Your answers stay on this phone / iPad. | Câu trả lời chỉ lưu trên điện thoại này / iPad này. |
| A tap on a button logs it at once. | Chạm vào một nút là ghi ngay. |
| Press and hold one to remove it. | Chạm và giữ một nút để xoá nút đó. |
| Weigh in a few mornings a week. | Cân vài buổi sáng mỗi tuần. |
| Your plan follows the 7-day average. | Kế hoạch dựa theo trung bình 7 ngày. |
| MUSQ can be wrong. For pain or a health condition, see a doctor. | MUSQ có thể sai. Nếu bị đau hoặc có bệnh lý, hãy đi khám bác sĩ. |
