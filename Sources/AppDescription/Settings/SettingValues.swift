import Foundation

/// A key for accessing settings in an Environment
///
/// You can create custom setting values by extending the
/// ``SettingValues`` structure with new properties.
/// First declare a new setting key type and specify a value for the
/// required ``defaultValue`` property:
///
///     private struct MySettingKey: SettingKey {
///         static let defaultValue: String = "Default value"
///     }
///
/// The Swift compiler automatically infers the associated ``Value`` type as the
/// type you specify for the default value. Then use the key to define a new
/// setting value property:
///
///     extension SettingValues {
///         var myCustomValue: String {
///             get { self[MySettingKey.self] }
///             set { self[MySettingKey.self] = newValue }
///         }
///     }
///
/// Clients of your environment value never use the key directly.
/// Instead, they use the key path of your custom environment value property.
/// To set the environment value for a view and all its subviews, add the
/// ``View/environment(_:_:)`` view modifier to that view:
///
///     Environment(name: "Dev") {
///         .setting(\.myCustomValue, "Another string")
///
/// To read the value from an `Environment` use the
/// ``settings`` property:
///
///     config.preferredEnvironment.settings.myCustomValue
///
public protocol SettingKey {
    /// The associated type representing the type of the setting key's value.
    associatedtype Value
    /// The default value for the setting key.
    static var defaultValue: Value { get }
}

/// A collection of setting values available through an `Environment`
///
/// You can create custom setting values by extending the
/// ``SettingValues`` structure with new properties.
/// First declare a new setting key type and specify a value for the
/// required ``defaultValue`` property:
///
///     private struct MySettingKey: SettingKey {
///         static let defaultValue: String = "Default value"
///     }
///
/// The Swift compiler automatically infers the associated ``Value`` type as the
/// type you specify for the default value. Then use the key to define a new
/// setting value property:
///
///     extension SettingValues {
///         var myCustomValue: String {
///             get { self[MySettingKey.self] }
///             set { self[MySettingKey.self] = newValue }
///         }
///     }
///
/// To read the value from an `Environment` use the
/// ``settings`` property:
///
///     config.preferredEnvironment.settings.myCustomValue
public struct SettingValues: CustomStringConvertible {
    internal var data: [SettingPropertyKey: Any] = [:]

    /// Accesses the setting value associated with a specified key.
    internal subscript<K>(key: K.Type) -> K.Value where K: SettingKey {
        get { data[.init(type: key)] as? K.Value ?? K.defaultValue }
        set { data[.init(type: key)] = newValue }
    }

    public var description: String {
        let keyValues = data.map { "\($0.key) = \($0.value)" }.joined(separator: ", ")
        return "[\(keyValues)]"
    }
}

private struct RemoteUrlSettingKey: SettingKey {
    static var defaultValue: URL? = nil
}

public extension SettingValues {
    var remoteUrl: URL? {
        get { self[RemoteUrlSettingKey.self] }
        set { self[RemoteUrlSettingKey.self] = newValue }
    }
}
