//
//  EventsViewController.swift
//  Studs
//
//  Created by Michel Tabari on 2018-10-27.
//  Copyright © 2018 Studieresan. All rights reserved.
//

import UIKit
import RxSwift

final class EventsViewController: UIViewController {

    // MARK: Properties

    @IBOutlet weak var eventsTable: UITableView!

    // Array of next event, upcoming events, past events
    var data = [[Event](), [Event](), [Event]()]
    let sectionTitles = ["Next event", "Upcoming", "Past events"]
    let disposeBag = DisposeBag()

    // MARK: Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        // Hide the top navigation bar in this view
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidLoad() {
        setTableStyles()
        loadEventData()
    }

    override func viewDidAppear(_ animated: Bool) {
        resetSelectedCell()
    }

}

extension EventsViewController: UITableViewDelegate {

    private func setTableStyles() {
        // Set styling
        view.backgroundColor = UIColor.bgColor
        eventsTable.backgroundColor = UIColor.bgColor

        // Set up the table view
        eventsTable.delegate = self
        eventsTable.dataSource = self
    }

    private func resetSelectedCell() {
        if let selectedIndex = eventsTable.indexPathForSelectedRow {
            eventsTable.deselectRow(at: selectedIndex, animated: true)
        }
    }

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
        let eventDetailViewController = EventDetailViewController.instance()
        eventDetailViewController.event = selectedEvent

        navigationController?.present(eventDetailViewController, animated: true, completion: nil)
    }

}

extension EventsViewController: UITableViewDataSource {

    private func loadEventData() {
        // Fetch the events
        Http.fetchAllEvents().subscribe(onNext: { events in
            // Sort events, earliest first
            let sortedEvents = events.data.allEvents.sorted(by: { $0 < $1 })
            self.data = self.organizeEvents(events: sortedEvents)

            DispatchQueue.main.async {
                self.eventsTable.reloadData()
            }
        }, onError: { error in
            print(error)
        }).disposed(by: disposeBag)
    }

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
            return [[], [], events]
        }

        let nextEvent = [events[idxOfFirstUpcoming]]
        let upcoming = Array(events[idxOfFirstUpcoming+1..<events.count])
        let pastEvents = Array(events[0..<idxOfFirstUpcoming])

        return [nextEvent, upcoming, pastEvents]
    }

}
