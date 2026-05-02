import Foundation

public struct PitchDetectionOptions: Sendable, Codable, Hashable {
    public let sampleRate: Int
    public let window: Int
    public let minFrequency: Double
    public let maxFrequency: Double
    public let threshold: Double
    public let rmsGate: Float

    public init(
        sampleRate: Int = 48_000,
        window: Int = 4096,
        minFrequency: Double = 70,
        maxFrequency: Double = 400,
        threshold: Double = 0.12,
        rmsGate: Float = 0.006
    ) throws {
        guard sampleRate > 0 else {
            throw MusicaError.invalidSampleRate(
                sampleRate
            )
        }

        guard window > 0 else {
            throw MusicaError.invalidWindow(
                window
            )
        }

        guard minFrequency.isFinite,
              maxFrequency.isFinite,
              minFrequency > 0,
              maxFrequency > minFrequency else {
            throw MusicaError.invalidFrequencyRange(
                min: minFrequency,
                max: maxFrequency
            )
        }

        guard threshold.isFinite,
              threshold > 0,
              threshold < 1 else {
            throw MusicaError.invalidThreshold(
                threshold
            )
        }

        guard rmsGate.isFinite,
              rmsGate >= 0 else {
            throw MusicaError.invalidRMSGate(
                rmsGate
            )
        }

        self.sampleRate = sampleRate
        self.window = window
        self.minFrequency = minFrequency
        self.maxFrequency = maxFrequency
        self.threshold = threshold
        self.rmsGate = rmsGate
    }
}
