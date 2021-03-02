//
//  UIViewController+Studs.swift
//  Studs
//
//  Created by Michel Tabari on 2018-10-26.
//  Copyright © 2018 Studieresan. All rights reserved.
//

import UIKit

extension UIViewController {
    static func instance() -> Self {
        let storyboardName = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
		guard let viewController: Self = storyboard.initialViewController() else {
			fatalError("No vc with name \(storyboardName)")
		}
        return viewController
    }

	///Instance with name of storyboard file
	static func instance(withName storyboardName: String) -> Self {
		let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
		guard let viewController: Self = storyboard.initialViewController() else {
			fatalError("No vc with name \(storyboardName)")
		}
		return viewController
	}

    func setTabBarVisible(visible: Bool, animated: Bool) {
        guard isTabBarVisible != visible else { return }

        let frame = self.tabBarController?.tabBar.frame
        let height = frame?.size.height
        let offsetY = (visible ? -height! : height)

        let duration: TimeInterval = (animated ? 0.3 : 0.0)

        if frame != nil {
            UIView.animate(withDuration: duration) {
                self.tabBarController?.tabBar.frame = frame!.offsetBy(dx: 0, dy: offsetY!)
                return
            }
        }
    }

    var isTabBarVisible: Bool {
        return (self.tabBarController?.tabBar.frame.origin.y ?? 0) < self.view.frame.maxY
    }
}
