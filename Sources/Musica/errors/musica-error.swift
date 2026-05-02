import Foundation

public enum MusicaError: Error, Sendable, LocalizedError, CustomStringConvertible {
    case invalidA4(Double)
    case invalidSampleRate(Int)
    case invalidWindow(Int)
    case invalidFrequencyRange(
        min: Double,
        max: Double
    )
    case invalidThreshold(Double)
    case invalidRMSGate(Float)
    case invalidRingCapacity(Int)

    public var errorDescription: String? {
        description
    }

    public var description: String {
        switch self {
        case .invalidA4(let value):
            return "Invalid A4 frequency: \(value)."

        case .invalidSampleRate(let value):
            return "Invalid sample rate: \(value)."

        case .invalidWindow(let value):
            return "Invalid analysis window: \(value)."

        case .invalidFrequencyRange(
            let min,
            let max
        ):
            return "Invalid frequency range: \(min)-\(max) Hz."

        case .invalidThreshold(let value):
            return "Invalid YIN threshold: \(value)."

        case .invalidRMSGate(let value):
            return "Invalid RMS gate: \(value)."

        case .invalidRingCapacity(let value):
            return "Invalid sample ring capacity: \(value)."
        }
    }
}
