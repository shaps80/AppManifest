import XCTest
@testable import AppManifest

final class EnvironmentTests: XCTestCase {

    func test_namedEnvironment() {
        let dev = Environment(name: "Dev", configuration: .mock(isActive: true))

        let config = AppConfiguration {
            Environment(name: "AppStore1", distribution: .mock(isActive: true), configuration: .mock(isActive: true))
            Environment(name: "AppStore2", distribution: .mock(isActive: true), configuration: .mock(isActive: true))
            dev
            Environment(name: "Staging", distribution: .mock(isActive: true))
        }

        XCTAssertEqual(config.environment(named: "Dev")?.name, dev.name)
        XCTAssertEqual(config.environment(named: "Test")?.name, nil)
    }

    func test_duplicateConfigurations() {
        let actual = AppConfiguration {
            Environment(name: "Dev", configuration: .mock(isActive: true))
            Environment(name: "AppStore1", distribution: .mock(isActive: true), configuration: .mock(isActive: true))
            Environment(name: "AppStore2", distribution: .mock(isActive: true), configuration: .mock(isActive: true))
            Environment(name: "Staging", distribution: .mock(isActive: true))
        }.preferredEnvironment.name

        XCTAssertEqual("AppStore1", actual)
    }

    func test_activeDistribution() {
        let actual = AppConfiguration {
            Environment(name: "Test", distribution: .mock(isActive: true))

            Environment(name: "Release")

            Environment(name: "Dev", configuration: .mock(isActive: false))
        }.preferredEnvironment.name

        XCTAssertEqual("Test", actual)
    }

    func test_activeConfiguration() {
        let actual = AppConfiguration {
            Environment(name: "Test", distribution: .mock(isActive: false))

            Environment(name: "Release")

            Environment(name: "Dev", configuration: .mock(isActive: true))
        }.preferredEnvironment.name

        XCTAssertEqual("Dev", actual)
    }

    func test_activeConfigurationAndDistribution() {
        let actual = AppConfiguration {
            Environment(name: "Test", distribution: .mock(isActive: false))

            Environment(name: "Release")

            Environment(name: "Staging", distribution: .mock(isActive: true), configuration: .mock(isActive: true))

            Environment(name: "Dev", configuration: .mock(isActive: true))
        }.preferredEnvironment.name

        XCTAssertEqual("Staging", actual)
    }

    func test_activeDistributionOverActiveConfiguration() {
        let actual = AppConfiguration {
            Environment(name: "Test", distribution: .mock(isActive: true))

            Environment(name: "Release")

            Environment(name: "Dev", configuration: .mock(isActive: true))
        }.preferredEnvironment.name

        XCTAssertEqual("Test", actual)
    }

    func test_releaseFallback() {
        let config = AppConfiguration {
            Environment(name: "Test")

            Environment(name: "Release", configuration: .mock(isActive: true))

            Environment(name: "Staging")

            Environment(name: "Dev")
        }

        XCTAssertEqual("Release", config.preferredEnvironment.name)
    }

    func test_firstFallback() {
        let actual = AppConfiguration {
            Environment(name: "Test")
            Environment(name: "Dev")
        }.preferredEnvironment.name

        XCTAssertEqual("Test", actual)
    }

}

private struct MockDistribution: BuildDistribution {
    var isActive: Bool
}

private struct MockConfiguration: BuildConfiguration {
    var isActive: Bool
}

private extension BuildDistribution where Self == MockDistribution {
    static func mock(isActive: Bool) -> Self { .init(isActive: isActive) }
}

private extension BuildConfiguration where Self == MockConfiguration {
    static func mock(isActive: Bool) -> Self { .init(isActive: isActive) }
}
