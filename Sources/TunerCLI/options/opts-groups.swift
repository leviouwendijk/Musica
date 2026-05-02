import Arguments
import Foundation

struct TunerInputOptions: Sendable, ArgumentGroup {
    @Opt(
        "audio",
        alias: "device",
        short: "a",
        help: "Audio input device name."
    )
    var device: String?

    init() {}
}

struct TunerPitchOptions: Sendable, ArgumentGroup {
    @Opt(
        "a4",
        default: 440.0,
        help: "A4 reference frequency."
    )
    var a4: Double

    init() {}
}

struct TunerAnalysisOptions: Sendable, ArgumentGroup {
    @Opt(
        "sample-rate",
        default: 48_000,
        help: "Audio sample rate."
    )
    var sampleRate: Int

    @Opt(
        "channel",
        default: 1,
        help: "Audio input channel count."
    )
    var channel: Int

    @Opt(
        "window",
        default: 4096,
        help: "Pitch detector window size."
    )
    var window: Int

    @Opt(
        "tolerance",
        default: 5.0,
        help: "Tuned tolerance in cents."
    )
    var tolerance: Double

    @Opt(
        "duration",
        short: "d",
        help: "Stop automatically after this many seconds."
    )
    var duration: Double?

    init() {}

    func validated() throws -> Self {
        guard sampleRate > 0 else {
            throw TunerArgumentError.invalid(
                "--sample-rate must be greater than zero."
            )
        }

        guard channel > 0 else {
            throw TunerArgumentError.invalid(
                "--channel must be greater than zero."
            )
        }

        guard window > 0 else {
            throw TunerArgumentError.invalid(
                "--window must be greater than zero."
            )
        }

        guard tolerance.isFinite,
              tolerance >= 0 else {
            throw TunerArgumentError.invalid(
                "--tolerance must be zero or greater."
            )
        }

        if let duration {
            guard duration.isFinite,
                  duration > 0 else {
                throw TunerArgumentError.invalid(
                    "--duration must be greater than zero."
                )
            }
        }

        return self
    }
}

struct TunerRenderOptions: Sendable, ArgumentGroup {
    @Opt(
        "fps",
        default: 30,
        help: "Terminal render frames per second."
    )
    var fps: Int

    init() {}

    func validated() throws -> Self {
        guard fps > 0 else {
            throw TunerArgumentError.invalid(
                "--fps must be greater than zero."
            )
        }

        return self
    }
}

enum TunerArgumentError: Error, LocalizedError {
    case invalid(String)

    var errorDescription: String? {
        switch self {
        case .invalid(let message):
            return message
        }
    }
}
