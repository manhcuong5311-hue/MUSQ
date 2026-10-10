//
//  AdBanner.swift
//  GymWorkout
//
//  The banner slot directly on top of the tab bar, under the rest timer.
//  Every tab root draws its own bar, so each one hosts the same `BannerView`
//  from `Ads` rather than loading a new ad per tab. Takes no space until an
//  ad has loaded, and none at all once the ads are removed.
//
//  On iPad the slot is the content column (never under the sidebar), and the
//  banner is re-fitted whenever that column changes width: centred, at most
//  leaderboard-wide, on a strip of ground.
//

import GoogleMobileAds
import SwiftUI

struct AdBanner: View {
    @Environment(Ads.self) private var ads
    @Environment(\.dsLayout) private var layout
    /// iPad: the content column's width, measured even while no ad shows, so
    /// the first ad is already requested at the right size.
    @State private var columnWidth: CGFloat = 0

    var body: some View {
        if DS.isPad {
            padBanner
        } else if ads.showsBanner, let banner = ads.banner {
            BannerHost(banner: banner)
                .frame(height: ads.bannerHeight)
                .frame(maxWidth: .infinity)
                // Clear space from the rest timer's buttons above, so a tap
                // meant for them can't land on the ad.
                .padding(.top, 6)
                .background(DS.ink)
        }
    }

    /// The banner's width in the column: inside the gutters and no wider
    /// than a leaderboard in regular, the full column otherwise.
    private var slotWidth: CGFloat {
        layout.isRegular ? min(columnWidth - 2 * layout.gutter, 728) : columnWidth
    }

    private var padBanner: some View {
        VStack(spacing: 0) {
            if ads.showsBanner, let banner = ads.banner {
                BannerHost(banner: banner)
                    .frame(width: layout.isRegular ? max(0, slotWidth) : nil, height: ads.bannerHeight)
                    .frame(maxWidth: .infinity)
                    .padding(.top, layout.isRegular ? 8 : 6)
                    .padding(.bottom, layout.isRegular ? 8 : 0)
                    .background(DS.ink)
            }
        }
        .frame(maxWidth: .infinity)
        .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { columnWidth = $0 }
        .onChange(of: slotWidth, initial: true) { _, width in
            guard width > 0 else { return }
            ads.resizeBanner(width: width)
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
        // An iPad slot can narrow (rotation, Split View) before the resized
        // ad arrives; never let the old one spill past it.
        if DS.isPad {
            banner.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor).isActive = true
        }
        banner.rootViewController = window?.rootViewController
    }
}
