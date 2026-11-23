//
//  GymWorkoutApp.swift
//  GymWorkout
//
//  Created by Sam Manh Cuong on 13/9/26.
//

import SwiftUI

@main
struct GymWorkoutApp: App {
    init() {
        // Firebase, for the Premium AI features' sign-in and server calls.
        AIService.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
