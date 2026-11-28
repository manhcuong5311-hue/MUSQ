//
//  NotificationSettingsView.swift
//  GymWorkout
//
//  Profile › Settings › Notifications (2026-11-27): the nudges (see
//  `Nudges.swift`), each type on or off, with the permission ask at the
//  bottom where the thumb is when notifications aren't allowed yet. The
//  rules sit in one footnote: three a day at most, never 22:30-7:30, and
//  everything worked out on the phone. DEBUG builds also show how often
//  each type went out and was opened.
//

import SwiftUI
import UserNotifications

struct NotificationSettingsView: View {
    @Environment(DailyStore.self) private var daily
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dsLayout) private var layout
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.openURL) private var openURL
    /// Nil until read.
    @State private var status: UNAuthorizationStatus?
    @AppStorage(NudgeKind.optedInKey) private var optedIn = false

    private var isAllowed: Bool {
        guard let status else { return true }
        return [.authorized, .provisional, .ephemeral].contains(status)
    }

    var body: some View {
        ZStack {
            DS.ink.ignoresSafeArea()

            VStack(spacing: 0) {
                HistoryHeader(title: String(localized: "Notifications"), meta: headerMeta,
                              maxWidth: 620, onBack: { dismiss() })
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 28) {
                        typesSection
                        friendsSection
                        #if DEBUG
                        statsSection
                        #endif
                    }
                    .dsReadable(620)
                    .dsGutter()
                    .padding(.top, 6)
                    .padding(.bottom, 32)
                }
            }
        }
        // The one action, in thumb reach, only while it's needed.
        .safeAreaInset(edge: .bottom) {
            if !isAllowed {
                VStack(spacing: 8) {
                    Text(status == .denied
                         ? String(localized: "Notifications are off for MUSQ in iOS Settings.")
                         : String(localized: "Allow notifications to get these nudges."))
                        .font(.ui(layout.value(12, 13.5)))
                        .foregroundStyle(DS.silver.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    WideButton(title: status == .denied ? String(localized: "Open Settings")
                                                        : String(localized: "Turn on notifications"),
                               prominent: true, fontSize: 15, verticalPadding: 16, action: allow)
                }
                .dsReadable(620)
                .dsGutter()
                .padding(.top, 10)
                .padding(.bottom, 8)
                .background(DS.ink.ignoresSafeArea(edges: .bottom))
            } else if !optedIn {
                WideButton(title: String(localized: "Turn on nudges"),
                           prominent: true, fontSize: 15, verticalPadding: 16) {
                    optedIn = true
                    NudgeScheduler.shared.replanSoon()
                }
                .dsReadable(620)
                .dsGutter()
                .padding(.top, 10)
                .padding(.bottom, 8)
                .background(DS.ink.ignoresSafeArea(edges: .bottom))
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden()
        .dsBackShortcuts { dismiss() }
        .task { await readStatus() }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { Task { await readStatus() } }
        }
    }

    /// "ON YOUR PHONE · 3 A DAY MAX"
    private var headerMeta: String {
        String(localized: "On your phone · 3 a day max",
               comment: "Notification settings header: nudges are local, at most three a day").uppercased()
    }

    private var typesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionEyebrow(text: "NUDGES")
                .accessibilityAddTraits(.isHeader)
            VStack(spacing: 0) {
                ForEach(Array(NudgeKind.allCases.enumerated()), id: \.element) { index, kind in
                    if index > 0 { Hairline(opacity: 0.06) }
                    NudgeToggleRow(kind: kind)
                }
            }
            .padding(.horizontal, layout.value(14, 18))
            .background(RoundedRectangle(cornerRadius: layout.cardRadius, style: .continuous).fill(DS.surfaceAlt))
            .opacity(isAllowed && optedIn ? 1 : 0.55)

            Text("At most 3 a day, never between 10:30 pm and 7:30 am. Worked out on your phone from what you log; nothing is sent anywhere.")
                .font(.ui(layout.value(11.5, 13)))
                .cssLineHeight(layout.value(11.5, 13), 1.45)
                .foregroundStyle(DS.silver.opacity(0.5))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 4)
        }
    }

    /// Nudges from friends (Friends tab): a notification when the app
    /// fetches one, unless turned off here.
    private var friendsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionEyebrow(text: "FRIENDS")
                .accessibilityAddTraits(.isHeader)
            FriendNudgeToggleRow()
                .padding(.horizontal, layout.value(14, 18))
                .background(RoundedRectangle(cornerRadius: layout.cardRadius, style: .continuous).fill(DS.surfaceAlt))
                .opacity(isAllowed ? 1 : 0.55)
        }
    }

    #if DEBUG
    /// Sent and opened per type, to see which nudges work. DEBUG only.
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionEyebrow(text: "DEBUG · SENT / OPENED")
            VStack(spacing: 0) {
                ForEach(NudgeKind.allCases) { kind in
                    let sent = UserDefaults.standard.integer(forKey: kind.sentKey)
                    let opened = UserDefaults.standard.integer(forKey: kind.openedKey)
                    HStack {
                        Text(kind.title)
                            .font(.ui(13))
                            .foregroundStyle(DS.silver.opacity(0.8))
                        Spacer()
                        Text("\(sent) / \(opened)")
                            .font(.mono(12, .semibold))
                            .foregroundStyle(DS.silver.opacity(0.6))
                    }
                    .padding(.vertical, 8)
                }
            }
            .padding(.horizontal, layout.value(14, 18))
            .background(RoundedRectangle(cornerRadius: layout.cardRadius, style: .continuous).fill(DS.surfaceAlt))
        }
    }
    #endif

    private func readStatus() async {
        status = await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
    }

    private func allow() {
        if status == .denied {
            if let url = URL(string: UIApplication.openNotificationSettingsURLString) { openURL(url) }
            return
        }
        optedIn = true
        Task {
            // DailyStore's ask, so the reminder rows learn the answer too.
            _ = await daily.requestNotifications()
            await readStatus()
            NudgeScheduler.shared.replanSoon()
        }
    }
}

