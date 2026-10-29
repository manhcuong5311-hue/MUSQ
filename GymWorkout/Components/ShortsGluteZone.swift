//
//  ShortsGluteZone.swift
//  GymWorkout
//
//  Since 2026-10-28 the male bodies' shorts sit wholly over the muscles
//  (`AnatomyBody.usdc` / `AnatomyBodyV2.usdc` refitted), so a lift that works
//  the glutes would show none of its red: they are under the fabric. The
//  fabric over them takes their paint instead (the owner's pick of three
//  looks). Two masks over the shorts' own UVs, baked from the body by
//  `Tools/model-pipeline/shorts/make_mask.py`, hold where the shorts cover
//  each side's glutes: `ShortsGluteMask.png` the gluteus maximus, down the
//  back to the hem (a deep hinge pulls the hem up over the buttock), and
//  `ShortsGluteMaskMedius.png` the medius and minimus at the side of the hip;
//  red the left side, green the right, soft-edged. The shorts' colour is
//  mixed toward each muscle's own paint through them, so an abduction lift
//  that works the medius lights the side of the hip, and a one-sided lift
//  its working side only.
//
//  Base colour only: RealityKit ignores an emissive texture on these
//  materials and spreads the emissive colour over the whole of the shorts
//  (tried 2026-10-28). The glow goes into the base colour instead, the way
//  the model pipeline reads a paint's level (`tiers.py`): the larger of the
//  diffuse and the emissive over 0.153, the files' full glow.
//

import RealityKit
import UIKit
import ImageIO

enum ShortsGluteZone {
    /// The shorts' slot in a model and the paint of each glute it covers
    /// (linear); a nil paint is unlit.
    struct Wear {
        var slot: Int
        var maximus: (left: SIMD3<Float>?, right: SIMD3<Float>?)
        var medius: (left: SIMD3<Float>?, right: SIMD3<Float>?)

        var lit: Bool {
            maximus.left != nil || maximus.right != nil || medius.left != nil || medius.right != nil
        }
    }

    /// What a body wears, from the file meshes using each of its material
    /// slots (`users`): the slot only the shorts use, and the glutes' paint.
    /// Nil for a body without the male shorts (the female bodies' are
    /// textured `MUSQ_Shorts`).
    @MainActor static func wear(of mesh: ModelEntity, users: [Int: [String]],
                                unlit: (UIColor) -> Bool) -> Wear? {
        guard let materials = mesh.model?.materials,
              let slot = users.filter({ $0.value.allSatisfy { $0.hasPrefix("Anatomy_Shorts") } }).keys.min()
        else { return nil }
        /// The brightest lit paint among the slots that `prefixes` use.
        func paint(_ prefixes: [String]) -> SIMD3<Float>? {
            let slots = users.filter { $0.value.contains { id in prefixes.contains { id.hasPrefix($0) } } }.keys
            return slots.sorted().compactMap { slot -> SIMD3<Float>? in
                guard slot < materials.count, let glutes = materials[slot] as? PhysicallyBasedMaterial,
                      !unlit(glutes.baseColor.tint) else { return nil }
                let glow = linear(glutes.emissiveColor.color) * glutes.emissiveIntensity
                return simd_max(linear(glutes.baseColor.tint), glow / 0.153)
            }.max { $0.x < $1.x }
        }
        return Wear(slot: slot,
                    maximus: (paint(["GluteusMaximus_L"]), paint(["GluteusMaximus_R"])),
                    medius: (paint(["GluteusMedius_L", "GluteusMinimus_L"]),
                             paint(["GluteusMedius_R", "GluteusMinimus_R"])))
    }

