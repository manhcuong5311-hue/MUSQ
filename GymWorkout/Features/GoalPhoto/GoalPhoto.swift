//
//  GoalPhoto.swift
//  GymWorkout
//
//  "See your goal": the member's own photo, edited by AI to the look they
//  pick (sex, muscle, body fat), with their own face put back on the phone.
//  v1 (2026-11-21) showed a year of training toward the plan's goal in
//  athletic wear. v2 (2026-11-23, owner-approved after a test on the owner's own
//  photos): the member picks the look, the edit keeps their clothes, and
//  FaceRestore pastes their face back, since no image model locks a face.
//  Free members get one goal photo, Premium 2 a year, Pro 5 a year. Adults
//  only, only their own photo, labelled as an illustration rather than a
//  prediction. The result, the photo it was made from and the goal record
//  stay on this device only (Application Support/GoalPhoto) and make the
//  Goal page (Features/Goal).
//

import ImageIO
import Photos
import PhotosUI
import SwiftUI
import UIKit
import UniformTypeIdentifiers
import UserNotifications

// MARK: - Storage

enum GoalPhotoSaveResult { case saved, denied, failed }

/// The goal photo files, on this device only: the result (`latest.jpg`) and
/// the photo it was made from (`before.jpg`); the record sits beside them
/// (GoalStore).
enum GoalPhotoStore {
    static var folder: URL {
        FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("GoalPhoto", isDirectory: true)
    }
    private static var latestURL: URL { folder.appendingPathComponent("latest.jpg") }
    private static var beforeURL: URL { folder.appendingPathComponent("before.jpg") }

    static var hasLatest: Bool { FileManager.default.fileExists(atPath: latestURL.path) }

    static func latestData() -> Data? { try? Data(contentsOf: latestURL) }

    static func latest() -> UIImage? { latestData().flatMap(UIImage.init(data:)) }

    static func before() -> UIImage? { (try? Data(contentsOf: beforeURL)).flatMap(UIImage.init(data:)) }

    /// Writes the goal photo. False when it couldn't be written.
    @discardableResult
    static func save(_ jpeg: Data) -> Bool { write(jpeg, to: latestURL) }

    @discardableResult
    static func saveBefore(_ jpeg: Data) -> Bool { write(jpeg, to: beforeURL) }

    static func delete() {
        try? FileManager.default.removeItem(at: latestURL)
    }

    static func deleteBefore() {
        try? FileManager.default.removeItem(at: beforeURL)
    }

    private static func write(_ data: Data, to url: URL) -> Bool {
        do {
            try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
            var url = url
            // "Unless open": the file can still be created if the device locks
            // while an edit is finishing, and is sealed again once closed.
            try data.write(to: url, options: [.atomic, .completeFileProtectionUnlessOpen])
            // A private picture: keep it out of iCloud and device backups.
            var values = URLResourceValues()
            values.isExcludedFromBackup = true
            try? url.setResourceValues(values)
            return true
        } catch {
            return false
        }
    }

    /// Adds the goal photo to the member's library, with its AI marking.
    static func saveLatestToPhotos() async -> GoalPhotoSaveResult {
        guard let jpeg = latestData() else { return .failed }
        return await saveToPhotos(jpeg)
    }

    static func saveToPhotos(_ jpeg: Data) async -> GoalPhotoSaveResult {
        let status = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
        guard status == .authorized || status == .limited else { return .denied }
        do {
            try await PHPhotoLibrary.shared().performChanges {
                PHAssetCreationRequest.forAsset().addResource(with: .photo, data: jpeg, options: nil)
            }
            return .saved
        } catch {
            return .failed
        }
    }
}

// MARK: - Face

/// Puts the member's own face back on the server's edit (FaceRestore) and
/// writes the JPEG that is kept and shown. The new file is marked as a
/// composite with AI-made content (IPTC digital source type), since the
/// server's own AI marking can't survive a re-encode. When the face can't
/// go back (none found, or the edit moved the head), the server's JPEG is
/// kept as it came.
nonisolated enum GoalPhotoComposer {
    static func compose(upload: Data, edited: Data) -> (jpeg: Data, restored: Bool) {
        guard let original = image(upload), let edit = image(edited) else { return (edited, false) }
        switch FaceRestore.restore(original: original, edited: edit) {
        case .success(let composite):
            guard let jpeg = encode(composite) else { return (edited, false) }
            return (jpeg, true)
        case .failure(let skip):
            #if DEBUG
            print("[GoalPhoto] face not put back: \(skip)")
            #endif
            return (edited, false)
        }
    }

    /// The face check before upload, on the image as it will be sent.
    static func check(upload: Data) -> FaceRestore.Check {
        image(upload).map(FaceRestore.check) ?? .none
    }

    private static func image(_ data: Data) -> CGImage? {
        CGImageSourceCreateWithData(data as CFData, nil).flatMap { CGImageSourceCreateImageAtIndex($0, 0, nil) }
    }

    private static func encode(_ image: CGImage) -> Data? {
        let data = NSMutableData()
        guard let destination = CGImageDestinationCreateWithData(data, UTType.jpeg.identifier as CFString, 1, nil) else {
            return nil
        }
        let metadata = CGImageMetadataCreateMutable()
        CGImageMetadataSetValueWithPath(metadata, nil, "Iptc4xmpExt:DigitalSourceType" as CFString,
                                        "http://cv.iptc.org/newscodes/digitalsourcetype/compositeWithTrainedAlgorithmicMedia" as CFString)
        CGImageMetadataSetValueWithPath(metadata, nil, "xmp:CreatorTool" as CFString,
                                        "MUSQ goal photo (OpenAI image edit, own face restored)" as CFString)
        CGImageDestinationAddImageAndMetadata(destination, image, metadata,
                                              [kCGImageDestinationLossyCompressionQuality: 0.92] as CFDictionary)
        return CGImageDestinationFinalize(destination) ? data as Data : nil
    }
}

