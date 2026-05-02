import Foundation

public struct PitchClass: Sendable, Codable, Hashable, Comparable {
    public let semitone: Int

    public init(
        _ semitone: Int
    ) {
        self.semitone = Self.normalized(
            semitone
        )
    }

    public var name: String {
        PitchClassNameMap.name(
            for: self
        )
    }

    public static func < (
        lhs: PitchClass,
        rhs: PitchClass
    ) -> Bool {
        lhs.semitone < rhs.semitone
    }
}

public extension PitchClass {
    static let c = PitchClass(0)
    static let cSharp = PitchClass(1)
    static let d = PitchClass(2)
    static let dSharp = PitchClass(3)
    static let e = PitchClass(4)
    static let f = PitchClass(5)
    static let fSharp = PitchClass(6)
    static let g = PitchClass(7)
    static let gSharp = PitchClass(8)
    static let a = PitchClass(9)
    static let aSharp = PitchClass(10)
    static let b = PitchClass(11)
}

private extension PitchClass {
    static func normalized(
        _ semitone: Int
    ) -> Int {
        (
            (
                semitone % 12
            ) + 12
        ) % 12
    }
}

public struct KeyboardMappedPitchClass: Sendable, Codable, Hashable {
    public let symbol: String
    public let isSharpOrFlat: Bool

    public init(
        symbol: String,
        isSharpOrFlat: Bool
    ) {
        self.symbol = symbol
        self.isSharpOrFlat = isSharpOrFlat
    }
}

public enum PitchClassNameMap {
    public static let keyboard: [Int: KeyboardMappedPitchClass] = [
        0: .init(symbol: "C", isSharpOrFlat: false),
        1: .init(symbol: "C#", isSharpOrFlat: true),
        2: .init(symbol: "D", isSharpOrFlat: false),
        3: .init(symbol: "D#", isSharpOrFlat: true),
        4: .init(symbol: "E", isSharpOrFlat: false),
        5: .init(symbol: "F", isSharpOrFlat: false),
        6: .init(symbol: "F#", isSharpOrFlat: true),
        7: .init(symbol: "G", isSharpOrFlat: false),
        8: .init(symbol: "G#", isSharpOrFlat: true),
        9: .init(symbol: "A", isSharpOrFlat: false),
        10: .init(symbol: "A#", isSharpOrFlat: true),
        11: .init(symbol: "B", isSharpOrFlat: false),
    ]

    public static let names: [String] = [
        "C",
        "C#",
        "D",
        "D#",
        "E",
        "F",
        "F#",
        "G",
        "G#",
        "A",
        "A#",
        "B",
    ]

    public static let semitones: [String: Int] = [
        "C": 0,
        "B#": 0,
        "C#": 1,
        "DB": 1,
        "D": 2,
        "D#": 3,
        "EB": 3,
        "E": 4,
        "FB": 4,
        "F": 5,
        "E#": 5,
        "F#": 6,
        "GB": 6,
        "G": 7,
        "G#": 8,
        "AB": 8,
        "A": 9,
        "A#": 10,
        "BB": 10,
        "B": 11,
        "CB": 11,
    ]

    public static func parse(
        _ string: String
    ) -> PitchClass? {
        let key = string
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()

        guard let semitone = semitones[key] else {
            return nil
        }

        return PitchClass(
            semitone
        )
    }

    public static func name(
        for pitchClass: PitchClass
    ) -> String {
        names[pitchClass.semitone]
    }

    public static func name(
        forSemitone semitone: Int
    ) -> String {
        name(
            for: PitchClass(
                semitone
            )
        )
    }
}
