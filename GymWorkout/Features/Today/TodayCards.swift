//
//  TodayCards.swift
//  GymWorkout
//
//  The Today tab's pieces (2026-11-21): the rings hero (the owner had no
//  preference among rings, tiles and a summary card), the cards' frame and
//  rows, the weigh-in and water sheets, and the plan sheet that reopens
//  onboarding's result pages.
//

import Charts
import SwiftUI

// MARK: - Hero

enum TodayPalette {
    static let water = Color(hex: 0x4A9DFF)
    static let workout = DS.activation
    static let weighIn = DS.rhythmDue
}

/// Water, the workout and the weigh-in as three rings, with the day's
/// calories and macros below.
struct TodayHero: View {
    var metrics: TodayMetrics

    @Environment(\.dsLayout) private var layout

    var body: some View {
        TodayCard {
            HStack(spacing: layout.value(18, 24)) {
                ZStack {
                    Ring(progress: metrics.waterProgress, color: TodayPalette.water, lineWidth: 12)
                        .frame(width: 128, height: 128)
                    Ring(progress: metrics.workoutProgress, color: TodayPalette.workout, lineWidth: 12)
                        .frame(width: 96, height: 96)
                    Ring(progress: metrics.weighInProgress, color: TodayPalette.weighIn, lineWidth: 12)
                        .frame(width: 64, height: 64)
                }
                .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 10) {
                    legendRow(color: TodayPalette.water, title: String(localized: "Water", comment: "Today ring"),
                              value: "\(DailyStore.litres(metrics.waterMl)) / \(DailyStore.litres(metrics.waterTarget))")
                    legendRow(color: TodayPalette.workout, title: String(localized: "Workout", comment: "Today ring"),
                              value: workoutValue)
                    legendRow(color: TodayPalette.weighIn, title: String(localized: "Weigh-in", comment: "Today ring"),
                              value: metrics.weighedIn ? String(localized: "Done") : String(localized: "Not yet"))
                }
                Spacer(minLength: 0)
            }
            if let calories = metrics.calories {
                Hairline(opacity: 0.08)
                    .padding(.vertical, 12)
                HStack(alignment: .firstTextBaseline) {
                    Text("Plan", comment: "Today hero: the day's calorie plan")
                        .font(.ui(layout.value(13, 14), .semibold))
                        .foregroundStyle(DS.silver.opacity(0.6))
                    Spacer()
                    Text("\(calories.formatted()) kcal", comment: "The day's calorie target")
                        .font(.ui(layout.value(15, 16), .semibold))
                        .foregroundStyle(DS.silver)
                }
                macroLine
                    .padding(.top, 6)
            }
        }
    }

    private func legendRow(color: Color, title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 6) {
                Circle().fill(color).frame(width: 8, height: 8)
                Text(title)
                    .font(.mono(layout.value(9.5, 10.5), .semibold))
                    .trackingEm(0.08, size: layout.value(9.5, 10.5))
                    .foregroundStyle(DS.silver.opacity(0.55))
                    .textCase(.uppercase)
            }
            Text(value)
                .font(.ui(layout.value(15, 16), .semibold))
                .foregroundStyle(DS.silver)
                .monospacedDigit()
        }
        .accessibilityElement(children: .combine)
    }

    private var workoutValue: String {
        if metrics.setsPlanned > 0 {
            return String(localized: "\(metrics.setsDone)/\(metrics.setsPlanned) sets", comment: "Today ring: sets done of planned, 12/30 sets")
        }
        return metrics.isTrainingDay ? String(localized: "Not started") : String(localized: "Rest day")
    }

    private var macroLine: some View {
        MacroLine(protein: metrics.protein ?? 0, fat: metrics.fat ?? 0, carbs: metrics.carbs ?? 0)
    }
}

/// A progress ring: a faint full circle and the filled arc over it.
struct Ring: View {
    var progress: Double
    var color: Color
    var lineWidth: CGFloat

    var body: some View {
        ZStack {
            Circle().stroke(color.opacity(0.16), lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: max(0.001, min(1, progress)))
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .opacity(progress > 0 ? 1 : 0)
        }
        .animation(.easeOut(duration: 0.4), value: progress)
    }
}

// MARK: - Card pieces

/// A Today card: the app's raised surface, rounded.
struct TodayCard<Content: View>: View {
    @ViewBuilder var content: () -> Content

    @Environment(\.dsLayout) private var layout

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            content()
        }
        .padding(layout.value(16, 18))
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: layout.value(18, 20), style: .continuous).fill(DS.surfaceAlt))
    }
}

/// A card's icon, title and the value on the right.
struct CardTitle: View {
    var symbol: String
    var title: String
    var trailing: String?

