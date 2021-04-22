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
	var sections: [EventSection] = []

    var disposeBag = DisposeBag()

    // What should happen when the cellVMs are changed
	var reloadTableViewClosure: (() -> Void)!

    // MARK: Public methods

    func getEvent(at indexPath: IndexPath) -> Event {
		return sections[indexPath.section].events[indexPath.row]
    }

    func numberOfRowsInSection(section: Int) -> Int {
		return sections[section].events.count
    }

    // MARK: Private methods

    /**
     Takes an array of Events and divides them into three categories:
     the next event, all upcoming events (not including next event), all past events.
     */
	func groupEvents(_ events: [Event]) -> [EventSection] {
		//The events are in order based on date, the earliest event last
        let today = Date()

		//If there is no event where today is
        let idxOfFirstPrevious = events.firstIndex(where: {
            $0.date <= today
		}) ?? 0

		//Reversed for the order of events to be [next event, the one after that, ...]
		var upcomingEvents: [Event] = Array(events[0..<idxOfFirstPrevious]).reversed()
        let pastEvents = Array(events[idxOfFirstPrevious..<events.count])

		//If there are upcomming events, the first should be next event so remove it from
		//upcomming and set it as next. If there are no upcomming, there is no "next event" either
		var nextEvent: [Event] = []
		if upcomingEvents.count > 0 {
			//If there is a nextEvent, render it as a card
			var event: Event = upcomingEvents.removeFirst()
			event.isCard = true
			nextEvent.append(event)
		}

		let nextEventSection = EventSection(events: nextEvent, title: "Nästa event")
		let upcomingEventsSection = EventSection(events: upcomingEvents, title: "Kommande events")
		let pastEventsSection = EventSection(events: pastEvents, title: "Tidigare events")

        return [nextEventSection, upcomingEventsSection, pastEventsSection]
    }
}
