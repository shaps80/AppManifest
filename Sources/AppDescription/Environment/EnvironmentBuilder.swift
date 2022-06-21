import Foundation

@resultBuilder
public struct EnvironmentBuilder {
    public static func buildBlock() -> Never { fatalError() }
    public static func buildBlock(_ components: Environment...) -> [Environment] { components }
}
