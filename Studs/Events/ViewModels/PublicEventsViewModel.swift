//
//  PublicEventsViewModel.swift
//  Studs
//
//  Created by Glenn Olsson on 2020-12-18.
//  Copyright © 2020 Studieresan. All rights reserved.
//

import Foundation
import RxSwift

class PublicEventsViewModel: EventsViewModel {

	///The parameter sent when fetching events. Should be nil if all events should come
	var studsYearParameter: Int? //Set to nil

	///Array of section title and the events in this section
	var sections: [(title: String, events: [Event])] = []

	var disposeBag = DisposeBag()

	var reloadTableViewClosure: (() -> Void)!

	func groupEvents(_ events: [Event]) -> [(title: String, events: [Event])] {
		print("Group events private")

		var yearEventDict: [Int: [Event]] = [:]
		events
//			.filter({$0.published})
			.forEach({event in
				print("Published? ", event.published)
			let studsYear = event.studsYear ?? -1
			if yearEventDict[studsYear] == nil {
				yearEventDict[studsYear] = [event]
			} else {
				yearEventDict[studsYear]!.append(event)
			}
		})

		var unsortedResult: [(title: String, events: [Event])] = []
		yearEventDict.forEach({year, events in
			unsortedResult.append((title: year.description, events: events))
		})

		let sortedResult = unsortedResult.sorted(by: {section1, section2 in
			return section1.title > section2.title
		})

		print("Private grouped", sortedResult)

		return sortedResult
	}

}
