import TestFlows

@main
enum MusicaTestFlowsMain {
    static func main() async {
        await TestFlowCLI.run(
            suite: MusicaFlowSuite.self
        )
    }
}
