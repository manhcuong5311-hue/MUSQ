//
//  OnboardingComponents.swift
//  GymWorkout
//
//  The pieces onboarding's pages are made of: the column the content sits
//  in, a question page, answer cards, wheels, and the result pages' cards,
//  stats and formula boxes.
//

import SwiftUI

// MARK: - Layout

/// Where onboarding's content sits across the width: the phone's gutter; one
/// centred 600pt column in regular; a 540pt column in the wide form pane,
/// 56pt clear of the stage and the edge.
struct OnboardingColumn: ViewModifier {
    var compactPadding: CGFloat

    @Environment(\.dsLayout) private var layout

    func body(content: Content) -> some View {
        switch layout.tier {
        case .compact:
            content
                .padding(.horizontal, compactPadding)
        case .regular:
            content
                .frame(maxWidth: 600, alignment: .leading)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, layout.gutter)
        case .wide:
            content
                .frame(maxWidth: 540, alignment: .leading)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 56)
        }
    }
}

/// Return confirms the step on an iPad's hardware keyboard.
struct OnboardingReturnKey: ViewModifier {
    func body(content: Content) -> some View {
        if DS.isPad {
            content.keyboardShortcut(.defaultAction)
        } else {
            content
        }
    }
}

// MARK: - Pages

/// A question: its eyebrow, title and why it's asked, then the answers.
struct OnboardingQuestionPage<Content: View>: View {
    var eyebrow: String
    var title: String
    var caption: String
    @ViewBuilder var content: () -> Content

    @Environment(\.dsLayout) private var layout

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                OnboardingHeading(eyebrow: eyebrow, title: title, caption: caption)
                VStack(spacing: layout.value(10, 12)) {
                    content()
                }
                .padding(.top, layout.value(22, 28))
            }
            .modifier(OnboardingColumn(compactPadding: DS.Metric.gutter))
            .padding(.top, layout.value(16, 24))
            .padding(.bottom, 16)
        }
    }
}

/// Eyebrow, title and caption.
struct OnboardingHeading: View {
    var eyebrow: String
    var title: String
    var caption: String? = nil

    @Environment(\.dsLayout) private var layout

    var body: some View {
        let captionSize: CGFloat = layout.value(14, 16)
        VStack(alignment: .leading, spacing: 0) {
            SectionEyebrow(text: eyebrow)
            Text(title)
                .font(.ui(layout.pt(26, 32, wide: 34), .semibold))
                .tracking(layout.value(-0.6, -0.85))
                .foregroundStyle(DS.silver)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, layout.value(8, 10))
            if let caption {
                Text(caption)
                    .font(.ui(captionSize))
                    .cssLineHeight(captionSize, layout.value(1.45, 1.5))
                    .foregroundStyle(DS.silver.opacity(0.55))
                    .fixedSize(horizontal: false, vertical: true)
                    // A reading measure under the title; nil on iPhone.
                    .frame(maxWidth: layout.isRegular ? 480 : nil, alignment: .leading)
                    .padding(.top, layout.value(8, 12))
            }
        }
    }
}

/// A result page: heading, then cards, scrolling.
struct OnboardingResultPage<Content: View>: View {
    var eyebrow: String
    var title: String
    var caption: String? = nil
    @ViewBuilder var content: () -> Content

    @Environment(\.dsLayout) private var layout

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                OnboardingHeading(eyebrow: eyebrow, title: title, caption: caption)
                VStack(alignment: .leading, spacing: layout.value(10, 12)) {
                    content()
                }
                .padding(.top, layout.value(20, 26))
            }
            .modifier(OnboardingColumn(compactPadding: DS.Metric.gutter))
            .padding(.top, layout.value(16, 24))
            .padding(.bottom, 16)
        }
    }
}

// MARK: - Answers

/// One answer: icon, title and what choosing it does. A multi-choice answer
/// shows a square box instead of a round one.
struct OptionCard: View {
    var symbol: String?
    var title: String
    var detail: String?
    /// A short tag beside the title, e.g. "BEST FIT".
    var badge: String? = nil
    var isSelected: Bool
    var multi = false
    var action: () -> Void

    @Environment(\.dsLayout) private var layout

