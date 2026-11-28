//
//  FriendDetailSheet.swift
//  GymWorkout
//
//  One friend (2026-11-28): their week, the four nudges, mute, and the
//  safety actions (remove, block, report), each behind a confirmation.
//

import SwiftUI

struct FriendDetailSheet: View {
    var friendId: String
    var nudged: Set<String>
    /// Sends the nudge; the last argument shows its result in this sheet.
    var onNudge: (Friend, FriendNudgeKind, @escaping (String) -> Void) -> Void
    /// A message for the Friends tab, shown once this sheet is gone.
    var onToast: (String) -> Void

    private var service: FriendsService { .shared }
    @Environment(\.dismiss) private var dismiss

    @State private var confirmRemove = false
    @State private var confirmBlock = false
    @State private var confirmReport = false
    @State private var error: String?
    /// This sheet's own toast (the tab's is hidden behind the sheet).
    @State private var toast: String?
    @State private var isReporting = false

    private var friend: Friend? { service.friend(friendId) }

    var body: some View {
        Group {
            if let f = friend {
                content(f)
            } else {
                Color.clear.onAppear { dismiss() }
            }
        }
        .overlay(alignment: .bottom) {
            if let toast {
                FriendsToast(text: toast)
                    .padding(.bottom, 24)
                    .allowsHitTesting(false)
            }
        }
        .animation(.spring(duration: 0.3), value: toast)
        .task(id: toast) {
            guard toast != nil else { return }
            try? await Task.sleep(for: .seconds(2.2))
            toast = nil
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .presentationBackground(DS.ink)
    }

    private func content(_ f: Friend) -> some View {
        ScrollView {
            VStack(spacing: 18) {
                VStack(spacing: 8) {
                    FriendAvatar(emoji: f.emoji, size: 76)
                    Text(f.displayName)
                        .font(.ui(24, .bold))
                        .foregroundStyle(DS.silver)
                    Group {
                        if let last = f.lastActiveDate {
                            Text("Active \(last.formatted(.relative(presentation: .named)))",
                                 comment: "Friend detail: Active 2 hours ago")
                        } else if let since = f.sinceDate {
                            Text("Friends since \(since.formatted(date: .abbreviated, time: .omitted))")
                        }
                    }
                    .font(.ui(13.5))
                    .foregroundStyle(DS.silver.opacity(0.5))
                }
                .padding(.top, 24)

                HStack(spacing: 10) {
                    stat("\(f.week.workouts)", String(localized: "workouts this week"))
                    stat("🔥 \(f.week.streak)", String(localized: "day streak"))
                    if let pct = f.week.goalPct {
                        stat("\(pct)%", String(localized: "to goal"))
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text(nudged.contains(f.id) ? LocalizedStringKey("Nudged today") : LocalizedStringKey("Nudge"))
                        .font(.ui(15, .semibold))
                        .foregroundStyle(DS.silver.opacity(0.6))
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                        ForEach(FriendRow.kinds, id: \.self) { kind in
                            Button {
                                onNudge(f, kind) { toast = $0 }
                            } label: {
                                Text(kind.message)
                                    .font(.ui(14.5, .semibold))
                                    .foregroundStyle(DS.silver)
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(DS.surface))
                            }
                            .buttonStyle(.plain)
                            .disabled(nudged.contains(f.id))
                            .opacity(nudged.contains(f.id) ? 0.4 : 1)
                        }
                    }
                }

                Toggle(isOn: Binding(
                    get: { f.muted },
                    set: { new in Task { await run { try await service.setMuted(f, new) } } })) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Mute nudges").font(.ui(16, .semibold)).foregroundStyle(DS.silver)
                        Text("You won't see nudges from \(f.displayName).")
                            .font(.ui(13)).foregroundStyle(DS.silver.opacity(0.55))
                    }
                }
                .tint(DS.activation)
                .padding(14)
                .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(DS.surface))

                if let error {
                    Text(error).font(.ui(14, .medium)).foregroundStyle(DS.rhythmWaiting)
                }

                VStack(spacing: 0) {
                    safetyRow(String(localized: "Remove friend"), "person.fill.xmark") { confirmRemove = true }
                    Rectangle().fill(DS.silver.opacity(0.06)).frame(height: 1)
                    safetyRow(String(localized: "Block"), "hand.raised.fill") { confirmBlock = true }
                    Rectangle().fill(DS.silver.opacity(0.06)).frame(height: 1)
                    safetyRow(String(localized: "Report"), "exclamationmark.bubble.fill") { confirmReport = true }
                        .disabled(isReporting)
                }
                .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(DS.surface))
            }
            .padding(.horizontal, DS.Metric.gutter)
            .padding(.bottom, 24)
            .friendsColumn()
        }
        .confirmationDialog(String(localized: "Remove \(f.displayName)?"), isPresented: $confirmRemove, titleVisibility: .visible) {
            Button(String(localized: "Remove"), role: .destructive) {
                Task { await run(done: String(localized: "Removed \(f.displayName)")) { try await service.remove(f) } }
            }
        } message: {
            Text("You'll stop seeing each other's activity. You can add them again later.")
        }
        .confirmationDialog(String(localized: "Block \(f.displayName)?"), isPresented: $confirmBlock, titleVisibility: .visible) {
            Button(String(localized: "Block"), role: .destructive) {
                Task { await run(done: String(localized: "Blocked \(f.displayName)")) { try await service.block(f) } }
            }
        } message: {
            Text("They're removed and can't send you requests or nudges again.")
        }
        .confirmationDialog(String(localized: "Report \(f.displayName)?"), isPresented: $confirmReport, titleVisibility: .visible) {
            ForEach(FriendReportReason.allCases) { reason in
                Button(reason.title) { report(f, reason) }
            }
        } message: {
            Text("MUSQ reviews every report within 24 hours. To stop seeing them too, block them.")
        }
    }

    /// Sends the report, then closes the sheet with the thanks on the tab
    /// (an error stays here).
    private func report(_ f: Friend, _ reason: FriendReportReason) {
        guard !isReporting else { return }
        isReporting = true
        error = nil
        Task {
            defer { isReporting = false }
            do {
                try await service.report(f, reason: reason)
                onToast(String(localized: "Thanks — we'll take a look."))
                dismiss()
            } catch {
                self.error = friendsMessage(error)
            }
        }
    }

    private func stat(_ value: String, _ label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.ui(22, .bold))
                .foregroundStyle(DS.silver)
                .monospacedDigit()
            Text(label)
                .font(.ui(12))
                .foregroundStyle(DS.silver.opacity(0.5))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(DS.surface))
    }

    private func safetyRow(_ title: String, _ symbol: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: symbol)
                    .font(.system(size: 15, weight: .semibold))
                    .frame(width: 24)
                Text(title).font(.ui(16, .medium))
                Spacer()
            }
            .foregroundStyle(DS.rhythmWaiting)
            .padding(.horizontal, 16)
            .frame(height: 52)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func run(done: String? = nil, _ work: () async throws -> Void) async {
        error = nil
        do {
            try await work()
            if let done {
                onToast(done)
                dismiss()
            }
        } catch {
            self.error = friendsMessage(error)
        }
    }
}