    /// The shorts' base colour for a fabric colour and the glutes' paint,
    /// made once per combination: every model with the same paint shares it.
    @MainActor static func texture(fabric: UIColor, wear: Wear) -> TextureResource? {
        guard let masks else { return nil }
        let base = linear(fabric)
        let key = Key(fabric: base, paints: [wear.maximus.left, wear.maximus.right, wear.medius.left, wear.medius.right])
        if let done = made[key] { return done }
        // Plain fabric everywhere, then only the covered texels mix.
        var texels = [UInt32](repeating: packed(base), count: masks.size * masks.size)
        for texel in masks.covered {
            var colour = base
            for (paint, cover) in zip(key.paints, texel.cover) where cover > 0 {
                if let paint { colour += (paint - colour) * cover }
            }
            texels[texel.index] = packed(colour)
        }
        guard let space = CGColorSpace(name: CGColorSpace.sRGB),
              let provider = CGDataProvider(data: texels.withUnsafeBytes { Data($0) } as CFData),
              let image = CGImage(width: masks.size, height: masks.size, bitsPerComponent: 8, bitsPerPixel: 32,
                                  bytesPerRow: masks.size * 4, space: space,
                                  bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipLast.rawValue),
                                  provider: provider, decode: nil, shouldInterpolate: true, intent: .defaultIntent),
              let texture = try? TextureResource(image: image, options: .init(semantic: .color))
        else { return nil }
        made[key] = texture
        return texture
    }

    private struct Key: Hashable {
        var fabric: SIMD3<Float>
        var paints: [SIMD3<Float>?]
    }

    @MainActor private static var made: [Key: TextureResource] = [:]

    /// The two masks, read once: their side, and each covered texel with its
    /// cover by the left and right maximus, then the left and right medius.
    @MainActor private static let masks: (size: Int, covered: [(index: Int, cover: [Float])])? = {
        guard let maximus = pixels("ShortsGluteMask"), let medius = pixels("ShortsGluteMaskMedius"),
              maximus.size == medius.size
        else { return nil }
        var covered: [(index: Int, cover: [Float])] = []
        for i in 0..<maximus.size * maximus.size {
            let cover = [maximus.bytes[i * 4], maximus.bytes[i * 4 + 1], medius.bytes[i * 4], medius.bytes[i * 4 + 1]]
            if cover.contains(where: { $0 > 0 }) { covered.append((i, cover.map { Float($0) / 255 })) }
        }
        return (maximus.size, covered)
    }()

    /// A square mask's RGBA bytes from the bundle.
    private static func pixels(_ name: String) -> (size: Int, bytes: [UInt8])? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "png"),
              let source = CGImageSourceCreateWithURL(url as CFURL, nil),
              let image = CGImageSourceCreateImageAtIndex(source, 0, nil),
              image.width == image.height,
              let space = CGColorSpace(name: CGColorSpace.sRGB),
              let context = CGContext(data: nil, width: image.width, height: image.height, bitsPerComponent: 8,
                                      bytesPerRow: image.width * 4, space: space,
                                      bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
        else { return nil }
        context.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))
        guard let data = context.data?.assumingMemoryBound(to: UInt8.self) else { return nil }
        return (image.width, Array(UnsafeBufferPointer(start: data, count: image.width * image.height * 4)))
    }

    /// sRGB bytes for 4096 steps of linear light, so a texture needs no `pow`
    /// per texel.
    private static let encoded: [UInt8] = (0..<4096).map { step in
        let x = Float(step) / 4095
        let y = x <= 0.0031308 ? 12.92 * x : 1.055 * pow(x, 1 / 2.4) - 0.055
        return UInt8((min(max(y, 0), 1) * 255).rounded())
    }

    /// A linear colour as one RGBX texel, red in the lowest byte.
    private static func packed(_ colour: SIMD3<Float>) -> UInt32 {
        func byte(_ c: Float) -> UInt32 { UInt32(encoded[Int((min(max(c, 0), 1) * 4095).rounded())]) }
        return byte(colour.x) | byte(colour.y) << 8 | byte(colour.z) << 16 | 0xFF00_0000
    }

    /// A colour's linear light, whatever space it was made in.
    private static func linear(_ colour: UIColor) -> SIMD3<Float> {
        guard let space = CGColorSpace(name: CGColorSpace.extendedLinearSRGB),
              let converted = colour.cgColor.converted(to: space, intent: .defaultIntent, options: nil),
              let c = converted.components, c.count >= 3
        else { return .zero }
        return SIMD3(Float(c[0]), Float(c[1]), Float(c[2]))
    }
}
