//
//  FriendsPhotosImage.swift
//  GymWorkout
//
//  Friends photo check-ins (2026-11-28): getting a photo ready to send and
//  showing the ones friends sent.
//
//  Sending: drawn again from its pixels at ≤ 1080 px on the long side and
//  encoded as JPEG 0.75, so nothing of the original file goes along (no
//  EXIF, GPS, camera or date); refused when still over 1.5 MB.
//
//  Showing: the post's `url` when the server gave one, else the Cloud
//  Storage object at `imagePath`, read over Storage's REST endpoint with
//  the member's Firebase ID token (storage.rules decide, so no extra SDK).
//  Kept in memory (FriendsPhotoService, decoded off the main thread and
//  bounded by bytes) and on disk in Caches/friend-photos, where files older
//  than 30 days are removed; a photo's file goes as soon as the member
//  loses access to it (block, remove, report, a post gone from the inbox)
//  and the whole folder on sign-out or account deletion. Downloads use a
//  session with no URL cache, so no second copy sits in Cache.db.
//

import Foundation
import SwiftUI
import UIKit

nonisolated enum FriendsPhotoImage {
    struct Prepared: Sendable {
        var data: Data
        var width: Int
        var height: Int
    }

    /// The photo as it goes to the server: pixels only, upright, ≤ 1080 px.
    static func prepare(_ image: UIImage) throws -> Prepared {
        let pixelWidth = image.size.width * image.scale
        let pixelHeight = image.size.height * image.scale
        guard pixelWidth >= 1, pixelHeight >= 1 else { throw FriendsPhotoError.unreadableImage }
        let factor = min(1, FriendsPhotoLimits.maxPixelSide / max(pixelWidth, pixelHeight))
        let target = CGSize(width: max(1, (pixelWidth * factor).rounded()),
                            height: max(1, (pixelHeight * factor).rounded()))
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        format.opaque = true
        format.preferredRange = .standard
        // Drawing applies the orientation, so the result is upright and
        // carries no orientation flag (nor any other metadata).
        let rendered = UIGraphicsImageRenderer(size: target, format: format).image { context in
            UIColor.black.setFill()
            context.fill(CGRect(origin: .zero, size: target))
            image.draw(in: CGRect(origin: .zero, size: target))
        }
        for quality in [FriendsPhotoLimits.jpegQuality, 0.6, 0.5] {
            guard let data = rendered.jpegData(compressionQuality: quality) else {
                throw FriendsPhotoError.unreadableImage
            }
            if data.count <= FriendsPhotoLimits.maxBytes {
                return Prepared(data: data, width: Int(target.width), height: Int(target.height))
            }
        }
        throw FriendsPhotoError.tooLarge
    }

    /// A photo for the composer's preview and for `prepare`: at most
    /// `maxSide` px on the long side (a 48 MP camera shot is ≈ 190 MB
    /// decoded), upright. Smaller images come back as they are.
    static func displayCopy(_ image: UIImage, maxSide: CGFloat = 2048) -> UIImage {
        let pixelWidth = image.size.width * image.scale
        let pixelHeight = image.size.height * image.scale
        let longest = max(pixelWidth, pixelHeight)
        guard longest > maxSide, pixelWidth >= 1, pixelHeight >= 1 else { return image }
        let factor = maxSide / longest
        let target = CGSize(width: (pixelWidth * factor).rounded(), height: (pixelHeight * factor).rounded())
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        format.opaque = true
        return UIGraphicsImageRenderer(size: target, format: format).image { _ in
            image.draw(in: CGRect(origin: .zero, size: target))
        }
    }

    /// A JPEG decoded now (call off the main thread), so drawing it later
    /// doesn't decode on the main thread while the feed scrolls.
    static func decoded(_ data: Data) -> UIImage? {
        guard let image = UIImage(data: data) else { return nil }
        return image.preparingForDisplay() ?? image
    }

    // MARK: Disk cache

    static let maxAge: TimeInterval = 30 * 24 * 60 * 60

    static var directory: URL? {
        guard let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        let dir = caches.appendingPathComponent("friend-photos", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }

    /// The file for a post: its id, letters, digits, - and _ only.
    static func fileURL(_ key: String) -> URL? {
        let safe = String(key.unicodeScalars.filter {
            CharacterSet.alphanumerics.contains($0) || $0 == "-" || $0 == "_"
        }.map(Character.init).prefix(80))
        guard !safe.isEmpty else { return nil }
        return directory?.appendingPathComponent(safe + ".jpg")
    }

    static func readDisk(_ key: String) -> UIImage? {
        guard let url = fileURL(key), let data = try? Data(contentsOf: url) else { return nil }
        return decoded(data)
    }

    static func writeDisk(_ key: String, data: Data) {
        guard let url = fileURL(key) else { return }
        try? data.write(to: url, options: [.atomic, .completeFileProtectionUntilFirstUserAuthentication])
    }

    static func removeDisk(_ key: String) {
        guard let url = fileURL(key) else { return }
        try? FileManager.default.removeItem(at: url)
    }

    /// Removes files older than 30 days (or everything, signing out).
    static func cleanDisk(all: Bool = false, now: Date = Date()) {
        guard let dir = directory,
              let files = try? FileManager.default.contentsOfDirectory(
                at: dir, includingPropertiesForKeys: [.contentModificationDateKey]) else { return }
        for file in files {
            let modified = (try? file.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate
            if all || (modified.map { now.timeIntervalSince($0) > maxAge } ?? true) {
                try? FileManager.default.removeItem(at: file)
            }
        }
    }

    // MARK: Download

    /// Where a post's photo is read from, and the header it needs.
    struct Source: Sendable {
        var url: URL
        var bearer: String?
    }

    /// Cloud Storage's REST URL for an object (works with storage.rules).
    static func storageURL(bucket: String, path: String, emulator: Bool) -> URL? {
        var allowed = CharacterSet.alphanumerics
        allowed.insert(charactersIn: "-._~")
        guard let encoded = path.addingPercentEncoding(withAllowedCharacters: allowed) else { return nil }
        let host = emulator ? "http://127.0.0.1:9199" : "https://firebasestorage.googleapis.com"
        return URL(string: "\(host)/v0/b/\(bucket)/o/\(encoded)?alt=media")
    }

    /// No URL cache and no cookies: the only copy on the device is the one
    /// FriendsPhotoService keeps (and removes when access ends).
    private static let session: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.urlCache = nil
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.httpCookieStorage = nil
        return URLSession(configuration: configuration)
    }()

    static func download(_ source: Source) async throws -> Data {
        var request = URLRequest(url: source.url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
        if let bearer = source.bearer { request.setValue("Firebase \(bearer)", forHTTPHeaderField: "Authorization") }
        let (data, response) = try await session.data(for: request)
        let status = (response as? HTTPURLResponse)?.statusCode ?? 0
        switch status {
        case 200..<300: return data
        case 401, 403, 404: throw FriendsPhotoError.gone
        default: throw FriendsPhotoError.friends(.unavailable)
        }
    }

    // MARK: Sample (DEBUG screens, no network)

    /// A gradient with a symbol, standing in for a photo.
    static func placeholder(seed: String, symbol: String = "dumbbell.fill",
                            size: CGSize = CGSize(width: 1080, height: 1350)) -> UIImage {
        let palettes: [(UIColor, UIColor)] = [
            (UIColor(red: 1.00, green: 0.42, blue: 0.21, alpha: 1), UIColor(red: 0.85, green: 0.12, blue: 0.40, alpha: 1)),
            (UIColor(red: 0.18, green: 0.55, blue: 1.00, alpha: 1), UIColor(red: 0.45, green: 0.20, blue: 0.90, alpha: 1)),
            (UIColor(red: 0.10, green: 0.78, blue: 0.55, alpha: 1), UIColor(red: 0.05, green: 0.40, blue: 0.55, alpha: 1)),
            (UIColor(red: 1.00, green: 0.78, blue: 0.20, alpha: 1), UIColor(red: 0.95, green: 0.40, blue: 0.15, alpha: 1)),
            (UIColor(red: 0.55, green: 0.35, blue: 0.95, alpha: 1), UIColor(red: 0.95, green: 0.35, blue: 0.70, alpha: 1)),
        ]
        let index = Int(seed.unicodeScalars.reduce(UInt32(0)) { ($0 &* 31) &+ $1.value } % UInt32(palettes.count))
        let (top, bottom) = palettes[index]
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        format.opaque = true
        return UIGraphicsImageRenderer(size: size, format: format).image { context in
            let colors = [top.cgColor, bottom.cgColor] as CFArray
            if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors, locations: [0, 1]) {
                context.cgContext.drawLinearGradient(gradient, start: .zero,
                                                     end: CGPoint(x: size.width, y: size.height), options: [])
            }
            let config = UIImage.SymbolConfiguration(pointSize: size.width * 0.32, weight: .semibold)
            if let glyph = UIImage(systemName: symbol, withConfiguration: config)?
                .withTintColor(UIColor.white.withAlphaComponent(0.9), renderingMode: .alwaysOriginal) {
                let rect = CGRect(x: (size.width - glyph.size.width) / 2, y: (size.height - glyph.size.height) / 2,
                                  width: glyph.size.width, height: glyph.size.height)
                glyph.draw(in: rect)
            }
        }
    }
}

/// A post's photo, loaded through FriendsPhotoService's caches; a quiet
/// placeholder until it arrives.
struct FriendPhotoAsyncImage: View {
    var post: FriendPhotoPost
    var contentMode: ContentMode = .fill

    @State private var image: UIImage?
    @State private var failed = false

    var body: some View {
        ZStack {
            Rectangle().fill(DS.surfaceRaised)
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .transition(.opacity)
            } else if failed {
                StyledSymbol(name: "photo", size: 22)
                    .foregroundStyle(DS.silver.opacity(0.5))
            } else {
                ProgressView().tint(DS.silver)
            }
        }
        .clipped()
        .task(id: post.id) {
            let service = FriendsPhotoService.shared
            if let cached = service.cachedImage(for: post) {
                image = cached
                return
            }
            let loaded = await service.image(for: post)
            guard !Task.isCancelled else { return }
            withAnimation(.easeOut(duration: 0.2)) {
                image = loaded
                failed = loaded == nil
            }
        }
        // Off screen, a feed row lets go of its bitmap (the service's
        // byte-bounded cache keeps recent ones); back on screen, the task
        // above runs again.
        .onDisappear { image = nil }
        .accessibilityLabel(Text(post.caption ?? String(localized: "Photo", comment: "Friends photo accessibility label")))
    }
}
