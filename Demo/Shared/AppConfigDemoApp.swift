import SwiftUI
import AppDescription

@main
struct AppConfigDemoApp: App {
    @State private var currentEnvironment = config.preferredEnvironment
    
    var body: some Scene {
        WindowGroup {
            VStack {
                Picker("Environment", selection: $currentEnvironment) {
                    ForEach(config.environments) { env in
                        Text(env.name).tag(env)
                    }
                }
                .pickerStyle(.segmented)

                EnvironmentDetailView()
            }
            .padding()
            .environment(\.deployedEnvironment, currentEnvironment)
        }
    }
}

struct EnvironmentDetailView: View {
    @EnvironmentSetting(\.remoteUrl) private var url

    var body: some View {
        VStack {
            Text(url?.absoluteString ?? "No URL")
        }
    }
}

let config = AppConfiguration {
    Environment(name: "Debug", distribution: .debugger)
        .setting(\.remoteUrl, URL(string: "localhost:4444"))

    Environment(name: "Dev", configuration: .debug)
        .setting(\.remoteUrl, URL(string: "https://dev-api.com"))

    Environment(name: "Test", distribution: .testFlight)
        .setting(\.remoteUrl, URL(string: "https://test-api.com"))

    Environment(name: "Release", distribution: .appStore)
        .setting(\.remoteUrl, URL(string: "https://api.com"))
}
