//
//  AppDelegate.swift
//  Studs
//
//  Created by Michel Tabari on 2018-10-26.
//  Copyright © 2018 Studieresan. All rights reserved.
//

import UIKit
import UserNotifications
import WidgetKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

	public static let STUDSYEAR = Bundle.main.infoDictionary!["STUDS_YEAR"] as? Int

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {

        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })

        application.registerForRemoteNotifications()

        window = UIWindow(frame: UIScreen.main.bounds)

		//Reload widget when opening app
		if #available(iOS 14.0, *) {
			WidgetCenter.shared.reloadAllTimelines()
		}

        window?.run {
            $0.rootViewController = StudsViewController()
            $0.makeKeyAndVisible()
        }

        return true
    }

	//Handle deep link
	func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
		let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
		let queries = urlComponents?.queryItems
		let scheme = url.scheme
		if scheme == "studs-widget",
			url.host == "event",
			let eventId = queries?.first(where: {queryItem in
				return queryItem.name == "id"
			})?.value {
			//TODO: Open event with ID
			print("Open event with id \(eventId)")
		}

		return false
	}
}
