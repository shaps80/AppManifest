import SwiftUI

private struct DeployedEnvironmentKey: EnvironmentKey {
    static var defaultValue: Environment = .none
}

public extension EnvironmentValues {
    var deployedEnvironment: Environment {
        get { self[DeployedEnvironmentKey.self] }
        set { self[DeployedEnvironmentKey.self] = newValue }
    }
}
