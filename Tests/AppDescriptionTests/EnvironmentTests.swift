import XCTest
@testable import AppDescription

final class EnvironmentTests: XCTestCase {

    func test_activeDistribution() {
        let actual = AppConfiguration {
            Environment(name: "Test")
                .when(distribution: .mock(isActive: true))

            Environment(name: "Release")

            Environment(name: "Dev")
                .when(configuration: .mock(isActive: false))
        }.preferredEnvironment.name

        XCTAssertEqual("Test", actual)
    }

    func test_activeConfiguration() {
        let actual = AppConfiguration {
            Environment(name: "Test")
                .when(distribution: .mock(isActive: false))

            Environment(name: "Release")

            Environment(name: "Dev")
                .when(configuration: .mock(isActive: true))
        }.preferredEnvironment.name

        XCTAssertEqual("Dev", actual)
    }

    func test_activeConfigurationAndDistribution() {
        let actual = AppConfiguration {
            Environment(name: "Test")
                .when(distribution: .mock(isActive: false))

            Environment(name: "Release")

            Environment(name: "Staging")
                .when(distribution: .mock(isActive: true), configuration: .mock(isActive: true))

            Environment(name: "Dev")
                .when(configuration: .mock(isActive: true))
        }.preferredEnvironment.name

        XCTAssertEqual("Staging", actual)
    }

    func test_activeDistributionOverActiveConfiguration() {
        let actual = AppConfiguration {
            Environment(name: "Test")
                .when(distribution: .mock(isActive: true))

            Environment(name: "Release")

            Environment(name: "Dev")
                .when(configuration: .mock(isActive: true))
        }.preferredEnvironment.name

        XCTAssertEqual("Test", actual)
    }

    func test_releaseFallback() {
        let actual = AppConfiguration {
            Environment(name: "Test")
                .when(distribution: .mock(isActive: false))

            Environment(name: "Release")

            Environment(name: "Staging")

            Environment(name: "Dev")
                .when(configuration: .mock(isActive: false))
        }.preferredEnvironment.name

        XCTAssertEqual("Test", actual)
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

extension BuildDistribution where Self == MockDistribution {
    static func mock(isActive: Bool) -> Self { .init(isActive: isActive) }
}

extension BuildConfiguration where Self == MockConfiguration {
    static func mock(isActive: Bool) -> Self { .init(isActive: isActive) }
}
