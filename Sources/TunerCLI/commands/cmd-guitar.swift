import Arguments

enum GuitarCommand: ParsedArgumentCommand {
    typealias Options = TunerCommandOptions

    static let name = "guitar"

    static func run(
        _ options: TunerCommandOptions,
        invocation: ParsedInvocation
    ) async throws {
        try await TunerRunner(
            options: options.options(
                mode: .guitar
            )
        ).run()
    }
}
