//
//  StudsViewController.swift
//  Studs
//
//  Created by Michel Tabari on 2018-10-27.
//  Copyright © 2018 Studieresan. All rights reserved.
//

import UIKit

final class StudsViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
		updateViewControllers()
    }

    func updateViewControllers() {

		var viewControllers: [UIViewController] = []

		let isLoggedIn = UserManager.isLoggedIn()

        let eventsViewController = UINavigationController(rootViewController: EventsViewController.instance(withName: "EventsView")).apply {
            $0.tabBarItem = UITabBarItem(title: "Events", image: #imageLiteral(resourceName: "eventsTab"), tag: 0)
        }
		viewControllers.append(eventsViewController)

		if isLoggedIn {
			let travelViewController = UINavigationController(rootViewController: CountdownVC.instance(withName: "Countdown")).apply {
				$0.tabBarItem = UITabBarItem(title: "Resan", image: #imageLiteral(resourceName: "travelTab"), tag: 1)
			}

			let settingsViewController = UINavigationController(rootViewController: ProfileViewController.instance(withName: "Profile")).apply {
				$0.tabBarItem = UITabBarItem(title: "Profil", image: #imageLiteral(resourceName: "aboutTab"), tag: 2)
			}

			viewControllers.append(contentsOf: [travelViewController, settingsViewController])
		} else {
			let logginViewController = UINavigationController(rootViewController: LoginViewController.instance(withName: "LoginView")).apply {
				$0.tabBarItem = UITabBarItem(title: "Logga in", image: #imageLiteral(resourceName: "aboutTab"), tag: 2)
			}
			viewControllers.append(logginViewController)
		}

		self.viewControllers = viewControllers
		self.selectedIndex = 0
    }
}