    var body: some View {
        let well: CGFloat = layout.value(44, 52)
        let radius: CGFloat = layout.value(18, 20)
        let detailSize: CGFloat = layout.value(12.5, 13.5)
        let badgeSize: CGFloat = layout.value(8.5, 9.5)
        Button(action: action) {
            HStack(spacing: layout.value(14, 16)) {
                if let symbol {
                    Image(systemName: symbol)
                        .font(.system(size: layout.value(18, 21), weight: .medium))
                        .foregroundStyle(isSelected ? DS.ink : DS.silver)
                        .frame(width: well, height: well)
                        .background(
                            RoundedRectangle(cornerRadius: layout.value(12, 14), style: .continuous)
                                .fill(isSelected ? DS.silver : DS.silver.opacity(0.07))
                        )
                }
                VStack(alignment: .leading, spacing: layout.value(3, 4)) {
                    HStack(spacing: 7) {
                        Text(title)
                            .font(.ui(layout.value(15.5, 17), .semibold))
                            .foregroundStyle(DS.silver)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        if let badge {
                            Text(badge)
                                .font(.mono(badgeSize, .semibold))
                                .trackingEm(0.08, size: badgeSize)
                                .foregroundStyle(DS.silver.opacity(0.75))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .background(Capsule().fill(DS.silver.opacity(0.08)))
                                .fixedSize()
                        }
                    }
                    if let detail {
                        Text(detail)
                            .font(.ui(detailSize))
                            .cssLineHeight(detailSize, 1.4)
                            .foregroundStyle(DS.silver.opacity(0.55))
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.leading)
                    }
                }
                Spacer(minLength: 4)
                Image(systemName: multi ? (isSelected ? "checkmark.square.fill" : "square")
                                        : (isSelected ? "checkmark.circle.fill" : "circle"))
                    .font(.system(size: layout.value(20, 22)))
                    .foregroundStyle(DS.silver.opacity(isSelected ? 1 : 0.25))
            }
            .padding(layout.value(14, 16))
            .background(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .fill(DS.surfaceAlt)
            )
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .strokeBorder(DS.silver.opacity(isSelected ? 0.9 : 0.08), lineWidth: isSelected ? 1.5 : 1)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .dsHover(.highlight, radius: radius)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

/// A row of small answers under a label, for short follow-ups ("Yes" /
/// "Not yet").
struct ChoiceRow<Value: Hashable>: View {
    var label: String
    var options: [(value: Value, title: String)]
    @Binding var selection: Value?

    @Environment(\.dsLayout) private var layout

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionEyebrow(text: label, size: layout.value(9.5, 10.5))
            FlowLayout(spacing: 8) {
                ForEach(Array(options.enumerated()), id: \.offset) { _, option in
                    let isSelected = selection == option.value
                    Button {
                        withAnimation(.easeOut(duration: 0.15)) { selection = option.value }
                    } label: {
                        Text(option.title)
                            .font(.ui(layout.value(13.5, 15), .semibold))
                            .foregroundStyle(isSelected ? DS.ink : DS.silver)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(Capsule().fill(isSelected ? DS.silver : DS.surfaceAlt))
                            .overlay(Capsule().strokeBorder(DS.silver.opacity(isSelected ? 0 : 0.08), lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(isSelected ? .isSelected : [])
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// Lays its children out in rows, wrapping when a row is full.
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = arrange(subviews, width: proposal.width ?? .infinity)
        let height = rows.reduce(0) { $0 + $1.height } + spacing * CGFloat(max(rows.count - 1, 0))
        let width = rows.map(\.width).max() ?? 0
        return CGSize(width: proposal.width ?? width, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var y = bounds.minY
        for row in arrange(subviews, width: bounds.width) {
            var x = bounds.minX
            for index in row.indices {
                let size = subviews[index].sizeThatFits(.unspecified)
                subviews[index].place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
                x += size.width + spacing
            }
            y += row.height + spacing
        }
    }

    private func arrange(_ subviews: Subviews, width: CGFloat) -> [(indices: [Int], width: CGFloat, height: CGFloat)] {
        var rows: [(indices: [Int], width: CGFloat, height: CGFloat)] = []
        var current: [Int] = []
        var x: CGFloat = 0
        var height: CGFloat = 0
        for index in subviews.indices {
            let size = subviews[index].sizeThatFits(.unspecified)
            if !current.isEmpty && x + spacing + size.width > width {
                rows.append((current, x, height))
                current = []
                x = 0
                height = 0
            }
            x += (current.isEmpty ? 0 : spacing) + size.width
            height = max(height, size.height)
            current.append(index)
        }
        if !current.isEmpty { rows.append((current, x, height)) }
        return rows
    }
}

/// A wheel picker under a small label, on a card.
struct WheelBox<Content: View>: View {
    var label: String
    @ViewBuilder var content: () -> Content

    @Environment(\.dsLayout) private var layout

    var body: some View {
        VStack(spacing: 4) {
            SectionEyebrow(text: label, size: layout.value(9.5, 10.5))
            content()
                .pickerStyle(.wheel)
                .frame(height: layout.value(170, 200))
                .clipped()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, layout.value(12, 14))
        .background(RoundedRectangle(cornerRadius: layout.value(16, 18), style: .continuous).fill(DS.surfaceAlt))
    }
}

// MARK: - Results

/// One card of a result page, with optional content below its text.
struct ResultCard<Extra: View>: View {
    var symbol: String?
    var title: String
    var detail: String?
    @ViewBuilder var extra: () -> Extra

    @Environment(\.dsLayout) private var layout

    init(symbol: String? = nil, title: String, detail: String? = nil,
         @ViewBuilder extra: @escaping () -> Extra = { EmptyView() }) {
        self.symbol = symbol
        self.title = title
        self.detail = detail
        self.extra = extra
    }

    var body: some View {
        let detailSize: CGFloat = layout.value(12.5, 13.5)
        HStack(alignment: .top, spacing: layout.value(14, 16)) {
            if let symbol {
                Image(systemName: symbol)
                    .font(.system(size: layout.value(15, 18), weight: .medium))
                    .foregroundStyle(DS.silver)
                    .frame(width: layout.value(36, 44), height: layout.value(36, 44))
                    .background(RoundedRectangle(cornerRadius: layout.value(10, 12), style: .continuous)
                        .fill(DS.silver.opacity(0.07)))
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.ui(layout.value(15, 17), .semibold))
                    .foregroundStyle(DS.silver)
                    .fixedSize(horizontal: false, vertical: true)
                if let detail {
                    Text(detail)
                        .font(.ui(detailSize))
                        .cssLineHeight(detailSize, 1.4)
                        .foregroundStyle(DS.silver.opacity(0.55))
                        .fixedSize(horizontal: false, vertical: true)
                }
                extra()
            }
            Spacer(minLength: 0)
        }
        .padding(layout.value(14, 18))
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: layout.value(18, 20), style: .continuous).fill(DS.surfaceAlt))
        .accessibilityElement(children: .combine)
    }
}

/// A big number with its unit and a label: "2,050 kcal / a day".
struct ResultStat: View {
    var value: String
    var unit: String
    var label: String

    @Environment(\.dsLayout) private var layout

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .firstTextBaseline, spacing: 5) {
                Text(value)
                    .font(.ui(layout.pt(40, 48), .semibold))
                    .tracking(-1.2)
                    .foregroundStyle(DS.silver)
                    .monospacedDigit()
                Text(unit)
                    .font(.ui(layout.value(15, 17), .semibold))
                    .foregroundStyle(DS.silver.opacity(0.55))
            }
            Text(label)
                .font(.ui(layout.value(13, 14)))
                .foregroundStyle(DS.silver.opacity(0.55))
        }
        .accessibilityElement(children: .combine)
    }
}

/// "How it's calculated": each step with the user's own numbers, then the
/// sources.
struct FormulaCard: View {
    struct Line: Hashable {
        var label: String
        var math: String
    }

