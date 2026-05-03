import Capture

extension TunerRunner {
    static func chain(
        for mode: TunerMode
    ) -> AudioChain {
        switch mode {
        case .listen:
            return generalChain()

        case .guitar:
            return guitarChain()

        case .bass:
            return bassChain()
        }
    }
}

private extension TunerRunner {
    static func generalChain() -> AudioChain {
        AudioChain {
            A.gain.standard(
                1.5
            )

            A.equalizer.parametric(
                bands: [
                    .highpass(
                        frequency: 30,
                        q: 0.707
                    ),
                    .lowpass(
                        frequency: 10_000,
                        q: 0.707
                    ),
                ]
            )

            A.gate.soft(
                floor: 0.00125,
                open: 0.005
            )

            A.compressor.standard(
                thresholdDB: -26,
                ratio: 3.8,
                attackMS: 6,
                releaseMS: 150,
                kneeDB: 6,
                makeupDB: 5,
                detector: .rms(
                    windowMS: 10
                ),
                sidechain: .filtered(
                    highpassFrequency: 55,
                    lowpassFrequency: 5_000
                )
            )

            A.limiter.standard(
                ceiling: 0.9
            )
        }
    }

    static func guitarChain() -> AudioChain {
        AudioChain {
            A.gain.standard(
                1.5
            )

            A.equalizer.parametric(
                bands: [
                    .highpass(
                        frequency: 45,
                        q: 0.707
                    ),
                    .lowpass(
                        frequency: 5_000,
                        q: 0.707
                    ),
                ]
            )

            A.gate.soft(
                floor: 0.00125,
                open: 0.005
            )

            A.compressor.standard(
                thresholdDB: -26,
                ratio: 3.8,
                attackMS: 6,
                releaseMS: 150,
                kneeDB: 6,
                makeupDB: 5,
                detector: .rms(
                    windowMS: 10
                ),
                sidechain: .filtered(
                    highpassFrequency: 55,
                    lowpassFrequency: 3_500
                )
            )

            A.limiter.standard(
                ceiling: 0.9
            )
        }
    }

    static func bassChain() -> AudioChain {
        AudioChain {
            A.gain.standard(
                1.75
            )

            A.equalizer.parametric(
                bands: [
                    .highpass(
                        frequency: 25,
                        q: 0.707
                    ),
                    .lowpass(
                        frequency: 4_000,
                        q: 0.707
                    ),
                ]
            )

            A.gate.soft(
                floor: 0.001,
                open: 0.0045
            )

            A.compressor.standard(
                thresholdDB: -28,
                ratio: 4,
                attackMS: 10,
                releaseMS: 220,
                kneeDB: 7,
                makeupDB: 5,
                detector: .rms(
                    windowMS: 16
                ),
                sidechain: .filtered(
                    highpassFrequency: 30,
                    lowpassFrequency: 2_500
                )
            )

            A.limiter.standard(
                ceiling: 0.9
            )
        }
    }
}
