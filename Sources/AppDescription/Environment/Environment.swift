import Foundation

/// Represents an Environment the app communicates with
public struct Environment: Hashable, Identifiable, CustomStringConvertible {

    public var id: String { name }

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
    private var _condition: EnvironmentCondition = .init(
        distribution: nil,
        configuration: .init(.release)
    )

    /// Returns a new environment with the specified name
    /// - Parameters:
    ///   - name: A unique name for identifying this environment
    public init(name: String) {
        self.name = name
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

public extension Environment {

    /// Adds a condition where this environment should be active
    /// - Parameter distribution: The active distribution where this environment should be available
    func when<D: BuildDistribution>(distribution: D) -> Environment {
        var env = self
        env.condition.distribution = .init(distribution)
        return env
    }

    /// Adds a condition where this environment should be active
    /// - Parameter configuration: The active configuration where this environment should be available
    func when<C: BuildConfiguration>(configuration: C) -> Environment {
        var env = self
        env.condition.configuration = .init(configuration)
        return env
    }

    /// Adds a condition where this environment should be active
    /// - Parameters:
    ///   - distribution: The active distribution where this environment should be available
    ///   - configuration: The active configuration where this environment should be available
    func when<D: BuildDistribution, C: BuildConfiguration>(distribution: D, configuration: C) -> Environment {
        var env = self
        env.condition.distribution = .init(distribution)
        env.condition.configuration = .init(configuration)
        return env
    }

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
