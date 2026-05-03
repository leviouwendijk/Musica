import Capture
import Foundation
import Musica
import Terminal

struct TunerRunner: Sendable {
    let options: TunerOptions

    func run() async throws {
        let pitch = try PitchStandard(
            a4: options.a4
        )
        let detection = try detectionOptions()
        let detector = YINPitchDetector(
            options: detection
        )
        let ring = try SampleRingBuffer(
            capacity: detection.sampleRate * 2
        )
        let stop = TunerStopState()

        let audio = try CaptureAudioOptions(
            device: audioDevice(),
            sampleRate: options.sampleRate,
            channel: options.channel,
            codec: .pcm,
            sample: .float32
        )

        let session = CaptureAudioInputSession(
            audio: audio,
            chain: Self.chain(
                for: options.mode
            )
        ) { buffer in
            ring.appendSamples { append in
                buffer.forEachMonoFloatSample { sample in
                    append(
                        sample
                    )
                }
            }
        }

        let signalHandler = TunerSignalHandler {
            stop.stop()
            session.cancel()
        }

        _ = signalHandler

        if let duration = options.duration {
            Task {
                try? await Task.sleep(
                    nanoseconds: UInt64(
                        duration * 1_000_000_000
                    )
                )

                stop.stop()
                session.cancel()
            }
        }

        let start = try await session.start()

        Terminal.hideCursor()
        defer {
            session.cancel()
            Terminal.writeInline(
                "\n"
            )
            Terminal.showCursor()
        }

        var stability = PitchStabilityTracker(
            options: PitchStabilityOptions(
                tolerance: options.tolerance
            )
        )

        let renderer = TunerRenderer()

        Terminal.writeInline(
            "input: \(start.device.name)    \(start.sampleRate) Hz    \(start.channelCount) ch"
        )

        try await Task.sleep(
            nanoseconds: 350_000_000
        )

        while !stop.stopped,
              !Task.isCancelled {
            let currentReading: PitchReading?

            if let samples = ring.latest(
                detection.window
            ),
               let result = detector.detect(
                samples
               ) {
                currentReading = reading(
                    from: result,
                    pitch: pitch
                )
            } else {
                currentReading = nil
            }

            let state = stability.update(
                reading: currentReading,
                time: Date().timeIntervalSinceReferenceDate
            )

            Terminal.writeInline(
                renderer.render(
                    reading: currentReading,
                    state: state
                )
            )

            try await Task.sleep(
                nanoseconds: frameDelay()
            )
        }
    }
}

private extension TunerRunner {
    func audioDevice() -> CaptureAudioDevice {
        guard let device = options.device?
            .trimmingCharacters(in: .whitespacesAndNewlines),
              !device.isEmpty else {
            return .systemDefault
        }

        return .name(
            device
        )
    }

    func detectionOptions() throws -> PitchDetectionOptions {
        switch options.mode {
        case .listen:
            return try PitchDetectionOptions(
                sampleRate: options.sampleRate,
                window: options.window,
                minFrequency: 50,
                maxFrequency: 1200
            )

        case .guitar:
            return try PitchDetectionOptions(
                sampleRate: options.sampleRate,
                window: options.window,
                minFrequency: 70,
                maxFrequency: 400
            )

        case .bass:
            return try PitchDetectionOptions(
                sampleRate: options.sampleRate,
                window: options.window,
                minFrequency: 35,
                maxFrequency: 300,
                threshold: 0.15,
                rmsGate: 0.004
            )
        }
    }

    func reading(
        from result: PitchDetectionResult,
        pitch: PitchStandard
    ) -> PitchReading? {
        let target: TuningTarget?

        switch options.mode {
        case .listen:
            target = PitchMath.chromaticTarget(
                for: result.frequency,
                standard: pitch
            )

        case .guitar:
            target = GuitarTuning.standard(
                pitch: pitch
            ).nearest(
                to: result.frequency
            )

        case .bass:
            target = BassTuning.standard(
                pitch: pitch
            ).nearest(
                to: result.frequency
            )
        }

        guard let target else {
            return nil
        }

        return PitchMath.reading(
            frequency: result.frequency,
            target: target,
            confidence: result.confidence,
            rms: result.rms
        )
    }

    func frameDelay() -> UInt64 {
        UInt64(
            1_000_000_000 / max(
                1,
                options.fps
            )
        )
    }
}
