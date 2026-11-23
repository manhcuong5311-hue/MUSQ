//
//  VoiceInput.swift
//  GymWorkout
//
//  Speaking a quick log (2026-11-22): water, a walk or a meal; and a meal
//  scan's note, in the app's language (`appLocale`). On iOS 26
//  the words are heard on the device by Apple's dictation model
//  (`SpeechAnalyzer` + `DictationTranscriber`, which has Vietnamese as well
//  as English); the audio never leaves the phone and nothing is kept.
//  Earlier iOS has no in-app mic here: the sheet's text field takes the
//  keyboard's own dictation instead, so MUSQ never sends audio anywhere.
//
//  Review fix (2026-11-22): a start that fails part-way lets go of
//  everything it had set up (tap, engine, analyzer, audio session, so other
//  apps' audio isn't left ducked); a stop while the mic is still getting
//  ready makes that start let go instead of turning on; setting the mic up
//  and letting it go run one at a time across the app.
//
//  Review fixes (2026-11-23): a stop while the mic is getting ready (the
//  model downloading) ends that start before it touches the audio session;
//  two stops at once are one (the second waits for the first, so what was
//  heard is final for both); `reset` clears the words heard so far for the
//  rest of a session too, and keeps "no mic here" and "access off"; a
//  language without on-device dictation reports `.unavailable` (the
//  keyboard's mic), never English heard as Vietnamese.
//

import AVFoundation
import Foundation
import Observation
import Speech

@Observable
final class VoiceInput {
    enum State: Equatable {
        case idle
        case preparing
        case listening
        /// No in-app mic here (older iOS, a locale without on-device
        /// dictation): use the keyboard's mic.
        case unavailable
        /// Microphone access turned off for MUSQ.
        case denied
        case failed
    }

    private(set) var state: State = .idle
    /// What was heard so far: finished phrases plus the one in progress.
    private(set) var transcript = ""
    /// A stop is letting the mic go: what was heard isn't final yet.
    private(set) var isStopping = false

    @ObservationIgnored private var stopAction: (() async -> Void)?
    @ObservationIgnored private var resultsTask: Task<Void, Never>?
    /// The stop letting the mic go, which another stop waits for.
    @ObservationIgnored private var stopping: Task<Void, Never>?
    /// The phrases heard and finished this session; `reset` clears them.
    @ObservationIgnored private var finished = ""
    /// Bumped by every start and stop: a start still getting ready when it
    /// was stopped (the sheet closed, the mic let go) sees it and lets go.
    @ObservationIgnored private var attempt = 0
    /// The start whose words fill `transcript`; a start that was stopped
    /// while getting ready never writes there.
    @ObservationIgnored private var liveAttempt = 0

    /// Whether a mic setup or teardown is running, app-wide, and who waits
    /// for it: they run one at a time, so a late teardown never switches
    /// off the audio session a newer start has just turned on.
    private static var audioBusy = false
    private static var audioWaiters: [CheckedContinuation<Void, Never>] = []

    /// Whether the in-app mic can work on this iOS.
    static var isSupported: Bool {
        if #available(iOS 26.0, *) { return true }
        return false
    }

    /// The language MUSQ itself shows, for words that go into its own text
    /// (a meal scan's note is read in it): Vietnamese as vi-VN and English
    /// as en-US, whatever the device's region; the device's own locale
    /// otherwise (2026-11-22).
    static var appLocale: Locale {
        let language = Bundle.main.preferredLocalizations.first ?? ""
        if language.hasPrefix("vi") { return Locale(identifier: "vi-VN") }
        if language.hasPrefix("en") { return Locale(identifier: "en-US") }
        return .current
    }

    /// Starts listening; `transcript` fills as words arrive.
    func start(locale: Locale = .current) async {
        guard state != .listening, state != .preparing, !isStopping else { return }
        transcript = ""
        finished = ""
        guard Self.isSupported else { state = .unavailable; return }
        attempt += 1
        let mine = attempt
        state = .preparing
        guard await AVAudioApplication.requestRecordPermission() else {
            if attempt == mine { state = .denied }
            return
        }
        guard #available(iOS 26.0, *) else { state = .unavailable; return }
        await Self.takeAudioTurn()
        defer { Self.endAudioTurn() }
        // Stopped while asking or waiting: never turn the mic on.
        guard attempt == mine else { return }
        do {
            let letGo = try await startAnalyzer(locale: locale, attempt: mine)
            if attempt == mine {
                stopAction = letGo
                state = .listening
            } else {
                // Stopped while getting ready: let go of the mic at once.
                liveAttempt = 0
                resultsTask?.cancel()
                resultsTask = nil
                await letGo()
            }
        } catch VoiceError.unsupportedLocale {
            if attempt == mine { state = .unavailable }
        } catch VoiceError.stopped {
            // Stopped while getting ready: `stop` has set the state.
        } catch {
            // `startAnalyzer` has already let go of what it set up.
            if attempt == mine { state = .failed }
        }
    }

    /// Stops listening and keeps what was heard. While the mic is still
    /// getting ready, that start lets go of it instead of turning it on.
    /// A stop while another is letting the mic go waits for that one.
    func stop() async {
        if let stopping {
            await stopping.value
            return
        }
        attempt += 1
        let action = stopAction
        stopAction = nil
        if let action {
            isStopping = true
            let letGo = Task {
                await Self.takeAudioTurn()
                await action()
                Self.endAudioTurn()
            }
            stopping = letGo
            await letGo.value
            stopping = nil
            isStopping = false
        }
        resultsTask = nil
        if state == .listening || state == .preparing { state = .idle }
    }

