import TestFlows

enum MusicaFlowSuite: TestFlowRegistry {
    static let title = "Musica flow tests"

    static let flows: [TestFlow] = [
        pitchFlow,
        detectionFlow,
        bufferFlow,
        stabilityFlow,
    ]
}
