import ArgumentParser
import MayAyeEyeDenCore

@main
struct MayAyeEyeDenCLI: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "mayaeyedenden-cli",
        abstract: "Command-line interface for MayAyeEyeDen."
    )

    @Option(name: .shortAndLong, help: "Name to greet.")
    var name: String = "world"

    @Flag(name: .shortAndLong, help: "Show version information and exit.")
    var showVersion: Bool = false

    mutating func run() throws {
        if showVersion {
            print("\(MayAyeEyeDenCore.appName) \(MayAyeEyeDenCore.version)")
            return
        }

        let greeter = Greeter()
        print(greeter.greet(name: name))
    }
}
