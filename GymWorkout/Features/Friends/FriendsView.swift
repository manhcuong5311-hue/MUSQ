//
//  FriendsView.swift
//  GymWorkout
//
//  The Friends tab (2026-11-28, Friends v1). Signed out: what the tab is
//  and Sign in with Apple. Then a short profile, and the tab itself: my
//  code, requests, the feed and this week's board with one-tap nudges.
//  Everything goes through `FriendsService` (callables); nothing from
//  Apple Health is ever shared, and the rest of MUSQ needs no account.
//

import AuthenticationServices
import SwiftUI

struct FriendsView: View {
    @Binding var tab: AppTab

    private var service: FriendsService { .shared }
    private var photos: FriendsPhotoService { .shared }
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.colorScheme) private var scheme

    private enum Segment: Hashable { case feed, week }

    @State private var segment: Segment = .feed
    @State private var showAdd = false
    @State private var showEdit = false
    @State private var detail: FriendRef?
    @State private var toast: String?
    @State private var nudged: Set<String> = NudgedToday.ids()
    @State private var nudgeTick = 0
    /// Nudges on their way to the server, so a second tap doesn't send
    /// another (which the server would refuse as "already nudged").
    @State private var nudging: Set<String> = []
    @State private var signInError: String?
    @State private var isSigningIn = false
    @State private var respondingTo: String?
    @State private var reportingRequest: FriendRequest?
    @State private var photoSource: FriendsPhotoSource?
    @State private var viewer: FriendsPhotoViewerRequest?
    @State private var photoDetail: FriendsPhotoDetailRequest?

    var body: some View {
        NavigationStack {
            content
                .background(DS.ink.ignoresSafeArea())
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    VStack(spacing: 0) {
                        bottomActions
                        TabBarView(selection: $tab)
                    }
                }
                .overlay(alignment: .bottom) {
                    if let toast {
                        FriendsToast(text: toast)
                            .padding(.bottom, 150)
                            .allowsHitTesting(false)
                    }
                }
                .animation(.spring(duration: 0.3), value: toast)
                .statusBarScrim()
                .toolbar(.hidden, for: .navigationBar)
        }
        .task { await service.refresh() }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                nudged = NudgedToday.ids()
                Task { await service.refresh() }
            }
            syncPhotoListening()
        }
        // Photos, reactions and comments arrive live while the tab is up.
        .onAppear { syncPhotoListening() }
        // A full-screen cover (story viewer, camera) also fires onDisappear
        // here while the tab is still up: keep the feed live then. Leaving
        // the tab (or the app going to the background, above) stops it.
        .onDisappear { if tab != .friends { photos.stopListening() } }
        .onChange(of: tab) { _, new in if new != .friends { photos.stopListening() } }
        .onChange(of: service.me != nil) { _, _ in syncPhotoListening() }
        .friendsPhotoCapture(source: $photoSource) {
            toast = String(localized: "Shared with your friends 📸")
        }
        .fullScreenCover(item: $viewer) { r in
            FriendsPhotoViewer(stories: r.stories, start: r.start)
        }
        .sheet(item: $photoDetail) { r in
            FriendsPhotoDetail(initial: r.post)
        }
        .task(id: toast) {
            guard toast != nil else { return }
            try? await Task.sleep(for: .seconds(2.2))
            toast = nil
        }
        .sensoryFeedback(.success, trigger: nudgeTick)
        .sheet(isPresented: $showAdd) { AddFriendSheet() }
        .sheet(isPresented: $showEdit) {
            NavigationStack {
                FriendsSetupView(editing: true)
                    .navigationTitle(String(localized: "Edit profile"))
                    .navigationBarTitleDisplayMode(.inline)
            }
            .presentationBackground(DS.ink)
        }
        .sheet(item: $detail) { ref in
            FriendDetailSheet(friendId: ref.id, nudged: nudged,
                              onNudge: { f, kind, show in sendNudge(f, kind, show: show) },
                              onToast: { toast = $0 })
        }
        .confirmationDialog(String(localized: "Report \(reportingRequest?.displayName ?? "")?"),
                            isPresented: Binding(get: { reportingRequest != nil },
                                                 set: { if !$0 { reportingRequest = nil } }),
                            titleVisibility: .visible, presenting: reportingRequest) { r in
            ForEach(FriendReportReason.allCases) { reason in
                Button(reason.title) { report(r, reason) }
            }
        } message: { _ in
            Text("MUSQ reviews every report within 24 hours. Their request is declined and they're blocked.")
        }
    }

    // MARK: - State switch

    @ViewBuilder private var content: some View {
        switch service.state {
        case .signedOut:
            signedOut
        case .needsProfile:
            FriendsSetupView()
        case .loading:
            if service.me != nil { ready } else { loading }
        case .ready:
            ready
        case .failed(let message):
            if service.me != nil { ready } else { failed(message) }
        }
    }

    @ViewBuilder private var bottomActions: some View {
        switch service.state {
        case .signedOut:
            VStack(spacing: 10) {
                SignInWithAppleButton(.signIn) { request in
                    AccountService.shared.prepare(request)
                } onCompletion: { result in
                    Task { await finishSignIn(result) }
                }
                .signInWithAppleButtonStyle(scheme == .dark ? .white : .black)
                .frame(height: 54)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .disabled(isSigningIn)
                #if DEBUG
                if AIService.usesEmulator {
                    Button("Sign in for testing (emulator)") {
                        Task {
                            try? await AccountService.shared.signInForTesting()
                            await service.refresh()
                        }
                    }
                    .font(.ui(13, .semibold))
                }
                #endif
                Text(signInError ?? String(localized: "Only Friends needs an account. The rest of MUSQ works without one."))
                    .font(.ui(12.5))
                    .foregroundStyle(DS.silver.opacity(0.5))
                    .multilineTextAlignment(.center)
            }
            .bottomBarPadding()
        case .ready, .loading, .failed:
            if service.me != nil {
                FriendsPhotoBottomButtons(onCamera: { photoSource = .camera },
                                          onLibrary: { photoSource = .library })
                    .bottomBarPadding()
            }
        case .needsProfile:
            EmptyView()
        }
    }

    // MARK: - Signed out

    private var signedOut: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                Text("Friends")
                    .font(.ui(34, .bold))
                    .foregroundStyle(DS.silver)
                    .padding(.top, 12)

                VStack(spacing: 14) {
                    StyledSymbol(name: "person.2.fill", size: 34)
                        .foregroundStyle(.white)
                        .frame(width: 84, height: 84)
                        .background(Circle().fill(LinearGradient(
                            colors: [DS.activationSoft, DS.activation],
                            startPoint: .top, endPoint: .bottom)))
                    Text("Train together")
                        .font(.ui(22, .bold))
                        .foregroundStyle(DS.silver)
                    Text("See when friends train, cheer them on and keep a streak together.")
                        .font(.ui(15))
                        .foregroundStyle(DS.silver.opacity(0.6))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)

                VStack(spacing: 10) {
                    heroRow("dumbbell.fill", .orange, "Friends' workouts, water and PRs")
                    heroRow("camera.fill", .purple, "Gym photos only your friends see")
                    heroRow("hand.wave.fill", .pink, "One-tap nudges: \"Time to train!\"")
                    heroRow("chart.bar.fill", .blue, "A weekly board: who trained most")
                    heroRow("flame.fill", .red, "Streaks you keep alive together")
                }
            }
            .padding(.horizontal, DS.Metric.gutter)
            .padding(.bottom, 24)
            .friendsColumn()
        }
    }

    private func heroRow(_ symbol: String, _ tint: Color, _ text: LocalizedStringKey) -> some View {
        HStack(spacing: 14) {
            StyledSymbol(name: symbol, size: 17)
                .foregroundStyle(tint)
                .frame(width: 40, height: 40)
                .background(Circle().fill(tint.opacity(0.14)))
            Text(text)
                .font(.ui(15, .medium))
                .foregroundStyle(DS.silver)
            Spacer(minLength: 0)
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(DS.surface))
    }

    private func finishSignIn(_ result: Result<ASAuthorization, Error>) async {
        if case .failure(let failure) = result, (failure as? ASAuthorizationError)?.code == .canceled { return }
        isSigningIn = true
        defer { isSigningIn = false }
        do {
            try await AccountService.shared.complete(result)
            signInError = nil
            await service.refresh()
        } catch {
            signInError = String(localized: "Sign in with Apple didn't finish. Try again.")
        }
    }

    // MARK: - Loading / failed

    private var loading: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Friends")
                    .font(.ui(34, .bold))
                    .foregroundStyle(DS.silver)
                    .padding(.top, 12)
                FriendsLoadingPlaceholder()
            }
            .padding(.horizontal, DS.Metric.gutter)
            .friendsColumn()
        }
        .scrollDisabled(true)
    }

    private func failed(_ message: String) -> some View {
        VStack(spacing: 14) {
            Spacer()
            Text("😕").font(.system(size: 44))
            Text("Couldn't load Friends")
                .font(.ui(20, .bold))
                .foregroundStyle(DS.silver)
            Text(message)
                .font(.ui(14))
                .foregroundStyle(DS.silver.opacity(0.55))
                .multilineTextAlignment(.center)
            Button(String(localized: "Retry")) {
                Task { await service.refresh() }
            }
            .buttonStyle(FriendsPrimaryButtonStyle())
            .frame(maxWidth: 260)
            .padding(.top, 6)
            Spacer()
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity)
    }

    // MARK: - Ready

    private var ready: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header
                if let nudge = service.currentNudge {
                    let sender = service.friends.first { $0.id == nudge.fromId }
                    NudgeBanner(
                        nudge: nudge,
                        onNudgeBack: sender.map { f in {
                            sendNudge(f, nudge.kind, then: { service.markNudgedBack(nudge.id) })
                        } },
                        nudgedBack: service.nudgedBack.contains(nudge.id) || (sender.map { nudged.contains($0.id) } ?? false),
                        onDismiss: { withAnimation { service.dismissNudge(nudge.id) } })
                }
                if !service.incoming.isEmpty { incomingStrip }
                if service.friends.isEmpty { inviteCard }

                Picker(String(localized: "View"), selection: $segment) {
                    Text("Feed").tag(Segment.feed)
                    Text("This week").tag(Segment.week)
                }
                .pickerStyle(.segmented)
                .padding(.top, 4)

                switch segment {
                case .feed:
                    FriendsPhotoFeed(myEmoji: service.me?.emoji ?? "🙂",
                                     onPost: { photoSource = .camera },
                                     onOpenStory: { list, i in viewer = FriendsPhotoViewerRequest(stories: list, start: i) },
                                     onOpenPost: { photoDetail = FriendsPhotoDetailRequest(post: $0) },
                                     onToast: { toast = $0 })
                case .week:
                    FriendsBoard(nudged: nudged,
                                 onNudge: { f, kind in sendNudge(f, kind) },
                                 onOpen: { f in detail = FriendRef(id: f.id) },
                                 onStory: { openStory($0) })
                }

            }
            .padding(.horizontal, DS.Metric.gutter)
            .padding(.bottom, 24)
            .friendsColumn()
            .animation(.spring(duration: 0.35), value: service.currentNudge?.id)
        }
        .refreshable { await service.refresh() }
    }

    private var header: some View {
        HStack(spacing: 12) {
            Button { showEdit = true } label: {
                HStack(spacing: 10) {
                    FriendAvatar(emoji: service.me?.emoji ?? "🙂", size: 48, highlighted: true)
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Friends")
                            .font(.ui(13, .semibold))
                            .foregroundStyle(DS.silver.opacity(0.5))
                        Text(service.me?.displayName ?? " ")
                            .font(.ui(22, .bold))
                            .foregroundStyle(DS.silver)
                            .lineLimit(1)
                    }
                }
            }
            .buttonStyle(.plain)
            .accessibilityHint(String(localized: "Edits your friend profile"))
            Spacer(minLength: 6)
            if let code = service.me?.code {
                codeChip(code)
            }
            Button { showAdd = true } label: {
                StyledSymbol(name: "person.badge.plus", size: 17)
                    .foregroundStyle(DS.silver)
                    .frame(width: 46, height: 46)
                    .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(DS.surface))
            }
            .buttonStyle(.plain)
            .accessibilityLabel(String(localized: "Add friend"))
        }
        .padding(.top, 12)
    }

    private func codeChip(_ code: String) -> some View {
        HStack(spacing: 0) {
            Button {
                UIPasteboard.general.string = code
                toast = String(localized: "Code copied")
            } label: {
                VStack(alignment: .leading, spacing: 0) {
                    Text("MY CODE")
                        .font(.mono(9.5))
                        .tracking(1.2)
                        .foregroundStyle(DS.silver.opacity(0.45))
                    Text(code)
                        .font(.system(size: 17, weight: .bold, design: .monospaced))
                        .tracking(2)
                        .foregroundStyle(DS.silver)
                }
                .padding(.leading, 12)
                .padding(.trailing, 8)
                .frame(height: 46)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(String(localized: "My code \(code). Copy", comment: "VoiceOver, the friend code chip"))
            if let invite = service.inviteText {
                ShareLink(item: invite) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(DS.silver)
                        .frame(width: 40, height: 46)
                }
                .accessibilityLabel(String(localized: "Share my invite"))
            }
        }
        .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(DS.surface))
    }

    private var incomingStrip: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Friend requests")
                .font(.ui(15, .semibold))
                .foregroundStyle(DS.silver.opacity(0.6))
            ForEach(service.incoming, id: \.id) { r in
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        FriendAvatar(emoji: r.emoji, size: 44)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(r.displayName)
                                .font(.ui(16, .semibold))
                                .foregroundStyle(DS.silver)
                            Text("wants to be friends · \((r.createdDate ?? .now).formatted(.relative(presentation: .named)))",
                                 comment: "Friend request subtitle: wants to be friends · 2 hours ago")
                                .font(.ui(13))
                                .foregroundStyle(DS.silver.opacity(0.55))
                        }
                        Spacer(minLength: 0)
                    }
                    HStack(spacing: 10) {
                        Button(String(localized: "Decline")) { respond(r, accept: false) }
                            .buttonStyle(FriendsPrimaryButtonStyle(filled: false))
                        Button(String(localized: "Accept")) { respond(r, accept: true) }
                            .buttonStyle(FriendsPrimaryButtonStyle())
                    }
                    .disabled(respondingTo == r.id)
                    // Report and block a stranger without accepting first.
                    HStack(spacing: 18) {
                        Button {
                            reportingRequest = r
                        } label: {
                            Label(String(localized: "Report"), systemImage: "exclamationmark.bubble.fill")
                        }
                        Button {
                            blockRequest(r)
                        } label: {
                            Label(String(localized: "Block"), systemImage: "hand.raised.fill")
                        }
                        Spacer(minLength: 0)
                    }
                    .font(.ui(13.5, .semibold))
                    .foregroundStyle(DS.rhythmWaiting)
                    .buttonStyle(.plain)
                    .disabled(respondingTo == r.id)
                }
                .padding(14)
                .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(DS.surface))
            }
        }
    }

    private var inviteCard: some View {
        VStack(spacing: 10) {
            Text("👋").font(.system(size: 40))
            Text("Training's better together")
                .font(.ui(18, .bold))
                .foregroundStyle(DS.silver)
            Text("Send your code to a friend. Once they add you, you'll see each other's week.")
                .font(.ui(14))
                .foregroundStyle(DS.silver.opacity(0.55))
                .multilineTextAlignment(.center)
            if let invite = service.inviteText {
                ShareLink(item: invite) {
                    Label(String(localized: "Invite a friend"), systemImage: "square.and.arrow.up")
                }
                .buttonStyle(FriendsPrimaryButtonStyle())
                .padding(.top, 4)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(LinearGradient(colors: [DS.activation.opacity(0.16), DS.surface],
                                 startPoint: .top, endPoint: .bottom)))
    }

    // MARK: - Actions

    private func respond(_ r: FriendRequest, accept: Bool) {
        respondingTo = r.id
        Task {
            defer { respondingTo = nil }
            do {
                try await service.respond(r, accept: accept)
                if accept {
                    toast = String(localized: "You and \(r.displayName) are friends 🎉")
                    await service.loadFeed(reset: true)
                }
            } catch {
                toast = friendsMessage(error)
            }
        }
    }

    private func blockRequest(_ r: FriendRequest) {
        respondingTo = r.id
        Task {
            defer { respondingTo = nil }
            do {
                try await service.block(request: r)
                toast = String(localized: "Blocked \(r.displayName)")
            } catch {
                toast = friendsMessage(error)
            }
        }
    }

    /// Reports the sender of a request, then blocks them (which declines it).
    private func report(_ r: FriendRequest, _ reason: FriendReportReason) {
        respondingTo = r.id
        Task {
            defer { respondingTo = nil }
            do {
                try await service.report(request: r, reason: reason)
                try await service.block(request: r)
                toast = String(localized: "Thanks — we'll take a look.")
            } catch {
                toast = friendsMessage(error)
            }
        }
    }

    /// Sends a nudge. `show` puts the result on screen where the tap was
    /// (the friend sheet has its own toast); this view's toast otherwise.
    private func sendNudge(_ f: Friend, _ kind: FriendNudgeKind, show: ((String) -> Void)? = nil,
                           then: @escaping () -> Void = {}) {
        let say: (String) -> Void = show ?? { toast = $0 }
        guard !nudged.contains(f.id) else {
            say(String(localized: "Nudged \(f.displayName) today already"))
            return
        }
        guard nudging.insert(f.id).inserted else { return }
        Task {
            defer { nudging.remove(f.id) }
            do {
                try await service.nudge(f, kind: kind)
                markNudged(f)
                nudgeTick += 1
                then()
                say(String(localized: "Nudged \(f.displayName)", comment: "Toast after a nudge: Nudged Minh"))
            } catch {
                // The server allows one nudge a day per friend; say so on
                // the button too when it refuses for that.
                if (error as? FriendsError) == .alreadyNudged { markNudged(f) }
                say(friendsMessage(error))
            }
        }
    }

    /// Listens for photos only while signed in with a profile and the app
    /// is in front; stops otherwise.
    private func syncPhotoListening() {
        if service.me != nil && scenePhase == .active {
            photos.startListening()
        } else {
            photos.stopListening()
        }
    }

    /// Opens the viewer on one person's photo, then walks the stories row.
    private func openStory(_ story: FriendPhotoStory) {
        let list = FriendsPhotoRing.ordered()
        let i = list.firstIndex { $0.authorId == story.authorId && $0.isMine == story.isMine } ?? 0
        viewer = FriendsPhotoViewerRequest(stories: list.isEmpty ? [story] : list, start: i)
    }

    private func markNudged(_ f: Friend) {
        NudgedToday.add(f.id)
        nudged = NudgedToday.ids()
    }
}

private extension View {
    func bottomBarPadding() -> some View {
        padding(.horizontal, DS.Metric.gutter)
            .padding(.top, 10)
            .padding(.bottom, 8)
            .frame(maxWidth: 640)
            .frame(maxWidth: .infinity)
            .background(DS.ink.opacity(0.96))
    }
}
