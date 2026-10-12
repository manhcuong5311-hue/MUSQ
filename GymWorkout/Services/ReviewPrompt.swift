//
//  ReviewPrompt.swift
//  GymWorkout
//
//  Asks for an App Store rating after a finished workout, the moment the app
//  has just been useful. The system shows the prompt at most three times a
//  year and may skip any request; on top of that we ask only at a few workout
//  milestones, at most once per app version, and never over another screen
//  (a full-screen ad, a sheet).
//

import StoreKit
import SwiftUI
import UIKit

enum ReviewPrompt {
    /// Completed-workout counts worth asking at. A milestone missed (an ad was
    /// showing) is picked up at the next finished workout.
    private static let milestones = [3, 10, 25, 60]
    private static let askedCountKey = "reviewPrompt.askedAtCount"
    private static let askedVersionKey = "reviewPrompt.askedVersion"

    private static var version: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }

    /// Call right after a workout is completed, with the new total.
    @MainActor
    static func workoutCompleted(count: Int, request: RequestReviewAction) {
        let defaults = UserDefaults.standard
        let askedAt = defaults.integer(forKey: askedCountKey)
        guard milestones.contains(where: { $0 > askedAt && $0 <= count }),
              defaults.string(forKey: askedVersionKey) != version else { return }
        Task { @MainActor in
            // Past the ad's 1.2 s delay, so the two never meet.
            try? await Task.sleep(for: .seconds(2.5))
            guard !isCoveredByModal else { return }
            defaults.set(count, forKey: askedCountKey)
            defaults.set(version, forKey: askedVersionKey)
            request()
        }
    }

    @MainActor
    private static var isCoveredByModal: Bool {
        let scene = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
        guard let scene else { return true }
        return scene.windows.contains { $0.isKeyWindow && $0.rootViewController?.presentedViewController != nil }
    }
}
