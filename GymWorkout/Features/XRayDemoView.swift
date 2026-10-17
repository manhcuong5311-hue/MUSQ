//
//  XRayDemoView.swift
//  GymWorkout
//
//  Full-screen x-ray demo a technique cue opens (2026-10-17): the model in
//  see-through muscle with the shoulder blades drawn inside, with the angle,
//  the moment of the clip and the playback speed under the viewer's control.
//  Always dark: the model is lit for a dark ground, and the demo reads the
//  same in Light Mode.
//

import SwiftUI

struct XRayDemoView: View {
    let demo: XRayDemo
    /// Shown in the meta line, e.g. `BARBELL BENCH PRESS`.
    var exerciseName: String

    @Environment(\.dismiss) private var dismiss
    @Environment(\.dsLayout) private var layout
    @State private var stage: XRayStage

    init(demo: XRayDemo, exerciseName: String) {
        self.demo = demo
        self.exerciseName = exerciseName
        _stage = State(initialValue: XRayStage(demo: demo))
    }

    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.horizontal, 16)
                .padding(.top, 8)

            ZStack(alignment: .top) {
                XRayViewport(stage: stage)
                caption
                    .padding(.top, 10)
                    .allowsHitTesting(false)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            controls
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
                .frame(maxWidth: layout.isRegular ? 620 : .infinity)
        }
        .background(
            RadialGradient(colors: [Color(white: 0.17), Color(white: 0.06)],
                           center: .center, startRadius: 40, endRadius: 520)
                .ignoresSafeArea()
        )
        .environment(\.colorScheme, .dark)
    }

    // MARK: Header

    private var header: some View {
        HStack(spacing: 12) {
            CircleIconButton(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(DS.silver)
            }
            .accessibilityLabel("Close")
            .keyboardShortcut(.cancelAction)

            VStack(alignment: .leading, spacing: 2) {
                Text(demo.title)
                    .font(.ui(16, .semibold))
                    .tracking(-0.25)
                    .foregroundStyle(DS.silver)
                    .lineLimit(1)
                MetaLine(text: "\(exerciseName.uppercased()) · X-RAY")
                    .lineLimit(1)
            }
            Spacer(minLength: 0)
        }
    }

    /// What the clip is showing right now.
    private var caption: some View {
        let phase = demo.phase(at: stage.time)
        return Text(phase?.caption ?? demo.summary)
            .font(.ui(13, .semibold))
            .foregroundStyle(DS.silver)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Capsule().fill(Color.black.opacity(0.45)))
            .overlay(Capsule().strokeBorder(DS.silver.opacity(0.10), lineWidth: 1))
            .padding(.horizontal, 24)
            .animation(.easeOut(duration: 0.2), value: phase?.chip)
    }

    // MARK: Controls

    private var controls: some View {
        VStack(alignment: .leading, spacing: 12) {
            legend

            SectionEyebrow(text: "ANGLE", size: 9.5)
            MonoSegmentedControl(
                options: XRayView.allCases.map { ($0, $0.title) },
                selection: Binding(get: { stage.view }, set: { stage.pick($0) }),
                fillsWidth: true
            )

            SectionEyebrow(text: "MOMENT", size: 9.5)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 7) {
                    ForEach(demo.phases, id: \.chip) { phase in
                        FilterChip(title: phase.chip, selected: demo.phase(at: stage.time)?.chip == phase.chip) {
                            stage.seek(to: phase.jump)
                        }
                    }
                }
            }

            HStack(spacing: 10) {
                CircleIconButton(action: stage.togglePause) {
                    Image(systemName: stage.paused ? "play.fill" : "pause.fill")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(DS.silver)
                }
                .accessibilityLabel(stage.paused ? "Play" : "Pause")

                scrubber

                MonoSegmentedControl(
                    options: [(Float(0.25), "0.25×"), (Float(0.5), "0.5×"), (Float(1), "1×")],
                    selection: Binding(get: { stage.speed }, set: { stage.speed = $0 })
                )
                .accessibilityLabel("Playback speed")
            }

            Text("Drag to turn · pinch to zoom · double-tap to reset")
                .font(.ui(11))
                .foregroundStyle(DS.silver.opacity(0.4))
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }

    /// The clip's progress; tap or drag along it to jump.
    private var scrubber: some View {
        GeometryReader { geo in
            let fraction = CGFloat(stage.time / demo.duration)
            ZStack(alignment: .leading) {
                Capsule().fill(DS.silver.opacity(0.12)).frame(height: 4)
                Capsule().fill(DS.silver.opacity(0.75)).frame(width: max(4, geo.size.width * fraction), height: 4)
                ForEach(demo.phases.dropFirst(), id: \.chip) { phase in
                    Rectangle().fill(DS.silver.opacity(0.35))
                        .frame(width: 1, height: 10)
                        .offset(x: geo.size.width * CGFloat(phase.start / demo.duration))
                }
            }
            .frame(maxHeight: .infinity)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let f = min(max(value.location.x / max(geo.size.width, 1), 0), 1)
                        stage.seek(to: TimeInterval(f) * demo.duration)
                    }
            )
        }
        .frame(height: 34)
        .accessibilityElement()
        .accessibilityLabel("Clip position")
        .accessibilityValue("\(Int(stage.time)) of \(Int(demo.duration)) seconds")
    }

    private var legend: some View {
        HStack(spacing: 14) {
            swatch(Color(red: 0.93, green: 0.86, blue: 0.72), demo.boneLabel)
            swatch(DS.activation, demo.muscleLabel)
        }
    }

    private func swatch(_ color: Color, _ label: String) -> some View {
        HStack(spacing: 6) {
            Circle().fill(color).frame(width: 9, height: 9)
            Text(label)
                .font(.ui(11.5))
                .foregroundStyle(DS.silver.opacity(0.7))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
    }
}
