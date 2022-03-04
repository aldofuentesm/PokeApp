//
//  AppDelegate.swift
//  VIPER
//
//  Created by Omar Hernandez on 10/02/22.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let controller = PokeMainViewRouterImplementation()
        window?.rootViewController = controller.navigationController
        window?.makeKeyAndVisible()
        return true
    }
}

