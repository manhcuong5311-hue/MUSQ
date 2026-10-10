//
//  RestTimerBar.swift
//  GymWorkout
//
//  The running rest, floated over the bottom of whatever screen is open: the
//  time left, ±15 s, and Skip. Draws nothing when no rest is running. In
//  regular width it is a centred pill at most 480pt wide, so a rest on a
//  1000pt column doesn't become a toolbar.
//

import SwiftUI

struct RestTimerBar: View {
    @Environment(RestTimer.self) private var timer
    @Environment(\.dsLayout) private var layout

    var body: some View {
        VStack(spacing: 0) {
            if let endsAt = timer.endsAt {
                running(until: endsAt)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            } else if timer.finishedAt != nil {
                finished
                    .transition(.opacity)
            }
        }
        .animation(.easeOut(duration: 0.22), value: timer.endsAt == nil)
        .animation(.easeOut(duration: 0.22), value: timer.finishedAt == nil)
    }

    private func running(until endsAt: Date) -> some View {
        TimelineView(.periodic(from: .now, by: 0.5)) { context in
            let remaining = max(0, endsAt.timeIntervalSince(context.date))
            let seconds = Int(remaining.rounded(.up))
            card {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 2) {
                        SectionEyebrow(text: "REST", size: 9.5)
                        Text(String(format: "%d:%02d", seconds / 60, seconds % 60))
                            .font(.mono(layout.isRegular ? 26 : 22, .semibold))
                            .foregroundStyle(DS.silver)
                            .contentTransition(.numericText(countsDown: true))
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Rest, \(seconds) seconds left")

                    Spacer(minLength: 4)

                    adjustButton("−15", seconds: -15)
                    adjustButton("+15", seconds: 15)

                    Button("Skip") {
                        timer.skip()
                    }
                    .font(.ui(13, .semibold))
                    .foregroundStyle(DS.ink)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .frame(minHeight: layout.isRegular ? 40 : nil)
                    .background(Capsule().fill(DS.silver))
                    .buttonStyle(.plain)
                    .dsHover(.highlight)
                }
            } progress: {
                timer.duration > 0 ? remaining / timer.duration : 0
            }
        }
    }

    private var finished: some View {
        card {
            HStack(spacing: 8) {
                Image(systemName: "bell.fill")
                    .font(.system(size: 12, weight: .semibold))
                Text("Rest over — time for your next set")
                    .font(.ui(13.5, .semibold))
                Spacer(minLength: 0)
            }
            .foregroundStyle(DS.silver)
            .padding(.vertical, 8)
        } progress: { 0 }
        .onTapGesture { timer.skip() }
    }

    private func adjustButton(_ title: String, seconds: Int) -> some View {
        Button(title) {
            timer.add(seconds)
        }
        .font(.mono(12, .semibold))
        .foregroundStyle(DS.silver)
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .frame(minHeight: layout.isRegular ? 40 : nil)
        .background(Capsule().fill(DS.silver.opacity(0.08)))
        .buttonStyle(.plain)
        .dsHover(.highlight)
        .accessibilityLabel(seconds > 0 ? "Add 15 seconds" : "Remove 15 seconds")
    }

    /// The floating surface, with the time left drawn along its bottom edge.
    private func card<Content: View>(@ViewBuilder _ content: () -> Content,
                                     progress: () -> Double) -> some View {
        let fraction = min(max(progress(), 0), 1)
        let regular = layout.isRegular
        let radius: CGFloat = regular ? 22 : 18
        return content()
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .fill(DS.surfaceRaised)
            )
            .overlay(alignment: .bottomLeading) {
                GeometryReader { geo in
                    Capsule()
                        .fill(DS.silver.opacity(0.55))
                        .frame(width: geo.size.width * fraction, height: regular ? 3 : 2)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                }
                .padding(.horizontal, regular ? 22 : 18)
                .padding(.bottom, 1)
            }
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .strokeBorder(DS.silver.opacity(0.10), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.18), radius: 14, y: 4)
            // Regular: a centred pill in the content column. The nil frames
            // leave compact laid out exactly as before.
            .frame(maxWidth: regular ? 480 : nil)
            .frame(maxWidth: regular ? .infinity : nil)
            .padding(.horizontal, regular ? 0 : 12)
            .padding(.bottom, regular ? 16 : 8)
    }
}

extension View {
    /// Floats the rest timer over the bottom of a pushed screen. Tab roots get
    /// it from `TabBarView`. Adds nothing inside a pane that has set
    /// `restTimerInsetSuppressed()`, so an embedded screen on iPad doesn't
    /// draw a second timer next to its host's.
    func restTimerInset() -> some View {
        modifier(RestTimerInset())
    }

    /// Marks this subtree as hosted by a screen that already shows the rest
    /// timer — an iPad detail pane embedding a pushed screen.
    func restTimerInsetSuppressed() -> some View {
        environment(\.restTimerInsetSuppressed, true)
    }
}

private struct RestTimerInset: ViewModifier {
    @Environment(\.restTimerInsetSuppressed) private var suppressed

    func body(content: Content) -> some View {
        if suppressed {
            content
        } else {
            content.safeAreaInset(edge: .bottom, spacing: 0) { RestTimerBar() }
        }
    }
}
