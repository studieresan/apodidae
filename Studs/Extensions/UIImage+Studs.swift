//
//  UIImage+Studs.swift
//  Studs
//
//  Created by Glenn Olsson on 2020-12-15.
//  Copyright © 2020 Studieresan. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
	static let studsLogo = UIImage(named: "squareLogo")!
	static let blurredBackground = UIImage(named: "Blurred-Background")!
	static let squareStudsS = UIImage(named: "squareS")!
	static let roundStudsS = UIImage(named: "roundS")!

	//Reverse the apperance (light/dark mode) versions
	func reversedApperance() -> UIImage {
		print("Reverse!")
		if #available(iOS 13, *), let config = self.configuration,
		   let traits = config.traitCollection {
			print("Config and traits exists")
			let style = traits.userInterfaceStyle
			var newStyle: UIUserInterfaceStyle!
			if style == .light || style == .unspecified {
				newStyle = .dark
			} else {
				newStyle = .light
			}

			let newTrait = UITraitCollection(userInterfaceStyle: newStyle)

			return self.withConfiguration(config.withTraitCollection(newTrait))
		}
		print("Done reversing")
		return self
	}
}
