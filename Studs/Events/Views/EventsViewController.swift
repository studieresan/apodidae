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
    var data = [Event]()

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
                self.data = value.data.allEvents.sorted(by: { $0 < $1 })
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

    // MARK: Table methods

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = eventsTable.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventTableViewCell else {
            fatalError("The dequeued cell is not an instance of EventTableViewCell")
        }
        let currentData = data[indexPath.row]

        // iOS <11 can't parse ISO8601 dates with milliseconds, so we remove them
        let trimmedIsoString = currentData.date!.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        let dateParser = ISO8601DateFormatter()
        guard let date = dateParser.date(from: trimmedIsoString) else {
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
}
