//
//  UIColor+Studs.swift
//  Studs
//
//  Created by Michel Tabari on 2018-10-26.
//  Copyright © 2018 Studieresan. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red supplied")
        assert(green >= 0 && green <= 255, "Invalid green supplied")
        assert(blue >= 0 && blue <= 255, "Invalid blue supplied")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(red: (rgb >> 16) & 0xFF, green: (rgb >> 8) & 0xFF, blue: rgb & 0xFF)
    }

    // MARK: - Studs Colors
	// Force unwrapp so we will notice at first run if the colors are bad
	static let primary = UIColor(named: "Primary")!
	static let secondary = UIColor(named: "Secondary")!

	static let primaryBG = UIColor(named: "PrimaryBG")!
	static let secondaryBG = UIColor(named: "SecondaryBG")!
	static let veryLightGray = UIColor(named: "VeryLightGray")!

	static let textColor = UIColor(named: "TextColor")!

	static let shadow = UIColor(named: "Shadow")!
}
