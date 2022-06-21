import Foundation

internal struct EnvironmentCondition: Equatable {
    var distribution: AnyBuildDistribution?
    var configuration: AnyBuildConfiguration?

    var isActive: Bool {
        (distribution?.isActive ?? false)
        || (configuration?.isActive ?? false)
    }
}
