//
//  AIAccessViews.swift
//  GymWorkout
//
//  What stands between a member and an AI feature (2026-11-21): signing in
//  with Apple, and a consent per feature that names OpenAI and says exactly
//  what is sent (App Store 5.1.2(i)). Shared by the meal scan and the goal
//  photo; the Ask MUSQ chat keeps its own consent sheet on the same key.
//

import AuthenticationServices
import SwiftUI

// MARK: - Sign in

/// Sign in with Apple, for the AI features. Everything else in MUSQ works
/// without an account.
struct AISignInPrompt: View {
    /// Called once signed in; the sheet closes itself.
    var onSignedIn: () -> Void = {}

    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var scheme
    @State private var error: String?
    @State private var isWorking = false

    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: "person.crop.circle.badge.checkmark")
                .font(.system(size: 40, weight: .regular))
                .foregroundStyle(DS.silver.opacity(0.85))
                .padding(.top, 28)
            Text("Sign in to use MUSQ's AI")
                .font(.ui(22, .bold))
                .tracking(-0.4)
                .foregroundStyle(DS.silver)
                .multilineTextAlignment(.center)
                .padding(.top, 14)
            Text("The AI runs on MUSQ's server, which checks your purchase with Apple and keeps count of your allowance. Your workouts are kept on this \(DS.deviceNoun): an AI feature sends only what its consent lists, after you agree. You can hide your email from MUSQ.")
                .font(.ui(14.5))
                .foregroundStyle(DS.silver.opacity(0.68))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 10)
            SignInWithAppleButton(.signIn) { request in
                AccountService.shared.prepare(request)
            } onCompletion: { result in
                Task { await finish(result) }
            }
            .signInWithAppleButtonStyle(scheme == .dark ? .white : .black)
            .frame(height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .disabled(isWorking)
            .padding(.top, 24)
            #if DEBUG
            if AIService.usesEmulator {
                Button("Sign in for testing (emulator)") {
                    Task {
                        try? await AccountService.shared.signInForTesting()
                        onSignedIn()
                        dismiss()
                    }
                }
                .font(.ui(14, .semibold))
                .padding(.top, 12)
            }
            #endif
            if let error {
                Text(error)
                    .font(.ui(13))
                    .foregroundStyle(DS.silver.opacity(0.75))
                    .multilineTextAlignment(.center)
                    .padding(.top, 12)
            }
            Button(String(localized: "Not now")) { dismiss() }
                .font(.ui(15, .semibold))
                .foregroundStyle(DS.silver.opacity(0.7))
                .padding(.top, 14)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: 460)
        .presentationDetents([.medium])
        .presentationBackground(DS.surface)
    }

    private func finish(_ result: Result<ASAuthorization, Error>) async {
        if case .failure(let failure) = result, (failure as? ASAuthorizationError)?.code == .canceled { return }
        isWorking = true
        defer { isWorking = false }
        do {
            try await AccountService.shared.complete(result)
            onSignedIn()
            dismiss()
        } catch {
            self.error = String(localized: "Sign in with Apple didn't finish. Try again.")
        }
    }
}

// MARK: - Consent

/// What a feature sends to OpenAI, asked once per feature before the first use.
struct AIConsentSheet: View {
    enum Feature {
        case meal, goalPhoto

        var consent: AIService.Consent { self == .meal ? .meal : .goalPhoto }

        var title: String {
            switch self {
            case .meal: return String(localized: "Meal scans use AI")
            case .goalPhoto: return String(localized: "Your goal photo uses AI")
            }
        }

        var lines: [(symbol: String, text: String)] {
            switch self {
            case .meal:
                return [
                    ("photo", String(localized: "The meal photo you take or pick, and your note if you add one, go to OpenAI through MUSQ's server to estimate the foods, grams and calories.")),
                    ("hand.raised", String(localized: "Only an anonymous ID goes with it, so OpenAI can spot abuse: not your name, workouts, body measurements or health answers.")),
                    ("trash", String(localized: "MUSQ doesn't keep the photo. The meal you save stays on this \(DS.deviceNoun).")),
                ]
            case .goalPhoto:
                return [
                    ("person.crop.square", String(localized: "The photo you pick, with the look you choose (sex, muscle and body fat) and an anonymous ID, goes to OpenAI through MUSQ's server, which edits it to show you at that goal. MUSQ's server checks your birth year and doesn't pass it on.")),
                    ("checkmark.shield", String(localized: "Use only a photo of yourself. The edit keeps your clothes, and MUSQ puts your own face back on this \(DS.deviceNoun); it's an illustration, not a prediction.")),
                    ("trash", String(localized: "MUSQ doesn't keep your photo or the result. Both stay on this \(DS.deviceNoun) only, for your Goal page.")),
                ]
            }
        }
    }

    var feature: Feature
    var onAgree: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(feature.title)
                .font(.ui(22, .bold))
                .tracking(-0.4)
                .foregroundStyle(DS.silver)
                .padding(.top, 26)
            VStack(alignment: .leading, spacing: 14) {
                ForEach(Array(feature.lines.enumerated()), id: \.offset) { _, line in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: line.symbol)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(DS.silver.opacity(0.8))
                            .frame(width: 22)
                        Text(line.text)
                            .font(.ui(14.5))
                            .foregroundStyle(DS.silver.opacity(0.8))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(.top, 18)
            Text("OpenAI may keep what it receives for up to 30 days to check for abuse, and doesn't use it to train its models.")
                .font(.ui(12.5))
                .foregroundStyle(DS.silver.opacity(0.6))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 16)
            Link(String(localized: "Privacy Policy"), destination: AppLinks.privacy)
                .font(.ui(13, .semibold))
                .foregroundStyle(DS.silver.opacity(0.75))
                .padding(.top, 8)
            Spacer(minLength: 16)
            WideButton(title: String(localized: "Agree and continue"), prominent: true, fontSize: 16, verticalPadding: 14,
                       cornerRadius: 14) {
                feature.consent.give()
                dismiss()
                onAgree()
            }
            Button(String(localized: "Not now")) { dismiss() }
                .font(.ui(15, .semibold))
                .foregroundStyle(DS.silver.opacity(0.7))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: 520)
        .presentationDetents([.large])
        .presentationBackground(DS.surface)
    }
}

