//
//  EventCellViewModel.swift
//  Studs
//
//  Created by Willy Liu on 2019-02-22.
//  Copyright © 2019 Studieresan. All rights reserved.
//

import Foundation

struct EventCellViewModel {
    let month: String
    let day: String
    let companyName: String

	init(event: Event) {

		let date = event.getDate()

		let dateFormatter = DateFormatter()

		dateFormatter.dateFormat = "MMM"
		self.month = dateFormatter.string(from: date).uppercased()

		dateFormatter.dateFormat = "d"
		self.day = dateFormatter.string(from: date)

		self.companyName = event.company?.name ?? "Okänt företag"
	}
}
