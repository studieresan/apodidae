//
//  HappeningNewVC.swift
//  Studs
//
//  Created by Glenn Olsson on 2021-04-06.
//  Copyright © 2021 Studieresan. All rights reserved.
//

import Foundation
import UIKit

class HappeningNewViewController: UIViewController {

	var pickedEmoji: String?

	@IBOutlet var emojiButtons: [UIButton]!

	@IBAction func emojiButtonPressed(_ sender: Any) {
		for emojiButton in self.emojiButtons {
			if let pressedButton = sender as? UIButton {
				if pressedButton == emojiButton {
					emojiButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .largeTitle)

					self.pickedEmoji = emojiButton.titleLabel?.text
				} else { //Not pressed, change to smaller font
					emojiButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
				}
			}
		}
	}

	override func viewDidLoad() {
		self.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.preferredFont(forTextStyle: .title1)]
	}
}
