import Foundation

final class TunerStopState: @unchecked Sendable {
    private let lock = NSLock()
    private var value = false

    func stop() {
        lock.lock()
        value = true
        lock.unlock()
    }

    var stopped: Bool {
        lock.lock()
        defer {
            lock.unlock()
        }

        return value
    }
}
