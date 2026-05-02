import Foundation
import Musica
import Terminal

struct TunerRenderer: Sendable {
    func render(
        reading: PitchReading?,
        state: PitchStabilityState
    ) -> String {
        guard let reading else {
            return "listening    no signal    \(bar(cents: nil))"
                .ansi(
                    .dim
                )
        }

        let status = state.stable
            ? "stable"
            : label(
                for: state.status
            )
        let line = [
            reading.target.name.padding(
                toLength: 4,
                withPad: " ",
                startingAt: 0
            ),
            String(
                format: "%7.2f Hz",
                reading.frequency
            ),
            String(
                format: "%+6.1f cents",
                reading.cents
            ),
            status.padding(
                toLength: 6,
                withPad: " ",
                startingAt: 0
            ),
            bar(
                cents: reading.cents
            ),
        ].joined(
            separator: "  "
        )

        if state.stable {
            return line.ansi(
                .green
            )
        }

        switch state.status {
        case .tuned:
            return line.ansi(
                .brightGreen
            )

        case .flat, .sharp:
            return line.ansi(
                .yellow
            )

        case .noSignal:
            return line.ansi(
                .dim
            )
        }
    }
}

private extension TunerRenderer {
    func label(
        for status: PitchTuningStatus
    ) -> String {
        switch status {
        case .noSignal:
            return "quiet"

        case .flat:
            return "flat"

        case .sharp:
            return "sharp"

        case .tuned:
            return "tuned"
        }
    }

    func bar(
        cents: Double?
    ) -> String {
        let radius = 10
        let width = radius * 2 + 1
        var slots = Array(
            repeating: "·",
            count: width
        )
        let center = radius

        slots[center] = "|"

        guard let cents,
              cents.isFinite else {
            return "[\(slots.joined())]"
        }

        let clamped = max(
            -50,
            min(
                50,
                cents
            )
        )
        let offset = Int(
            (
                clamped / 50 * Double(
                    radius
                )
            ).rounded()
        )
        let index = max(
            0,
            min(
                width - 1,
                center + offset
            )
        )

        slots[index] = "●"

        return "[\(slots.joined())]"
    }
}
