import Foundation

internal struct EnvironmentCondition: Equatable {
    var distribution: AnyBuildDistribution = .init(.appStore)
    var configuration: AnyBuildConfiguration = .init(.release)

    var isActive: Bool {
        distribution.isActive || configuration.isActive
    }
}
