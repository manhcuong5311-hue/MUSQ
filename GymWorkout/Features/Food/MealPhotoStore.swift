//
//  MealPhotoStore.swift
//  GymWorkout
//
//  A small picture of a scanned meal (2026-11-27), kept on this device only
//  so the meal editor and Today's meal rows can show what was eaten: a JPEG
//  of at most 600 px at Application Support/Daily/meal-photos/<meal id>.jpg.
//  It's never uploaded (the scan sends its own copy once, to be read) and
//  goes when the meal is deleted. `MealEntry` has no field for it: the
//  meal's id names the file.
//

import UIKit

nonisolated enum MealPhotoStore {
    /// Pictures already read, by meal id.
    nonisolated(unsafe) private static let cache: NSCache<NSUUID, UIImage> = {
        let cache = NSCache<NSUUID, UIImage>()
        cache.countLimit = 60
        return cache
    }()

    /// Meals already looked up with no picture on disk, so a redraw of a
    /// typed meal's row doesn't read the disk again.
    nonisolated(unsafe) private static let absent: NSCache<NSUUID, NSNull> = {
        let cache = NSCache<NSUUID, NSNull>()
        cache.countLimit = 400
        return cache
    }()

    static var folder: URL {
        FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Daily", isDirectory: true)
            .appendingPathComponent("meal-photos", isDirectory: true)
    }

    private static func url(for id: UUID) -> URL {
        folder.appendingPathComponent("\(id.uuidString).jpg")
    }

    /// Keeps a small copy of the photo for the meal; quietly does nothing
    /// if it can't.
    @MainActor
    static func save(_ photo: UIImage, for id: UUID) {
        let small = downsized(photo, maxPixel: 600)
        cache.setObject(small, forKey: id as NSUUID)
        absent.removeObject(forKey: id as NSUUID)
        guard let data = small.jpegData(compressionQuality: 0.7) else { return }
        let target = url(for: id)
        Task.detached(priority: .utility) {
            try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
            try? data.write(to: target, options: [.atomic, .completeFileProtectionUntilFirstUserAuthentication])
        }
    }

    /// The meal's picture, when one was kept.
    static func photo(for id: UUID) -> UIImage? {
        if let cached = cache.object(forKey: id as NSUUID) { return cached }
        if absent.object(forKey: id as NSUUID) != nil { return nil }
        guard let image = UIImage(contentsOfFile: url(for: id).path) else {
            absent.setObject(NSNull(), forKey: id as NSUUID)
            return nil
        }
        cache.setObject(image, forKey: id as NSUUID)
        return image
    }

    static func delete(for id: UUID) {
        cache.removeObject(forKey: id as NSUUID)
        try? FileManager.default.removeItem(at: url(for: id))
    }

    /// Removes pictures of meals no longer logged (deleted elsewhere, or
    /// trimmed from the log). Only pictures older than two days, and never
    /// when the log reads as empty, so a log that failed to load loses
    /// nothing.
    static func prune(keeping ids: Set<UUID>) {
        guard !ids.isEmpty,
              let files = try? FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: [.contentModificationDateKey])
        else { return }
        let cutoff = Date().addingTimeInterval(-2 * 24 * 3600)
        for file in files where file.pathExtension == "jpg" {
            guard let id = UUID(uuidString: file.deletingPathExtension().lastPathComponent), !ids.contains(id) else { continue }
            let modified = (try? file.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date()
            if modified < cutoff { try? FileManager.default.removeItem(at: file) }
        }
    }

    /// At most `maxPixel` on the longer side, drawn at scale 1.
    @MainActor
    private static func downsized(_ image: UIImage, maxPixel: CGFloat) -> UIImage {
        let size = CGSize(width: image.size.width * image.scale, height: image.size.height * image.scale)
        let longer = max(size.width, size.height)
        guard longer > maxPixel, longer > 0 else { return image }
        let ratio = maxPixel / longer
        let target = CGSize(width: (size.width * ratio).rounded(), height: (size.height * ratio).rounded())
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        format.opaque = true
        return UIGraphicsImageRenderer(size: target, format: format).image { _ in
            image.draw(in: CGRect(origin: .zero, size: target))
        }
    }
}
