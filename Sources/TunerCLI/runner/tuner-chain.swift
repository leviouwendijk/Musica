import Capture

extension TunerRunner {
    static let chain = AudioChain {
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

    // static let chain = AudioChain {
    //     A.gain.standard(
    //         1.5
    //     )

    //     A.gate.soft(
    //         floor: 0.002,
    //         open: 0.008
    //     )

    //     A.compressor.standard(
    //         threshold: 0.18,
    //         ratio: 3,
    //         makeup: 1.2
    //     )

    //     A.equalizer.parametric(
    //         bands: [
    //             .bell(
    //                 frequency: 220,
    //                 gain: -2,
    //                 q: 1.2
    //             ),
    //             .bell(
    //                 frequency: 2_500,
    //                 gain: 1.5,
    //                 q: 0.8
    //             ),
    //         ]
    //     )

    //     A.limiter.standard()
    // }
}
