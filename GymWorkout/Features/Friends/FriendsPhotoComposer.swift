//
//  FriendsPhotoComposer.swift
//  GymWorkout
//
//  Posting a photo check-in (2026-11-28). `.friendsPhotoCapture` opens the
//  camera (front/back flip is the system camera's own; the library on a
//  device without a camera, e.g. the simulator) or the library, then the
//  composer: preview, a short caption (120), today's workout tag (can be
//  removed) and one big "Share with friends". FriendsPhotoService shrinks
//  the photo and re-encodes it without metadata before it leaves.
//

import PhotosUI
import SwiftUI

extension View {
    /// Takes or picks a photo when `source` is set, then shows the composer.
    func friendsPhotoCapture(source: Binding<FriendsPhotoSource?>, onPosted: @escaping () -> Void) -> some View {
        modifier(FriendsPhotoCaptureModifier(source: source, onPosted: onPosted))
    }
}

/// A picked photo on its way into the composer.
struct FriendsPhotoDraft: Identifiable {
    let id = UUID()
    var image: UIImage
}

private struct FriendsPhotoCaptureModifier: ViewModifier {
    @Binding var source: FriendsPhotoSource?
    var onPosted: () -> Void

    @State private var showsCamera = false
    @State private var showsLibrary = false
    @State private var pickerItem: PhotosPickerItem?
    @State private var draft: FriendsPhotoDraft?
    /// The camera's photo, held until its cover has gone (a sheet can't
    /// open while the cover is still closing).
    @State private var shot: UIImage?

    func body(content: Content) -> some View {
        content
            .onChange(of: source) { _, new in
                guard let new else { return }
                source = nil
                if new == .camera && UIImagePickerController.isSourceTypeAvailable(.camera) {
                    showsCamera = true
                } else {
                    showsLibrary = true
                }
            }
            .fullScreenCover(isPresented: $showsCamera, onDismiss: {
                guard let taken = shot else { return }
                shot = nil
                // The camera's full-size shot (12–48 MP) is shrunk off the
                // main thread before the composer holds and shows it.
                Task {
                    let small = await Task.detached(priority: .userInitiated) {
                        FriendsPhotoImage.displayCopy(taken)
                    }.value
                    draft = FriendsPhotoDraft(image: small)
                }
            }) {
                CameraPicker { image in shot = image }
                    .ignoresSafeArea()
            }
            .photosPicker(isPresented: $showsLibrary, selection: $pickerItem, matching: .images)
            .onChange(of: pickerItem) { _, item in
                guard let item else { return }
                pickerItem = nil
                Task {
                    if let image = await PickedPhoto.load(item) {
                        draft = FriendsPhotoDraft(image: image)
                    }
                }
            }
            .sheet(item: $draft) { d in
                FriendsPhotoComposer(image: d.image, onPosted: onPosted)
            }
    }
}

struct FriendsPhotoComposer: View {
    @State var image: UIImage
    var onPosted: () -> Void

    static let captionLimit = 120

    private var photos: FriendsPhotoService { .shared }
    @Environment(\.dismiss) private var dismiss