/// One nudge type: icon, name, a line of what it does, and its switch.
private struct NudgeToggleRow: View {
    let kind: NudgeKind
    @AppStorage private var isOn: Bool
    @Environment(\.dsLayout) private var layout

    init(kind: NudgeKind) {
        self.kind = kind
        _isOn = AppStorage(wrappedValue: true, kind.storageKey)
    }

    var body: some View {
        Toggle(isOn: $isOn) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: kind.symbol)
                    .font(.system(size: layout.value(15, 17), weight: .regular))
                    .foregroundStyle(DS.silver.opacity(0.7))
                    .frame(width: 24)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 3) {
                    Text(kind.title)
                        .font(.ui(layout.value(14.5, 16), .semibold))
                        .foregroundStyle(DS.silver)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(kind.detail)
                        .font(.ui(layout.value(12, 13.5)))
                        .foregroundStyle(DS.silver.opacity(0.5))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .tint(DS.silver)
        .padding(.vertical, layout.value(13, 16))
        .onChange(of: isOn) { _, _ in
            // Choosing a type is a yes to nudges.
            UserDefaults.standard.set(true, forKey: NudgeKind.optedInKey)
            NudgeScheduler.shared.replanSoon()
        }
    }
}

/// Friend nudges as notifications (FriendsInbox); the in-app banner shows
/// either way.
private struct FriendNudgeToggleRow: View {
    @AppStorage(FriendsInbox.notifyKey) private var isOn = true
    @Environment(\.dsLayout) private var layout

    var body: some View {
        Toggle(isOn: $isOn) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "hand.wave")
                    .font(.system(size: layout.value(15, 17), weight: .regular))
                    .foregroundStyle(DS.silver.opacity(0.7))
                    .frame(width: 24)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 3) {
                    Text("Friend nudges")
                        .font(.ui(layout.value(14.5, 16), .semibold))
                        .foregroundStyle(DS.silver)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("When a friend nudges you. Mute one friend from their page on the Friends tab.")
                        .font(.ui(layout.value(12, 13.5)))
                        .foregroundStyle(DS.silver.opacity(0.5))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .tint(DS.silver)
        .padding(.vertical, layout.value(13, 16))
    }
}

#Preview("Notifications · iPhone") {
    NavigationStack {
        NotificationSettingsView()
    }
    .environment(DailyStore(fileURL: FileManager.default.temporaryDirectory.appendingPathComponent("preview-daily.json")))
    .dsPreview(.phone)
}
