//
//  AccountService.swift
//  GymWorkout
//
//  The MUSQ account (2026-11-21): Sign in with Apple through Firebase Auth,
//  needed only for the Premium AI features so the server can tie usage to
//  a purchase. Everything else in the app works signed out, and workouts
//  stay on the device either way. Only the email is asked for (often
//  Apple's relay address), never the name. Deleting the account revokes the
//  Apple token (App Store 5.1.1(v)) and removes what the server holds.
//

import AuthenticationServices
import CryptoKit
import FirebaseAuth
import Foundation
import Observation
import UIKit

@MainActor
@Observable
final class AccountService {
    static let shared = AccountService()

    struct Member: Equatable {
        var uid: String
        /// Often Apple's private relay address.
        var email: String?
    }

    /// How revoking the Sign in with Apple token went when the account was
    /// deleted; the server logs it.
    enum AppleRevocation: String {
        case done, failed
        /// The emulator's test accounts have no Apple token.
        case skipped
    }

    enum AccountError: LocalizedError {
        case appleSignInFailed
        case notSignedIn

        var errorDescription: String? {
            switch self {
            case .appleSignInFailed: return String(localized: "Sign in with Apple didn't finish. Try again.")
            case .notSignedIn: return String(localized: "You're not signed in.")
            }
        }
    }

    private(set) var member: Member?
    var isSignedIn: Bool { member != nil }
    #if DEBUG
    /// Why the last deletion couldn't revoke the Apple token, shown in
    /// Profile so a missing Apple key in the Firebase console is caught
    /// before release.
    private(set) var lastRevocationError: String?
    #endif

    @ObservationIgnored private var listener: AuthStateDidChangeListenerHandle?
    @ObservationIgnored private var currentNonce: String?

    private init() {}

    /// Follows Firebase's sign-in state; called once Firebase is set up.
    func start() {
        guard listener == nil else { return }
        listener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            MainActor.assumeIsolated {
                guard let self else { return }
                let wasSignedIn = self.member != nil
                self.member = user.map { Member(uid: $0.uid, email: $0.email) }
                if user != nil && !wasSignedIn {
                    Task { await AIService.shared.syncEntitlements() }
                    // Friends (2026-11-28) loads its profile and friends.
                    Task { await FriendsService.shared.refresh() }
                }
                if user == nil {
                    AIService.shared.signedOut()
                    if wasSignedIn { FriendsService.shared.signedOut() }
                }
            }
        }
    }

    // MARK: - Sign in with Apple

    /// For `SignInWithAppleButton(onRequest:)`.
    func prepare(_ request: ASAuthorizationAppleIDRequest) {
        let nonce = Self.randomNonce()
        currentNonce = nonce
        // The email only: MUSQ never uses the name, so it doesn't ask for it.
        request.requestedScopes = [.email]
        request.nonce = Self.sha256(nonce)
    }

    /// For `SignInWithAppleButton(onCompletion:)`.
    func complete(_ result: Result<ASAuthorization, Error>) async throws {
        let authorization = try result.get()
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let tokenData = credential.identityToken,
              let token = String(data: tokenData, encoding: .utf8),
              let nonce = currentNonce else {
            throw AccountError.appleSignInFailed
        }
        let firebaseCredential = OAuthProvider.appleCredential(withIDToken: token, rawNonce: nonce, fullName: nil)
        try await Auth.auth().signIn(with: firebaseCredential)
        currentNonce = nil
    }

    #if DEBUG
    /// The emulator can't sign in with Apple: a throwaway account there.
    func signInForTesting() async throws {
        guard AIService.usesEmulator else { return }
        try await Auth.auth().signInAnonymously()
    }
    #endif

    func signOut() {
        try? Auth.auth().signOut()
    }

    /// Revokes the Apple token, deletes the server's records and the account,
    /// withdraws the AI consents and signs out. Workouts on the device stay;
    /// the Premium purchase stays with the Apple Account.
    @discardableResult
    func deleteAccount() async throws -> AppleRevocation {
        guard isSignedIn else { throw AccountError.notSignedIn }
        #if DEBUG
        let skipsApple = AIService.usesEmulator
        lastRevocationError = nil
        #else
        let skipsApple = false
        #endif
        var revocation = AppleRevocation.skipped
        if !skipsApple {
            // Apple asks apps to revoke the token when an account is deleted.
            // That needs a fresh authorization code, so Apple asks once more.
            let code = try await AppleReauthorizer().authorizationCode()
            do {
                try await Auth.auth().revokeToken(withAuthorizationCode: code)
                revocation = .done
            } catch {
                // Revocation needs the Apple key in the Firebase console. The
                // account is still deleted below, and the server logs this.
                revocation = .failed
                #if DEBUG
                lastRevocationError = error.localizedDescription
                #endif
            }
        }
        try await AIService.shared.deleteAccountOnServer(appleRevocation: revocation.rawValue)
        AIService.Consent.withdrawAll()
        try? Auth.auth().signOut()
        return revocation
    }

    // MARK: - Nonce

    private static func randomNonce(length: Int = 32) -> String {
        let charset = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var bytes = [UInt8](repeating: 0, count: length)
        if SecRandomCopyBytes(kSecRandomDefault, length, &bytes) != errSecSuccess {
            return UUID().uuidString + UUID().uuidString
        }
        return String(bytes.map { charset[Int($0) % charset.count] })
    }

    private static func sha256(_ input: String) -> String {
        SHA256.hash(data: Data(input.utf8)).map { String(format: "%02x", $0) }.joined()
    }
}

/// Asks Sign in with Apple once more, for the authorization code that
/// revoking the token needs.
@MainActor
private final class AppleReauthorizer: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    private var continuation: CheckedContinuation<String, Error>?

    func authorizationCode() async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = []
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    }

    nonisolated func authorizationController(controller: ASAuthorizationController,
                                             didCompleteWithAuthorization authorization: ASAuthorization) {
        let code = (authorization.credential as? ASAuthorizationAppleIDCredential)?.authorizationCode
            .flatMap { String(data: $0, encoding: .utf8) }
        MainActor.assumeIsolated {
            if let code {
                continuation?.resume(returning: code)
            } else {
                continuation?.resume(throwing: AccountService.AccountError.appleSignInFailed)
            }
            continuation = nil
        }
    }

    nonisolated func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        MainActor.assumeIsolated {
            continuation?.resume(throwing: error)
            continuation = nil
        }
    }

    nonisolated func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        MainActor.assumeIsolated {
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap(\.windows)
                .first { $0.isKeyWindow } ?? ASPresentationAnchor()
        }
    }
}
