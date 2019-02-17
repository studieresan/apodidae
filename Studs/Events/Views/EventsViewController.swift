//
//  EventsViewController.swift
//  Studs
//
//  Created by Michel Tabari on 2018-10-27.
//  Copyright © 2018 Studieresan. All rights reserved.
//

import UIKit

final class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Properties

    @IBOutlet weak var eventsTable: UITableView!

    // Array of next event, upcoming events, past events
    var data = [[Event](), [Event](), [Event]()]
    let sectionTitles = ["Next event", "Upcoming", "Past events"]

    // MARK: Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        // Hide the top navigation bar in this view
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidLoad() {
        // Fetch the events
        // Maybe do something with the returned object?
        _ = Http.fetchAllEvents().subscribe { event in
            switch event {
            case .next(let value):
                // Sort events, earliest first
                let sortedEvents = value.data.allEvents.sorted(by: { $0 < $1 })
                self.data = self.organizeEvents(events: sortedEvents)

                DispatchQueue.main.async {
                    self.eventsTable.reloadData()
                }
            case .error(let error):
                print(error)
            case .completed:
                // Maybe do something here?
                print("done")
            }
        }

        // Set styling
        view.backgroundColor = UIColor.bgColor
        eventsTable.backgroundColor = UIColor.bgColor

        // Set up the table view
        eventsTable.delegate = self
        eventsTable.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        if let selectedIndex = eventsTable.indexPathForSelectedRow {
            eventsTable.deselectRow(at: selectedIndex, animated: true)
        }
    }

    // MARK: Table methods

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        let label = UILabel()
        header.addSubview(label)

        header.backgroundColor = UIColor.bgColor
        label.text = sectionTitles[section]

        let fontWeight = section == 0 ? UIFont.Weight.heavy : UIFont.Weight.regular
        label.font = UIFont.systemFont(ofSize: 38, weight: fontWeight)
        label.bottomAnchor.constraint(greaterThanOrEqualTo: header.bottomAnchor, constant: -10).isActive = true
        label.leftAnchor.constraint(greaterThanOrEqualTo: header.leftAnchor, constant: 15).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false

        return header
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = eventsTable.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventTableViewCell else {
            fatalError("The dequeued cell is not an instance of EventTableViewCell")
        }
        let currentData = data[indexPath.section][indexPath.row]

        guard let date = currentData.getDate() else {
            fatalError("Couldn't format date of event")
        }

        // Display month and date
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "MMM"
        cell.month.text = dateFormatter.string(from: date).uppercased()

        dateFormatter.dateFormat = "d"
        cell.day.text = dateFormatter.string(from: date)

        cell.companyName.text = currentData.companyName

        return cell
    }

    // MARK: Navigation

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEvent = data[indexPath.section][indexPath.row]
        let storyboard = UIStoryboard(name: "EventsViewController", bundle: nil)
        guard let eventDetailController = storyboard.instantiateViewController(withIdentifier: "EventDetail")
            as? EventDetailViewController else {
            fatalError("EventDetail was not an instance of EventDetailViewController")
        }
        eventDetailController.event = selectedEvent

        navigationController?.present(eventDetailController, animated: true, completion: nil)
    }

    // MARK: Helper functions

    /**
     Takes an array of Events and divides them into three categories:
     the next event, all upcoming events (not including next event), all past events.
    */
    private func organizeEvents(events: [Event]) -> [[Event]] {
        let today = Date()
        guard let ixOfFirstUpcoming = events.firstIndex(where: {
            $0.getDate()! > today
        }) else {
            // All events are in the past
            return [[], [], events]
        }

        let nextEvent = [events[ixOfFirstUpcoming]]
        let upcoming = Array(events[ixOfFirstUpcoming+1..<events.count])
        let pastEvents = Array(events[0..<ixOfFirstUpcoming])

        return [nextEvent, upcoming, pastEvents]
    }
}
