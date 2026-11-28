//
//  AddFriendSheet.swift
//  GymWorkout
//
//  Add a friend by their 6-character code, or send your invite (2026-11-28).
//

import SwiftUI

struct AddFriendSheet: View {
    private var service: FriendsService { .shared }
    @Environment(\.dismiss) private var dismiss

    @State private var code = ""
    @State private var isWorking = false
    @State private var message: String?
    @State private var success = false
    @FocusState private var focused: Bool

    /// The code alphabet: A–Z and 2–9 without look-alikes (O/0, I/1, L).
    private static let allowed = FriendsCatalog.codeAlphabet

    var body: some View {
        VStack(spacing: 0) {
            Text("Add a friend")
                .font(.ui(22, .bold))
                .foregroundStyle(DS.silver)
                .padding(.top, 26)
            Text("Ask for their code — it's on their Friends tab.")
                .font(.ui(14))
                .foregroundStyle(DS.silver.opacity(0.55))
                .multilineTextAlignment(.center)
                .padding(.top, 6)

            HStack(spacing: 10) {
                TextField("ABC234", text: $code)
                    .font(.system(size: 30, weight: .bold, design: .monospaced))
                    .tracking(6)
                    .multilineTextAlignment(.center)
                    .textInputAutocapitalization(.characters)
                    .autocorrectionDisabled()
                    .keyboardType(.asciiCapable)
                    .submitLabel(.go)
                    .focused($focused)
                    .onSubmit { Task { await add() } }
                    .frame(height: 64)
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(DS.surfaceDim))
                    .onChange(of: code) { _, new in
                        // Typed, or pasted from the edit menu: the code out of
                        // an invite link or share text, like the Paste button.
                        let clean = Self.extractCode(new)
                        if clean != new { code = clean }
                        message = nil
                    }
                PasteButton(payloadType: String.self) { strings in
                    guard let s = strings.first else { return }
                    Task { @MainActor in code = Self.extractCode(s) }
                }
                .labelStyle(.iconOnly)
                .buttonBorderShape(.roundedRectangle(radius: 16))
                .frame(height: 64)
            }
            .padding(.top, 20)

            if let message {
                Text(message)
                    .font(.ui(14.5, .semibold))
                    .foregroundStyle(success ? DS.rhythmDue : DS.rhythmWaiting)
                    .multilineTextAlignment(.center)
                    .padding(.top, 12)
            }

            if !service.outgoing.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Waiting for")
                        .font(.ui(13, .semibold))
                        .foregroundStyle(DS.silver.opacity(0.5))
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(service.outgoing, id: \.id) { r in
                                HStack(spacing: 6) {
                                    Text(r.emoji)
                                    Text(r.displayName).font(.ui(14, .medium)).foregroundStyle(DS.silver)
                                }
                                .padding(.horizontal, 12)
                                .frame(height: 34)
                                .background(Capsule().fill(DS.silver.opacity(0.06)))
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 18)
            }

            Spacer(minLength: 16)

            VStack(spacing: 10) {
                Button {
                    Task { await add() }
                } label: {
                    if isWorking { ProgressView().tint(DS.ink) } else { Text("Add") }
                }
                .buttonStyle(FriendsPrimaryButtonStyle())
                .disabled(code.count != 6 || isWorking)

                if let invite = service.inviteText {
                    ShareLink(item: invite) {
                        Label(String(localized: "Share my invite"), systemImage: "square.and.arrow.up")
                    }
                    .buttonStyle(FriendsPrimaryButtonStyle(filled: false))
                }
            }
            .padding(.bottom, 12)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: 520)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .presentationBackground(DS.surface)
        .sensoryFeedback(.success, trigger: success)
        .onAppear { focused = true }
    }

    /// A pasted code, or the code out of a pasted invite (".../f/ABC234").
    static func extractCode(_ text: String) -> String {
        if let code = FriendsCatalog.normalizedCode(text) { return code }
        let upper = text.uppercased()
        if let range = upper.range(of: "/F/") {
            let tail = upper[range.upperBound...]
            return String(tail.filter { allowed.contains($0) }.prefix(6))
        }
        // The first run of 6 code characters in the text.
        var run = ""
        for ch in upper {
            if allowed.contains(ch) { run.append(ch); if run.count == 6 { return run } } else { run = "" }
        }
        return String(upper.filter { allowed.contains($0) }.prefix(6))
    }

    private func add() async {
        guard code.count == 6, !isWorking else { return }
        if code == service.me?.code {
            success = false
            message = String(localized: "That's your own code.")
            return
        }
        isWorking = true
        defer { isWorking = false }
        do {
            let status = try await service.add(code: code)
            switch status {
            case .accepted:
                message = String(localized: "You're now friends! 🎉")
            case .already:
                message = String(localized: "Already friends or requested.")
            case .sent:
                message = String(localized: "Request sent. They'll see it on their Friends tab.")
            }
            success = true
            code = ""
        } catch {
            success = false
            message = friendsMessage(error)
        }
    }
}
