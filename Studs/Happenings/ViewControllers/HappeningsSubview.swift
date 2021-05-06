//
//  HappeningsSubview.swift
//  Studs
//
//  Created by Glenn Olsson on 2021-03-30.
//  Copyright © 2021 Studieresan. All rights reserved.
//

import Foundation
import UIKit

protocol HappeningsSubview: UIViewController {
	///Handle the new happenings found in system
	func onData(_ happenings: [Happening])
}
