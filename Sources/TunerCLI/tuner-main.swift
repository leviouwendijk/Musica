import Arguments
import Foundation

@main
enum TunerCommand: ArgumentCommand {
    static let name = "tuner"
    static let defaultChild = ListenCommand.self

    static let children: [ArgumentCommandType] = [
        HelpCommand.self,
        ListenCommand.self,
        GuitarCommand.self,
        BassCommand.self,
    ]

    static func main() async {
        await ArgumentProgram.main(
            command: Self.self,
            errorHandler: { error in
                TunerCLI.writeError(
                    error
                )

                return 1
            }
        )
    }
}
