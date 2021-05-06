//
//  Date+Studs.swift
//  Studs
//
//  Created by Glenn Olsson on 2021-03-30.
//  Copyright © 2021 Studieresan. All rights reserved.
//

import Foundation

extension Date {
	func isSameDay(as otherDate: Date) -> Bool {
		let calendar = Calendar(identifier: .iso8601)
		return calendar.isDate(self, inSameDayAs: otherDate)
	}
}
