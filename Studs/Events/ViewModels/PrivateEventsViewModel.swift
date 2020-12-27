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
        let today = Date()
        let idxOfFirstUpcoming = events.firstIndex(where: {
            $0.getDate()! > today
        }) ?? 0

        let nextEvent = [events[idxOfFirstUpcoming]]
        let upcomingEvents = Array(events[idxOfFirstUpcoming+1..<events.count])
        let pastEvents = Array(events[0..<idxOfFirstUpcoming])

		let nextEventSection = (title: "Nästa event", events: nextEvent)
		let upcomingEventsSection = (title: "Kommande events", events: upcomingEvents)
		let pastEventsSection = (title: "Tidigare events", events: pastEvents)

        return [nextEventSection, upcomingEventsSection, pastEventsSection]
    }
}
