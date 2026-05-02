import Arguments

enum ListenCommand: ParsedArgumentCommand {
    typealias Options = TunerCommandOptions

    static let name = "listen"

    static func run(
        _ options: TunerCommandOptions,
        invocation: ParsedInvocation
    ) async throws {
        try await TunerRunner(
            options: options.options(
                mode: .listen
            )
        ).run()
    }
}
