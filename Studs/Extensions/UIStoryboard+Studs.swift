//
//  UIStoryboard+Studs.swift
//  Studs
//
//  Created by Michel Tabari on 2018-10-26.
//  Copyright © 2018 Studieresan. All rights reserved.
//

import UIKit

extension UIStoryboard {
    func initialViewController<T: UIViewController>() -> T? {
        return self.instantiateInitialViewController() as? T
    }
}
