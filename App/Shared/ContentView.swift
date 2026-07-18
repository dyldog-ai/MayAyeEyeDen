import SwiftUI

/// Primary view for MayAyeEyeDen, shared by the macOS and iOS apps.
struct ContentView: View {
    @State private var name: String = "world"

    private let greeter = Greeter()

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "eye.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)

            Text("\(AppCore.appName) v\(AppCore.version)")
                .font(.headline)

            TextField("Name", text: $name)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 240)

            Text(greeter.greet(name: name))
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(minWidth: 320, minHeight: 240)
    }
}

#Preview {
    ContentView()
}
