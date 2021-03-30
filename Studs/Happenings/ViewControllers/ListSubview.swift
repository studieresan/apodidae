//
//  ListSubview.swift
//  Studs
//
//  Created by Glenn Olsson on 2021-03-30.
//  Copyright © 2021 Studieresan. All rights reserved.
//

import Foundation
import UIKit

class ListSubview: UIViewController, HappeningsSubview {
	var happenings: [Happening] = []

	func onData(_ happenings: [Happening]) {
		self.happenings = happenings
		print("RENDER LIST")
	}
}