    var lines: [Line]
    var sources: String

    @Environment(\.dsLayout) private var layout

    var body: some View {
        let mathSize: CGFloat = layout.value(11.5, 12.5)
        VStack(alignment: .leading, spacing: 0) {
            SectionEyebrow(text: String(localized: "HOW IT'S CALCULATED",
                                        comment: "Eyebrow over the card that shows each formula with the user's own numbers"),
                           size: layout.value(9.5, 10.5))
            VStack(alignment: .leading, spacing: layout.value(10, 12)) {
                ForEach(lines, id: \.self) { line in
                    VStack(alignment: .leading, spacing: 3) {
                        Text(line.label)
                            .font(.ui(layout.value(12.5, 13.5), .semibold))
                            .foregroundStyle(DS.silver.opacity(0.85))
                        Text(line.math)
                            .font(.mono(mathSize, .medium))
                            .cssLineHeight(mathSize, 1.45)
                            .foregroundStyle(DS.silver.opacity(0.6))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(.top, 10)
            Text(sources)
                .font(.ui(layout.value(11, 12)))
                .italic()
                .foregroundStyle(DS.silver.opacity(0.4))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 12)
        }
        .padding(layout.value(14, 18))
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: layout.value(18, 20), style: .continuous)
                .strokeBorder(DS.silver.opacity(0.1), lineWidth: 1)
        )
    }
}

/// A heads-up that needs reading: see a doctor first, a goal set aside.
struct NoticeCard: View {
    var symbol: String = "exclamationmark.triangle"
    var title: String
    var lines: [String]

    @Environment(\.dsLayout) private var layout

    var body: some View {
        let size: CGFloat = layout.value(12.5, 13.5)
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: symbol)
                .font(.system(size: layout.value(15, 17), weight: .semibold))
                .foregroundStyle(DS.fault)
                .padding(.top, 1)
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.ui(layout.value(15, 16.5), .semibold))
                    .foregroundStyle(DS.silver)
                    .fixedSize(horizontal: false, vertical: true)
                ForEach(lines, id: \.self) { line in
                    Text(line)
                        .font(.ui(size))
                        .cssLineHeight(size, 1.4)
                        .foregroundStyle(DS.silver.opacity(0.65))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            Spacer(minLength: 0)
        }
        .padding(layout.value(14, 18))
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: layout.value(18, 20), style: .continuous)
                .fill(DS.fault.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: layout.value(18, 20), style: .continuous)
                .strokeBorder(DS.fault.opacity(0.35), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
    }
}
