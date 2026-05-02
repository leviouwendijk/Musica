import Foundation

public struct PitchStandard: Sendable, Codable, Hashable {
    public static let standard = PitchStandard(
        uncheckedA4: 440
    )

    public let a4: Double

    public init(
        a4: Double = 440
    ) throws {
        guard a4.isFinite,
              a4 > 0 else {
            throw MusicaError.invalidA4(
                a4
            )
        }

        self.a4 = a4
    }

    private init(
        uncheckedA4 a4: Double
    ) {
        self.a4 = a4
    }
}