// MARK: - Opening

/// Opens the goal from Today or Progress: the Goal page when there is one,
/// else the goal photo setup behind the checks a new photo needs (who can
/// make one, the allowance, sign-in and consent). Each host keeps one and
/// attaches `.goalLauncher(_:)`.
@Observable
final class GoalLauncher {
    var showsGoal = false
    var showsSetup = false
    var gate: AIGate?
    /// Signed in or agreed in a gate sheet: carry on once it has closed.
    var resumesAfterGate = false
    /// What to do once the Goal page has closed: a sheet can't open while
    /// another is still closing.
    var afterGoal: AfterGoal?
    /// The setup finished: open the new Goal page once it has closed.
    var opensGoalAfterSetup = false

    enum AfterGoal { case newPhoto, editSchedule }

    func open(profile: UserProfile?, purchases: Purchases, paywall: Paywall) {
        if GoalStore.shared.hasGoal {
            showsGoal = true
        } else {
            startNew(profile: profile, purchases: purchases, paywall: paywall)
        }
    }

    /// A new goal photo. A member without a plan whose free photo is used,
    /// or on Premium with this year's used, is offered a plan first; the
    /// server has the last word on what's left.
    func startNew(profile: UserProfile?, purchases: Purchases, paywall: Paywall) {
        guard GoalPhotoCard.canCreate(for: profile) else { return }
        if GoalPhotoCard.needsPlanForNew(purchases: purchases) {
            paywall.show(.goalPhoto)
            return
        }
        // The allowance is checked above (and by the server), so the gate
        // only asks for the account and the consent.
        switch AIGate.check(isPremium: true, consent: .goalPhoto) {
        case .ready, .paywall: showsSetup = true
        case .signIn: gate = .signIn
        case .consent: gate = .consent
        }
    }
}

private struct GoalLauncherModifier: ViewModifier {
    @Bindable var launcher: GoalLauncher
    var onEditSchedule: (() -> Void)?
    @Environment(WorkoutStore.self) private var store
    @Environment(Purchases.self) private var purchases
    @Environment(Paywall.self) private var paywall

    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $launcher.showsGoal, onDismiss: afterGoal) {
                GoalView(onNewPhoto: {
                    launcher.afterGoal = .newPhoto
                    launcher.showsGoal = false
                }, onEditSchedule: onEditSchedule.map { _ in {
                    launcher.afterGoal = .editSchedule
                    launcher.showsGoal = false
                } })
                .environment(store)
                .environment(purchases)
            }
            .sheet(isPresented: $launcher.showsSetup, onDismiss: afterSetup) {
                if let profile = store.profile {
                    GoalPhotoSheet(profile: profile) { launcher.opensGoalAfterSetup = true }
                        .environment(store)
                        .environment(purchases)
                }
            }
            .sheet(item: $launcher.gate, onDismiss: resume) { gate in
                switch gate {
                case .signIn: AISignInPrompt { launcher.resumesAfterGate = true }
                case .consent: AIConsentSheet(feature: .goalPhoto) { launcher.resumesAfterGate = true }
                case .paywall, .ready: EmptyView()
                }
            }
    }

    private func afterGoal() {
        let next = launcher.afterGoal
        launcher.afterGoal = nil
        switch next {
        case .newPhoto: launcher.startNew(profile: store.profile, purchases: purchases, paywall: paywall)
        case .editSchedule: onEditSchedule?()
        case nil: break
        }
    }

    private func afterSetup() {
        guard launcher.opensGoalAfterSetup else { return }
        launcher.opensGoalAfterSetup = false
        if GoalStore.shared.hasGoal { launcher.showsGoal = true }
    }

    private func resume() {
        guard launcher.resumesAfterGate else { return }
        launcher.resumesAfterGate = false
        launcher.startNew(profile: store.profile, purchases: purchases, paywall: paywall)
    }
}

extension View {
    /// The Goal page and the goal photo setup, opened through `launcher`.
    /// `onEditSchedule` opens the training days (the profile editor) after
    /// the Goal page has closed; without it the page doesn't offer to.
    func goalLauncher(_ launcher: GoalLauncher, onEditSchedule: (() -> Void)? = nil) -> some View {
        modifier(GoalLauncherModifier(launcher: launcher, onEditSchedule: onEditSchedule))
    }
}

// MARK: - Progress card

