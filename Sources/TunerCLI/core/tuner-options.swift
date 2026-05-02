struct TunerOptions: Sendable {
    let mode: TunerMode
    let device: String?
    let a4: Double
    let sampleRate: Int
    let channel: Int
    let window: Int
    let tolerance: Double
    let duration: Double?
    let fps: Int
}
