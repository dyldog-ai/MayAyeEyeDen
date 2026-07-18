import SwiftUI

/// iOS entry point. The shared UI and logic live in `Shared/` and are
/// compiled directly into this app target, so no module import is needed.
@main
struct MayAyeEyeDenApp: App {
    var body: some Scene {
        WindowGroup {
            AppView()
        }
    }
}
