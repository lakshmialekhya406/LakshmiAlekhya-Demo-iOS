//
//  NetworkMonitor.swift
//  Demo
//
//  Created by Batchu Lakshmi Alekhya on 16/01/25.
//

import Foundation
import Network

/// NetworkMonitor is a singleton class that uses Apple's Network framework
/// to continuously monitor the network status. It provides a closure to notify
/// when the network status changes and exposes a flag to indicate if the network
/// is currently available.
///
/// Usage:
/// 1. Access the shared instance: `NetworkMonitor.shared`
/// 2. Set the `networkStatusChangeHandler` closure to handle network status changes.
/// 3. Call `startMonitoring()` to begin monitoring network status.
/// 4. Optionally, call `stopMonitoring()` to stop monitoring network status.

class NetworkMonitor {
    
    // Singleton instance for global access to the network monitor
    static let shared = NetworkMonitor()
    
    // Private properties for the NWPathMonitor and the dispatch queue
    private var monitor: NWPathMonitor
    private let queue = DispatchQueue.global(qos: .background)
    
    // A boolean flag to indicate network availability
    private(set) var isNetworkAvailable: Bool = false {
        didSet {
            // Notify any listeners when the network availability changes
            networkStatusChangeHandler?(isNetworkAvailable)
        }
    }
    
    // Closure that can be set to handle network status changes
    var networkStatusChangeHandler: ((Bool) -> Void)?
    
    // Private initializer to enforce singleton pattern
    private init() {
        // Initialize the NWPathMonitor
        monitor = NWPathMonitor()
        
        // Define the path update handler to check the network status
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            // Update the network availability flag based on the path status
            self.isNetworkAvailable = path.status == .satisfied
        }
        
        // Start monitoring the network status
        monitor.start(queue: queue)
    }
    
    // Public method to start monitoring network status
    func startMonitoring() {
        monitor.start(queue: queue)
    }
    
    // Public method to stop monitoring network status
    func stopMonitoring() {
        monitor.cancel()
    }
}

extension Notification.Name {
    static let networkReachable = Notification.Name("networkReachable")
}
