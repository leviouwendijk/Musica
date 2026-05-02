import Foundation

public struct YINPitchDetector: Sendable {
    public let options: PitchDetectionOptions

    public init(
        options: PitchDetectionOptions
    ) {
        self.options = options
    }

    public func detect(
        _ samples: [Float]
    ) -> PitchDetectionResult? {
        guard samples.count >= options.window else {
            return nil
        }

        let window = Array(
            samples.suffix(
                options.window
            )
        )

        let rms = Self.rms(
            window
        )

        guard rms >= options.rmsGate else {
            return nil
        }

        let minTau = max(
            2,
            Int(
                Double(
                    options.sampleRate
                ) / options.maxFrequency
            )
        )
        let maxTau = min(
            options.window - 2,
            Int(
                Double(
                    options.sampleRate
                ) / options.minFrequency
            )
        )

        guard maxTau > minTau else {
            return nil
        }

        var difference = Array(
            repeating: 0.0,
            count: maxTau + 1
        )

        for tau in 1...maxTau {
            var sum = 0.0
            let limit = options.window - tau

            for index in 0..<limit {
                let delta = Double(
                    window[index] - window[index + tau]
                )

                sum += delta * delta
            }

            difference[tau] = sum
        }

        var normalized = Array(
            repeating: 1.0,
            count: maxTau + 1
        )
        var running = 0.0

        for tau in 1...maxTau {
            running += difference[tau]

            if running > 0 {
                normalized[tau] = difference[tau]
                    * Double(
                        tau
                    )
                    / running
            }
        }

        guard let tau = firstMinimum(
            in: normalized,
            minTau: minTau,
            maxTau: maxTau
        ) else {
            return nil
        }

        let refinedTau = parabolicTau(
            tau,
            values: normalized
        )
        let frequency = Double(
            options.sampleRate
        ) / refinedTau

        guard frequency.isFinite,
              frequency >= options.minFrequency,
              frequency <= options.maxFrequency else {
            return nil
        }

        let confidence = max(
            0,
            min(
                1,
                1 - normalized[tau]
            )
        )

        return PitchDetectionResult(
            frequency: frequency,
            confidence: confidence,
            rms: rms
        )
    }
}

private extension YINPitchDetector {
    static func rms(
        _ samples: [Float]
    ) -> Float {
        guard !samples.isEmpty else {
            return 0
        }

        var sum: Float = 0

        for sample in samples {
            sum += sample * sample
        }

        return sqrt(
            sum / Float(
                samples.count
            )
        )
    }

    func firstMinimum(
        in values: [Double],
        minTau: Int,
        maxTau: Int
    ) -> Int? {
        var tau = minTau

        while tau <= maxTau {
            if values[tau] < options.threshold {
                while tau + 1 <= maxTau,
                      values[tau + 1] < values[tau] {
                    tau += 1
                }

                return tau
            }

            tau += 1
        }

        return values[minTau...maxTau]
            .enumerated()
            .min {
                $0.element < $1.element
            }
            .map {
                minTau + $0.offset
            }
    }

    func parabolicTau(
        _ tau: Int,
        values: [Double]
    ) -> Double {
        guard tau > 0,
              tau + 1 < values.count else {
            return Double(
                tau
            )
        }

        let left = values[tau - 1]
        let center = values[tau]
        let right = values[tau + 1]
        let denominator = left - 2 * center + right

        guard denominator != 0,
              denominator.isFinite else {
            return Double(
                tau
            )
        }

        let offset = 0.5 * (
            left - right
        ) / denominator

        guard offset.isFinite,
              abs(
                offset
              ) <= 1 else {
            return Double(
                tau
            )
        }

        return Double(
            tau
        ) + offset
    }
}
