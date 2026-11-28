//
//  FriendsSetupView.swift
//  GymWorkout
//
//  The Friends profile (2026-11-28): a name, an emoji and what friends may
//  see. Shown once after Sign in with Apple, and again from the header's
//  edit button. Apple Health is never shared.
//

import SwiftUI

struct FriendsSetupView: View {
    /// True when editing an existing profile (offers a new code and Cancel).
    var editing = false
    var onDone: () -> Void = {}

    private var service: FriendsService { .shared }
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var emoji = ""
    @State private var share = FriendShare()
    @State private var regenerate = false
    @State private var isSaving = false
    @State private var error: String?
    @State private var loaded = false
    @FocusState private var nameFocused: Bool

    private var trimmed: String { name.trimmingCharacters(in: .whitespacesAndNewlines) }
    private var canSave: Bool { (1...FriendsCatalog.nameLimit).contains(trimmed.count) && !emoji.isEmpty && !isSaving }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                if !editing {
                    Text("Your friend profile")
                        .font(.ui(28, .bold))
                        .foregroundStyle(DS.silver)
                        .padding(.top, 12)
                }

                HStack(spacing: 14) {
                    FriendAvatar(emoji: emoji.isEmpty ? "🙂" : emoji, size: 60, highlighted: true)
                    TextField(String(localized: "Your name"), text: $name)
                        .font(.ui(20, .semibold))
                        .foregroundStyle(DS.silver)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                        .submitLabel(.done)
                        .focused($nameFocused)
                        .padding(.horizontal, 14)
                        .frame(height: 54)
                        .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(DS.surface))
                        .onChange(of: name) { _, new in
                            if new.count > 24 { name = String(new.prefix(24)) }
                        }
                }

                section(String(localized: "Pick an emoji")) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 6), spacing: 8) {
                        ForEach(FriendsCatalog.emojis, id: \.self) { e in
                            Button {
                                emoji = e
                            } label: {
                                Text(e)
                                    .font(.system(size: 26))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 48)
                                    .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(emoji == e ? DS.activation.opacity(0.18) : DS.surface))
                                    .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .strokeBorder(emoji == e ? DS.activation : .clear, lineWidth: 2))
                            }
                            .buttonStyle(.plain)
                            .accessibilityAddTraits(emoji == e ? .isSelected : [])
                        }
                    }
                    .sensoryFeedback(.selection, trigger: emoji)
                }

                section(String(localized: "What friends see")) {
                    VStack(spacing: 0) {
                        toggle($share.workouts, "dumbbell.fill", .orange,
                               String(localized: "Workouts"),
                               String(localized: "Workout name, minutes, sets and PRs"))
                        divider
                        toggle($share.water, "drop.fill", .blue,
                               String(localized: "Water"),
                               String(localized: "When you hit your water goal"))
                        divider
                        toggle($share.meals, "fork.knife", .green,
                               String(localized: "Meals"),
                               String(localized: "How many meals you logged — never calories or photos"))
                        divider
                        toggle($share.goal, "flag.checkered", .pink,
                               String(localized: "Goal"),
                               String(localized: "Your goal progress in % — never your weight"))
                    }
                    .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(DS.surface))
                    Label(String(localized: "Apple Health data is never shared."), systemImage: "lock.fill")
                        .font(.ui(13, .medium))
                        .foregroundStyle(DS.silver.opacity(0.55))
                        .padding(.top, 4)
                }

                if editing {
                    Toggle(isOn: $regenerate) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("New friend code")
                                .font(.ui(16, .semibold))
                                .foregroundStyle(DS.silver)
                            Text("Your old code and invite link stop working.")
                                .font(.ui(13))
                                .foregroundStyle(DS.silver.opacity(0.55))
                        }
                    }
                    .tint(DS.activation)
                    .padding(14)
                    .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(DS.surface))
                }

                if let error {
                    Text(error)
                        .font(.ui(14, .medium))
                        .foregroundStyle(DS.rhythmWaiting)
                }
            }
            .padding(.horizontal, DS.Metric.gutter)
            .padding(.bottom, 24)
            .friendsColumn()
        }
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            VStack(spacing: 8) {
                if !editing {
                    // Agreement shown in the app itself (App Review, UGC 1.2),
                    // not only in the terms page (2026-11-28).
                    Text("By continuing you agree to the [community rules](https://musq.app/terms.html#friends): no abuse, spam or offensive names.")
                        .font(.ui(12.5))
                        .foregroundStyle(DS.silver.opacity(0.55))
                        .tint(DS.silver)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Button {
                    Task { await save() }
                } label: {
                    if isSaving { ProgressView().tint(DS.ink) } else { Text(editing ? LocalizedStringKey("Save") : LocalizedStringKey("Continue")) }
                }
                .buttonStyle(FriendsPrimaryButtonStyle())
                .disabled(!canSave)
                if editing {
                    Button(String(localized: "Cancel")) { dismiss() }
                        .font(.ui(15, .semibold))
                        .foregroundStyle(DS.silver.opacity(0.7))
                        .frame(height: 36)
                }
            }
            .padding(.horizontal, DS.Metric.gutter)
            .padding(.vertical, 10)
            .frame(maxWidth: 640)
            .frame(maxWidth: .infinity)
            .background(DS.ink)
        }
        .background(DS.ink.ignoresSafeArea())
        .onAppear(perform: load)
    }

    private var divider: some View {
        Rectangle().fill(DS.silver.opacity(0.06)).frame(height: 1).padding(.leading, 66)
    }

    private func section<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.ui(15, .semibold))
                .foregroundStyle(DS.silver.opacity(0.6))
            content()
        }
    }

    private func toggle(_ value: Binding<Bool>, _ symbol: String, _ tint: Color,
                        _ title: String, _ detail: String) -> some View {
        Toggle(isOn: value) {
            HStack(spacing: 12) {
                StyledSymbol(name: symbol, size: 16)
                    .foregroundStyle(tint)
                    .frame(width: 38, height: 38)
                    .background(Circle().fill(tint.opacity(0.14)))
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.ui(16, .semibold))
                        .foregroundStyle(DS.silver)
                    Text(detail)
                        .font(.ui(13))
                        .foregroundStyle(DS.silver.opacity(0.55))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .tint(DS.activation)
        .padding(14)
    }

    private func load() {
        guard !loaded else { return }
        loaded = true
        if let me = service.me {
            name = me.displayName
            // The server's spelling may differ by a variation selector.
            emoji = FriendsCatalog.avatar(me.emoji) ?? me.emoji
            share = me.share
        } else {
            emoji = FriendsCatalog.defaultEmoji
            nameFocused = true
        }
    }

    private func save() async {
        if let problem = FriendsService.nameProblem(trimmed) {
            error = problem
            return
        }
        isSaving = true
        defer { isSaving = false }
        error = nil
        do {
            try await service.saveProfile(name: trimmed, emoji: emoji, share: share, regenerateCode: regenerate)
            onDone()
            if editing { dismiss() }
        } catch {
            self.error = friendsMessage(error)
        }
    }
}
