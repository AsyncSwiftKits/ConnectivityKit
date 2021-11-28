import Foundation

public enum ConnectivityStatus: String {
    case satisfied
    case unsatisfied
    case requiresConnection
}

extension ConnectivityStatus: CustomStringConvertible {
    public var description: String {
        rawValue
    }
}

public enum ConnectivityInterfaceType: String {
    case other
    case wifi
    case cellular
    case wiredEthernet
    case loopback
}

public struct ConnectivityInterface {
    public let name: String
    public let type: ConnectivityInterfaceType

    public init(name: String, type: ConnectivityInterfaceType) {
        self.name = name
        self.type = type
    }
}

extension ConnectivityInterface: CustomStringConvertible {
    public var description: String {
        "\(name) (\(type))"
    }
}

extension Array where Element == ConnectivityInterface {
    public var description: String {
        self.map { "\($0.name) (\($0.type))" }.joined(separator: ", ")
    }
}

public struct ConnectivityPath {
    public let status: ConnectivityStatus
    public let availableInterfaces: [ConnectivityInterface]
    public let isExpensive: Bool
    public let supportsDNS: Bool
    public let supportsIPv4: Bool
    public let supportsIPv6: Bool

    public init(status: ConnectivityStatus = .unsatisfied,
                availableInterfaces: [ConnectivityInterface] = [],
                isExpensive: Bool = false,
                supportsDNS: Bool = false,
                supportsIPv4: Bool = false,
                supportsIPv6: Bool = false) {
        self.status = status
        self.availableInterfaces = availableInterfaces
        self.isExpensive = isExpensive
        self.supportsDNS = supportsDNS
        self.supportsIPv4 = supportsIPv4
        self.supportsIPv6 = supportsIPv6
    }
}

extension ConnectivityPath: CustomStringConvertible {
    public var description: String {
        [
            "\(status): \(availableInterfaces.description)",
            "Expensive = \(isExpensive ? "YES" : "NO")",
            "DNS = \(supportsDNS ? "YES" : "NO")",
            "IPv4 = \(supportsIPv4 ? "YES" : "NO")",
            "IPv6 = \(supportsIPv6 ? "YES" : "NO")"
        ].joined(separator: "; ")
    }
}

public typealias PathUpdateHandler = (ConnectivityPath) -> Void

public protocol AnyConnectivityMonitor {
    func start(pathUpdateQueue: DispatchQueue, pathUpdateHandler: @escaping PathUpdateHandler)
    func cancel()
}

public class ConnectivityMonitor {
    private var monitor: AnyConnectivityMonitor?
    private let queue = DispatchQueue(label: "com.acme.connectivity", qos: .background)

    public init() {}

    public func start(pathUpdateQueue: DispatchQueue, pathUpdateHandler: @escaping PathUpdateHandler) {
        let monitor = createMonitor()
        monitor.start(pathUpdateQueue: pathUpdateQueue, pathUpdateHandler: pathUpdateHandler)
        self.monitor = monitor
    }

    public func cancel() {
        guard let monitor = monitor else { return }
        monitor.cancel()
        self.monitor = nil
    }

    private func createMonitor() -> AnyConnectivityMonitor {
        let result: AnyConnectivityMonitor
        if #available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 6.0, *) {
            result = NetworkMonitor()
        } else {
            result = ReachabilityMonitor()
        }
        return result
    }

}
