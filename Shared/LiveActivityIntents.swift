//
//  LiveActivityIntents.swift
//  Shared
//
//  Buttons on the Live Activities and widgets. LiveActivityIntent makes the
//  system run perform() in the APP's process (launched in the background if
//  needed), where the app has registered a handler that mutates WorkoutStore /
//  RestTimer / DailyStore through their existing APIs. In the extension's
//  process there is no handler: the action is queued in the App Group
//  (PendingActions) for the app to apply on its next launch.
//
//  App side, at launch (MainActor):
//      LiveActivityActions.handler = MyHandler()   // conforms to LiveActivityActionHandling
//      PendingActions.drain { action in ... }        // on becoming active
//

import AppIntents
import Foundation

// MARK: - Handler the app implements

@MainActor
protocol LiveActivityActionHandling: AnyObject {
    /// Mark the next undone set of the current exercise done (starts rest).
    func doneSet() async
    /// Add (positive) or take off (negative) seconds from the running rest.
    func adjustRest(seconds: Int) async
    /// End the running rest now.
    func skipRest() async
    /// Log water now (DailyStore.addWater).
    func addWater(ml: Int) async
    /// Route a deep link (musq://…) — used by OpenQuickLogIntent.
    func open(_ url: URL) async
}

@MainActor
enum LiveActivityActions {
    /// Set by the app at launch; nil in MUSQWidgets.
    static var handler: (any LiveActivityActionHandling)?
}

// MARK: - Queue for actions that ran without the app's handler

nonisolated enum PendingAction: Codable, Hashable, Sendable {
    case doneSet
    case adjustRest(seconds: Int)
    case skipRest
    case addWater(ml: Int, at: Date)
}

nonisolated enum PendingActions {
    static func enqueue(_ action: PendingAction) {
        var all = load()
        all.append(action)
        if let data = try? JSONEncoder().encode(all) {
            AppGroup.defaults.set(data, forKey: AppGroup.Key.pendingActions)
        }
    }

    static func load() -> [PendingAction] {
        guard let data = AppGroup.defaults.data(forKey: AppGroup.Key.pendingActions) else { return [] }
        return (try? JSONDecoder().decode([PendingAction].self, from: data)) ?? []
    }

    /// App only: returns and clears the queue (apply water; rest/set actions
    /// are usually stale by then — the app decides).
    static func drain() -> [PendingAction] {
        let all = load()
        AppGroup.defaults.removeObject(forKey: AppGroup.Key.pendingActions)
        return all
    }
}

// MARK: - Workout intents

nonisolated struct DoneSetIntent: LiveActivityIntent {
    static let title: LocalizedStringResource = "Done set"
    static let description = IntentDescription("Marks the current set done and starts the rest.")
    static let isDiscoverable = false

    init() {}

    @MainActor
    func perform() async throws -> some IntentResult {
        if let handler = LiveActivityActions.handler { await handler.doneSet() }
        else { PendingActions.enqueue(.doneSet) }
        return .result()
    }
}

struct RestAdjustIntent: LiveActivityIntent {
    static let title: LocalizedStringResource = "Change rest"
    static let isDiscoverable = false

    @Parameter(title: "Seconds")
    var seconds: Int

    init() { seconds = 15 }
    init(seconds: Int) { self.seconds = seconds }

    @MainActor
    func perform() async throws -> some IntentResult {
        if let handler = LiveActivityActions.handler { await handler.adjustRest(seconds: seconds) }
        else { PendingActions.enqueue(.adjustRest(seconds: seconds)) }
        return .result()
    }
}

nonisolated struct SkipRestIntent: LiveActivityIntent {
    static let title: LocalizedStringResource = "Skip rest"
    static let isDiscoverable = false

    init() {}

    @MainActor
    func perform() async throws -> some IntentResult {
        if let handler = LiveActivityActions.handler { await handler.skipRest() }
        else { PendingActions.enqueue(.skipRest) }
        return .result()
    }
}

// MARK: - Today intents

struct AddWaterIntent: LiveActivityIntent {
    static let title: LocalizedStringResource = "Add water"
    static let description = IntentDescription("Logs a glass of water in MUSQ.")

    @Parameter(title: "Millilitres")
    var ml: Int

    init() { ml = 250 }
    init(ml: Int) { self.ml = ml }

    @MainActor
    func perform() async throws -> some IntentResult {
        if let handler = LiveActivityActions.handler { await handler.addWater(ml: ml) }
        else {
            // No app to run it: queue it, and show it on the widgets now so
            // a second tap isn't needed to see it (the app rewrites the
            // snapshot from its stores once it has applied the queue).
            PendingActions.enqueue(.addWater(ml: ml, at: Date()))
            TodaySnapshot.addQueuedWater(ml)
        }
        return .result()
    }
}

/// Opens the app on the food quick log (musq://quicklog/food). Widgets and
/// Live Activities can equally use `Link(destination: MUSQLink.quickLogFood)`.
nonisolated struct OpenQuickLogIntent: AppIntent {
    static let title: LocalizedStringResource = "Log meal"
    static let description = IntentDescription("Opens MUSQ to log a meal.")
    static let openAppWhenRun = true

    init() {}

    @MainActor
    func perform() async throws -> some IntentResult {
        await LiveActivityActions.handler?.open(MUSQLink.quickLogFood)
        return .result()
    }
}
