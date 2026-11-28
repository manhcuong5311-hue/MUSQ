//
//  GymWorkoutApp.swift
//  GymWorkout
//
//  Created by Sam Manh Cuong on 13/9/26.
//

import SwiftUI
import UserNotifications

@main
struct GymWorkoutApp: App {
    @Environment(\.scenePhase) private var scenePhase

    init() {
        // Firebase, for the Premium AI features' sign-in and server calls.
        AIService.configure()
        // Set before launch finishes, so a tap that opened the app is routed.
        UNUserNotificationCenter.current().delegate = NudgeNotificationDelegate.shared
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // Nudges are laid for today and tomorrow from the latest logs: again
        // on every open, and on leaving with whatever was just logged.
        .onChange(of: scenePhase) { _, phase in
            if phase == .active || phase == .background {
                NudgeScheduler.shared.replanSoon()
            }
        }
    }
}
