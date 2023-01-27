//
//  AppDelegate.swift
//  Lime
//
//  Created by Vadim Presnov on 27.01.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties
    let window = UIWindow()
    
    // MARK: - Functions
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window.rootViewController = FeedViewController()
        window.makeKeyAndVisible()
        return true
    }
}

