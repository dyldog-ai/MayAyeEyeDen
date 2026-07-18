import Foundation

/// Shared core for MayAyeEyeDen (single codebase shared by the macOS and iOS apps).
public enum MayAyeEyeDenCore {
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
        "Hello, \(name)! Welcome to \(MayAyeEyeDenCore.appName) v\(MayAyeEyeDenCore.version)."
    }
}