/// The way in, on the Progress tab: the goal, or an invitation to make one.
struct GoalPhotoCard: View {
    @Environment(WorkoutStore.self) private var store
    @Environment(Purchases.self) private var purchases
    @Environment(Paywall.self) private var paywall
    /// Owned by the Progress tab, above its layouts (see MuscleProgressView).
    var launcher: GoalLauncher

    /// Whether this member can make a goal photo: adults only, and not while
    /// pregnant or before the after-birth check-up, when a picture of a
    /// "fitter you" isn't the right thing to show. The profile has only a
    /// birth year, so 19 this year is what guarantees 18 or older.
    static func canCreate(for profile: UserProfile?) -> Bool {
        guard AIService.isLive, let profile, let age = profile.age() else { return false }
        if let health = profile.health, health.isPregnant || health.isPostpartumUncleared { return false }
        return age >= 19
    }

    /// A new photo needs a plan first: no plan and the free photo is used,
    /// or Premium with this year's photos used (Pro makes more). Unknown
    /// counts as not used, and the server decides.
    static func needsPlanForNew(purchases: Purchases) -> Bool {
        if !purchases.isPremium { return AIService.shared.freeGoalPhotoUsed == true }
        return !purchases.isPro && AIService.shared.goalPhotosLeft == 0
    }

    /// Whether the card shows: when a goal photo can be made, and always
    /// while a goal is kept, so it can still be seen and deleted.
    static func isAvailable(for profile: UserProfile?) -> Bool {
        canCreate(for: profile) || (AIService.isLive && GoalStore.shared.hasGoal)
    }

    var body: some View {
        let goals = GoalStore.shared
        Button { launcher.open(profile: store.profile, purchases: purchases, paywall: paywall) } label: {
            HStack(spacing: 14) {
                Group {
                    if let photo = goals.photo {
                        Image(uiImage: photo).resizable().scaledToFill()
                    } else {
                        ZStack {
                            DS.silver.opacity(0.06)
                            Image(systemName: "figure.strengthtraining.traditional")
                                .font(.system(size: 26, weight: .regular))
                                .foregroundStyle(DS.silver.opacity(0.7))
                        }
                    }
                }
                .frame(width: 64, height: 84)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(goals.hasGoal ? String(localized: "Your goal") : String(localized: "See your goal"))
                            .font(.ui(16, .semibold))
                            .foregroundStyle(DS.silver)
                        if let tag {
                            Text(tag)
                                .font(.mono(9, .semibold))
                                .trackingEm(0.08, size: 9)
                                .foregroundStyle(DS.silver.opacity(0.7))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .overlay(Capsule().strokeBorder(DS.silver.opacity(0.3), lineWidth: 1))
                        }
                    }
                    Text(subtitle)
                        .font(.ui(13))
                        .foregroundStyle(DS.silver.opacity(0.62))
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(DS.silver.opacity(0.35))
            }
            .padding(14)
            .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(DS.surfaceAlt))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    /// FREE while a member without a plan still has the free photo; PREMIUM
    /// once it is used.
    private var tag: String? {
        guard !GoalStore.shared.hasGoal, !purchases.isPremium else { return nil }
        return AIService.shared.freeGoalPhotoUsed == true
            ? String(localized: "PREMIUM", comment: "Tag: needs a plan")
            : String(localized: "FREE", comment: "Tag: the first goal photo is free")
    }

    private var subtitle: String {
        let goals = GoalStore.shared
        if goals.hasGoal, let progress = goals.progress(profile: store.profile, experience: store.experience,
                                                         trainedDays: store.trainedDays) {
            // The share in the locale's percent format, as on the Goal page.
            return String(localized: "\(progress.look.summary): \(GoalWords.percent(progress.fraction)) of the way. Tap for your goal page.",
                          comment: "Progress tab goal card; the look picked, then the share reached, e.g. Muscular · Athletic: 34% of the way")
        }
        if Self.needsPlanForNew(purchases: purchases) {
            return purchases.isPremium
                ? String(localized: "You've used this year's goal photos on Premium. Pro makes up to \(GoalPhotoAllowance.pro) a year.")
                : String(localized: "Your free goal photo is used. Premium makes \(GoalPhotoAllowance.premium) a year.")
        }
        return String(localized: "Pick the muscle and body fat you want and see yourself there, with your own face.")
    }
}

/// The allowances, as the paywall states them (Purchases.Tier.ai).
enum GoalPhotoAllowance {
    static var premium: Int { Purchases.Tier.premium.ai?.goalPhotosPerYear ?? 2 }
    static var pro: Int { Purchases.Tier.pro.ai?.goalPhotosPerYear ?? 5 }
}

// MARK: - Setup sheet

/// Making a goal photo: the photo, the look, the member's word that it's
/// them, then the edit, with their face put back. A new photo replaces the
/// goal kept before.
struct GoalPhotoSheet: View {
    var profile: UserProfile
    /// "See my goal": the host opens the Goal page once this has closed.
    var onOpenGoal: () -> Void = {}

    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    @Environment(WorkoutStore.self) private var store
    @Environment(Purchases.self) private var purchases

    private enum Phase: Equatable {
        case choose
        case working
        case result
        /// The allowance is used up.
        case limit
        case failed(String, canRetry: Bool)
    }

