//
//  Ads.swift
//  GymWorkout
//
//  AdMob, kept out of the way, and never for MUSQ Premium. RootView calls
//  `start()` once onboarding is done. Start-up runs in the order the rules
//  want: Google's consent form where it applies (EEA, UK, some US states),
//  then Apple's tracking prompt, then the SDK.
//
//  Two formats. One adaptive banner sits on top of the tab bar; it is a single
//  view shared by all four tab roots, so switching tabs doesn't request a new
//  ad. Full-screen ads only come at a natural break — finishing a workout, or
//  every fourth time an exercise screen is closed outside a workout (that one
//  at most once a day) — none until the second workout is finished, and never
//  within three minutes of the last one.
//

import AppTrackingTransparency
import GoogleMobileAds
import Observation
import UIKit
import UserMessagingPlatform

@Observable
final class Ads: NSObject {

    enum UnitID {
        #if DEBUG
        // Google's test units: real ads must never be clicked in development.
        static let banner = "ca-app-pub-3940256099942544/2435281174"
        static let interstitial = "ca-app-pub-3940256099942544/4411468910"
        #else
        static let banner = "ca-app-pub-5982140566133654/2652401806"
        static let interstitial = "ca-app-pub-5982140566133654/9679262000"
        #endif
    }

    /// Where a full-screen ad may show.
    enum Moment {
        case workoutCompleted
        case exerciseClosed
    }

    /// Consent is settled and the SDK is running.
    private(set) var isReady = false
    /// Height of the loaded banner; zero until one has loaded, so the tab bar
    /// never shows an empty slot.
    private(set) var bannerHeight: CGFloat = 0
    /// The consent form must stay reachable from Settings where it applies.
    private(set) var privacyOptionsRequired = false

    /// Finished workouts so far, read live; RootView points it at the store.
    @ObservationIgnored var completedWorkouts: () -> Int = { 0 }
    /// Whether a workout is under way, read live; RootView points it at the
    /// store and the rest timer.
    @ObservationIgnored var workoutInProgress: () -> Bool = { false }

    @ObservationIgnored private let purchases: Purchases
    @ObservationIgnored private(set) var banner: BannerView?
    @ObservationIgnored private var interstitial: InterstitialAd?
    @ObservationIgnored private var interstitialLoadedAt: Date?
    @ObservationIgnored private var isLoadingInterstitial = false
    @ObservationIgnored private var isStarting = false
    @ObservationIgnored private var lastFullScreenAd = Date()
    @ObservationIgnored private var exercisesClosedSinceAd = 0
    /// The break the ad on screen was shown at, so only an exercise-screen ad
    /// uses up the day's one.
    @ObservationIgnored private var presentingMoment: Moment?
    /// iPad: the slot width last asked for, and the banner's current width.
    @ObservationIgnored private var requestedBannerWidth: CGFloat?
    @ObservationIgnored private var bannerWidth: CGFloat?
    @ObservationIgnored private var resizing: Task<Void, Never>?

    private static let fullScreenGap: TimeInterval = 180
    /// The SDK's anchored sizes are now only the large ones (up to ~150 pt);
    /// an adaptive banner capped here keeps the strip about as tall as the
    /// old anchored one, so it doesn't eat the screen above the tab bar.
    private static let bannerMaxHeight: CGFloat = 60
    private static let exercisesPerAd = 4
    /// The first finished workout never ends in an ad.
    private static let workoutsBeforeFullScreen = 2
    /// Start of the day the last exercise-screen ad showed, kept across launches.
    private static let exerciseClosedAdDayKey = "ads.exerciseClosedAdDay"
    /// Google drops a loaded interstitial after an hour.
    private static let interstitialLifetime: TimeInterval = 55 * 60

    init(purchases: Purchases) {
        self.purchases = purchases
    }

    var showsAds: Bool { isReady && !purchases.isPremium }
    var showsBanner: Bool { showsAds && bannerHeight > 0 && banner != nil }

    // MARK: - Start-up

    /// Safe to call repeatedly; does nothing once running, or for Premium.
    func start() async {
        guard !isReady, !isStarting else { return }
        isStarting = true
        defer { isStarting = false }

        if !purchases.hasCheckedEntitlements { await purchases.refreshEntitlements() }
        guard !purchases.isPremium else { return }

        do {
            try await ConsentInformation.shared.requestConsentInfoUpdate(with: RequestParameters())
            try await ConsentForm.loadAndPresentIfRequired(from: Self.topViewController)
        } catch {
            // Offline or not configured: `canRequestAds` still reflects any
            // consent given on an earlier launch.
        }
        privacyOptionsRequired = ConsentInformation.shared.privacyOptionsRequirementStatus == .required

        if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
            _ = await ATTrackingManager.requestTrackingAuthorization()
        }

