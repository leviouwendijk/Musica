import Foundation

public struct PitchStabilityOptions: Sendable, Codable, Hashable {
    public let tolerance: Double
    public let hold: TimeInterval

    public init(
        tolerance: Double = 5,
        hold: TimeInterval = 0.35
    ) {
        self.tolerance = tolerance
        self.hold = hold
    }
}

public struct PitchStabilityState: Sendable, Codable, Hashable {
    public let status: PitchTuningStatus
    public let stable: Bool
    public let held: TimeInterval

    public init(
        status: PitchTuningStatus,
        stable: Bool,
        held: TimeInterval
    ) {
        self.status = status
        self.stable = stable
        self.held = held
    }
}

public struct PitchStabilityTracker: Sendable {
    public let options: PitchStabilityOptions

    private var targetName: String?
    private var stableStart: TimeInterval?

    public init(
        options: PitchStabilityOptions = .init()
    ) {
        self.options = options
    }

    public mutating func update(
        reading: PitchReading?,
        time: TimeInterval
    ) -> PitchStabilityState {
        guard let reading else {
            targetName = nil
            stableStart = nil

            return PitchStabilityState(
                status: .noSignal,
                stable: false,
                held: 0
            )
        }

        let status = reading.status(
            tolerance: options.tolerance
        )

        guard status == .tuned else {
            targetName = reading.target.name
            stableStart = nil

            return PitchStabilityState(
                status: status,
                stable: false,
                held: 0
            )
        }

        if targetName != reading.target.name {
            targetName = reading.target.name
            stableStart = time
        }

        let start = stableStart ?? time
        stableStart = start

        let held = max(
            0,
            time - start
        )

        return PitchStabilityState(
            status: status,
            stable: held >= options.hold,
            held: held
        )
    }
}
