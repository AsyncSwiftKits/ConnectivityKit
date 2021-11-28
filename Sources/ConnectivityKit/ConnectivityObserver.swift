#if canImport(Combine)

import Foundation
import Combine

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public class ConnectivityObserver {
    private var monitor: AnyConnectivityMonitor?
    private var subject: PassthroughSubject<ConnectivityPath, Never>?

    public init() {}

    /// Starts monitor and returns a publisher
    /// - Parameter pathUpdateQueue: queue which is runs the upate
    /// - Returns: AnyPublisher for updates on path changes
    public func start(pathUpdateQueue: DispatchQueue = .main) -> AnyPublisher<ConnectivityPath, Never> {
        let publisher: AnyPublisher<ConnectivityPath, Never>

        if let subject = subject {
            publisher = subject.eraseToAnyPublisher()
        } else {
            let subject = PassthroughSubject<ConnectivityPath, Never>()
            let monitor = NetworkMonitor()
            monitor.start(pathUpdateQueue: pathUpdateQueue, pathUpdateHandler: handlePath(_:))

            self.subject = subject
            self.monitor = monitor

            publisher = subject.eraseToAnyPublisher()
        }

        return publisher
    }

    /// Cancel monitoring changes to network path
    public func cancel() {
        guard let monitor = monitor, let subject = subject else {
            return
        }
        defer {
            self.subject = nil
            self.monitor = nil
        }

        monitor.cancel()
        subject.send(completion: .finished)
    }

    private func handlePath(_ path: ConnectivityPath) -> Void {
        subject?.send(path)
    }

}

#endif
