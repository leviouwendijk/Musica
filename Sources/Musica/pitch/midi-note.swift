import Foundation

public struct MidiNote: Sendable, Codable, Hashable, Comparable {
    public let value: Int

    public init(
        _ value: Int
    ) {
        self.value = value
    }

    public var pitchClass: PitchClass {
        PitchClass(
            value
        )
    }

    public var octave: Int {
        value / 12 - 1
    }

    public var name: String {
        "\(pitchClass.name)\(octave)"
    }

    public static func < (
        lhs: MidiNote,
        rhs: MidiNote
    ) -> Bool {
        lhs.value < rhs.value
    }
}

public extension MidiNote {
    static let a4 = MidiNote(69)

    static let bassE1 = MidiNote(28)
    static let bassA1 = MidiNote(33)
    static let bassD2 = MidiNote(38)
    static let bassG2 = MidiNote(43)

    static let guitarE2 = MidiNote(40)
    static let guitarA2 = MidiNote(45)
    static let guitarD3 = MidiNote(50)
    static let guitarG3 = MidiNote(55)
    static let guitarB3 = MidiNote(59)
    static let guitarE4 = MidiNote(64)
}
