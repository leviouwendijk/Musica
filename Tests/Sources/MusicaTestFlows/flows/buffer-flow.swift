import Musica
import TestFlows

extension MusicaFlowSuite {
    static var bufferFlow: TestFlow {
        TestFlow(
            "sample-ring-buffer",
            tags: [
                "buffer",
                "detection",
            ]
        ) {
            Step("ring buffer reports count before capacity") {
                let buffer = try SampleRingBuffer(
                    capacity: 4
                )

                buffer.append(
                    1
                )
                buffer.append(
                    2
                )

                try Expect.equal(
                    buffer.count,
                    2,
                    "ring.count"
                )
            }

            Step("ring buffer returns latest samples in order") {
                let buffer = try SampleRingBuffer(
                    capacity: 4
                )

                buffer.append(
                    contentsOf: [
                        1,
                        2,
                        3,
                        4,
                        5,
                    ]
                )

                try Expect.equal(
                    buffer.latest(
                        4
                    ),
                    [
                        2,
                        3,
                        4,
                        5,
                    ],
                    "ring.latest.wrapped"
                )
            }

            Step("ring buffer returns nil when underfilled") {
                let buffer = try SampleRingBuffer(
                    capacity: 4
                )

                buffer.append(
                    1
                )

                try Expect.isNil(
                    buffer.latest(
                        2
                    ),
                    "ring.latest.underfilled"
                )
            }
        }
    }
}
