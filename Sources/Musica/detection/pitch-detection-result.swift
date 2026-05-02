import Foundation

public struct PitchDetectionResult: Sendable, Codable, Hashable {
    public let frequency: Double
    public let confidence: Double
    public let rms: Float

    public init(
        frequency: Double,
        confidence: Double,
        rms: Float
    ) {
        self.frequency = frequency
        self.confidence = confidence
        self.rms = rms
    }
}
