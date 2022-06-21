import SwiftUI

@propertyWrapper
public struct EnvironmentSetting<Value>: DynamicProperty {
    @SwiftUI.Environment(\.deployedEnvironment) private var environment

    private let keyPath: KeyPath<SettingValues, Value>

    public var wrappedValue: Value {
        environment.settings[keyPath: keyPath]
    }

    public init(_ keyPath: KeyPath<SettingValues, Value>) {
        self.keyPath = keyPath
    }
}
