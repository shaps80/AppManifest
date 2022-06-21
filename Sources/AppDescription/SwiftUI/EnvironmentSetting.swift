import SwiftUI

@propertyWrapper
public struct EnvironmentSetting<Value>: DynamicProperty {
    @SwiftUI.Environment(\.deployedEnvironment) private var environment

    private let keyPath: KeyPath<SettingValues, Value>

    public var wrappedValue: Value {
        assert(!environment.name.isEmpty, "A deployment environment was not injecting into your SwiftUI environment:\n  .environment(\\.deploymentEnvironment, config.preferredEnvironment)")
        return environment.settings[keyPath: keyPath]
    }

    public init(_ keyPath: KeyPath<SettingValues, Value>) {
        self.keyPath = keyPath
    }
}
