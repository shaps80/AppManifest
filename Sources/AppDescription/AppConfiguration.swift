@_exported import Foundation

/**
 The configuration for an app, including the currently deployed environment.

 To determine the preferred `Environment` in the current context, the following
 rules are evaluated (priority top to bottom):

 1. Distribution AND configuration are both active
 2. Distribution only is active
 3. Configuration only is active
 4. First available Environment
 */
public struct AppConfiguration {

    /// Returns all configured environments
    public let environments: [Environment]

    /// Returns all environments available in the current deployment
    public var availableEnvironments: [Environment] {
        environments.filter { $0.condition.isActive }
    }

    /// Returns the preferred environment in the current context,
    /// taking into account active conditions
    public var preferredEnvironment: Environment {
        let activeDistributions = environments
            .filter { $0.condition.distribution.isActive }

        let activeConfigurations = environments
            .filter { $0.condition.configuration.isActive }

        return (activeDistributions + activeConfigurations).first
        ?? activeDistributions.first
        ?? activeConfigurations.first
        ?? environments.first!
    }

    /// Creates a new instance for the given environment descriptions
    /// - Parameter environments: The environments to include
    public init(@EnvironmentBuilder environments: () -> [Environment]) {
        let environments = environments()
        assert(!environments.isEmpty, "At least 1 valid environment configuration must be supplied")
        assert(environments.allSatisfy { !$0.name.isEmpty }, "1 or more Environments are missing a name. This is not allowed")
        assert(Set(environments.map { $0.name }).count == environments.map { $0.name }.count, "1 or more Environments have the same name. This is not allowed.")
        self.environments = environments
    }

}
