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
	var location: GeoJSON?
	var companions: [User] = []

	@IBOutlet var emojiButtons: [UIButton]!

	@IBOutlet var descriptionField: UITextView!

	@IBAction func saveButtonPressed(_ sender: Any) {
		print("SAVE")
	}

	@objc func hideKeyboard() {
		print("HIDE")
		self.view.endEditing(true)
	}

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
		super.viewDidLoad()

		//Set bar title font
		self.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.preferredFont(forTextStyle: .title1)]

		self.descriptionField.delegate = self
		self.descriptionField.returnKeyType = .done

	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.hideKeyboard()
	}
}

extension HappeningNewViewController: UITextViewDelegate {

	func textAreaShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()

		print("Should return ")
		self.hideKeyboard()
		textField.endEditing(true)

		return true
	}
}
