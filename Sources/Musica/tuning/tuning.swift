import Foundation

public struct TuningTarget: Sendable, Codable, Hashable {
    public let name: String
    public let note: MidiNote
    public let frequency: Double

    public init(
        name: String,
        note: MidiNote,
        frequency: Double
    ) {
        self.name = name
        self.note = note
        self.frequency = frequency
    }
}

public struct Tuning: Sendable, Codable, Hashable {
    public let name: String
    public let targets: [TuningTarget]

    public init(
        name: String,
        targets: [TuningTarget]
    ) {
        self.name = name
        self.targets = targets
    }

    public func nearest(
        to frequency: Double
    ) -> TuningTarget? {
        guard frequency.isFinite,
              frequency > 0 else {
            return nil
        }

        return targets.min { lhs, rhs in
            abs(
                log2(
                    frequency / lhs.frequency
                )
            ) < abs(
                log2(
                    frequency / rhs.frequency
                )
            )
        }
    }
}

public enum GuitarTuning {
    public static func standard(
        pitch: PitchStandard = .standard
    ) -> Tuning {
        let notes: [MidiNote] = [
            .guitarE2,
            .guitarA2,
            .guitarD3,
            .guitarG3,
            .guitarB3,
            .guitarE4,
        ]

        return Tuning(
            name: "standard",
            targets: notes.map { note in
                TuningTarget(
                    name: note.name,
                    note: note,
                    frequency: PitchMath.frequency(
                        for: note,
                        standard: pitch
                    )
                )
            }
        )
    }
}
