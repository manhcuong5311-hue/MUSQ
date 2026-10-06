//
//  BodyMap.swift
//  GymWorkout
//
//  The flat front/back muscle map in the Muscles Worked panel. Regions are
//  drawn from `BodyMapPaths` (generated) and lit from the exercise's own
//  activation data, so the map always agrees with the bars beside it.
//

import SwiftUI

// MARK: - Regions

enum BodySide: CaseIterable {
    case front, back

    var title: String { self == .front ? "FRONT" : "BACK" }
}

/// One drawable region of the map. Cases match the source data's slugs.
enum BodyRegion {
    case chest, obliques, abs, biceps, triceps, neck, trapezius, deltoids
    case adductors, quadriceps, tibialis, calves, forearm
    case upperBack, lowerBack, gluteal, hamstring
    // Not muscles: always drawn neutral.
    case knees, hands, ankles, feet, head, hair

    var isMuscle: Bool {
        switch self {
        case .knees, .hands, .ankles, .feet, .head, .hair: return false
        default: return true
        }
    }

    /// Where a named muscle shows on the map, and on which views.
    ///
    /// Matched on keywords rather than exact names so that new content lights
    /// up without touching this file. A deltoid or trapezius head only lights
    /// the view it actually faces; "Middle Trapezius" is a back muscle even
    /// though the front view shows the upper fibres.
    static func regions(forMuscle name: String) -> [(BodyRegion, Set<BodySide>)] {
        let n = name.lowercased()
        func has(_ words: String...) -> Bool { words.contains { n.contains($0) } }
        let both: Set<BodySide> = [.front, .back]

        if has("biceps femoris", "hamstring", "semitendinosus", "semimembranosus") {
            return [(.hamstring, both)]
        }
        if has("pector", "chest") { return [(.chest, both)] }
        if has("deltoid", "delt") {
            if has("anterior", "front") { return [(.deltoids, [.front])] }
            if has("posterior", "rear") { return [(.deltoids, [.back])] }
            return [(.deltoids, both)]
        }
        if has("trapez", "traps") {
            if has("middle", "lower") { return [(.trapezius, [.back])] }
            return [(.trapezius, both)]
        }
        if has("latissimus", "lats", "rhomboid", "teres", "infraspinatus", "upper back") {
            return [(.upperBack, both)]
        }
        if has("erector", "spinae", "lower back", "quadratus lumborum") { return [(.lowerBack, both)] }
        if has("glute") { return [(.gluteal, both)] }
        if has("quad", "rectus femoris", "vastus") { return [(.quadriceps, both)] }
        if has("adductor") { return [(.adductors, both)] }
        if has("oblique") { return [(.obliques, both)] }
        if has("abdomin", "abs", "core") { return [(.abs, both)] }
        if has("brachioradialis", "forearm", "wrist", "grip") { return [(.forearm, both)] }
        if has("biceps", "brachialis") { return [(.biceps, both)] }
        if has("triceps") { return [(.triceps, both)] }
        // Tibialis posterior and the fibularis (peroneal) muscles lie behind
        // and beside the shin bone, so they light the calves, not the front
        // of the shin.
        if has("gastrocnemius", "soleus", "calf", "calves", "tibialis posterior", "fibularis", "peroneus") {
            return [(.calves, both)]
        }
        if has("tibialis", "shin") { return [(.tibialis, both)] }
        if has("neck", "sternocleidomastoid") { return [(.neck, both)] }
        return []
    }
}

// MARK: - Figure

/// One view of the body with any regions filled. Unlisted regions draw idle.
struct BodyMapCanvas: View {
    var side: BodySide
    var fills: [BodyRegion: Color]
    var lineWidth: CGFloat = 0.75

    var body: some View {
        Canvas { ctx, size in
            let box = BodyMapPaths.contentBox
            let scale = min(size.width / box.width, size.height / box.height)
            ctx.translateBy(x: (size.width - box.width * scale) / 2 - box.minX * scale,
                            y: (size.height - box.height * scale) / 2 - box.minY * scale)
            ctx.scaleBy(x: scale, y: scale)

            for (region, path) in BodyMapShapes.regions(side) {
                ctx.fill(path, with: .color(fills[region] ?? Self.idle(region)))
            }
            ctx.stroke(BodyMapShapes.outline(side),
                       with: .color(DS.silver.opacity(0.2)),
                       lineWidth: lineWidth / scale)
        }
    }

