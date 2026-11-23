import CoreImage
import CoreML
import Foundation
import ImageIO
import Vision
#if DEBUG
import os
private let log = Logger(subsystem: "com.SamCorp.GymWorkout", category: "FaceRestore")
#endif

/// Puts the member's own face back on a goal photo.
///
/// The image model redraws the whole frame, face included, and no setting
/// locks a face in place: OpenAI's advice for anything that must stay
/// exactly as it was is to composite it back from the original. So the
/// inner face (brows to chin, ear to ear) of the photo the member sent is
/// lined up on the edit's face with a similarity transform fitted to the
/// eyes, brows, nose and lips, matched to the edit's colour, and blended in
/// with a soft edge. The neck, body, hair and background stay the edit's,
/// so a thicker neck or broader shoulders still show. It all runs on the
/// phone; nothing more leaves it.
///
/// Images are upright (EXIF orientation already applied), as the app
/// uploads them and as the server returns them.
nonisolated enum FaceRestore {
    /// Why the original face was not put back; the edit is then shown as it came.
    enum Skip: Error, Equatable {
        /// No face in the original or in the edit.
        case noFace
        /// The face is too small for reliable landmarks.
        case tooSmall
        /// The edit turned, tilted or rescaled the head, so the original face would not line up.
        case headMoved
    }

    /// What a check of the photo before upload found.
    enum Check: Equatable {
        case clear
        /// A face, but small in the frame: the edit may not keep it as well.
        case small
        /// No face found.
        case none
        /// Someone else is in it too, about as close to the camera: only the
        /// member's own photo may be sent (review F4).
        case several
    }

    /// Whether the photo shows one face big enough to keep well. In tests a
    /// face about an eighth of the frame's height kept well; much smaller
    /// faces get redrawn more. A second face at least half the size of the
    /// largest means another person beside the member; faces far smaller
    /// (people far behind in a gym, reflections) don't count.
    static func check(_ image: CGImage) -> Check {
        let faces = faces(in: image, landmarks: false)
            .sorted { $0.boundingBox.height > $1.boundingBox.height }
        guard let face = faces.first else { return .none }
        if faces.count > 1, faces[1].boundingBox.height >= face.boundingBox.height * 0.5 { return .several }
        let height = face.boundingBox.height * CGFloat(image.height)
        return height < CGFloat(max(image.width, image.height)) * 0.07 ? .small : .clear
    }

    /// The edit with the original's inner face blended back in.
    static func restore(original: CGImage, edited: CGImage) -> Result<CGImage, Skip> {
        let oSize = CGSize(width: original.width, height: original.height)
        let eSize = CGSize(width: edited.width, height: edited.height)
        guard let lo = largestFace(in: original, landmarks: true)?.landmarks,
              let le = largestFace(in: edited, landmarks: true)?.landmarks else { return .failure(.noFace) }
        let p = anchors(lo, oSize), q = anchors(le, eSize)
        let contour = points(lo.faceContour, oSize)
        guard p.count == q.count, p.count >= 12, contour.count >= 6 else { return .failure(.noFace) }
        guard let minX = contour.map(\.x).min(), let maxX = contour.map(\.x).max() else { return .failure(.noFace) }
        let faceWidth = maxX - minX
        guard faceWidth >= 60 else { return .failure(.tooSmall) }
        guard let fit = similarity(from: p, to: q), abs(fit.scale - 1) < 0.2, abs(fit.degrees) < 12 else {
            return .failure(.headMoved)
        }

        // The inner-face outline in the edit's frame: the jaw contour (temple,
        // round the chin, to the other temple), then the brows lifted towards
        // the forehead, back across.
        let t = fit.transform
        let jaw = contour.map { $0.applying(t) }
        let brows = (points(lo.leftEyebrow, oSize) + points(lo.rightEyebrow, oSize)).map { $0.applying(t) }
        let eyes = (points(lo.leftEye, oSize) + points(lo.rightEye, oSize)).map { $0.applying(t) }
        let lips = points(lo.outerLips, oSize).map { $0.applying(t) }
        guard !brows.isEmpty, !eyes.isEmpty, !lips.isEmpty, let first = jaw.first, let last = jaw.last else {
            return .failure(.noFace)
        }
        let eyeCentre = mean(eyes), mouthCentre = mean(lips)
        let up = CGVector(dx: eyeCentre.x - mouthCentre.x, dy: eyeCentre.y - mouthCentre.y)
        let length = hypot(up.dx, up.dy)
        guard length > 1 else { return .failure(.noFace) }
        let unit = CGVector(dx: up.dx / length, dy: up.dy / length)
        let lift = length * 0.45
        let raised = brows.map { CGPoint(x: $0.x + unit.dx * lift, y: $0.y + unit.dy * lift) }
        // Across the face (perpendicular to "up"), to walk the brows from the
        // jaw's last point back to its first.
        let across = { (point: CGPoint) in point.x * unit.dy - point.y * unit.dx }
        let backwards = across(last) > across(first)
        let forehead = raised.sorted { backwards ? across($0) > across($1) : across($0) < across($1) }
        let outline = jaw + forehead

        guard let mask = mask(outline, size: eSize, feather: max(2, faceWidth * 0.035)) else { return .failure(.noFace) }
        let context = CIContext(options: [.workingColorSpace: CGColorSpace(name: CGColorSpace.sRGB) as Any])
        let editedImage = CIImage(cgImage: edited)
        var face = CIImage(cgImage: original).transformed(by: t)

        // The model may relight the frame a little: shift the original face's
        // colour to the edit's average inside the outline, within limits.
        let inside = mask.hard
        let have = average(face, inside: inside, context: context)
        let want = average(editedImage, inside: inside, context: context)
        if let have, let want {
            let bias = (0..<3).map { max(-0.08, min(0.08, want[$0] - have[$0])) }
            face = face.applyingFilter("CIColorMatrix", parameters: [
                "inputBiasVector": CIVector(x: bias[0], y: bias[1], z: bias[2], w: 0),
            ])
        }

        let blended = face
            .applyingFilter("CIBlendWithMask", parameters: [
                kCIInputBackgroundImageKey: editedImage,
                kCIInputMaskImageKey: mask.soft,
            ])
            .cropped(to: editedImage.extent)
        guard let sRGB = CGColorSpace(name: CGColorSpace.sRGB),
              let result = context.createCGImage(blended, from: editedImage.extent, format: .RGBA8, colorSpace: sRGB) else {
            return .failure(.noFace)
        }
        return .success(result)
    }

    // MARK: - Faces

    /// The largest face, in Vision's coordinates (normalised, origin bottom-left).
    private static func largestFace(in image: CGImage, landmarks: Bool) -> VNFaceObservation? {
        faces(in: image, landmarks: landmarks)
            .max { $0.boundingBox.width * $0.boundingBox.height < $1.boundingBox.width * $1.boundingBox.height }
    }

    private static func faces(in image: CGImage, landmarks: Bool) -> [VNFaceObservation] {
        let request: VNImageBasedRequest = landmarks ? VNDetectFaceLandmarksRequest() : VNDetectFaceRectanglesRequest()
        #if targetEnvironment(simulator)
        // The simulator has no Neural Engine: Vision's face models fail there
        // ("Could not create inference context") unless they run on the CPU.
        // Even then its landmarks wander from run to run, so the paste-back
        // is skipped there by the head-moved check; it can only be judged on
        // a device (or on a Mac, where the same code is stable).
        if let stages = try? request.supportedComputeStageDevices {
            for (stage, devices) in stages {
                if let cpu = devices.first(where: { if case .cpu = $0 { true } else { false } }) {
                    request.setComputeDevice(cpu, for: stage)
                }
            }
        }
        #endif
        do {
            try VNImageRequestHandler(cgImage: image, orientation: .up, options: [:]).perform([request])
        } catch {
            #if DEBUG
            log.error("Vision failed (landmarks \(landmarks)): \(String(describing: error), privacy: .public)")
            #endif
        }
        return (request.results as? [VNFaceObservation]) ?? []
    }

    /// A landmark region in pixels, origin bottom-left (as Core Image uses).
    private static func points(_ region: VNFaceLandmarkRegion2D?, _ size: CGSize) -> [CGPoint] {
        region?.pointsInImage(imageSize: size) ?? []
    }

    /// The points that hold still when only the body changes, in a fixed order.
    private static func anchors(_ face: VNFaceLandmarks2D, _ size: CGSize) -> [CGPoint] {
        [face.leftEye, face.rightEye, face.leftEyebrow, face.rightEyebrow, face.nose, face.noseCrest, face.outerLips]
            .flatMap { points($0, size) }
    }

    private static func mean(_ points: [CGPoint]) -> CGPoint {
        let n = CGFloat(max(points.count, 1))
        return CGPoint(x: points.map(\.x).reduce(0, +) / n, y: points.map(\.y).reduce(0, +) / n)
    }

    /// The least-squares similarity transform (scale, rotation, shift) taking `p` onto `q`.
    private static func similarity(from p: [CGPoint], to q: [CGPoint]) -> (transform: CGAffineTransform, scale: CGFloat, degrees: CGFloat)? {
        let pm = mean(p), qm = mean(q)
        var norm: CGFloat = 0, dot: CGFloat = 0, cross: CGFloat = 0
        for (a, b) in zip(p, q) {
            let px = a.x - pm.x, py = a.y - pm.y, qx = b.x - qm.x, qy = b.y - qm.y
            norm += px * px + py * py
            dot += px * qx + py * qy
            cross += px * qy - py * qx
        }
        guard norm > 0 else { return nil }
        let a = dot / norm, b = cross / norm
        let shift = CGPoint(x: qm.x - (a * pm.x - b * pm.y), y: qm.y - (b * pm.x + a * pm.y))
        return (CGAffineTransform(a: a, b: b, c: -b, d: a, tx: shift.x, ty: shift.y),
                (a * a + b * b).squareRoot(), atan2(b, a) * 180 / .pi)
    }

    // MARK: - Mask and colour

    /// The outline filled white on black at the edit's size: `hard` as drawn,
    /// `soft` pulled in and blurred by `feather` so the seam fades out inside
    /// the face.
    private static func mask(_ outline: [CGPoint], size: CGSize, feather: CGFloat) -> (hard: CIImage, soft: CIImage)? {
        guard let canvas = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8,
                                     bytesPerRow: 0, space: CGColorSpaceCreateDeviceGray(),
                                     bitmapInfo: CGImageAlphaInfo.none.rawValue) else { return nil }
        canvas.setFillColor(gray: 0, alpha: 1)
        canvas.fill(CGRect(origin: .zero, size: size))
        canvas.setFillColor(gray: 1, alpha: 1)
        canvas.addLines(between: outline)
        canvas.closePath()
        canvas.fillPath()
        guard let drawn = canvas.makeImage() else { return nil }
        let hard = CIImage(cgImage: drawn)
        let soft = hard
            .applyingFilter("CIMorphologyMinimum", parameters: [kCIInputRadiusKey: feather])
            .applyingFilter("CIGaussianBlur", parameters: [kCIInputRadiusKey: feather])
            .cropped(to: hard.extent)
        return (hard, soft)
    }

    /// The average red, green and blue inside the mask. Read as floats: the
    /// face is a small part of the frame, so 8 bits would round its share of
    /// the whole-image average to a few levels.
    private static func average(_ image: CIImage, inside mask: CIImage, context: CIContext) -> [CGFloat]? {
        let extent = CIVector(cgRect: mask.extent)
        let masked = image.applyingFilter("CIBlendWithMask", parameters: [
            kCIInputBackgroundImageKey: CIImage(color: .black).cropped(to: mask.extent),
            kCIInputMaskImageKey: mask,
        ])
        var sum = [Float](repeating: 0, count: 4), cover = [Float](repeating: 0, count: 4)
        let pixel = CGRect(x: 0, y: 0, width: 1, height: 1)
        context.render(masked.applyingFilter("CIAreaAverage", parameters: [kCIInputExtentKey: extent]),
                       toBitmap: &sum, rowBytes: 16, bounds: pixel, format: .RGBAf, colorSpace: nil)
        context.render(mask.applyingFilter("CIAreaAverage", parameters: [kCIInputExtentKey: extent]),
                       toBitmap: &cover, rowBytes: 16, bounds: pixel, format: .RGBAf, colorSpace: nil)
        guard cover[0] > 0.0001 else { return nil }
        return (0..<3).map { CGFloat(sum[$0] / cover[0]) }
    }
}
