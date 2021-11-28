[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FbrennanMKE%2FConnectivityKit%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/brennanMKE/ConnectivityKit)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FbrennanMKE%2FConnectivityKit%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/brennanMKE/ConnectivityKit)

# ConnectivityKit

Adapting to changes in network connectivity can allow for suspending or resuming network activity. When entering an elevator or going through a tunnel our devices typically lose connectivity completely. We also move out of range of WiFi and transition to a cellular connection. Apple's [Network Framework] includes [NWPathMonitor] which provides updates in response to changes to [NWPath]. This framework was introduced in 2018 and is a modern replacement to [SCNetworkReachability], simply known as the Reachability API which does not support many of the features supported by modern network protocols such as WiFi 6 and 5G.

For apps which still support older OS versions it is necessary to use Reachability while most users are able to use the Network framework. This package automatically users the API which is available based on the OS version.

See: [Introduction to Network.framework]

## Usage

This package includes `ConnectivityMonitor` which internally uses `NetworkMonitor` or `ReachabilityMonitor` which are simply available as `AnyConnectivityMonitor`. For recent OS versions of iOS, macOS, tvOS and watchOS the `NetworkMonitor` will be used. For earlier versions `ReachabilityMonitor` will be used.

Simply call the `start` function and provide a path handler to get updates. Call the `cancel` function to discontinue monitoring.

## Combine

Support for Combine is provided by `ConnectivityObserver` which has the same `start` and `cancel` functions as `ConnectivityMonitor` but it returns `AnyPublisher`. It can be used to observe path changes.

## Swift Package

This project is set up as a Swift Package which can be used by the [Swift Package Manager] (SPM) with Xcode. In your `Package.swift` add this package with the code below.

```swift
dependencies: [
    .package(url: "https://github.com/brennanMKE/ConnectivityKit", from: "1.0.0"),
],
```

## Supporting iOS 10.0 and Later

Since this package automatically handles the selection of the implementation your code can just use `ConnectivityMonitor` to get updates to the network path. The Reachability API comes from the [System Configuration Framework] which is available for all of Apple's platforms except watchOS. The implementation for the `ReachabilityMonitor` will get an empty implementation for watchOS prior to watchOS 6.0 which is when [Network Framework] was first made available to watchOS.

If your Deployment Target for any of Apple's platforms supports [Network Framework] then it will always use the modern implementation. This package will allow you to use the same code across all platforms and respond to changes to network connectivity.

---
[Network Framework]: https://developer.apple.com/documentation/network
[NWPathMonitor]: https://developer.apple.com/documentation/network/nwpathmonitor
[NWPath]: https://developer.apple.com/documentation/network/nwpath
[SCNetworkReachability]: https://developer.apple.com/documentation/systemconfiguration/scnetworkreachability-g7d
[System Configuration Framework]: https://developer.apple.com/documentation/systemconfiguration
[Introduction to Network.framework]: https://developer.apple.com/videos/play/wwdc2018/715
[Swift Package Manager]: https://swift.org/package-manager/
