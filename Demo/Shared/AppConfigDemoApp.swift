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
                        Text(env.name)
                            .tag(env)
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
        Text(url?.absoluteString ?? "No URL defined")
    }
}

let config = AppConfiguration {
    Environment(name: "Dev")
        .when(distribution: .debugger)
        .setting(\.remoteUrl, URL(string: "https://dev-api.com"))

    Environment(name: "Test")
        .when(distribution: .testFlight, configuration: .debug)

    Environment(name: "Release")
        .setting(\.remoteUrl, URL(string: "https://api.com"))
}
