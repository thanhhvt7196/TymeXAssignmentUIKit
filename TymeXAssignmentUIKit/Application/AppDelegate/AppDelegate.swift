//
//  AppDelegate.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 4/6/25.
//

import UIKit
import Pulse
import PulseProxy
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    static let sharedRealmConfig: Realm.Configuration = {
        var config = Realm.Configuration.defaultConfiguration
        config.schemaVersion = 1
        config.deleteRealmIfMigrationNeeded = false
        if let url = config.fileURL {
            let fileUrl = url.deletingLastPathComponent().appendingPathComponent("github_user.realm")
            config.fileURL = fileUrl
        }
        return config
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions    launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupUI()
        setupPulse()
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

    private func setupPulse() {
        NetworkLogger.enableProxy()
    }
    
    private func setupUI() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        appearance.titleTextAttributes = [
            .font: FontFamily.TTNormsPro.bold.font(size: 18),
            .foregroundColor: UIColor.baseText
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().compactScrollEdgeAppearance = appearance
    }
}

