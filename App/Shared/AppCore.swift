import Foundation

/// Shared core module for MayAyeEyeDen.
///
/// This is the single source of platform-agnostic logic and constants used by
/// both the macOS and iOS GUI apps. It is compiled directly into each app
/// target (see `project.yml`), so there is no separate framework or SwiftPM
/// package to resolve at build time.
public enum AppCore {
    /// Display name of the product.
    public static let appName = "MayAyeEyeDen"

    /// Semantic version of the product.
    public static let version = "0.1.0"
}

/// A minimal example service so the scaffold has something real to build and test.
public struct Greeter {
    public init() {}

    /// Returns a greeting message for the given name.
    /// - Parameter name: The name to greet.
    /// - Returns: A localized-friendly greeting string.
    public func greet(name: String) -> String {
        "Hello, \(name)! Welcome to \(AppCore.appName) v\(AppCore.version)."
    }
}