    @State private var caption = ""
    @State private var tag: String?
    /// The workout tag was offered once; removing it sticks (onAppear runs
    /// again after Retake's camera cover closes).
    @State private var tagOffered = false
    @State private var error: String?
    @State private var showsCamera = false
    @State private var pickerItem: PhotosPickerItem?
    @FocusState private var captionFocused: Bool

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    preview
                    captionField
                    if let tag {
                        FriendsPhotoTagChip(text: tag) {
                            withAnimation(.snappy) { self.tag = nil }
                        }
                    }
                    if let error {
                        Text(error)
                            .font(.ui(13.5, .medium))
                            .foregroundStyle(DS.rhythmWaiting)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(.horizontal, DS.Metric.gutter)
                .padding(.top, 8)
                .padding(.bottom, 20)
                .friendsColumn()
            }
            .scrollDismissesKeyboard(.interactively)
            .background(DS.ink.ignoresSafeArea())
            .safeAreaInset(edge: .bottom, spacing: 0) { bottomBar }
            .navigationTitle(String(localized: "New photo"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Cancel")) { dismiss() }
                        .disabled(photos.isPosting)
                }
            }
        }
        .presentationBackground(DS.ink)
        .interactiveDismissDisabled(photos.isPosting)
        .onAppear {
            guard !tagOffered else { return }
            tagOffered = true
            tag = photos.autoTag()
        }
        .onChange(of: caption) { _, new in
            if new.count > Self.captionLimit { caption = String(new.prefix(Self.captionLimit)) }
        }
        .fullScreenCover(isPresented: $showsCamera) {
            CameraPicker { taken in
                Task {
                    image = await Task.detached(priority: .userInitiated) {
                        FriendsPhotoImage.displayCopy(taken)
                    }.value
                }
            }
            .ignoresSafeArea()
        }
        .onChange(of: pickerItem) { _, item in
            guard let item else { return }
            pickerItem = nil
            Task { if let picked = await PickedPhoto.load(item) { image = picked } }
        }
    }

    private var preview: some View {
        Color.clear
            .aspectRatio(4 / 5, contentMode: .fit)
            .overlay {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            }
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(alignment: .bottomTrailing) {
                HStack(spacing: 8) {
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        overlayButton("camera.rotate.fill", String(localized: "Retake")) { showsCamera = true }
                    }
                    PhotosPicker(selection: $pickerItem, matching: .images) {
                        overlayIcon("photo.on.rectangle")
                    }
                    .accessibilityLabel(String(localized: "Choose another photo"))
                }
                .padding(12)
                .disabled(photos.isPosting)
            }
    }

    private func overlayButton(_ symbol: String, _ label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) { overlayIcon(symbol) }
            .buttonStyle(.plain)
            .accessibilityLabel(label)
    }

    private func overlayIcon(_ symbol: String) -> some View {
        StyledSymbol(name: symbol, size: 16)
            .foregroundStyle(.white)
            .frame(width: 42, height: 42)
            .background(Circle().fill(.black.opacity(0.45)))
    }

    private var captionField: some View {
        VStack(alignment: .trailing, spacing: 4) {
            TextField(String(localized: "Say something (optional)"), text: $caption, axis: .vertical)
                .font(.ui(16))
                .lineLimit(1...4)
                .focused($captionFocused)
                .submitLabel(.done)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(DS.surface))
            Text("\(caption.count)/\(Self.captionLimit)")
                .font(.ui(11.5, .medium))
                .monospacedDigit()
                .foregroundStyle(caption.count >= Self.captionLimit ? DS.rhythmWaiting : DS.silver.opacity(0.4))
        }
    }

    private var bottomBar: some View {
        VStack(spacing: 8) {
            Button(action: share) {
                HStack(spacing: 8) {
                    if photos.isPosting {
                        ProgressView().tint(.white)
                    } else {
                        StyledSymbol(name: "paperplane.fill", size: 16)
                    }
                    Text(photos.isPosting ? String(localized: "Sharing…") : String(localized: "Share with friends"))
                }
            }
            .buttonStyle(FriendsCameraButtonStyle())
            .disabled(photos.isPosting)
            HStack(spacing: 5) {
                Image(systemName: "lock.fill").font(.system(size: 10, weight: .semibold))
                Text("Only your friends see it. Removed after 30 days.")
            }
            .font(.ui(12))
            .foregroundStyle(DS.silver.opacity(0.45))
        }
        .padding(.horizontal, DS.Metric.gutter)
        .padding(.top, 10)
        .padding(.bottom, 8)
        .frame(maxWidth: 640)
        .frame(maxWidth: .infinity)
        .background(DS.ink.opacity(0.96))
    }

    private func share() {
        captionFocused = false
        error = nil
        let text = caption.trimmingCharacters(in: .whitespacesAndNewlines)
        Task {
            do {
                try await photos.post(image: image, caption: text.isEmpty ? nil : text, tag: tag)
                onPosted()
                dismiss()
            } catch {
                self.error = friendsPhotoMessage(error)
            }
        }
    }
}
