import Foundation

internal struct SettingPropertyKey {
    let type: Any.Type
}

extension SettingPropertyKey: CustomStringConvertible {
    var description: String {
        "\(String(describing: Self.self))<\(String(describing: type))>"
    }
}

extension SettingPropertyKey: Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.type == rhs.type
    }
}

extension SettingPropertyKey: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(type))
    }
}

internal extension Dictionary {
    subscript(_ key: Any.Type) -> Value? where Key == SettingPropertyKey {
        get { self[.init(type: key)] }
        _modify { yield &self[.init(type: key)] }
    }
}
