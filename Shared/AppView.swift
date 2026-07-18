import SwiftUI

/// Shared UI for MayAyeEyeDen, used by both the macOS and iOS app targets.
///
/// The view adapts its chrome to the platform: iOS gets a navigation title,
/// while macOS keeps a compact, window-sized layout.
struct AppView: View {
    @State private var name: String = "world"

    private let greeter = Greeter()

    var body: some View {
        #if os(macOS)
        content
            .padding()
            .frame(minWidth: 320, minHeight: 240)
        #else
        NavigationStack {
            content
                .padding()
                .navigationTitle(MayAyeEyeDenCore.appName)
        }
        #endif
    }

    private var content: some View {
        VStack(spacing: 16) {
            Image(systemName: "eye.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)

            Text("\(MayAyeEyeDenCore.appName) v\(MayAyeEyeDenCore.version)")
                .font(.headline)

            TextField("Name", text: $name)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 240)

            Text(greeter.greet(name: name))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    AppView()
}
