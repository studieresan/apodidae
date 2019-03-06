//
//  AppDelegate.swift
//  Studs
//
//  Created by Michel Tabari on 2018-10-26.
//  Copyright © 2018 Studieresan. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let userToken = UserDefaults.standard.string(forKey: "token")
        let isLoggedIn = userToken != nil

        let rootVC = isLoggedIn ? StudsViewController() : LoginViewController.instance()

        window?.run {
            $0.rootViewController = rootVC
            $0.makeKeyAndVisible()
        }
        return true
    }
}