    @Environment(\.dsLayout) private var layout

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Image(systemName: symbol)
                .font(.system(size: layout.value(14, 15), weight: .semibold))
                .foregroundStyle(DS.silver.opacity(0.8))
            Text(title)
                .font(.ui(layout.value(16, 17), .semibold))
                .foregroundStyle(DS.silver)
            Spacer(minLength: 8)
            if let trailing {
                Text(trailing)
                    .font(.ui(layout.value(14, 15), .semibold))
                    .foregroundStyle(DS.silver.opacity(0.85))
                    .monospacedDigit()
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isHeader)
    }
}

struct ProgressBar: View {
    var value: Double
    var color: Color

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(color.opacity(0.16))
                Capsule().fill(color)
                    .frame(width: geo.size.width * max(0, min(1, value)))
                    .opacity(value > 0 ? 1 : 0)
            }
        }
        .frame(height: 6)
        .animation(.easeOut(duration: 0.3), value: value)
        .accessibilityHidden(true)
    }
}

/// A small capsule button for a card's actions.
struct PillButton: View {
    var title: String
    var prominent = false
    var action: () -> Void

    @Environment(\.dsLayout) private var layout

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.ui(layout.value(13, 14), .semibold))
                .foregroundStyle(prominent ? DS.ink : DS.silver)
                .padding(.horizontal, 14)
                .padding(.vertical, 9)
                .background(Capsule().fill(prominent ? DS.silver : DS.silver.opacity(0.08)))
                .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        .dsHover(.highlight, radius: 20)
    }
}

/// A reminder's name and schedule, an Edit button when it has settings, and
/// its switch.
struct ReminderRow: View {
    var title: String
    var detail: String
    @Binding var isOn: Bool
    /// What VoiceOver reads for the edit button: "Water reminder settings".
    var editLabel: String
    var onEdit: (() -> Void)?

    @Environment(\.dsLayout) private var layout

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "bell")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(DS.silver.opacity(0.6))
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.ui(layout.value(13.5, 14.5), .semibold))
                    .foregroundStyle(DS.silver)
                Text(detail)
                    .font(.ui(layout.value(12, 13)))
                    .foregroundStyle(DS.silver.opacity(0.55))
            }
            Spacer(minLength: 8)
            if let onEdit {
                Button(action: onEdit) {
                    Text("Edit", comment: "Edits a reminder's schedule")
                        .font(.ui(layout.value(13, 14), .semibold))
                        .foregroundStyle(DS.silver)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Capsule().fill(DS.silver.opacity(0.08)))
                        // A 44-pt target without making the row taller.
                        .padding(.vertical, 6)
                        .contentShape(Rectangle())
                        .padding(.vertical, -6)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(editLabel)
            }
            Toggle(title, isOn: $isOn)
                .labelsHidden()
                .tint(DS.silver)
        }
    }
}

/// "P 150 g · F 56 g · C 229 g" with the macro colours of the plan pages.
struct MacroLine: View {
    var protein: Int
    var fat: Int
    var carbs: Int

    @Environment(\.dsLayout) private var layout

    var body: some View {
        // The full names when the row fits, else the short ones of the
        // one-line meal summary: Vietnamese "Tinh bột 229 g" wrapped onto a
        // second line beside the other two (2026-11-23). English always fits.
        ViewThatFits(in: .horizontal) {
            row(short: false)
            row(short: true)
        }
    }

    private func row(short: Bool) -> some View {
        HStack(spacing: 14) {
            item(short ? String(localized: "macro.short.protein", defaultValue: "Protein",
                                comment: "Macro in a row too tight for the full names; as short as the meal summary's")
                       : String(localized: "Protein", comment: "Macro"), protein, DS.activation)
            item(short ? String(localized: "macro.short.fat", defaultValue: "Fat",
                                comment: "Macro in a row too tight for the full names; as short as the meal summary's")
                       : String(localized: "Fat", comment: "Macro"), fat, DS.activationSoft)
            item(short ? String(localized: "macro.short.carbs", defaultValue: "Carbs",
                                comment: "Macro in a row too tight for the full names; as short as the meal summary's")
                       : String(localized: "Carbs", comment: "Macro"), carbs, DS.silver.opacity(0.4))
            Spacer(minLength: 0)
        }
    }

    private func item(_ name: String, _ grams: Int, _ color: Color) -> some View {
        HStack(spacing: 5) {
            Capsule().fill(color).frame(width: 10, height: 4)
            Text("\(name) \(grams) g", comment: "A macro and its grams: Protein 150 g")
                .font(.ui(layout.value(12.5, 13.5), .semibold))
                .foregroundStyle(DS.silver.opacity(0.8))
                .monospacedDigit()
                .lineLimit(1)
        }
        .accessibilityElement(children: .combine)
    }
}