    static func idle(_ region: BodyRegion) -> Color {
        DS.silver.opacity(region.isMuscle ? 0.13 : 0.06)
    }
}

/// One view of the body, with the given muscles lit by rank.
struct BodyMapFigure: View {
    var side: BodySide
    var muscles: [MuscleActivation]

    var body: some View {
        let lit = litRegions
        BodyMapCanvas(side: side, fills: lit.mapValues { $0.rank.barColor })
            .accessibilityElement()
            .accessibilityLabel(accessibilityText(lit))
    }

    /// The strongest muscle landing on each region of this view: primary over
    /// secondary, then the larger share.
    private var litRegions: [BodyRegion: MuscleActivation] {
        var lit: [BodyRegion: MuscleActivation] = [:]
        for muscle in muscles {
            for (region, sides) in BodyRegion.regions(forMuscle: muscle.name) where sides.contains(side) {
                if let current = lit[region], Self.outranks(current, muscle) { continue }
                lit[region] = muscle
            }
        }
        return lit
    }

    private static func outranks(_ a: MuscleActivation, _ b: MuscleActivation) -> Bool {
        if a.rank != b.rank { return a.rank == .primary }
        return a.fraction >= b.fraction
    }

    private func accessibilityText(_ lit: [BodyRegion: MuscleActivation]) -> String {
        let names = muscles.filter { m in lit.values.contains { $0.id == m.id } }
            .map { "\($0.name), \($0.rank.rawValue.lowercased())" }
        let view = side == .front ? "Front of body" : "Back of body"
        return names.isEmpty ? view : "\(view): " + names.joined(separator: "; ")
    }
}

// MARK: - Parsed shapes

/// `BodyMapPaths` parsed once, on first use.
private enum BodyMapShapes {
    private static let front: [(BodyRegion, Path)] = BodyMapPaths.front.flatMap { region, ds in ds.map { (region, parse($0)) } }
    private static let back: [(BodyRegion, Path)] = BodyMapPaths.back.flatMap { region, ds in ds.map { (region, parse($0)) } }
    private static let frontOutline = parse(BodyMapPaths.frontOutline)
    private static let backOutline = parse(BodyMapPaths.backOutline)

    static func regions(_ side: BodySide) -> [(BodyRegion, Path)] {
        side == .front ? front : back
    }

    static func outline(_ side: BodySide) -> Path {
        side == .front ? frontOutline : backOutline
    }

    /// Reads the generator's canonical form: absolute `M x y`, `L x y`,
    /// `C x1 y1 x2 y2 x y` and `Z`, numbers separated by single spaces.
    private static func parse(_ d: String) -> Path {
        var path = Path()
        var command: Character = " "
        var args: [CGFloat] = []
        var number = ""

        func endNumber() {
            if let value = Double(number) { args.append(CGFloat(value)) }
            number = ""
        }
        func emit() {
            endNumber()
            let p = { (i: Int) in CGPoint(x: args[i], y: args[i + 1]) }
            switch command {
            case "M" where args.count == 2: path.move(to: p(0))
            case "L" where args.count == 2: path.addLine(to: p(0))
            case "C" where args.count == 6: path.addCurve(to: p(4), control1: p(0), control2: p(2))
            case "Z": path.closeSubpath()
            default: break
            }
            args.removeAll(keepingCapacity: true)
        }

        for ch in d {
            if ch.isLetter {
                emit()
                command = ch
            } else if ch == " " {
                endNumber()
            } else {
                number.append(ch)
            }
        }
        emit()
        return path
    }
}

// MARK: - Training muscle groups on the map

extension MuscleGroup {
    /// Where the group is drawn. Regions missing from a view simply don't draw
    /// there (e.g. the lats only exist on the back view).
    var bodyRegions: [BodyRegion] {
        switch self {
        case .chest: return [.chest]
        case .back: return [.upperBack, .lowerBack, .trapezius]
        case .shoulders: return [.deltoids]
        case .biceps: return [.biceps]
        case .triceps: return [.triceps]
        case .forearms: return [.forearm]
        case .abs: return [.abs, .obliques]
        case .glutes: return [.gluteal]
        case .quads: return [.quadriceps]
        case .hamstrings: return [.hamstring]
        case .calves: return [.calves]
        case .adductors: return [.adductors]
        }
    }

    /// The view the group is most visible from, for small single-figure art.
    var preferredSide: BodySide {
        switch self {
        case .back, .triceps, .glutes, .hamstrings, .calves: return .back
        default: return .front
        }
    }
}