        guard ConsentInformation.shared.canRequestAds else { return }
        // The app is rated 9+, so nothing above parental guidance.
        MobileAds.shared.requestConfiguration.maxAdContentRating = .parentalGuidance
        _ = await MobileAds.shared.start()
        lastFullScreenAd = Date()
        isReady = true
        loadBanner()
        loadInterstitial()
    }

    /// Settings' "Privacy choices": reopens Google's consent form.
    func presentPrivacyOptions() async {
        try? await ConsentForm.presentPrivacyOptionsForm(from: Self.topViewController)
    }

    // MARK: - Banner

    private func loadBanner() {
        guard banner == nil else { return }
        let width = requestedBannerWidth ?? Self.keyWindow?.bounds.width ?? 390
        bannerWidth = width
        let view = BannerView(adSize: inlineAdaptiveBanner(width: width, maxHeight: Self.maxHeight(for: width)))
        view.adUnitID = UnitID.banner
        view.delegate = self
        view.rootViewController = Self.topViewController
        view.load(Request())
        banner = view
    }

    /// iPad only: fits the banner to its slot in the content column, which
    /// changes with rotation, Split View and the sidebar. Settles for half a
    /// second first, so a window being dragged doesn't request an ad per
    /// frame; a change under a point is ignored. iPhone never calls this —
    /// its banner keeps the width it was created with.
    func resizeBanner(width: CGFloat) {
        guard width > 0 else { return }
        requestedBannerWidth = width
        resizing?.cancel()
        resizing = Task { [weak self] in
            try? await Task.sleep(for: .seconds(0.5))
            guard !Task.isCancelled, let self else { return }
            self.applyBannerWidth(width)
        }
    }

    private func applyBannerWidth(_ width: CGFloat) {
        guard let banner, abs((bannerWidth ?? 0) - width) > 1 else { return }
        bannerWidth = width
        banner.adSize = inlineAdaptiveBanner(width: width, maxHeight: Self.maxHeight(for: width))
        banner.load(Request())
        // The new height arrives with the ad; until then keep the slot as it
        // was rather than collapsing it.
    }

    /// A leaderboard-wide slot gets a leaderboard's height.
    private static func maxHeight(for width: CGFloat) -> CGFloat {
        width >= 728 ? 90 : bannerMaxHeight
    }

    // MARK: - Full screen

    /// Offers a break to show a full-screen ad at; most are passed over.
    func moment(_ moment: Moment) {
        guard showsAds else { return }
        // The count already includes a workout that has just been finished.
        guard completedWorkouts() >= Self.workoutsBeforeFullScreen else { return }
        if moment == .exerciseClosed {
            // Between sets is no break, and those closes don't count either:
            // the workout's own end is the break.
            guard !workoutInProgress() else { return }
            exercisesClosedSinceAd += 1
            guard exercisesClosedSinceAd >= Self.exercisesPerAd,
                  !hasShownExerciseClosedAdToday else { return }
        }
        guard Date().timeIntervalSince(lastFullScreenAd) >= Self.fullScreenGap else { return }
        guard let ad = interstitial, let loadedAt = interstitialLoadedAt,
              Date().timeIntervalSince(loadedAt) < Self.interstitialLifetime else {
            interstitial = nil
            loadInterstitial()
            return
        }
        // Let the screen that triggered it finish its own transition first.
        let delay: Duration = moment == .workoutCompleted ? .seconds(1.2) : .seconds(0.45)
        Task {
            try? await Task.sleep(for: delay)
            guard showsAds, let root = Self.topViewController else { return }
            presentingMoment = moment
            ad.present(from: root)
        }
    }

    private var hasShownExerciseClosedAdToday: Bool {
        let day = UserDefaults.standard.double(forKey: Self.exerciseClosedAdDayKey)
        return Calendar.current.isDateInToday(Date(timeIntervalSinceReferenceDate: day))
    }

    private func loadInterstitial() {
        guard interstitial == nil, !isLoadingInterstitial, showsAds else { return }
        isLoadingInterstitial = true
        Task {
            let ad = try? await InterstitialAd.load(with: UnitID.interstitial, request: Request())
            isLoadingInterstitial = false
            interstitial = ad
            interstitialLoadedAt = ad == nil ? nil : Date()
            ad?.fullScreenContentDelegate = self
        }
    }

    // MARK: - Windows

    private static var keyWindow: UIWindow? {
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        let scene = scenes.first { $0.activationState == .foregroundActive } ?? scenes.first
        return scene?.keyWindow ?? scene?.windows.first
    }

    static var topViewController: UIViewController? {
        var top = keyWindow?.rootViewController
        while let presented = top?.presentedViewController { top = presented }
        return top
    }
}

extension Ads: BannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: BannerView) {
        bannerHeight = bannerView.adSize.size.height
    }
}

extension Ads: FullScreenContentDelegate {
    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
        lastFullScreenAd = Date()
        exercisesClosedSinceAd = 0
        // Only an ad that really showed counts as today's.
        if presentingMoment == .exerciseClosed {
            let day = Calendar.current.startOfDay(for: Date())
            UserDefaults.standard.set(day.timeIntervalSinceReferenceDate, forKey: Self.exerciseClosedAdDayKey)
        }
    }

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        lastFullScreenAd = Date()
        presentingMoment = nil
        interstitial = nil
        loadInterstitial()
    }

    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        presentingMoment = nil
        interstitial = nil
        loadInterstitial()
    }
}