    @State private var phase: Phase = .choose
    @State private var photo: UIImage?
    @State private var sex: GoalSex?
    @State private var muscle: MuscleTarget = .toned
    @State private var fat: FatTarget = .same
    @State private var faceCheck: FaceRestore.Check?
    @State private var confirmsOwnPhoto = false
    @State private var pickerItem: PhotosPickerItem?
    /// The newest pick still loading from the library; older ones are dropped.
    @State private var loadID: UUID?
    @State private var loadFailed = false
    @State private var showsCamera = false
    /// The result shown, and the photo it was made from (the "Now" side).
    @State private var result: UIImage?
    @State private var resultBefore: UIImage?
    @State private var showsBefore = false
    @State private var faceRestored = true
    @State private var remaining: Int?
    @State private var remainingPeriod: String?
    @State private var confirmsDelete = false
    @State private var savedToPhotos = false
    @State private var photoAlert: GoalPhotoSaveResult?
    /// "Report this image" couldn't open a mail app: show the address instead.
    @State private var showsReportAddress = false
    /// A result that couldn't be written to the device yet.
    @State private var unsaved: (record: GoalRecord, photo: Data, before: Data)?
    @State private var showsPaywall = false
    @State private var showsSignIn = false
    @State private var notificationsAsked = true
    /// The look is set up once: the camera's full-screen cover makes the sheet
    /// appear again, which mustn't reset the member's picks (review).
    @State private var isSetUp = false
    /// The plan when the paywall opened: only a plan bought there carries on,
    /// so closing it never opens it again (review GP-1).
    @State private var tierAtPaywall: Purchases.Tier?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    switch phase {
                    case .choose: chooser
                    case .working: working
                    case .result: resultView
                    case .limit: limit
                    case .failed(let message, let canRetry): failure(message, canRetry: canRetry)
                    }
                }
                .padding(.horizontal, DS.Metric.gutter)
                .padding(.bottom, 24)
            }
            .background(DS.ink.ignoresSafeArea())
            .navigationTitle(String(localized: "Your goal photo"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(phase == .result ? String(localized: "Done") : String(localized: "Close")) { dismiss() }
                        .disabled(phase == .working)
                }
            }
            .interactiveDismissDisabled(phase == .working || unsaved != nil)
        }
        .tint(DS.silver)
        .onAppear(perform: setUp)
        .onChange(of: pickerItem) { _, item in load(item) }
        .onChange(of: sex) { _, _ in keepFatChoiceValid() }
        .onChange(of: muscle) { _, _ in keepFatChoiceValid() }
        // The screen stays on while the photo is edited: a locked phone
        // suspends the app, and the answer, already counted, would be lost.
        .onChange(of: phase) { _, phase in UIApplication.shared.isIdleTimerDisabled = phase == .working }
        .onDisappear { UIApplication.shared.isIdleTimerDisabled = false }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.protectedDataDidBecomeAvailableNotification)) { _ in
            if let pending = unsaved, GoalStore.shared.set(pending.record, photoJPEG: pending.photo, beforeJPEG: pending.before) {
                unsaved = nil
            }
        }
        .fullScreenCover(isPresented: $showsCamera) {
            CameraPicker { image in
                loadID = nil
                setPhoto(image)
            }
                .ignoresSafeArea()
        }
        .sheet(isPresented: $showsPaywall, onDismiss: paywallClosed) {
            PremiumView(reason: .goalPhoto, profile: profile)
                .environment(purchases)
        }
        .sheet(isPresented: $showsSignIn) { AISignInPrompt { generate() } }
        .confirmationDialog(String(localized: "Delete your goal?"), isPresented: $confirmsDelete, titleVisibility: .visible) {
            Button(String(localized: "Delete"), role: .destructive) { deleteResult() }
            Button(String(localized: "Cancel"), role: .cancel) {}
        } message: {
            Text(String(localized: "The goal photo and its progress are removed from this \(DS.deviceNoun). Save the photo first to keep it."))
        }
        .alert(photoAlert == .denied ? String(localized: "MUSQ can't save to Photos")
                                     : String(localized: "The photo couldn't be saved."),
               isPresented: Binding(get: { photoAlert == .denied || photoAlert == .failed },
                                    set: { if !$0 { photoAlert = nil } })) {
            if photoAlert == .denied {
                Button(String(localized: "Open Settings")) {
                    if let url = URL(string: UIApplication.openSettingsURLString) { UIApplication.shared.open(url) }
                }
                Button(String(localized: "Not now"), role: .cancel) {}
            } else {
                Button(String(localized: "OK"), role: .cancel) {}
            }
        } message: {
            Text(photoAlert == .denied ? String(localized: "Let MUSQ add photos in Settings, then try again.")
                                       : String(localized: "Try again."))
        }
    }

    // MARK: Phases

    private var chooser: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Pick the look you're aiming for. Only your body changes: your face and clothes stay yours.")
                .font(.ui(15))
                .foregroundStyle(DS.silver.opacity(0.75))
                .fixedSize(horizontal: false, vertical: true)
            if let photo {
                Image(uiImage: photo)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 340)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .accessibilityLabel(String(localized: "Your photo"))
            } else {
                Text("Use a clear, well-lit photo of yourself from the waist up, face showing, in fitted clothes. Mirror selfies work.")
                    .font(.ui(13.5))
                    .foregroundStyle(DS.silver.opacity(0.6))
                    .fixedSize(horizontal: false, vertical: true)
            }
            if let note = faceNote {
                Label(note, systemImage: "face.dashed")
                    .font(.ui(13, .semibold))
                    .foregroundStyle(DS.silver.opacity(0.75))
                    .fixedSize(horizontal: false, vertical: true)
            }
            if loadID != nil {
                HStack(spacing: 8) {
                    ProgressView()
                    Text("Loading the photo…")
                }
                .font(.ui(13.5))
                .foregroundStyle(DS.silver.opacity(0.65))
            } else if loadFailed {
                Text("That photo couldn't be loaded. Try another one.")
                    .font(.ui(13.5))
                    .foregroundStyle(DS.silver.opacity(0.75))
                    .fixedSize(horizontal: false, vertical: true)
            }
            HStack(spacing: 10) {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    WideButton(title: String(localized: "Take photo"), prominent: false, fontSize: 15, verticalPadding: 13) {
                        showsCamera = true
                    }
                }
                PhotosPicker(selection: $pickerItem, matching: .images) {
                    Text(photo == nil ? String(localized: "Choose photo") : String(localized: "Another photo"))
                        .font(.ui(15, .semibold))
                        .foregroundStyle(DS.silver)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(RoundedRectangle(cornerRadius: 13, style: .continuous).fill(DS.silver.opacity(0.07)))
                }
                .buttonStyle(.plain)
            }
            lookPickers
            if photo != nil {
                // Asked for each photo: picking another turns it off again.
                Toggle(isOn: $confirmsOwnPhoto) {
                    Text("This is a photo of only me, and I'm 18 or older.")
                        .font(.ui(14.5, .semibold))
                        .foregroundStyle(DS.silver)
                }
                .tint(DS.silver)
                .padding(.vertical, 4)
                WideButton(title: String(localized: "Show my goal"), prominent: true, fontSize: 16, verticalPadding: 14,
                           cornerRadius: 14) { generate() }
                    .disabled(!ready)
                    .opacity(ready ? 1 : 0.5)
            }
            if let allowance = allowanceLine {
                Text(allowance)
                    .font(.ui(12.5))
                    .foregroundStyle(DS.silver.opacity(0.55))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    /// Sex, muscle and body fat. The sex is the profile's when it has one
    /// (the bands are set per sex, so a woman can't pick men's, review F3);
    /// only "Prefer not to say" picks here. Body-fat levels at or above the
    /// member's estimate, or that would mean an underweight goal, aren't
    /// offered, nor any while underweight.
    private var lookPickers: some View {
        VStack(alignment: .leading, spacing: 16) {
            if GoalSex(profile.sex) == nil {
                pickerBlock(title: String(localized: "Body", comment: "Goal photo setup: heads the Male / Female picker, the build the photo shows")) {
                    Picker(String(localized: "Body", comment: "Goal photo setup: heads the Male / Female picker, the build the photo shows"),
                           selection: $sex) {
                        ForEach(GoalSex.allCases) { Text($0.title).tag(Optional($0)) }
                    }
                    .pickerStyle(.segmented)
                } detail: {
                    sex == nil ? String(localized: "Pick one, so the photo shows the right build.") : nil
                }
            }
            if let sex {
                pickerBlock(title: String(localized: "Muscle")) {
                    Picker(String(localized: "Muscle"), selection: $muscle) {
                        ForEach(MuscleTarget.allCases) { Text($0.title).tag($0) }
                    }
                    .pickerStyle(.segmented)
                } detail: {
                    muscle.detail(for: sex)
                }
                pickerBlock(title: String(localized: "Body fat")) {
                    if fatChoices.count > 1 {
                        Picker(String(localized: "Body fat"), selection: $fat) {
                            ForEach(fatChoices) { Text($0.title).tag($0) }
                        }
                        .pickerStyle(.segmented)
                    }
                } detail: {
                    fatChoices.count > 1 ? fat.detail(for: sex)
                        : underweight ? String(localized: "Below a healthy weight, the photo keeps your body fat as it is.")
                        : String(localized: "You're already about as lean as these goals go, so the photo keeps your body fat and shows the muscle.")
                }
                if muscle == .same && fat == .same {
                    Text("Pick more muscle or less body fat: the same on both leaves nothing to show.")
                        .font(.ui(12.5, .semibold))
                        .foregroundStyle(DS.silver.opacity(0.7))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }

    private func pickerBlock<Content: View>(title: String, @ViewBuilder picker: () -> Content,
                                            detail: () -> String?) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionEyebrow(text: title.uppercased())
            picker()
            if let text = detail() {
                Text(text)
                    .font(.ui(12.5))
                    .foregroundStyle(DS.silver.opacity(0.6))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var working: some View {
        VStack(spacing: 14) {
            if let photo {
                Image(uiImage: photo)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 360)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 18, style: .continuous).fill(.black.opacity(0.45))
                        ProgressView().tint(.white).controlSize(.large)
                    }
            }
            Text("This usually takes under a minute. Keep MUSQ open until it's done.")
                .font(.ui(14.5))
                .foregroundStyle(DS.silver.opacity(0.7))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var resultView: some View {
        VStack(alignment: .leading, spacing: 14) {
            if let shown = showsBefore ? resultBefore : result {
                Image(uiImage: shown)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 460)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .accessibilityLabel(showsBefore ? String(localized: "Your photo") : String(localized: "Your goal photo"))
            }
            if resultBefore != nil {
                Picker(String(localized: "Show"), selection: $showsBefore) {
                    Text("Goal").tag(false)
                    Text("Now").tag(true)
                }
                .pickerStyle(.segmented)
            }
            Text("An AI illustration of where training toward your goal could take you, not a prediction. Real progress depends on your training, food, sleep and genetics.")
                .font(.ui(12.5))
                .foregroundStyle(DS.silver.opacity(0.6))
                .fixedSize(horizontal: false, vertical: true)
            if !faceRestored {
                Text("MUSQ couldn't put your own face back on this one (it needs your face clearly in view), so the face is the AI's.")
                    .font(.ui(12.5, .semibold))
                    .foregroundStyle(DS.silver.opacity(0.7))
                    .fixedSize(horizontal: false, vertical: true)
            }
            if unsaved != nil {
                Text("MUSQ couldn't keep this photo on your \(DS.deviceNoun) yet. Save it to Photos to keep it.")
                    .font(.ui(12.5, .semibold))
                    .foregroundStyle(DS.silver.opacity(0.75))
                    .fixedSize(horizontal: false, vertical: true)
            }
            WideButton(title: String(localized: "See my goal"), prominent: true, fontSize: 16, verticalPadding: 14,
                       cornerRadius: 14) {
                onOpenGoal()
                dismiss()
            }
            .disabled(unsaved != nil)
            HStack(spacing: 10) {
                WideButton(title: savedToPhotos ? String(localized: "Saved") : String(localized: "Save to Photos"),
                           prominent: false, fontSize: 15, verticalPadding: 13) { saveToPhotos() }
                    .disabled(savedToPhotos)
                WideButton(title: String(localized: "New photo"), prominent: false, fontSize: 15, verticalPadding: 13) {
                    startNew()
                }
            }
            if !notificationsAsked {
                WideButton(title: String(localized: "Get a Sunday check-in on this goal"), prominent: false, fontSize: 14,
                           verticalPadding: 11) { askForCheckIns() }
            }
            if let line = remainingLine {
                Text(line)
                    .font(.ui(12.5))
                    .foregroundStyle(DS.silver.opacity(0.5))
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
            }
            HStack(spacing: 18) {
                // App Store 1.2: AI-made content can be reported, and the
                // member can remove it. Without a mail app, the address shows.
                Button(String(localized: "Report this image")) {
                    openURL(Self.reportURL) { accepted in
                        if !accepted { showsReportAddress = true }
                    }
                }
                .reportByEmailFallback(isPresented: $showsReportAddress)
                Button(String(localized: "Delete it")) { confirmsDelete = true }
            }
            .font(.ui(13, .semibold))
            .foregroundStyle(DS.silver.opacity(0.6))
            .frame(maxWidth: .infinity)
            .padding(.top, 4)
        }
    }

    private static let reportURL = URL(string: "mailto:\(AppLinks.supportEmail)?subject=MUSQ%20goal%20photo%20report")!

    /// The allowance is used up: without a plan, Premium and Pro are offered;
    /// on Premium, Pro.
    private var limit: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(limitMessage)
                .font(.ui(15))
                .foregroundStyle(DS.silver.opacity(0.8))
                .fixedSize(horizontal: false, vertical: true)
            if serverBehindPlan {
                WideButton(title: String(localized: "Try again"), prominent: true, fontSize: 15, verticalPadding: 13) {
                    phase = .choose
                }
            } else if !purchases.isPro {
                WideButton(title: purchases.isPremium ? String(localized: "See Pro")
                                                      : String(localized: "See plans", comment: "Button: opens MUSQ's subscription plans (Premium, Pro)"),
                           prominent: true, fontSize: 15, verticalPadding: 13) {
                    openPaywall()
                }
            }
        }
    }

    private func failure(_ message: String, canRetry: Bool) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(message)
                .font(.ui(15))
                .foregroundStyle(DS.silver.opacity(0.8))
                .fixedSize(horizontal: false, vertical: true)
            if canRetry {
                WideButton(title: String(localized: "Try again"), prominent: true, fontSize: 15, verticalPadding: 13) {
                    phase = .choose
                }
            }
        }
    }

    // MARK: Look

    private var plan: NutritionPlan? { NutritionPlan(profile: profile) }

    private var underweight: Bool {
        if let plan { return plan.bmiClass == .under }
        return profile.bmi > 0 && profile.bmi < 18.5
    }

    private var fatChoices: [FatTarget] {
        guard let sex else { return [.same] }
        return GoalLook.fatChoices(sex: sex, currentPercent: GoalLook.bodyFatEstimate(profile: profile, sex: sex),
                                   weightKg: profile.weightKg, heightCm: profile.heightCm,
                                   muscleGainKg: muscle.leanGainKg(for: sex), underweight: underweight)
    }

    private var look: GoalLook? {
        sex.map { GoalLook(sex: $0, muscle: muscle, fat: fat) }
    }

    /// Ready once the photo's face check is in (it can take a moment) and
    /// shows no one else beside the member (review F4).
    private var ready: Bool {
        confirmsOwnPhoto && loadID == nil && photo != nil && faceCheck != nil && faceCheck != .several
            && (look?.changesSomething ?? false)
    }

    /// Starting values from the plan's goal: losing fat or recomposing aims
    /// at the next leaner band, building muscle at more muscle. Once only.
    private func setUp() {
        guard !isSetUp else { return }
        isSetUp = true
        sex = GoalSex(profile.sex)
        let goal = plan?.effectiveGoal ?? profile.goal
        switch goal {
        case .buildMuscle: muscle = .muscular
        case .loseWeight, .recomp, .getFit: muscle = .toned
        }
        if goal == .loseWeight || goal == .recomp {
            fat = fatChoices.first { $0 != .same } ?? .same
        } else {
            fat = .same
        }
        if GoalPhotoCard.needsPlanForNew(purchases: purchases) || (purchases.isPro && AIService.shared.goalPhotosLeft == 0) {
            phase = .limit
        }
    }

    /// A sex change moves the bands: keep the pick, or the nearest still offered.
    private func keepFatChoiceValid() {
        if !fatChoices.contains(fat) { fat = fatChoices.first { $0 != .same } ?? .same }
    }

    private var faceNote: String? {
        switch faceCheck {
        case .none?: return String(localized: "MUSQ can't find a face in this photo, so it can't keep yours. Use one where your face shows clearly.")
        case .small?: return String(localized: "Your face is small in this photo. A closer one, from the waist up, keeps it better.")
        case .several?: return String(localized: "Someone else is in this photo too. Use a photo with only you in it.")
        default: return nil
        }
    }

    private var allowanceLine: String? {
        if !purchases.isPremium {
            return AIService.shared.freeGoalPhotoUsed == true ? nil
                : String(localized: "Your first goal photo is free. Premium makes \(GoalPhotoAllowance.premium) a year, Pro \(GoalPhotoAllowance.pro).")
        }
        guard let left = AIService.shared.goalPhotosLeft else { return nil }
        return purchases.isPro
            ? String(localized: "\(left) of \(GoalPhotoAllowance.pro) goal photos left this year.")
            : String(localized: "\(left) of \(GoalPhotoAllowance.premium) goal photos left this year on Premium. Pro makes up to \(GoalPhotoAllowance.pro).")
    }

    private var remainingLine: String? {
        guard let remaining else { return nil }
        if remainingPeriod == "once" {
            return String(localized: "That was your free goal photo. Premium makes \(GoalPhotoAllowance.premium) a year, Pro up to \(GoalPhotoAllowance.pro).")
        }
        if purchases.isPro {
            return remaining == 1 ? String(localized: "1 goal photo left this year")
                : String(localized: "\(remaining) goal photos left this year")
        }
        return remaining == 0
            ? String(localized: "That's this year's goal photos on Premium. Pro makes up to \(GoalPhotoAllowance.pro) a year.")
            : String(localized: "\(remaining) more this year on Premium. Pro makes up to \(GoalPhotoAllowance.pro) a year.")
    }

    private var limitMessage: String {
        if serverBehindPlan {
            return String(localized: "Your plan is on, but MUSQ's server hasn't caught up yet. Try again in a moment.",
                          comment: "Goal photo: the member's subscription (Premium or Pro) is active but the server hasn't recorded it yet")
        }
        if purchases.isPro { return String(localized: "That's this year's goal photos. More next year.") }
        if purchases.isPremium {
            return String(localized: "You've used this year's goal photos on Premium. Pro makes up to \(GoalPhotoAllowance.pro) a year.")
        }
        return String(localized: "You've used your free goal photo. Premium makes \(GoalPhotoAllowance.premium) a year, and Pro up to \(GoalPhotoAllowance.pro).")
    }

    /// The member holds a plan (or Pro) but the server still counted a lower
    /// one: its record hasn't caught up with the purchase yet.
    private var serverBehindPlan: Bool {
        let counted = AIService.shared.limitAfterFailure["goalPhoto"]?.tier
        return (purchases.isPro && counted == "premium") || (purchases.isPremium && counted == "free")
    }

    // MARK: Actions

    /// A new photo, or none. Whether it's the member's own is asked again
    /// for each photo, and its face is checked again.
    private func setPhoto(_ image: UIImage?) {
        photo = image
        confirmsOwnPhoto = false
        showsBefore = false
        loadFailed = false
        faceCheck = nil
        guard let image else { return }
        Task {
            let check = await Task.detached(priority: .userInitiated) {
                AIService.goalUpload(image).map(GoalPhotoComposer.check(upload:))
            }.value
            if photo === image { faceCheck = check }
        }
    }

    /// Loads a pick from the library. Only the newest pick counts, and only
    /// while the photo can still be changed.
    private func load(_ item: PhotosPickerItem?) {
        guard let item else { return }
        pickerItem = nil
        let id = UUID()
        loadID = id
        loadFailed = false
        Task {
            let image = await PickedPhoto.load(item)
            guard loadID == id else { return }
            loadID = nil
            guard phase == .choose else { return }
            if let image { setPhoto(image) } else { loadFailed = true }
        }
    }

    /// "New photo" from the result: the same checks as opening the sheet.
    private func startNew() {
        if GoalPhotoCard.needsPlanForNew(purchases: purchases) {
            openPaywall()
            return
        }
        setPhoto(nil)
        savedToPhotos = false
        phase = .choose
    }

    private func generate() {
        guard let photo, let look, ready, let birthYear = profile.birthYear else { return }
        guard AccountService.shared.isSignedIn else {
            showsSignIn = true
            return
        }
        phase = .working
        // Leaving the app mid-edit mustn't lose a photo the server has already
        // counted: ask for time to finish in the background (review).
        let background = UIApplication.shared.beginBackgroundTask(withName: "GoalPhoto")
        Task {
            defer { if background != .invalid { UIApplication.shared.endBackgroundTask(background) } }
            do {
                let edited = try await AIService.shared.goalPhoto(photo, look: look, birthYear: birthYear,
                                                                  confirmsOwnPhoto: confirmsOwnPhoto)
                let upload = edited.upload, served = edited.jpeg
                let composed = await Task.detached(priority: .userInitiated) {
                    GoalPhotoComposer.compose(upload: upload, edited: served)
                }.value
                let record = GoalRecord(look: look, profile: profile)
                if GoalStore.shared.set(record, photoJPEG: composed.jpeg, beforeJPEG: edited.upload) {
                    unsaved = nil
                } else {
                    unsaved = (record, composed.jpeg, edited.upload)
                }
                result = UIImage(data: composed.jpeg)
                resultBefore = UIImage(data: edited.upload)
                faceRestored = composed.restored
                remaining = edited.remaining
                remainingPeriod = edited.period
                showsBefore = false
                savedToPhotos = false
                phase = .result
                await refreshCheckIns()
            } catch let error as AIServiceError {
                if error == .notSignedIn { phase = .choose; showsSignIn = true; return }
                // No allowance left, or none for this account at all (the server
                // answers "needs a plan"): show the plans (review GP-5).
                if error == .limitReached || error == .notPremium { phase = .limit; return }
                phase = .failed(Self.message(for: error), canRetry: Self.canRetry(error))
            } catch {
                phase = .failed(Self.message(for: .unavailable), canRetry: true)
            }
        }
    }

    /// Lays the weekly check-in for the new goal, and offers to allow
    /// notifications when they were never asked.
    private func refreshCheckIns() async {
        await GoalReminder.relay(profile: store.profile, experience: store.experience, trainedDays: store.trainedDays)
        let status = await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
        notificationsAsked = status != .notDetermined || !GoalReminder.isOn
    }

    private func askForCheckIns() {
        Task {
            _ = try? await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])
            await refreshCheckIns()
            notificationsAsked = true
        }
    }

    private func openPaywall() {
        tierAtPaywall = purchases.tier
        showsPaywall = true
    }

    /// Only a plan bought in the paywall carries on (the same photo can go
    /// again); closing it without one leaves the sheet where it was, so it
    /// never opens again by itself (review GP-1).
    private func paywallClosed() {
        guard let before = tierAtPaywall else { return }
        tierAtPaywall = nil
        guard purchases.tier > before, phase == .limit || phase == .result else { return }
        if phase == .result {
            setPhoto(nil)
            savedToPhotos = false
        }
        phase = .choose
    }

    private func deleteResult() {
        GoalStore.shared.delete()
        GoalReminder.cancel()
        dismiss()
    }

    /// Saves the kept photo, or the result that couldn't be kept yet.
    private func saveToPhotos() {
        let pending = unsaved?.photo
        Task {
            let outcome: GoalPhotoSaveResult
            if let pending { outcome = await GoalPhotoStore.saveToPhotos(pending) } else { outcome = await GoalPhotoStore.saveLatestToPhotos() }
            if outcome == .saved { savedToPhotos = true } else { photoAlert = outcome }
        }
    }

    private static func canRetry(_ error: AIServiceError) -> Bool {
        switch error {
        case .featureOff, .deviceNotVerified, .limitReached, .adultsOnly, .consentNeeded: return false
        default: return true
        }
    }

    static func message(for error: AIServiceError) -> String {
        switch error {
        case .limitReached: return String(localized: "That's all the goal photos for now.")
        case .photoNotAllowed: return String(localized: "This photo can't be edited. Use a clear photo of yourself, with only you in it.")
        case .adultsOnly: return String(localized: "Goal photos are for adults only.")
        case .notPremium:
            return String(localized: "Goal photos need a plan. If you've just bought one, try again in a moment.",
                          comment: "Goal photo error: the plan is a MUSQ subscription (Premium or Pro)")
        case .notSignedIn: return String(localized: "Sign in with Apple to make a goal photo.")
        case .consentNeeded: return String(localized: "Goal photos need your OK first.")
        case .featureOff: return String(localized: "Goal photos are paused for now. Try again later.")
        case .deviceNotVerified: return String(localized: "MUSQ couldn't verify this device. Update MUSQ and try again.")
        default: return String(localized: "MUSQ couldn't edit the photo right now. Check your connection and try again.")
        }
    }
}
