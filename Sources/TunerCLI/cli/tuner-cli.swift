import Darwin
import Foundation

enum TunerCLI {
    static func writeError(
        _ error: Error
    ) {
        let message: String

        if let localized = error as? LocalizedError,
           let description = localized.errorDescription {
            message = description
        } else {
            message = String(
                describing: error
            )
        }

        fputs(
            "tuner: \(message)\n",
            stderr
        )
    }
}
