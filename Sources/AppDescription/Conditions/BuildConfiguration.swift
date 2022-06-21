import Foundation

internal struct AnyBuildConfiguration: Equatable {
    var isActive: Bool
    private let name: String
    init<C: BuildConfiguration>(_ configuration: C) {
        isActive = configuration.isActive
        name = String(describing: C.self)
    }
}

/// Represents a build configuration (e.g. `DEBUG`, `RELEASE`)
public protocol BuildConfiguration: Equatable {
    /// A unique name for this configuration
    var name: String { get }
    /// Return `true` when this configuration should be applied
    var isActive: Bool { get }
}

public extension BuildConfiguration {
    var name: String {
        String(describing: Self.self)
    }
}

public struct Debug: BuildConfiguration {
    /// Returns `true` if the build was run in `Debug` configuration
    public var isActive: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
}

public extension BuildConfiguration where Self == Debug {
    /// Active if the build was run in `Debug` configuration
    static var debug: Self { .init() }
}

public struct Release: BuildConfiguration {
    /// Returns `true` if the build was run in `Release` configuration
    public var isActive: Bool {
        #if DEBUG
        return false
        #else
        return true
        #endif
    }
}

public extension BuildConfiguration where Self == Release {
    /// Active if the build was run in `Release` configuration
    static var release: Self { .init() }
}
