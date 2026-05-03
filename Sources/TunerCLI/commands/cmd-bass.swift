import Arguments

enum BassCommand: ParsedArgumentCommand {
    typealias Options = TunerCommandOptions

    static let name = "bass"

    static func run(
        _ options: TunerCommandOptions,
        invocation: ParsedInvocation
    ) async throws {
        try await TunerRunner(
            options: options.options(
                mode: .bass
            )
        ).run()
    }
}
