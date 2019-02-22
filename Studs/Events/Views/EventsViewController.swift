//
//  EventsViewController.swift
//  Studs
//
//  Created by Michel Tabari on 2018-10-27.
//  Copyright © 2018 Studieresan. All rights reserved.
//

import UIKit

final class EventsViewController: UIViewController {

    // MARK: Properties

    @IBOutlet weak var eventsTable: UITableView!

    let viewModel = EventsViewModel()

    // MARK: Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        // Hide the top navigation bar in this view
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidLoad() {
        setTableStyles()

        viewModel.reloadTableViewClosure = {
            DispatchQueue.main.async {
                self.eventsTable.reloadData()
            }
        }

        viewModel.fetchData()
    }

    override func viewDidAppear(_ animated: Bool) {
        resetSelectedCell()
    }

}

extension EventsViewController: UITableViewDelegate, UITableViewDataSource {

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
        return viewModel.sectionTitles.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        let label = UILabel()
        header.addSubview(label)

        header.backgroundColor = UIColor.bgColor
        label.text = viewModel.sectionTitles[section]

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

        let cellViewModel = viewModel.getCellViewModel(at: indexPath)
        cell.month.text = cellViewModel.month
        cell.day.text = cellViewModel.day
        cell.companyName.text = cellViewModel.companyName

        return cell
    }

    // MARK: Navigation

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEvent = viewModel.getEvent(at: indexPath)
        let eventDetailViewController = EventDetailViewController.instance()
        eventDetailViewController.event = selectedEvent

        navigationController?.present(eventDetailViewController, animated: true, completion: nil)
    }

}
