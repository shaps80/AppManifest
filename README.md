![mac](https://img.shields.io/badge/macOS-FD961A)
![ios](https://img.shields.io/badge/iOS-0C62C7)
![tv](https://img.shields.io/badge/tvOS-00B9BB)
![watchOS](https://img.shields.io/badge/iOS-DE1F51)

# AppManifest

Introducing **AppManifest**, a library for defining your app's deployed environment configuration.

Inspired by the Swift Package manifest and SwiftUI APIs, the library aims to provide a type-safe manifest of the available environments, the conditions in which they're available and even custom settings that will be applied when using that environment.

## Usage

Using a `resultBuilder` it couldn't be easier to define your `Environment`'s:

```swift
let config = AppConfiguration {
    Environment(name: "Dev", configuration: .debug)
    Environment(name: "Test", distribution: .testFlight)
    Environment(name: "Release", distribution: .appStore)
}
```

As you can see a unique name must be provided as well as any conditions (`distribution` or `configuration`) where the specified `Environment` is available. This allows you to define all of your `Environment`'s up-front and let the configuration decide which is the `preferredEnvironment` automatically.

> You can review the AppConfiguration header-docs for details on how priority is determined, however in most cases the behaviour should be 'as expected'. You can also review the unit tests to see working implementations.

Its also common to have `Environment` specific settings like API keys, URLs and more. The library provides a familiar `SwiftUI.Environment` style API, making it easy to learn and extend for your own needs.

```swift
Environment(name: "Release", distribution: .appStore)
    .setting(\.remoteUrl, URL(string: "https://api.com"))
```

> The library provides a default implementation of `remoteUrl` for you.
> See below for more details on how to create your own settings.

Once you have configured your `Environment`'s and any associated settings, you can use the configuration to determine the most appropriate `Environment` in the current context (e.g. AppStore, Debug, etc)

```swift
// Dev when in DEBUG
// Test when installed via TestFlight
// Release when installed via the AppStore
config.preferredEnvironment
```

## Custom Settings

You can create custom setting values by extending `SettingValues` similarly to how you would extend the `SwiftUI.EnvironmentValues`.

```swift
private struct MySettingKey: SettingKey {
    static let defaultValue: String = "foo"
}

extension SettingValues {
    var myCustomValue: String {
        get { self[MySettingKey.self] }
        set { self[MySettingKey.self] = newValue }
    }
}
```

You can then apply the setting to your `Environment`:

```swift
Environment(name: "Dev") { }
    .setting(\.myCustomValue, "bar")
```

## SwiftUI

If you need to access settings from your current `Environment` the library also provides a convenient dynamic `PropertyWrapper` that will cause your `View` to update whenever the associated setting changes:

```swift
@EnvironmentSetting(\.myCustomValue) private var value // "bar"
```

In order for this to behave correctly however you will need to inject the `Environment` somewhere at the top-level of your `View` hierarchy. Ommitting this step will throw an **assertion**.

```swift
@main
struct DemoApp: App {
    var body: some Scene {
        ContentView()
            .environment(\.deployedEnvironment, config.preferredEnvironment)
    }
}
```

> Note `deployedEnvironment` is a pre-defined `EnvironmentKey` you **must** use in order for the property wrapper to function.

## Installation

You can install manually (by copying the files in the `Sources` directory) or using Swift Package Manager (**preferred**)

To install using Swift Package Manager, add this to the `dependencies` section of your `Package.swift` file:

`.package(url: "https://github.com/shaps80/AppManifest.git", .upToNextMinor(from: "1.0.0"))`