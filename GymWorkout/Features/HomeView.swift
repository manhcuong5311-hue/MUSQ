//
//  HomeView.swift
//  GymWorkout
//
//  Screen 1a — Home.
//

import SwiftUI

struct HomeView: View {
    @Binding var tab: AppTab
    @Binding var libraryFilter: MuscleGroupName
    @State private var path: [Exercise] = []

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 9), count: 3)

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                DS.ink.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        header
                        continueTraining.padding(.top, 24)
                        muscleGroups.padding(.top, 26)
                        popular.padding(.top, 26)
                        recentlyViewed.padding(.top, 26)
                    }
                    .padding(.top, 22)
                    .padding(.bottom, 6)
                }
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                TabBarView(selection: $tab)
            }
            .navigationDestination(for: Exercise.self) { exercise in
                Exercise3DView(exercise: exercise)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .tint(DS.silver)
    }

    // MARK: - Header

    private var header: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 0) {
                Text(Self.dateLine)
                    .font(.mono(12, .medium))
                    .trackingEm(0.08, size: 12)
                    .foregroundStyle(DS.silver.opacity(0.42))
                Text("Good morning, \(SampleData.userName)")
                    .font(.ui(26, .semibold))
                    .tracking(-0.6)
                    .cssLineHeight(26, 1.15)
                    .foregroundStyle(DS.silver)
                    .padding(.top, 6)
            }

            Spacer(minLength: 12)

            Text(String(SampleData.userName.prefix(1)))
                .font(.ui(14, .semibold))
                .foregroundStyle(DS.silver)
                .frame(width: 40, height: 40)
                .background(Circle().fill(DS.surfaceRaised))
                .overlay(Circle().strokeBorder(DS.silver.opacity(0.1), lineWidth: 1))
        }
        .padding(.horizontal, DS.Metric.gutter)
    }

    private static var dateLine: String {
        let f = DateFormatter()
        f.dateFormat = "EEEE · d MMM"
        return f.string(from: Date()).uppercased()
    }

    // MARK: - Continue training

    private var continueTraining: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionEyebrow(text: "CONTINUE TRAINING")

            Button {
                path.append(SampleData.benchPress)
            } label: {
                Viewport(
                    slot: "home-continue",
                    inner: DS.viewportInner,
                    outer: DS.viewportOuter,
                    rx: 1.20, ry: 0.80, cx: 0.5, cy: 0.80,
                    glows: [.init(DS.activation.opacity(0.42), rx: 0.30, ry: 0.22, cx: 0.44, cy: 0.46)],
                    cornerRadius: 22
                ) {
                    LinearGradient(
                        stops: [
                            .init(color: .clear, location: 0.40),
                            .init(color: DS.cardFade(0.88), location: 1)
                        ],
                        startPoint: .top, endPoint: .bottom
                    )
                    .allowsHitTesting(false)
                }
                .frame(height: 206)
                .overlay(alignment: .bottom) { continueCardFooter }
            }
            .buttonStyle(.plain)
            .padding(.top, 12)
        }
        .padding(.horizontal, DS.Metric.gutter)
    }

    private var continueCardFooter: some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack(alignment: .leading) {
                Capsule().fill(DS.silver.opacity(0.22))
                GeometryReader { geo in
                    Capsule()
                        .fill(DS.silver)
                        .frame(width: geo.size.width * 0.62)
                }
            }
            .frame(height: 2)
            .padding(.trailing, 60)

            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 0) {
                    MetaLine(text: "PHASE 3 OF 4 · CHEST", em: 0.09, color: DS.silver.opacity(0.6))
                    Text(SampleData.benchPress.name)
                        .font(.ui(19, .semibold))
                        .tracking(-0.3)
                        .foregroundStyle(DS.silver)
                        .padding(.top, 5)
                }
                Spacer(minLength: 8)
                Image(systemName: "play.fill")
                    .font(.system(size: 15))
                    .foregroundStyle(DS.ink)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(DS.silver))
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 14)
        .allowsHitTesting(false)
    }

    // MARK: - Muscle groups

    private var muscleGroups: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionEyebrow(text: "MUSCLE GROUPS")

            LazyVGrid(columns: columns, spacing: 9) {
                ForEach(SampleData.muscleGroups) { group in
                    Button {
                        libraryFilter = MuscleGroupName(rawValue: group.name) ?? .all
                        tab = .exercises
                    } label: {
                        VStack(alignment: .leading, spacing: 0) {
                            RoundedRectangle(cornerRadius: 7, style: .continuous)
                                .fill(DS.activation.opacity(0.14))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 7, style: .continuous)
                                        .strokeBorder(DS.activation.opacity(0.3), lineWidth: 1)
                                )
                                .frame(width: 22, height: 22)
                                .frame(height: 26, alignment: .center)

                            Text(group.name)
                                .font(.ui(13, .semibold))
                                .foregroundStyle(DS.silver)
                                .padding(.top, 8)

                            Text(group.count)
                                .font(.mono(9, .medium))
                                .foregroundStyle(DS.silver.opacity(0.35))
                                .padding(.top, 3)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 11)
                        .padding(.top, 11)
                        .padding(.bottom, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(DS.surfaceAlt)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .strokeBorder(DS.silver.opacity(0.07), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.top, 12)
        }
        .padding(.horizontal, DS.Metric.gutter)
    }

    // MARK: - Popular

    private var popular: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .firstTextBaseline) {
                SectionEyebrow(text: "POPULAR EXERCISES")
                Spacer()
                Text("All")
                    .font(.ui(12, .semibold))
                    .foregroundStyle(DS.silver)
            }
            .padding(.horizontal, DS.Metric.gutter)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 10) {
                    ForEach(Array(SampleData.popular.enumerated()), id: \.offset) { index, item in
                        VStack(alignment: .leading, spacing: 0) {
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(DS.surfaceDim)
                                .frame(height: 104)
                                .overlay(
                                    RenderSlot(id: "home-pop\(index + 1)")
                                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                )

                            Text(item.name)
                                .font(.ui(13, .semibold))
                                .foregroundStyle(DS.silver)
                                .padding(.top, 8)

                            Text(item.meta)
                                .font(.mono(9, .medium))
                                .foregroundStyle(DS.silver.opacity(0.35))
                                .padding(.top, 2)
                        }
                        .frame(width: 152)
                    }

                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(
                            DS.silver.opacity(0.12),
                            style: StrokeStyle(lineWidth: 1, dash: [4, 4])
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(DS.surfaceAlt)
                        )
                        .frame(width: 60, height: 104)
                }
                .padding(.horizontal, DS.Metric.gutter)
            }
            .padding(.top, 12)
        }
    }

    // MARK: - Recently viewed

    private var recentlyViewed: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionEyebrow(text: "RECENTLY VIEWED")

            VStack(spacing: 0) {
                ForEach(Array(SampleData.recentlyViewed.enumerated()), id: \.element.id) { index, item in
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 11, style: .continuous)
                            .fill(DS.surfaceDim)
                            .frame(width: 44, height: 44)
                            .overlay(
                                RenderSlot(id: "home-rec\(index + 1)")
                                    .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                            )

                        VStack(alignment: .leading, spacing: 0) {
                            Text(item.name)
                                .font(.ui(14, .semibold))
                                .foregroundStyle(DS.silver)
                            MetaLine(text: item.meta, size: 9, em: 0, color: DS.silver.opacity(0.35))
                                .padding(.top, 3)
                        }

                        Spacer(minLength: 8)

                        Image(systemName: "chevron.right")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(DS.silver.opacity(0.3))
                    }
                    .padding(.vertical, 11)
                    .overlay(alignment: .bottom) {
                        if index < SampleData.recentlyViewed.count - 1 {
                            Hairline(opacity: 0.07)
                        }
                    }
                }
            }
            .padding(.top, 10)
        }
        .padding(.horizontal, DS.Metric.gutter)
    }
}
