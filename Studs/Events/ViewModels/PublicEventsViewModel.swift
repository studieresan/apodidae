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
	var sections: [EventSection] = []

	var disposeBag = DisposeBag()

	var reloadTableViewClosure: (() -> Void)!

	func groupEvents(_ events: [Event]) -> [EventSection] {

		var yearEventDict: [Int: [Event]] = [:]
		events
			.filter({$0.published}) //Only show published events in public view
			.forEach({event in
			let studsYear = event.studsYear ?? -1
			if yearEventDict[studsYear] == nil {
				yearEventDict[studsYear] = [event]
			} else {
				yearEventDict[studsYear]!.append(event)
			}
		})

		var unsortedSections: [EventSection] = []
		yearEventDict.forEach({year, events in
			unsortedSections.append(EventSection(events: events, title: year.description))
		})

		let sortedSections = unsortedSections.sorted(by: {section1, section2 in
			return section1.title > section2.title
		})

		return sortedSections
	}

}
