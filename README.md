# AppDescription

Introducing a library for defining your app's deployment environment configuration.

Inspired by the Swift Package manifest, the library aims to provide a type-safe _description_ of the available environments, the conditions in which they're available and even custom settings that should be applied when using that environment.

## Usage

Similarly to `Package.swift` you generally configure using:

```swift
let config = AppConfiguration {
    Environment(name: "Dev", configuration: .debug)
    Environment(name: "Test", distribution: .testFlight)
    Environment(name: "Release", distribution: .appStore)
}
```

Its also common to have `Environment` specific settings like API URLs and more. The library supports this similarly to how `EnvironmentValues` are supported in SwiftUI, making it easy for you to extend in a familiar, type-safe manner.

```swift
Environment(name: "Release", distribution: .appStore)
    .setting(\.remoteUrl, URL(string: "https://api.com"))
```

> The library provides a default implementation of `remoteUrl` for you.
> See below for more details on how to create your own settings.

Once you have configured your `Environment`'s and any associated settings, you can use the configuration to determine the most appropriate `Environment` for the current context.

```swift
// Dev when in DEBUG
// Test when installed via TestFlight
// Release when installed via the AppStore
config.preferredEnvironment
```

## Features
