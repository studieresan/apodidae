//
//  EventsViewModel.swift
//  Studs
//
//  Created by Willy Liu on 2019-02-22.
//  Copyright © 2019 Studieresan. All rights reserved.
//

import Foundation
import RxSwift

final class EventsViewModel {

    // MARK: Properties

    let sectionTitles = ["Next event", "Upcoming", "Past events"]

    // Array of next event, upcoming events, past events
    private var events = [[Event](), [Event](), [Event]()]

    // Array of next event cellVM, upcoming event cellVMs, past event cellVMs
    private var cellViewModels: [[EventCellViewModel]] =
        [[EventCellViewModel](), [EventCellViewModel](), [EventCellViewModel]()] {
        didSet {
            self.reloadTableViewClosure?()
        }
    }

    private let disposeBag = DisposeBag()

    // What should happen when the cellVMs are changed
    var reloadTableViewClosure: (() -> Void)?

    // MARK: Public methods

    func fetchData() {
        // Fetch the events
		Http.fetchEvents(studsYear: AppDelegate.STUDSYEAR).subscribe(onNext: { [weak self] events in
            guard let self = self else { return }

            // Sort events, earliest first
            let sortedEvents = events.data.events.sorted(by: { $0 < $1 })

            let organizedEvents = self.organizeEvents(events: sortedEvents)
            let cellViewModels = self.mapEventToCellViewModel(events: organizedEvents)

            self.events = organizedEvents
            self.cellViewModels = cellViewModels
        }, onError: { error in
            print(error)
        }).disposed(by: disposeBag)
    }

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
    private func organizeEvents(events: [Event]) -> [[Event]] {
        let today = Date()
        guard let idxOfFirstUpcoming = events.firstIndex(where: {
            $0.getDate()! > today
        }) else {
            // All events are in the past
            return [[], [], events.reversed()]
        }

        let nextEvent = [events[idxOfFirstUpcoming]]
        let upcoming = Array(events[idxOfFirstUpcoming+1..<events.count])
        let pastEvents = Array(events[0..<idxOfFirstUpcoming])

        return [nextEvent, upcoming, pastEvents.reversed()]
    }

    /**
     Takes a 2D array of Events and returns a new 2D array of EventTableCellViewModels
     */
    func mapEventToCellViewModel(events: [[Event]]) -> [[EventCellViewModel]] {
        // initialize a 2D array with as many inner arrays as `events` has.
        var result = Array(repeating: [EventCellViewModel](), count: events.count)

        // Display month and date
        let dateFormatter = DateFormatter()

        // create an EventTableCellViewModel for each event
        for (index, category) in events.enumerated() {
            for event in category {
                guard let date = event.getDate() else {
                    fatalError("Couldn't format date of event")
                }

                dateFormatter.dateFormat = "MMM"
                let month = dateFormatter.string(from: date).uppercased()

                dateFormatter.dateFormat = "d"
                let day = dateFormatter.string(from: date)

				let viewModel = EventCellViewModel(month: month, day: day, companyName: event.company?.name ?? "Okänt företag")
                result[index] += [viewModel]
            }
        }

        return result
    }
}
