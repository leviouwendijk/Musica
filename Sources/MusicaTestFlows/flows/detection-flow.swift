import Foundation
import Musica
import TestFlows

extension MusicaFlowSuite {
    static var detectionFlow: TestFlow {
        TestFlow(
            "yin-pitch-detector",
            tags: [
                "detection",
                "yin",
                "pitch",
            ]
        ) {
            Step("detects a generated A2 sine wave") {
                let frequency = 110.0
                let sampleRate = 48_000
                let window = 4096
                let detector = YINPitchDetector(
                    options: try PitchDetectionOptions(
                        sampleRate: sampleRate,
                        window: window,
                        minFrequency: 90,
                        maxFrequency: 130,
                        threshold: 0.15,
                        rmsGate: 0.001
                    )
                )
                let samples = sine(
                    frequency: frequency,
                    sampleRate: sampleRate,
                    count: window
                )
                let result = try Expect.notNil(
                    detector.detect(
                        samples
                    ),
                    "yin.detect.a2"
                )

                try Expect.approximatelyEqual(
                    result.frequency,
                    frequency,
                    tolerance: 0.75,
                    "yin.detect.a2.frequency"
                )
            }

            Step("gates quiet buffers") {
                let detector = YINPitchDetector(
                    options: try PitchDetectionOptions(
                        sampleRate: 48_000,
                        window: 4096,
                        minFrequency: 90,
                        maxFrequency: 130,
                        threshold: 0.15,
                        rmsGate: 0.001
                    )
                )
                let samples = Array(
                    repeating: Float(0),
                    count: 4096
                )

                try Expect.isNil(
                    detector.detect(
                        samples
                    ),
                    "yin.quiet.nil"
                )
            }

            Step("returns nil for short buffers") {
                let detector = YINPitchDetector(
                    options: try PitchDetectionOptions(
                        sampleRate: 48_000,
                        window: 4096,
                        minFrequency: 90,
                        maxFrequency: 130
                    )
                )

                try Expect.isNil(
                    detector.detect(
                        [
                            0,
                            1,
                            0,
                        ]
                    ),
                    "yin.short.nil"
                )
            }
        }
    }
}

private func sine(
    frequency: Double,
    sampleRate: Int,
    count: Int
) -> [Float] {
    (0..<count).map { index in
        Float(
            0.5 * sin(
                2 * Double.pi * frequency * Double(index) / Double(sampleRate)
            )
        )
    }
}
