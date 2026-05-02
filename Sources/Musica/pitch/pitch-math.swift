import Foundation

public enum PitchMath {
    public static func frequency(
        for note: MidiNote,
        standard: PitchStandard = .standard
    ) -> Double {
        standard.a4 * pow(
            2,
            Double(
                note.value - MidiNote.a4.value
            ) / 12
        )
    }

    public static func midiValue(
        for frequency: Double,
        standard: PitchStandard = .standard
    ) -> Double? {
        guard frequency.isFinite,
              frequency > 0 else {
            return nil
        }

        return 69 + 12 * log2(
            frequency / standard.a4
        )
    }

    public static func nearestNote(
        to frequency: Double,
        standard: PitchStandard = .standard
    ) -> MidiNote? {
        guard let value = midiValue(
            for: frequency,
            standard: standard
        ) else {
            return nil
        }

        return MidiNote(
            Int(
                value.rounded()
            )
        )
    }

    public static func cents(
        frequency: Double,
        target: Double
    ) -> Double? {
        guard frequency.isFinite,
              target.isFinite,
              frequency > 0,
              target > 0 else {
            return nil
        }

        return 1200 * log2(
            frequency / target
        )
    }

    public static func chromaticTarget(
        for frequency: Double,
        standard: PitchStandard = .standard
    ) -> TuningTarget? {
        guard let note = nearestNote(
            to: frequency,
            standard: standard
        ) else {
            return nil
        }

        return TuningTarget(
            name: note.name,
            note: note,
            frequency: self.frequency(
                for: note,
                standard: standard
            )
        )
    }

    public static func reading(
        frequency: Double,
        target: TuningTarget,
        confidence: Double,
        rms: Float
    ) -> PitchReading? {
        guard let cents = cents(
            frequency: frequency,
            target: target.frequency
        ) else {
            return nil
        }

        return PitchReading(
            frequency: frequency,
            target: target,
            cents: cents,
            confidence: confidence,
            rms: rms
        )
    }
}
