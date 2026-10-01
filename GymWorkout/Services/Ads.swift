//
//  Ads.swift
//  GymWorkout
//
//  AdMob, kept out of the way. Nothing starts until onboarding is done and
//  only if Remove Ads hasn't been bought. Start-up runs in the order the
//  rules want: Google's consent form where it applies (EEA, UK, some US
//  states), then Apple's tracking prompt, then the SDK.
//
//  Two formats. One adaptive banner sits on top of the tab bar; it is a single
//  view shared by all four tab roots, so switching tabs doesn't request a new
//  ad. Full-screen ads only come at a natural break — finishing a workout, or
//  every fourth time an exercise screen is closed — and never within three
//  minutes of the last one.
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

    @ObservationIgnored private let purchases: Purchases
    @ObservationIgnored private(set) var banner: BannerView?
    @ObservationIgnored private var interstitial: InterstitialAd?
    @ObservationIgnored private var interstitialLoadedAt: Date?
    @ObservationIgnored private var isLoadingInterstitial = false
    @ObservationIgnored private var isStarting = false
    @ObservationIgnored private var lastFullScreenAd = Date()
    @ObservationIgnored private var exercisesClosedSinceAd = 0

    private static let fullScreenGap: TimeInterval = 180
    private static let exercisesPerAd = 4
    /// Google drops a loaded interstitial after an hour.
    private static let interstitialLifetime: TimeInterval = 55 * 60

    init(purchases: Purchases) {
        self.purchases = purchases
    }

    var showsAds: Bool { isReady && !purchases.hasRemovedAds }
    var showsBanner: Bool { showsAds && bannerHeight > 0 && banner != nil }

    // MARK: - Start-up

    /// Safe to call repeatedly; does nothing once running, or for anyone who
    /// removed the ads.
    func start() async {
        guard !isReady, !isStarting else { return }
        isStarting = true
        defer { isStarting = false }

        if !purchases.hasCheckedEntitlements { await purchases.refreshEntitlements() }
        guard !purchases.hasRemovedAds else { return }

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
        let width = Self.keyWindow?.bounds.width ?? 390
        let view = BannerView(adSize: currentOrientationAnchoredAdaptiveBanner(width: width))
        view.adUnitID = UnitID.banner
        view.delegate = self
        view.rootViewController = Self.topViewController
        view.load(Request())
        banner = view
    }

    // MARK: - Full screen

    /// Offers a break to show a full-screen ad at; most are passed over.
    func moment(_ moment: Moment) {
        guard showsAds else { return }
        if moment == .exerciseClosed {
            exercisesClosedSinceAd += 1
            guard exercisesClosedSinceAd >= Self.exercisesPerAd else { return }
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
            ad.present(from: root)
        }
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
    }

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        lastFullScreenAd = Date()
        interstitial = nil
        loadInterstitial()
    }

    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        interstitial = nil
        loadInterstitial()
    }
}
