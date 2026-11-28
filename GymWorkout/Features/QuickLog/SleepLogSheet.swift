//
//  SleepLogSheet.swift
//  GymWorkout
//
//  Hours slept last night, logged by hand from Today's dock (2026-11-27,
//  the owner's "lazy thumb" Today): one big number, a slider in quarter
//  hours, four one-tap amounts and Save at the bottom where the thumb is.
//  Kept in MUSQ's own log (`DailyStore.logSleep`), never written to Apple
//  Health; Balance's Sleep pillar reads the same night.
//

import SwiftUI

struct SleepLogSheet: View {
    @Environment(DailyStore.self) private var daily
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dsLayout) private var layout

    /// Minutes, in quarter hours.
    @State private var minutes = 450
    @State private var didLoad = false

    private static let presets = [360, 420, 480, 540]
    private static let range = 180.0...720.0

    var body: some View {
        let logged = daily.sleepLog(on: Date())
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 22) {
                        Image(systemName: "bed.double.fill")
                            .font(.system(size: 30, weight: .semibold))
                            .foregroundStyle(SleepLogSheet.tint)
                            .frame(width: 64, height: 64)
                            .background(Circle().fill(SleepLogSheet.tint.opacity(0.16)))
                            .accessibilityHidden(true)
                            .padding(.top, 8)
                        Text(HealthFormat.sleep(minutes: minutes))
                            .font(.ui(44, .bold))
                            .monospacedDigit()
                            .foregroundStyle(DS.silver)
                            .contentTransition(.numericText())
                            .animation(.snappy, value: minutes)
                            .accessibilityHidden(true)
                        Slider(value: Binding(get: { Double(minutes) },
                                              set: { minutes = Int(($0 / 15).rounded()) * 15 }),
                               in: Self.range, step: 15)
                            .tint(SleepLogSheet.tint)
                            .accessibilityLabel(String(localized: "Hours slept", comment: "Sleep log slider"))
                            .accessibilityValue(HealthFormat.sleep(minutes: minutes))
                        HStack(spacing: 8) {
                            ForEach(Self.presets, id: \.self) { preset in
                                QuickChip(title: HealthFormat.sleep(minutes: preset), filled: minutes == preset) {
                                    minutes = preset
                                }
                            }
                        }
                        if logged != nil {
                            Button(String(localized: "Remove last night's log", comment: "Sleep log: deletes the night logged by hand"),
                                   role: .destructive) {
                                daily.clearSleepLog(on: Date())
                                dismiss()
                            }
                            .font(.ui(14, .semibold))
                            .frame(minHeight: 44)
                        }
                    }
                    .padding(.horizontal, DS.Metric.gutter)
                    .frame(maxWidth: 480)
                    .frame(maxWidth: .infinity)
                }
                // The thumb's button, at the bottom.
                WideButton(title: String(localized: "Save", comment: "Sleep log: saves last night's hours"),
                           prominent: true, fontSize: 17, verticalPadding: 16, cornerRadius: 16) {
                    daily.logSleep(minutes: minutes)
                    AccessibilityNotification.Announcement(
                        String(localized: "Logged \(HealthFormat.sleep(minutes: minutes)) of sleep",
                               comment: "VoiceOver after logging last night's sleep: Logged 7 h 30 of sleep")).post()
                    dismiss()
                }
                .padding(.horizontal, DS.Metric.gutter)
                .padding(.bottom, 12)
                .frame(maxWidth: 480)
            }
            .background(DS.ink.ignoresSafeArea())
            .navigationTitle(String(localized: "Last night's sleep", comment: "Sleep log sheet title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Cancel")) { dismiss() }
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .presentationBackground(DS.ink)
        .sensoryFeedback(.selection, trigger: minutes)
        .onAppear {
            guard !didLoad else { return }
            didLoad = true
            if let logged { minutes = logged.minutes }
        }
    }

    /// Sleep's indigo on the dock and here.
    static let tint = Color(light: 0x4F46E5, dark: 0x8B8CFF)
}
