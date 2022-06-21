import Foundation

/// Represents an Environment the app communicates with
public struct Environment: Hashable, CustomStringConvertible {

    /// A user friendly name to associate with this environment
    public let name: String

    /// The preferences associated with this environment
    public fileprivate(set) var settings: SettingValues {
        get { name.isEmpty ? .init() : _settings }
        set { _settings = newValue }
    }
    private var _settings: SettingValues  = .init()

    /// The conditions under which this environment is available
    fileprivate(set) var condition: EnvironmentCondition {
        get { name.isEmpty ? .init() : _condition }
        set { _condition = newValue }
    }
    private var _condition: EnvironmentCondition = .init()

    /// Returns a new environment with the specified name
    /// - Parameters:
    ///   - name: A unique name for identifying this environment
    public init(name: String) {
        self.name = name
        self.condition = .init(distribution: .init(AppStore()), configuration: .init(Release()))
    }

    /// Returns a new environment with the specified name
    /// - Parameters:
    ///   - name: A unique name for identifying this environment
    ///   - distribution: The active distribution where this environment should be available
    public init<D: BuildDistribution>(name: String, distribution: D) {
        self.name = name
        self.condition = .init(distribution: .init(distribution))
    }

    /// Returns a new environment with the specified name
    /// - Parameters:
    ///   - name: A unique name for identifying this environment
    ///   - configuration: The active configuration where this environment should be available
    public init<C: BuildConfiguration>(name: String, configuration: C) {
        self.name = name
        self.condition = .init(configuration: .init(configuration))
    }

    /// Returns a new environment with the specified name
    /// - Parameters:
    ///   - name: A unique name for identifying this environment
    ///   - distribution: The active distribution where this environment should be available
    ///   - configuration: The active configuration where this environment should be available
    public init<D: BuildDistribution, C: BuildConfiguration>(name: String, distribution: D, configuration: C) {
        self.name = name
        self.condition = .init(distribution: .init(distribution), configuration: .init(configuration))
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }

    public var description: String {
        let type = String(describing: Self.self)
        let state = condition.isActive ? "available" : "unavailable"
        return name.isEmpty ? "\(type): none" : "\(type): \(name) (\(state))"
    }

}

extension Environment: Identifiable {
    public var id: String { name }
}

public extension Environment {
    /// Sets the setting value of the specified key path to the given value.
    ///
    /// Use this modifier to set one of the writable properties of the
    /// ``SettingValues`` structure, including custom values that you
    /// create. For example, you can set the value associated with the
    /// ``SettingValue/remoteUrl`` key:
    ///
    ///     Environment(name: "Dev") { }
    ///         .environment(\.remoteUrl, URL(string: "https://dev-api.com"))
    ///
    /// You then read the value from the `Environment`
    /// using the ``Environment`` settings property:
    ///
    ///     config.preferredEnvironment.settings.remoteUrl
    ///
    /// - Parameters:
    ///   - keyPath: A key path that indicates the property of the
    ///     ``SettingValues`` structure to update.
    ///   - value: The new value to set for the item specified by `keyPath`.
    func setting<V>(_ keyPath: WritableKeyPath<SettingValues, V>, _ value: V) -> Environment {
        var env = self
        env.settings[keyPath: keyPath] = value
        return env
    }
}

internal extension Environment {
    static var none: Self { .init(name: "") }
}
