//
//  HealthSeed.swift
//  GymWorkout
//
//  DEBUG only: `-health.seed` fills the Simulator's Apple Health with 30
//  days of sample steps, walking distance, active energy and sleep (Watch
//  stages), plus a strength workout over this morning's MUSQ session, so the
//  phase 2 screens can be checked and shot. Release builds don't contain it
//  and never ask to write to Health. Runs once per install
//  (`health.seeded`); `-health.reseed` adds another copy anyway.
//

#if DEBUG
import Foundation
import HealthKit

enum HealthSeed {
    static func run() async {
        let defaults = UserDefaults.standard
        let force = ProcessInfo.processInfo.arguments.contains("-health.reseed")
        guard HKHealthStore.isHealthDataAvailable(), force || !defaults.bool(forKey: "health.seeded") else { return }
        let store = HKHealthStore()
        let steps = HKQuantityType(.stepCount)
        let distance = HKQuantityType(.distanceWalkingRunning)
        let energy = HKQuantityType(.activeEnergyBurned)
        let sleep = HKCategoryType(.sleepAnalysis)
        let share: Set<HKSampleType> = [steps, distance, energy, sleep, HKObjectType.workoutType()]
        do {
            try await store.requestAuthorization(toShare: share, read: AppleHealth.readTypes)
        } catch { return }

        let calendar = Calendar.current
        let now = Date()
        let today = calendar.startOfDay(for: now)
        var generator = HealthSeedGenerator(seed: 7)
        var samples: [HKSample] = []

        for offset in (0...29).reversed() {
            guard let day = calendar.date(byAdding: .day, value: -offset, to: today) else { continue }
            // A desk worker who walks more on some days: 5-12k steps, in
            // hourly chunks from 7 am to 9 pm, up to now today.
            let total = Double(Int.random(in: 5_200...12_400, using: &generator))
            let weights = (7...21).map { hour -> Double in hour == 8 || hour == 12 || hour == 18 ? 3 : 1 }
            let sum = weights.reduce(0, +)
            for (index, hour) in (7...21).enumerated() {
                guard let start = calendar.date(byAdding: .hour, value: hour, to: day),
                      let end = calendar.date(byAdding: .minute, value: 50, to: start), end <= now else { continue }
                let count = (total * weights[index] / sum).rounded()
                samples.append(HKQuantitySample(type: steps, quantity: HKQuantity(unit: .count(), doubleValue: count),
                                                start: start, end: end))
                samples.append(HKQuantitySample(type: distance,
                                                quantity: HKQuantity(unit: .meter(), doubleValue: count * 0.74),
                                                start: start, end: end))
                samples.append(HKQuantitySample(type: energy,
                                                quantity: HKQuantity(unit: .kilocalorie(), doubleValue: count * 0.045),
                                                start: start, end: end))
            }
            // The night before: asleep about 23:20 to 06:40 with stages, 5½-8 h.
            guard let bed = calendar.date(byAdding: .minute, value: -40 - Int.random(in: 0...50, using: &generator), to: day) else { continue }
            var cursor = bed
            let length = Int.random(in: 330...480, using: &generator)
            let pattern: [(HKCategoryValueSleepAnalysis, Int)] = [(.asleepCore, 40), (.asleepDeep, 50), (.asleepCore, 60),
                                                                  (.asleepREM, 25), (.awake, 5), (.asleepCore, 70),
                                                                  (.asleepDeep, 30), (.asleepREM, 35), (.asleepCore, 80),
                                                                  (.asleepREM, 40), (.asleepCore, 60)]
            var used = 0
            for (value, minutes) in pattern where used < length {
                let span = min(minutes, length - used)
                let end = cursor.addingTimeInterval(Double(span) * 60)
                guard end <= now else { break }
                samples.append(HKCategorySample(type: sleep, value: value.rawValue, start: cursor, end: end))
                cursor = end
                used += span
            }
        }
        do {
            try await store.save(samples)
        } catch { return }

        // A Watch strength workout over this morning's seeded MUSQ session.
        if let start = calendar.date(byAdding: .minute, value: 7 * 60 + 25, to: today),
           let end = calendar.date(byAdding: .minute, value: 50, to: start), end <= now {
            let configuration = HKWorkoutConfiguration()
            configuration.activityType = .traditionalStrengthTraining
            let builder = HKWorkoutBuilder(healthStore: store, configuration: configuration, device: .local())
            do {
                try await builder.beginCollection(at: start)
                let burn = HKQuantitySample(type: energy, quantity: HKQuantity(unit: .kilocalorie(), doubleValue: 214),
                                            start: start, end: end)
                try await builder.addSamples([burn])
                try await builder.endCollection(at: end)
                _ = try await builder.finishWorkout()
            } catch {}
        }
        defaults.set(true, forKey: "health.seeded")
    }
}

/// Repeatable sample numbers (SplitMix64).
private struct HealthSeedGenerator: RandomNumberGenerator {
    var state: UInt64
    init(seed: UInt64) { state = seed }
    mutating func next() -> UInt64 {
        state &+= 0x9E3779B97F4A7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }
}
#endif
