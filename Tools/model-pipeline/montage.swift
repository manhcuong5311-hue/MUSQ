import Foundation
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers
// usage: montage out.png in1.png ... — crops each to the viewport band, lays out in a row
let args = CommandLine.arguments
let out = URL(fileURLWithPath: args[1])
let imgs = args.dropFirst(2).compactMap { p -> CGImage? in
    guard let src = CGImageSourceCreateWithURL(URL(fileURLWithPath: p) as CFURL, nil) else { return nil }
    return CGImageSourceCreateImageAtIndex(src, 0, nil)
}
let top = Double(ProcessInfo.processInfo.environment["CROP_TOP"] ?? "0.13")!
let bot = Double(ProcessInfo.processInfo.environment["CROP_BOT"] ?? "0.72")!
let w = imgs[0].width, h = imgs[0].height
let cy0 = Int(Double(h) * top), ch = Int(Double(h) * (bot - top))
let ctx = CGContext(data: nil, width: w * imgs.count, height: ch, bitsPerComponent: 8, bytesPerRow: 0,
                    space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
for (i, img) in imgs.enumerated() {
    let crop = img.cropping(to: CGRect(x: 0, y: cy0, width: w, height: ch))!
    ctx.draw(crop, in: CGRect(x: i * w, y: 0, width: w, height: ch))
}
let dest = CGImageDestinationCreateWithURL(out as CFURL, UTType.png.identifier as CFString, 1, nil)!
CGImageDestinationAddImage(dest, ctx.makeImage()!, nil)
CGImageDestinationFinalize(dest)
