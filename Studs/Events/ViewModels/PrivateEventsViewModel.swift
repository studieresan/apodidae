//
//  PrivateEventsViewModel.swift
//  Studs
//
//  Created by Willy Liu on 2019-02-22.
//  Copyright © 2019 Studieresan. All rights reserved.
//

import Foundation
import RxSwift

class PrivateEventsViewModel: EventsViewModel {

	var studsYearParameter: Int? = AppDelegate.STUDSYEAR

    // MARK: Properties

	///Array of section title and the events in this section
	var sections: [(title: String, events: [Event])] = []

    // Array of next event, upcoming events, past events
    private var events = [[Event](), [Event](), [Event]()]

    // Array of next event cellVM, upcoming event cellVMs, past event cellVMs
    private var cellViewModels: [[EventCellViewModel]] =
        [[EventCellViewModel](), [EventCellViewModel](), [EventCellViewModel]()] {
        didSet {
            self.reloadTableViewClosure?()
        }
    }

    var disposeBag = DisposeBag()

    // What should happen when the cellVMs are changed
	var reloadTableViewClosure: (() -> Void)!

    // MARK: Public methods

    func getEvent(at indexPath: IndexPath) -> Event {
        return events[indexPath.section][indexPath.row]
    }

    func getCellViewModel(at indexPath: IndexPath) -> EventCellViewModel {
        return cellViewModels[indexPath.section][indexPath.row]
    }

    func numberOfRowsInSection(section: Int) -> Int {
        return cellViewModels[section].count
    }

    // MARK: Private methods

    /**
     Takes an array of Events and divides them into three categories:
     the next event, all upcoming events (not including next event), all past events.
     */
	func groupEvents(_ events: [Event]) -> [(title: String, events: [Event])] {
		//The events are in order based on date, the earliest event last
        let today = Date()

		//If there is no event where today is
        let idxOfFirstPrevious = events.firstIndex(where: {
            $0.getDate() <= today
		}) ?? 0

        var upcomingEvents = Array(events[0..<idxOfFirstPrevious])
        let pastEvents = Array(events[idxOfFirstPrevious..<events.count])

		//If there are upcomming events, the first should be next event so remove it from
		//upcomming and set it as next. If there are no upcomming, there is no "next event" either
		let nextEvent = upcomingEvents.count > 0 ? [upcomingEvents.removeFirst()] : []

		let nextEventSection = (title: "Nästa event", events: nextEvent)
		let upcomingEventsSection = (title: "Kommande events", events: upcomingEvents)
		let pastEventsSection = (title: "Tidigare events", events: pastEvents)

        return [nextEventSection, upcomingEventsSection, pastEventsSection]
    }
}
