//
//  HappeningsMainVC.swift
//  Studs
//
//  Created by Glenn Olsson on 2021-03-30.
//  Copyright © 2021 Studieresan. All rights reserved.
//

import Foundation
import UIKit

class HappeningsMainVC: UIViewController {

	@IBOutlet weak var subviewTypeSwitch: UISegmentedControl!
	@IBOutlet weak var happeningsSubview: UIView!

	@IBAction func newHappeningPressed(_ sender: Any) {
		print("New happening!")
	}

	override func viewDidLoad() {
		self.navigationController?.setNavigationBarHidden(true, animated: false)
		subviewTypeSwitch.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.primaryBG], for: .selected)
	}
}