/// The last weigh-ins as a thin line.
struct WeightSparkline: View {
    var entries: [(date: Date, value: Double)]

    var body: some View {
        let values = entries.map(\.value)
        let low = (values.min() ?? 0) - 0.5, high = (values.max() ?? 0) + 0.5
        Chart {
            ForEach(Array(entries.enumerated()), id: \.offset) { _, entry in
                LineMark(x: .value("Day", entry.date), y: .value("Weight", entry.value))
                    .foregroundStyle(TodayPalette.weighIn)
                    .interpolationMethod(.monotone)
                PointMark(x: .value("Day", entry.date), y: .value("Weight", entry.value))
                    .foregroundStyle(TodayPalette.weighIn)
                    .symbolSize(14)
            }
        }
        .chartYScale(domain: low...high)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .accessibilityHidden(true)
    }
}

// MARK: - Sheets

/// Logs a weigh-in on two wheels: whole units and tenths.
struct WeightLogSheet: View {
    var unit: WeightUnit
    var startKg: Double
    var onSave: (Double) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var whole = 70
    @State private var tenth = 0
    @State private var didLoad = false

    private var range: ClosedRange<Int> { unit == .kg ? 30...250 : 66...550 }

    var body: some View {
        NavigationStack {
            VStack(spacing: 14) {
                HStack(spacing: 0) {
                    Spacer(minLength: 0)
                    Picker("Weight", selection: $whole) {
                        ForEach(range, id: \.self) { Text(verbatim: "\($0)").tag($0) }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 110)
                    .clipped()
                    Text(verbatim: Locale.current.decimalSeparator ?? ".")
                        .font(.ui(22, .semibold))
                        .foregroundStyle(DS.silver)
                    Picker("Tenths", selection: $tenth) {
                        ForEach(0...9, id: \.self) { Text(verbatim: "\($0)").tag($0) }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 70)
                    .clipped()
                    Text(unit.symbol)
                        .font(.ui(18, .semibold))
                        .foregroundStyle(DS.silver.opacity(0.6))
                        .padding(.leading, 6)
                    Spacer(minLength: 0)
                }
                .frame(height: 170)
                Text("Weigh in at the same time each day, ideally in the morning before breakfast.")
                    .font(.ui(13))
                    .foregroundStyle(DS.silver.opacity(0.55))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                WideButton(title: "Save", prominent: true, fontSize: 15, verticalPadding: 14) {
                    onSave(unit.toKilograms(Double(whole) + Double(tenth) / 10))
                    dismiss()
                }
            }
            .padding(.horizontal, DS.Metric.gutter)
            .padding(.top, 8)
            .navigationTitle(String(localized: "Log weight"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Cancel")) { dismiss() }
                }
            }
        }
        .presentationDetents([.medium])
        .onAppear {
            guard !didLoad else { return }
            didLoad = true
            let value = unit.fromKilograms(startKg)
            let rounded = (value * 10).rounded() / 10
            whole = min(max(Int(rounded), range.lowerBound), range.upperBound)
            tenth = Int(((rounded - Double(Int(rounded))) * 10).rounded()) % 10
        }
    }
}

/// The water target and the reminders' window.
struct WaterSettingsSheet: View {
    var recommended: Int

    @Environment(DailyStore.self) private var daily
    @Environment(\.dismiss) private var dismiss
    @State private var showsDenied = false

    var body: some View {
        @Bindable var daily = daily
        NavigationStack {
            Form {
                Section {
                    Stepper(value: Binding(get: { daily.waterTarget },
                                           set: { daily.waterTargetOverride = $0 == recommended ? nil : $0 }),
                            in: 1_000...5_000, step: 250) {
                        LabeledContent(String(localized: "Daily target"), value: DailyStore.litres(daily.waterTarget))
                    }
                    if daily.waterTargetOverride != nil && daily.waterTargetOverride != recommended {
                        Button(String(localized: "Use the recommended \(DailyStore.litres(recommended))",
                                      comment: "Resets the water target: Use the recommended 2.5 L")) {
                            daily.waterTargetOverride = nil
                        }
                    }
                } footer: {
                    Text("EFSA's adequate intake is about 2.0 L of water a day for women and 2.5 L for men, food included, and more in pregnancy and while breastfeeding. Training and heat add to it, so MUSQ sets that much as your drinks target. With a heart or kidney condition, ask your doctor: some need to limit fluids.")
                }
                Section {
                    Toggle(String(localized: "Reminders"), isOn: Binding(get: { daily.waterReminder.isOn },
                                                                         set: { setReminder($0) }))
                    Picker(String(localized: "From"), selection: $daily.waterReminder.startHour) {
                        ForEach(5...12, id: \.self) { Text(TodayView.hour($0)).tag($0) }
                    }
                    Picker(String(localized: "Until"), selection: $daily.waterReminder.endHour) {
                        ForEach(14...23, id: \.self) { Text(TodayView.hour($0)).tag($0) }
                    }
                    Picker(String(localized: "Every"), selection: $daily.waterReminder.everyHours) {
                        ForEach([1, 2, 3], id: \.self) {
                            Text(String(localized: "\($0) h", comment: "Reminder interval in hours: 2 h")).tag($0)
                        }
                    }
                } footer: {
                    if daily.notificationsDenied {
                        Text("Notifications are off for MUSQ in iOS Settings, so no reminders can arrive. Turn them on there.")
                    } else {
                        Text("No reminders outside these hours, and none for the rest of the day once you reach your target.")
                    }
                }
            }
            .navigationTitle(String(localized: "Water"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "Done")) { dismiss() }
                }
            }
            .alert(String(localized: "Notifications are off"), isPresented: $showsDenied) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Turn on notifications for MUSQ in iOS Settings to get reminders.")
            }
        }
    }

    private func setReminder(_ isOn: Bool) {
        guard isOn else { daily.waterReminder.isOn = false; return }
        Task {
            if await daily.requestNotifications() {
                daily.waterReminder.isOn = true
            } else {
                showsDenied = true
            }
        }
    }
}

