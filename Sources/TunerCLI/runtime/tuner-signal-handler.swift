import Darwin
import Dispatch

final class TunerSignalHandler {
    private let source: DispatchSourceSignal

    init(
        stop: @escaping @Sendable () -> Void
    ) {
        signal(
            SIGINT,
            SIG_IGN
        )

        source = DispatchSource.makeSignalSource(
            signal: SIGINT,
            queue: .main
        )

        source.setEventHandler {
            stop()
        }

        source.resume()
    }

    deinit {
        source.cancel()

        signal(
            SIGINT,
            SIG_DFL
        )
    }
}
