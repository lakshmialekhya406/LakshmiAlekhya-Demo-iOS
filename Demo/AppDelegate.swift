//
//  AppDelegate.swift
//  Demo
//
//  Created by Batchu Lakshmi Alekhya on 13/01/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Check Network Reachability
        self.setupNetworkMonitoring()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func setupNetworkMonitoring() {
        NetworkMonitor.shared.networkStatusChangeHandler = { [weak self] isNetworkAvailable in
            guard self != nil else { return }
            if isNetworkAvailable {
                print("Network present")
                NotificationCenter.default.post(name: .networkReachable, object: nil)
            } else {
                print("Network not reachable")
            }
        }
        NetworkMonitor.shared.startMonitoring()
    }

}

