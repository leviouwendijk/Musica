import Arguments

struct TunerCommandOptions: Sendable, ArgumentParsed {
    typealias ArgumentPayload = Payload

    let input: TunerInputOptions
    let pitch: TunerPitchOptions
    let analysis: TunerAnalysisOptions
    let render: TunerRenderOptions

    init(
        arguments: Payload
    ) throws {
        self.input = arguments.input
        self.pitch = arguments.pitch
        self.analysis = try arguments.analysis.validated()
        self.render = try arguments.render.validated()
    }

    func options(
        mode: TunerMode
    ) -> TunerOptions {
        TunerOptions(
            mode: mode,
            device: input.device,
            a4: pitch.a4,
            sampleRate: analysis.sampleRate,
            channel: analysis.channel,
            window: analysis.window,
            tolerance: analysis.tolerance,
            duration: analysis.duration,
            fps: render.fps
        )
    }

    struct Payload: ArgumentGroup {
        @Group("audio")
        var input: TunerInputOptions

        @Group("pitch")
        var pitch: TunerPitchOptions

        @Group("analysis")
        var analysis: TunerAnalysisOptions

        @Group("render")
        var render: TunerRenderOptions

        init() {}
    }
}
