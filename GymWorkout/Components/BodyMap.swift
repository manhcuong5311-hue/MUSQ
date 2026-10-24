//
//  BodyMap.swift
//  GymWorkout
//
//  The flat front/back muscle map in the Muscles Worked panel. Regions are
//  drawn from `BodyMapPaths` (generated) and lit from the exercise's own
//  activation data, so the map always agrees with the bars beside it. The
//  chest's three bands follow the exercise model's paint (`ChestPaint`),
//  which the chest rows name head by head.
//

import SwiftUI

// MARK: - Regions

enum BodySide: CaseIterable {
    case front, back

    var title: String { self == .front ? "FRONT" : "BACK" }
}

/// One drawable region of the map. Cases match the source data's slugs,
/// except the chest: the source draws each pec whole (`chest`), and the map
/// cuts it into the pectoralis major's three heads, the way the exercise
/// models paint them (2026-10-22).
enum BodyRegion {
    case chest, upperChest, midChest, lowerChest
    case obliques, abs, biceps, triceps, neck, trapezius, deltoids
    case adductors, quadriceps, tibialis, calves, forearm
    case upperBack, lowerBack, gluteal, hamstring
    // Not muscles: always drawn neutral.
    case knees, hands, ankles, feet, head, hair

    /// The chest's bands, top to bottom.
    static let chestHeads: [BodyRegion] = [.upperChest, .midChest, .lowerChest]

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
        if has("pector", "chest") {
            if has("upper", "clavicular") { return [(.upperChest, both)] }
            if has("middle", "sternal", "sternocostal") { return [(.midChest, both)] }
            if has("lower", "abdominal") { return [(.lowerChest, both)] }
            return chestHeads.map { ($0, both) }
        }
        if has("deltoid", "delt") {
            if has("anterior", "front") { return [(.deltoids, [.front])] }
            if has("posterior", "rear") { return [(.deltoids, [.back])] }
            return [(.deltoids, both)]
        }
        if has("trapez", "traps") {
            if has("middle", "lower") { return [(.trapezius, [.back])] }
            return [(.trapezius, both)]
        }
        // The rotator cuff (a row on the re-painted rows and pulls, 2026-10-23)
        // lies on the shoulder blade, so it lights the upper back as the
        // infraspinatus always has.
        if has("latissimus", "lats", "rhomboid", "teres", "infraspinatus", "rotator cuff", "supraspinatus", "upper back") {
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

    /// Width over height of one figure, for framing a canvas without
    /// letterboxing it.
    static let aspect: CGFloat = 650.0 / 1265.0

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
    /// How the exercise's own model paints the chest's three heads. When the
    /// list has the chest, its bands follow the model (bright head primary,
    /// dim heads secondary, unlit heads idle) rather than the row names.
    var chest: ChestPaint.Heads? = nil
    var lineWidth: CGFloat = 0.75

    var body: some View {
        let lit = litRegions
        BodyMapCanvas(side: side, fills: fills(lit), lineWidth: lineWidth)
            .accessibilityElement()
            .accessibilityLabel(accessibilityText(lit))
    }

    private func fills(_ lit: [BodyRegion: MuscleActivation]) -> [BodyRegion: Color] {
        var fills = lit.mapValues { $0.rank.barColor }
        if let chest, BodyRegion.chestHeads.contains(where: { lit[$0] != nil }) {
            for (region, rank) in zip(BodyRegion.chestHeads, [chest.upper, chest.middle, chest.lower]) {
                fills[region] = rank?.barColor
            }
        }
        return fills
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

// MARK: - Pair

/// Front and back side by side at one height — the iPad heroes, where there
/// is room for both views at once instead of a FRONT/BACK toggle.
struct BodyMapPair: View {
    enum Source {
        /// Region colours per view, as `BodyMapCanvas` takes them.
        case fills(front: [BodyRegion: Color], back: [BodyRegion: Color])
        /// Muscles lit by rank, as `BodyMapFigure` draws them, with the
        /// model's chest paint when known.
        case muscles([MuscleActivation], chest: ChestPaint.Heads? = nil)
    }

    var source: Source
    var figureHeight: CGFloat
    var showsCaptions: Bool = true
    /// Outline width in points; nil picks 1.0 for a tall figure, else the
    /// canvas's own 0.75.
    var lineWidth: CGFloat? = nil

    init(source: Source, figureHeight: CGFloat, showsCaptions: Bool = true, lineWidth: CGFloat? = nil) {
        self.source = source
        self.figureHeight = figureHeight
        self.showsCaptions = showsCaptions
        self.lineWidth = lineWidth
    }

    var body: some View {
        HStack(alignment: .top, spacing: figureHeight * 0.10) {
            ForEach(BodySide.allCases, id: \.self) { side in
                VStack(spacing: 8) {
                    figure(side)
                        .frame(width: figureHeight * BodyMapCanvas.aspect, height: figureHeight)
                    if showsCaptions {
                        Text(side.title)
                            .font(.mono(9.5, .semibold))
                            .trackingEm(0.10, size: 9.5)
                            .foregroundStyle(DS.silver.opacity(0.4))
                            .accessibilityHidden(true)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func figure(_ side: BodySide) -> some View {
        let width = lineWidth ?? (figureHeight > 450 ? 1.0 : 0.75)
        switch source {
        case .fills(let front, let back):
            BodyMapCanvas(side: side, fills: side == .front ? front : back, lineWidth: width)
                .accessibilityElement()
                .accessibilityLabel(side == .front ? "Front of body" : "Back of body")
        case .muscles(let muscles, let chest):
            BodyMapFigure(side: side, muscles: muscles, chest: chest, lineWidth: width)
        }
    }
}

// MARK: - Parsed shapes

/// `BodyMapPaths` parsed once, on first use.
private enum BodyMapShapes {
    private static let front: [(BodyRegion, Path)] = BodyMapPaths.front.flatMap { region, ds in
        ds.flatMap { d -> [(BodyRegion, Path)] in
            let path = parse(d)
            guard region == .chest else { return [(region, path)] }
            return zip(BodyRegion.chestHeads, chestBands).map { ($0, path.intersection($1)) }
        }
    }
    private static let back: [(BodyRegion, Path)] = BodyMapPaths.back.flatMap { region, ds in ds.map { (region, parse($0)) } }
    private static let frontOutline = parse(BodyMapPaths.frontOutline)
    private static let backOutline = parse(BodyMapPaths.backOutline)

    static func regions(_ side: BodySide) -> [(BodyRegion, Path)] {
        side == .front ? front : back
    }

    static func outline(_ side: BodySide) -> Path {
        side == .front ? frontOutline : backOutline
    }

    /// The pecs (x 251-476, y 316-438 in the 724 x 1448 box) cut into the
    /// clavicular, sternal and abdominal heads: the upper cut at y 352 by the
    /// sternum, the lower at y 401, both dropping 10 units out to each
    /// armpit, as the heads' borders slope down and out.
    private static let chestBands: [Path] = {
        let mid: CGFloat = 363.5, left: CGFloat = 200, right: CGFloat = 530
        func cut(_ y: CGFloat, _ x: CGFloat) -> CGPoint { CGPoint(x: x, y: y + 10 * abs(x - mid) / 110) }
        func band(_ top: [CGPoint], _ bottom: [CGPoint]) -> Path {
            var p = Path()
            p.addLines(top + bottom.reversed())
            p.closeSubpath()
            return p
        }
        let upper = [left, mid, right].map { cut(352, $0) }
        let lower = [left, mid, right].map { cut(401, $0) }
        return [
            band([CGPoint(x: left, y: 250), CGPoint(x: right, y: 250)], upper),
            band(upper, lower),
            band(lower, [CGPoint(x: left, y: 520), CGPoint(x: right, y: 520)]),
        ]
    }()

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
        case .chest: return BodyRegion.chestHeads
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
