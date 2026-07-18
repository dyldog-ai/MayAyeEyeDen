import SwiftUI
import MayAyeEyeDenCore

struct ContentView: View {
    @State private var name: String = "world"

    private let greeter = Greeter()

    var body: some View {
        NavigationStack {
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
            .padding()
            .navigationTitle(MayAyeEyeDenCore.appName)
        }
    }
}

#Preview {
    ContentView()
}
