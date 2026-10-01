//
//  AdBanner.swift
//  GymWorkout
//
//  The banner slot directly on top of the tab bar, under the rest timer.
//  Every tab root draws its own bar, so each one hosts the same `BannerView`
//  from `Ads` rather than loading a new ad per tab. Takes no space until an
//  ad has loaded, and none at all once the ads are removed.
//

import GoogleMobileAds
import SwiftUI

struct AdBanner: View {
    @Environment(Ads.self) private var ads

    var body: some View {
        if ads.showsBanner, let banner = ads.banner {
            BannerHost(banner: banner)
                .frame(height: ads.bannerHeight)
                .frame(maxWidth: .infinity)
                // Clear space from the rest timer's buttons above, so a tap
                // meant for them can't land on the ad.
                .padding(.top, 6)
                .background(DS.ink)
        }
    }
}

private struct BannerHost: UIViewRepresentable {
    let banner: BannerView

    func makeUIView(context: Context) -> BannerSlot {
        BannerSlot(banner: banner)
    }

    func updateUIView(_ slot: BannerSlot, context: Context) {}
}

/// Takes the banner when it joins the window. The outgoing tab's slot and the
/// incoming one briefly exist together during a switch; claiming on
/// `didMoveToWindow` means the slot actually on screen always wins.
private final class BannerSlot: UIView {
    let banner: BannerView

    init(banner: BannerView) {
        self.banner = banner
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard window != nil, banner.superview !== self else { return }
        banner.removeFromSuperview()
        banner.translatesAutoresizingMaskIntoConstraints = false
        addSubview(banner)
        NSLayoutConstraint.activate([
            banner.centerXAnchor.constraint(equalTo: centerXAnchor),
            banner.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        banner.rootViewController = window?.rootViewController
    }
}
