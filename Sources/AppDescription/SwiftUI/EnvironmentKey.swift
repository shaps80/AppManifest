#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
private struct DeployedEnvironmentKey: EnvironmentKey {
    static var defaultValue: Environment = .none
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension EnvironmentValues {
    var deployedEnvironment: Environment {
        get { self[DeployedEnvironmentKey.self] }
        set { self[DeployedEnvironmentKey.self] = newValue }
    }
}
