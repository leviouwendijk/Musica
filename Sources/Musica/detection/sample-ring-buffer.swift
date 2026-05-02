import Foundation

public final class SampleRingBuffer: @unchecked Sendable {
    private let lock = NSLock()

    private var storage: [Float]
    private var writeIndex = 0
    private var stored = 0

    public let capacity: Int

    public init(
        capacity: Int
    ) throws {
        guard capacity > 0 else {
            throw MusicaError.invalidRingCapacity(
                capacity
            )
        }

        self.capacity = capacity
        self.storage = Array(
            repeating: 0,
            count: capacity
        )
    }

    public var count: Int {
        lock.lock()
        defer {
            lock.unlock()
        }

        return stored
    }

    public func append(
        _ sample: Float
    ) {
        lock.lock()
        appendUnlocked(
            sample
        )
        lock.unlock()
    }

    public func append(
        contentsOf samples: [Float]
    ) {
        lock.lock()

        for sample in samples {
            appendUnlocked(
                sample
            )
        }

        lock.unlock()
    }

    public func appendSamples(
        _ body: (_ append: (Float) -> Void) throws -> Void
    ) rethrows {
        lock.lock()
        defer {
            lock.unlock()
        }

        try body { sample in
            self.appendUnlocked(
                sample
            )
        }
    }

    public func latest(
        _ count: Int
    ) -> [Float]? {
        guard count > 0 else {
            return nil
        }

        lock.lock()
        defer {
            lock.unlock()
        }

        guard stored >= count else {
            return nil
        }

        var output: [Float] = []
        output.reserveCapacity(
            count
        )

        let start = (
            writeIndex - count + capacity
        ) % capacity

        for offset in 0..<count {
            let index = (
                start + offset
            ) % capacity

            output.append(
                storage[index]
            )
        }

        return output
    }
}

private extension SampleRingBuffer {
    func appendUnlocked(
        _ sample: Float
    ) {
        storage[writeIndex] = sample
        writeIndex = (
            writeIndex + 1
        ) % capacity
        stored = min(
            capacity,
            stored + 1
        )
    }
}