    /// Clears what was heard, for the rest of a session that's on too. A
    /// mic that's on or getting ready keeps going; one that can't listen
    /// here, or has no access, still says so.
    func reset() {
        transcript = ""
        finished = ""
        if state == .failed { state = .idle }
    }

    #if DEBUG
    /// For screenshots: the mic as it shows while hearing these words, with
    /// no microphone on. A stop afterwards keeps them, as after a real one.
    func previewListening(heard: String) {
        attempt += 1
        state = .listening
        transcript = heard
    }
    #endif

    /// Waits until no other mic setup or teardown is running.
    private static func takeAudioTurn() async {
        guard audioBusy else { audioBusy = true; return }
        await withCheckedContinuation { audioWaiters.append($0) }
    }

    /// Hands the turn to the next one waiting, if any.
    private static func endAudioTurn() {
        if audioWaiters.isEmpty { audioBusy = false } else { audioWaiters.removeFirst().resume() }
    }

    private enum VoiceError: Error { case unsupportedLocale, noFormat, stopped }

    /// Turns the mic on for `attempt` and returns what turns it off. If any
    /// step fails, what was already set up is let go before the error is
    /// thrown; a stop meanwhile (`attempt` moved on) ends it the same way,
    /// before the audio session is touched.
    @available(iOS 26.0, *)
    private func startAnalyzer(locale: Locale, attempt: Int) async throws -> () async -> Void {
        func stillWanted() throws {
            guard self.attempt == attempt else { throw VoiceError.stopped }
        }
        // English only for an English app: Vietnamese heard by the English
        // model is nonsense, and the keyboard's own mic does better.
        var match = await DictationTranscriber.supportedLocale(equivalentTo: locale)
        if match == nil, locale.language.languageCode == .english {
            match = await DictationTranscriber.supportedLocale(equivalentTo: Locale(identifier: "en-US"))
        }
        guard let supported = match else { throw VoiceError.unsupportedLocale }
        try stillWanted()
        let transcriber = DictationTranscriber(locale: supported, preset: .progressiveShortDictation)
        // The model downloads once per language, on first use.
        if let request = try await AssetInventory.assetInstallationRequest(supporting: [transcriber]) {
            try await request.downloadAndInstall()
        }
        try stillWanted()
        guard let format = await SpeechAnalyzer.bestAvailableAudioFormat(compatibleWith: [transcriber]) else {
            throw VoiceError.noFormat
        }
        try stillWanted()
        let analyzer = SpeechAnalyzer(modules: [transcriber])
        let (inputs, continuation) = AsyncStream.makeStream(of: AnalyzerInput.self)
        let session = AVAudioSession.sharedInstance()
        let engine = AVAudioEngine()
        var isActive = false
        var isTapped = false
        do {
            try await analyzer.start(inputSequence: inputs)
            try stillWanted()
            try session.setCategory(.record, mode: .measurement, options: .duckOthers)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
            isActive = true
            let node = engine.inputNode
            let micFormat = node.outputFormat(forBus: 0)
            node.installTap(onBus: 0, bufferSize: 4_096, format: micFormat,
                            block: Self.tap(from: micFormat, to: format, into: continuation))
            isTapped = true
            engine.prepare()
            try engine.start()
        } catch {
            // The mic busy in a call, a route change: let go of all of it,
            // so the analyzer stops and other apps' audio isn't left ducked.
            engine.stop()
            if isTapped { engine.inputNode.removeTap(onBus: 0) }
            continuation.finish()
            await analyzer.cancelAndFinishNow()
            if isActive { try? session.setActive(false, options: .notifyOthersOnDeactivation) }
            throw error
        }

        liveAttempt = attempt
        finished = ""
        resultsTask = Task { [weak self] in
            do {
                for try await result in transcriber.results {
                    guard let self, self.liveAttempt == attempt else { continue }
                    let text = String(result.text.characters)
                    if result.isFinal {
                        self.finished = [self.finished, text].filter { !$0.isEmpty }.joined(separator: " ")
                        self.transcript = self.finished
                    } else {
                        self.transcript = [self.finished, text].filter { !$0.isEmpty }.joined(separator: " ")
                    }
                }
            } catch {}
        }
        let node = engine.inputNode
        return {
            engine.stop()
            node.removeTap(onBus: 0)
            continuation.finish()
            do {
                try await analyzer.finalizeAndFinishThroughEndOfInput()
            } catch {
                await analyzer.cancelAndFinishNow()
            }
            try? session.setActive(false, options: .notifyOthersOnDeactivation)
        }
    }

    /// The microphone tap, off the main actor: converts each buffer to the
    /// model's format and hands it on.
    @available(iOS 26.0, *)
    private nonisolated static func tap(from source: AVAudioFormat, to target: AVAudioFormat,
                                        into continuation: AsyncStream<AnalyzerInput>.Continuation) -> AVAudioNodeTapBlock {
        let converter = AVAudioConverter(from: source, to: target)
        return { buffer, _ in
            guard let converter else { return }
            let ratio = target.sampleRate / source.sampleRate
            let capacity = AVAudioFrameCount((Double(buffer.frameLength) * ratio).rounded(.up)) + 16
            guard let output = AVAudioPCMBuffer(pcmFormat: target, frameCapacity: capacity) else { return }
            var consumed = false
            var error: NSError?
            converter.convert(to: output, error: &error) { _, status in
                if consumed {
                    status.pointee = .noDataNow
                    return nil
                }
                consumed = true
                status.pointee = .haveData
                return buffer
            }
            if error == nil, output.frameLength > 0 {
                continuation.yield(AnalyzerInput(buffer: output))
            }
        }
    }
}
