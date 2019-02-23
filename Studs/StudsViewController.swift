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
        setupApplication()
    }

    override func viewDidAppear(_ animated: Bool) {
        let isLoggedIn = false
        if !isLoggedIn {
            self.present(LoginViewController.instance(), animated: true, completion: nil)
            return
        }
    }

    private func setupApplication() {
        let eventsViewController = UINavigationController(rootViewController: EventsViewController.instance()).apply {
            $0.tabBarItem = UITabBarItem(title: "Events", image: #imageLiteral(resourceName: "eventsTab"), tag: 0)
        }

        let travelViewController = UINavigationController(rootViewController: TravelViewController.instance()).apply {
            $0.tabBarItem = UITabBarItem(title: "Travel", image: #imageLiteral(resourceName: "travelTab"), tag: 1)
        }

        let settingsViewController = UINavigationController(rootViewController: AboutViewController.instance()).apply {
            $0.tabBarItem = UITabBarItem(title: "About", image: #imageLiteral(resourceName: "aboutTab"), tag: 2)
        }

        viewControllers = [eventsViewController, travelViewController, settingsViewController]
    }
}
