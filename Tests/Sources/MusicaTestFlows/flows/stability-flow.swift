import Musica
import TestFlows

extension MusicaFlowSuite {
    static var stabilityFlow: TestFlow {
        TestFlow(
            "pitch-stability",
            tags: [
                "stability",
                "tuning",
            ]
        ) {
            Step("classifies readings by cents") {
                let target = TuningTarget(
                    name: "A4",
                    note: .a4,
                    frequency: 440
                )

                try Expect.equal(
                    PitchReading(
                        frequency: 438,
                        target: target,
                        cents: -7,
                        confidence: 1,
                        rms: 0.5
                    ).status(
                        tolerance: 5
                    ),
                    .flat,
                    "reading.status.flat"
                )

                try Expect.equal(
                    PitchReading(
                        frequency: 442,
                        target: target,
                        cents: 7,
                        confidence: 1,
                        rms: 0.5
                    ).status(
                        tolerance: 5
                    ),
                    .sharp,
                    "reading.status.sharp"
                )

                try Expect.equal(
                    PitchReading(
                        frequency: 440,
                        target: target,
                        cents: 2,
                        confidence: 1,
                        rms: 0.5
                    ).status(
                        tolerance: 5
                    ),
                    .tuned,
                    "reading.status.tuned"
                )
            }

            Step("requires tuned hold time before stable") {
                let target = TuningTarget(
                    name: "A4",
                    note: .a4,
                    frequency: 440
                )
                let reading = PitchReading(
                    frequency: 440,
                    target: target,
                    cents: 0,
                    confidence: 1,
                    rms: 0.5
                )
                var tracker = PitchStabilityTracker(
                    options: PitchStabilityOptions(
                        tolerance: 5,
                        hold: 0.35
                    )
                )

                let first = tracker.update(
                    reading: reading,
                    time: 10
                )
                let second = tracker.update(
                    reading: reading,
                    time: 10.2
                )
                let third = tracker.update(
                    reading: reading,
                    time: 10.36
                )

                try Expect.false(
                    first.stable,
                    "stability.first"
                )

                try Expect.false(
                    second.stable,
                    "stability.second"
                )

                try Expect.true(
                    third.stable,
                    "stability.third"
                )
            }
        }
    }
}