// MARK: - Account

/// The account row in Profile: sign in, or who's signed in with sign out
/// and delete. Shown only in builds with the AI features.
struct AccountSection: View {
    @State private var showsSignIn = false
    @State private var confirmsDelete = false
    @State private var isDeleting = false
    @State private var error: String?
    @Environment(\.dsLayout) private var layout
    @AppStorage(AIService.Consent.chat.rawValue) private var chatConsent = false
    @AppStorage(AIService.Consent.meal.rawValue) private var mealConsent = false
    @AppStorage(AIService.Consent.goalPhoto.rawValue) private var goalPhotoConsent = false

    private var account: AccountService { .shared }
    private var hasConsent: Bool { chatConsent || mealConsent || goalPhotoConsent }

    /// App Store 5.1.2(i): consent can be withdrawn as easily as it was given.
    private func withdrawConsent() {
        chatConsent = false
        mealConsent = false
        goalPhotoConsent = false
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionEyebrow(text: "ACCOUNT")
            VStack(spacing: 0) {
                if let member = account.member {
                    row(title: String(localized: "Signed in with Apple"),
                        detail: member.email ?? String(localized: "Your email is hidden.")) {
                        pill(String(localized: "SIGN OUT")) { account.signOut() }
                    }
                    if hasConsent {
                        Hairline(opacity: 0.06)
                        row(title: String(localized: "AI data sharing"),
                            detail: String(localized: "You agreed to share what the AI features need with OpenAI. Withdraw it, and each feature asks again before it sends anything.")) {
                            pill(String(localized: "WITHDRAW")) { withdrawConsent() }
                        }
                    }
                    Hairline(opacity: 0.06)
                    row(title: String(localized: "Delete account"),
                        detail: String(localized: "Removes your MUSQ account and your plan's record from the server; its service logs are deleted within 30 days. Usage counts belong to your purchase, not the account, and hold nothing about you. Workouts on this \(DS.deviceNoun) and your purchase stay.")) {
                        if isDeleting {
                            ProgressView()
                        } else {
                            pill(String(localized: "DELETE")) { confirmsDelete = true }
                        }
                    }
                } else {
                    row(title: String(localized: "Sign in with Apple"),
                        detail: String(localized: "Needed only for the AI features: Ask MUSQ, meal scans and your goal photo.")) {
                        pill(String(localized: "SIGN IN"), prominent: true) { showsSignIn = true }
                    }
                }
            }
            .padding(.horizontal, layout.value(14, 18))
            .background(RoundedRectangle(cornerRadius: layout.cardRadius, style: .continuous).fill(DS.surfaceAlt))
            if let error {
                Text(error)
                    .font(.ui(12.5))
                    .foregroundStyle(DS.silver.opacity(0.7))
                    .padding(.horizontal, 4)
            }
            #if DEBUG
            if let revocationError = account.lastRevocationError {
                Text(verbatim: "Debug: the Apple token wasn't revoked (\(revocationError)). Check the Apple provider's key and Services ID in the Firebase console.")
                    .font(.ui(12))
                    .foregroundStyle(DS.silver.opacity(0.6))
                    .padding(.horizontal, 4)
            }
            #endif
        }
        .sheet(isPresented: $showsSignIn) { AISignInPrompt() }
        .confirmationDialog(String(localized: "Delete your MUSQ account?"), isPresented: $confirmsDelete, titleVisibility: .visible) {
            Button(String(localized: "Delete account"), role: .destructive) { delete() }
            Button(String(localized: "Cancel"), role: .cancel) {}
        } message: {
            Text("Apple asks you to confirm once more. Your workouts on this \(DS.deviceNoun) and your purchase stay, and so do the usage counts that belong to the purchase. A subscription keeps renewing until you cancel it in Settings › Apple Account › Subscriptions.")
        }
    }

    private func delete() {
        isDeleting = true
        error = nil
        Task {
            defer { isDeleting = false }
            do {
                try await account.deleteAccount()
            } catch let failure as ASAuthorizationError where failure.code == .canceled {
                // Cancelled at Apple's sheet: nothing happened.
            } catch {
                self.error = String(localized: "The account couldn't be deleted. Check your connection and try again.")
            }
        }
    }

    private func row<Control: View>(title: String, detail: String, @ViewBuilder control: () -> Control) -> some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.ui(layout.value(14.5, 16), .semibold))
                    .foregroundStyle(DS.silver)
                Text(detail)
                    .font(.ui(layout.value(12, 13.5)))
                    .foregroundStyle(DS.silver.opacity(0.5))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 8)
            control()
        }
        .padding(.vertical, layout.value(13, 16))
    }

    private func pill(_ title: String, prominent: Bool = false, action: @escaping () -> Void) -> some View {
        let size: CGFloat = layout.value(10, 11)
        return Button(action: action) {
            Text(title)
                .font(.mono(size, .semibold))
                .trackingEm(0.08, size: size)
                .foregroundStyle(prominent ? DS.ink : DS.silver.opacity(0.8))
                .padding(.horizontal, layout.value(11, 14))
                .padding(.vertical, layout.value(8, 9))
                .background(Capsule().fill(prominent ? DS.silver : DS.silver.opacity(0.07)))
        }
        .buttonStyle(.plain)
    }
}
