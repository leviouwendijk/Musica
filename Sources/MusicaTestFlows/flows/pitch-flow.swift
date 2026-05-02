import Musica
import TestFlows

extension MusicaFlowSuite {
    static var pitchFlow: TestFlow {
        TestFlow(
            "pitch",
            tags: [
                "pitch",
                "math",
                "tuning",
            ]
        ) {
            Step("pitch classes normalize semitones") {
                try Expect.equal(
                    PitchClass(-1).semitone,
                    11,
                    "pitch-class.negative-normalization"
                )

                try Expect.equal(
                    PitchClass(12).semitone,
                    0,
                    "pitch-class.positive-normalization"
                )
            }

            Step("pitch class names parse enharmonics") {
                let dFlat = try Expect.notNil(
                    PitchClassNameMap.parse(
                        "Db"
                    ),
                    "pitch-class.parse.db"
                )

                try Expect.equal(
                    dFlat.semitone,
                    1,
                    "pitch-class.db.semitone"
                )
            }

            Step("midi notes expose names and octaves") {
                let middleC = MidiNote(
                    60
                )

                try Expect.equal(
                    middleC.name,
                    "C4",
                    "midi.middle-c.name"
                )

                try Expect.equal(
                    middleC.octave,
                    4,
                    "midi.middle-c.octave"
                )
            }

            Step("pitch math maps A4 to configured standard") {
                let pitch = try PitchStandard(
                    a4: 442
                )

                try Expect.approximatelyEqual(
                    PitchMath.frequency(
                        for: .a4,
                        standard: pitch
                    ),
                    442,
                    tolerance: 0.0001,
                    "pitch-math.a4.frequency"
                )
            }

            Step("standard guitar tuning has expected targets") {
                let tuning = GuitarTuning.standard()

                try Expect.equal(
                    tuning.targets.map(\.name),
                    [
                        "E2",
                        "A2",
                        "D3",
                        "G3",
                        "B3",
                        "E4",
                    ],
                    "guitar.standard.target-names"
                )
            }
        }
    }
}
