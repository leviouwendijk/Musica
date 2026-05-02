import Foundation

public enum PitchTuningStatus: String, Sendable, Codable, Hashable {
    case noSignal
    case flat
    case sharp
    case tuned
}

public struct PitchReading: Sendable, Codable, Hashable {
    public let frequency: Double
    public let target: TuningTarget
    public let cents: Double
    public let confidence: Double
    public let rms: Float

    public init(
        frequency: Double,
        target: TuningTarget,
        cents: Double,
        confidence: Double,
        rms: Float
    ) {
        self.frequency = frequency
        self.target = target
        self.cents = cents
        self.confidence = confidence
        self.rms = rms
    }

    public func status(
        tolerance: Double
    ) -> PitchTuningStatus {
        if abs(
            cents
        ) <= tolerance {
            return .tuned
        }

        if cents < 0 {
            return .flat
        }

        return .sharp
    }
}
