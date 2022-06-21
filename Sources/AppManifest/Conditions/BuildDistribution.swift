import Foundation

internal struct AnyBuildDistribution: Equatable {
    var isActive: Bool
    init<D: BuildDistribution>(_ distribution: D) {
        isActive = distribution.isActive
    }
}

/// Represents a build distribution method (e.g. `Debugger`, `AppStore`, `TestFlight`)
public protocol BuildDistribution: Equatable {
    /// A unique name for this distribution
    var name: String { get }
    /// Return `true` when this configuration should be applied
    var isActive: Bool { get }
}

public extension BuildDistribution {
    var name: String {
        String(describing: Self.self)
    }
}

/// Represents a build distributed via TestFlight
public struct TestFlight: BuildDistribution {
    /// Returns `true` if the build was distributed via TestFlight
    public var isActive: Bool {
        Bundle.main.appStoreReceiptURL?
            .absoluteString
            .localizedCaseInsensitiveContains("sandbox") == true
    }
}

public extension BuildDistribution where Self == TestFlight {
    /// Active if the build was distributed from TestFlight
    static var testFlight: Self { .init() }
}

/// Represents a build distributed via the AppStore
public struct AppStore: BuildDistribution {
    /// Returns `true` if the build was distributed from the AppStore
    public var isActive: Bool {
        !TestFlight().isActive
        && !Debugger().isActive
        && !Playground().isActive
    }
}

public extension BuildDistribution where Self == AppStore {
    /// Returns `true` if the build was distributed from the AppStore
    static var appStore: Self { .init() }
}

/// Represents a build distributed via a debugger (e.g. Xcode)
public struct Debugger: BuildDistribution {
    /// Active if the build is being run via a debugger (e.g. Xcode)
    public var isActive: Bool {
        var info = kinfo_proc()
        var mib = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        var size = MemoryLayout.stride(ofValue: info)
        let result = sysctl(&mib, UInt32(mib.count), &info, &size, nil, 0)
        guard result == 0 else { return false }
        return (info.kp_proc.p_flag & P_TRACED) != 0
    }
}

public extension BuildDistribution where Self == Debugger {
    /// Active if the build is being run via a debugger (e.g. Xcode)
    static var debugger: Self { .init() }
}

/// Represents a build being run in a Playground
public struct Playground: BuildDistribution {
    public init() {
        print(Bundle.allBundles)
    }
    /// Active is the build is being run via a Playground
    public var isActive: Bool {
        (Bundle.main.bundleIdentifier ?? "").localizedCaseInsensitiveContains("playground")
    }
}

public extension BuildDistribution where Self == Playground {
    /// Active is the build is being run via a Playground
    static var playground: Self { .init() }
}