/// Onboarding's four result pages again, from the Today tab: the plan and
/// how every number was worked out. With Apple Health connected, `plan`
/// carries the steps that set its daily activity (`plan.measured`), and the
/// calories page says so and where to turn it off.
struct PlanSheet: View {
    var plan: NutritionPlan
    var profile: UserProfile
    var experience: TrainingExperience
    var unit: WeightUnit
    var builtInPresetGroups: [MuscleGroup] = PresetProvider.trainableGroups

    @Environment(\.dismiss) private var dismiss
    @State private var draft = OnboardingDraft()
    @State private var page: OnboardingView.Step = .resultBody
    @State private var didLoad = false

    var body: some View {
        NavigationStack {
            TabView(selection: $page) {
                ForEach(OnboardingView.Step.results, id: \.self) { step in
                    OnboardingResult(step: step, plan: plan, profile: profile, draft: draft, isEditing: false,
                                     bodyTitle: String(localized: "Your plan"),
                                     builtInPresetGroups: builtInPresetGroups)
                        // Room for the page dots under each page.
                        .safeAreaInset(edge: .bottom, spacing: 0) { Color.clear.frame(height: 36) }
                        .tag(step)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .background(DS.ink.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "Done")) { dismiss() }
                }
            }
        }
        .onAppear {
            guard !didLoad else { return }
            didLoad = true
            draft.load(profile, experience: experience, unit: unit)
        }
    }
}

/// Every weigh-in, newest first; swipe to delete one logged by mistake.
struct WeightHistorySheet: View {
    var unit: WeightUnit
    /// Called after a delete, so the plan's weight follows the new average.
    var onChange: () -> Void

    @Environment(DailyStore.self) private var daily
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(daily.weights.reversed()) { entry in
                    HStack {
                        Text(entry.date.formatted(.dateTime.weekday(.abbreviated).day().month(.abbreviated).year()))
                        Spacer()
                        Text(unit.bodyWeight(entry.kg))
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            daily.deleteWeight(id: entry.id)
                            onChange()
                        } label: {
                            Label(String(localized: "Delete"), systemImage: "trash")
                        }
                    }
                }
            }
            .overlay {
                if daily.weights.isEmpty {
                    Text("No weigh-ins yet.")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle(String(localized: "Weigh-ins"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "Done")) { dismiss() }
                }
            }
        }
    }
}

/// When the morning weigh-in reminder goes off.
struct WeighInTimeSheet: View {
    @Environment(DailyStore.self) private var daily
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                DatePicker(String(localized: "Time"), selection: time, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                Text("Weigh in at the same time each day, ideally in the morning before breakfast.")
                    .font(.ui(13))
                    .foregroundStyle(DS.silver.opacity(0.55))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, DS.Metric.gutter)
            .navigationTitle(String(localized: "Weigh-in reminder"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "Done")) { dismiss() }
                }
            }
        }
        .presentationDetents([.medium])
    }

    private var time: Binding<Date> {
        Binding(get: {
                    var parts = DateComponents()
                    parts.hour = daily.weighInReminder.hour
                    parts.minute = daily.weighInReminder.minute
                    return Calendar.current.date(from: parts) ?? Date()
                },
                set: { date in
                    let parts = Calendar.current.dateComponents([.hour, .minute], from: date)
                    daily.weighInReminder.hour = parts.hour ?? 7
                    daily.weighInReminder.minute = parts.minute ?? 0
                })
    }
}
