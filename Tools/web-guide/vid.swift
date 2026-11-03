// Video helpers for the web guide's app demos (AVFoundation; no ffmpeg here).
//   swift vid.swift frames <in.mov> <outdir> <t1,t2,...>
//   swift vid.swift encode <in.mov> <out.mp4> <start> <duration> <width> <bitsPerSecond>
// Simulator recordings are variable frame rate, so frames are fetched with a
// 0.1 s tolerance.
import AVFoundation
import Foundation
import ImageIO
import UniformTypeIdentifiers

let args = CommandLine.arguments
let asset = AVURLAsset(url: URL(fileURLWithPath: args[2]))

func cgImage(at t: Double) -> CGImage? {
    let gen = AVAssetImageGenerator(asset: asset)
    gen.appliesPreferredTrackTransform = true
    gen.requestedTimeToleranceBefore = CMTime(seconds: 0.1, preferredTimescale: 600)
    gen.requestedTimeToleranceAfter = CMTime(seconds: 0.1, preferredTimescale: 600)
    return try? gen.copyCGImage(at: CMTime(seconds: t, preferredTimescale: 600), actualTime: nil)
}

switch args[1] {
case "frames":
    for t in args[4].split(separator: ",").compactMap({ Double($0) }) {
        guard let img = cgImage(at: t) else { continue }
        let url = URL(fileURLWithPath: "\(args[3])/f\(String(format: "%05.2f", t)).png")
        let dest = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil)!
        CGImageDestinationAddImage(dest, img, nil)
        CGImageDestinationFinalize(dest)
    }
case "encode":
    let out = URL(fileURLWithPath: args[3])
    let start = Double(args[4])!, length = Double(args[5])!
    let width = Int(args[6])!, bps = Int(args[7])!
    try? FileManager.default.removeItem(at: out)
    let track = asset.tracks(withMediaType: .video)[0]
    let size = track.naturalSize
    var height = Int((Double(width) * Double(size.height) / Double(size.width)).rounded())
    height += height % 2
    let reader = try! AVAssetReader(asset: asset)
    reader.timeRange = CMTimeRange(start: CMTime(seconds: start, preferredTimescale: 600),
                                   duration: CMTime(seconds: length, preferredTimescale: 600))
    let output = AVAssetReaderTrackOutput(track: track, outputSettings: [
        kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA])
    reader.add(output)
    let writer = try! AVAssetWriter(outputURL: out, fileType: .mp4)
    writer.shouldOptimizeForNetworkUse = true
    let input = AVAssetWriterInput(mediaType: .video, outputSettings: [
        AVVideoCodecKey: AVVideoCodecType.h264,
        AVVideoWidthKey: width,
        AVVideoHeightKey: height,
        AVVideoScalingModeKey: AVVideoScalingModeResizeAspectFill,
        AVVideoCompressionPropertiesKey: [
            AVVideoAverageBitRateKey: bps,
            AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel,
            AVVideoMaxKeyFrameIntervalKey: 60,
            AVVideoExpectedSourceFrameRateKey: 30,
        ],
    ])
    input.expectsMediaDataInRealTime = false
    writer.add(input)
    reader.startReading()
    writer.startWriting()
    writer.startSession(atSourceTime: CMTime(seconds: start, preferredTimescale: 600))
    let done = DispatchSemaphore(value: 0)
    input.requestMediaDataWhenReady(on: DispatchQueue(label: "enc")) {
        while input.isReadyForMoreMediaData {
            if let buf = output.copyNextSampleBuffer() {
                input.append(buf)
            } else {
                input.markAsFinished()
                writer.finishWriting { done.signal() }
                return
            }
        }
    }
    done.wait()
    print("encoded", width, "x", height, writer.status == .completed ? "ok" : "failed \(String(describing: writer.error))")
default:
    print("unknown mode")
}
