import SwiftUI
import XCTest
@testable import AppDescription

final class SettingsTests: XCTestCase {

    func testPropertyWrapper() {
        var settings = SettingValues()
        let actual = URL(fileURLWithPath: "/test")
        settings.remoteUrl = actual
        XCTAssertEqual(settings.remoteUrl, actual)
        XCTAssertEqual(settings.mock, "foo")
    }

}

private struct MockSettingKey: SettingKey {
    static var defaultValue: String = "foo"
}

extension SettingValues {
    var mock: String {
        get { self[MockSettingKey.self] }
        set { self[MockSettingKey.self] = newValue }
    }
}
