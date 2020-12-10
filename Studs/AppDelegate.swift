//
//  AppDelegate.swift
//  Studs
//
//  Created by Michel Tabari on 2018-10-26.
//  Copyright © 2018 Studieresan. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

	public static let STUDSYEAR = Bundle.main.infoDictionary!["STUDS_YEAR"] as? Int

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
//        FirebaseApp.configure()
        UserManager.setDefaultPreferences()

        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })

        application.registerForRemoteNotifications()

        window = UIWindow(frame: UIScreen.main.bounds)

        let rootVC = UserManager.isLoggedIn() ? StudsViewController() : LoginViewController.instance()

        window?.run {
            $0.rootViewController = rootVC
            $0.makeKeyAndVisible()
        }

        return true
    }
}
