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
    static let primary = UIColor(rgb: 0x3d8ec6)
    static let primaryDark = UIColor(rgb: 0x1D6598)
    static let bgColor = UIColor(rgb: 0xFCFCFC)
    static let veryLightGray = UIColor(rgb: 0xd9d9d9)

    static let textColor = UIColor(rgb: 0x4d4d4d)

    static let darkBlue = UIColor(rgb: 0x2F3C51)
    static let lightBlue = UIColor(rgb: 0x17B7C8)
}
