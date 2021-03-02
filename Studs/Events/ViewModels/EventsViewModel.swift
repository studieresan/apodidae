//
//  EventsViewModel.swift
//  Studs
//
//  Created by Glenn Olsson on 2020-12-18.
//  Copyright © 2020 Studieresan. All rights reserved.
//

import Foundation
import RxSwift

//Inherits AnyObject so it can be mutated (i.e. only classes can inherit)
protocol EventsViewModel: AnyObject {

	///The parameter sent when fetching events. Should be nil if all events should come
	var studsYearParameter: Int? { get }

	///Array of section title and the events in this section
	var sections: [EventSection] { get set }

	///Group the events into section title and events in section. The events passed are sorted by date, the earlies event last
	func groupEvents(_ events: [Event]) -> [EventSection]

	var reloadTableViewClosure: (() -> Void)! { get set }

	var disposeBag: DisposeBag { get }
}

extension EventsViewModel {

	///Get a single event at indexpath
	func getEvent(at indexPath: IndexPath) -> Event {
		let section = sections[indexPath.section]
		let event = section.events[indexPath.item]
		return event
	}

	func numberOfRowsInSection(section: Int) -> Int {
		let section = sections[section]
		return section.events.count
	}

	///Fetch the data, group it and assign to self
	func fetchData() {
		// Fetch the events
		Http.fetchEvents(studsYear: self.studsYearParameter).subscribe(onNext: { [self] events in

			// Sort events, earliest first
			let sortedEvents = events.sorted(by: { $0 > $1 })

			let groupedEvents = self.groupEvents(sortedEvents)

			self.sections = groupedEvents

			reloadTableViewClosure()
		}, onError: { error in
			print(error)
		}).disposed(by: self.disposeBag)
	}
}
