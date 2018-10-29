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

    private func setupApplication() {
        let eventsViewController = UINavigationController(rootViewController: EventsViewController.instance()).apply {
            $0.tabBarItem = UITabBarItem(title: "Events", image: nil, tag: 0)
        }

        let travelViewController = UINavigationController(rootViewController: TravelViewController.instance()).apply {
            $0.tabBarItem = UITabBarItem(title: "Travel", image: nil, tag: 1)
        }

        let settingsViewController = UINavigationController(rootViewController: SettingsViewController.instance()).apply {
            $0.tabBarItem = UITabBarItem(title: "Settings", image: nil, tag: 2)
        }

        viewControllers = [eventsViewController, travelViewController, settingsViewController]
    }
}
