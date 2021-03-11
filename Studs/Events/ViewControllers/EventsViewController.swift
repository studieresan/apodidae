//
//  EventsViewController.swift
//  Studs
//
//  Created by Michel Tabari on 2018-10-27.
//  Copyright © 2018 Studieresan. All rights reserved.
//

import UIKit
import SwiftUI

final class EventsViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var eventsTable: UITableView!

	let viewModel: EventsViewModel = UserManager.isLoggedIn() ? PrivateEventsViewModel() : PublicEventsViewModel()

	private let refreshControl = UIRefreshControl()

    // MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        // Hide the top navigation bar in this view
        navigationController?.setNavigationBarHidden(true, animated: animated)
        resetSelectedCell()
	}

    override func viewDidLoad() {
		super.viewDidLoad()
		
        setupTable()
        viewModel.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
				self?.eventsTable.reloadData()
				self?.refreshControl.endRefreshing()
				print("Reloading")
            }
        }

		//Register a card cell if iOS ≥ 14 (i.e. SwiftUI)
		if #available(iOS 14, *) {
			eventsTable.register(UITableCellHoster<EventTableCardViewCell>.self, forCellReuseIdentifier: "eventCard")
		}

		eventsTable.rowHeight = UITableView.automaticDimension
		eventsTable.estimatedRowHeight = UITableView.automaticDimension

        viewModel.fetchData()
    }
}

extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    private func setupTable() {
        // Set styling
		view.backgroundColor = .primaryBG
        eventsTable.backgroundColor = .primaryBG

        // Set up the table view
        eventsTable.delegate = self
        eventsTable.dataSource = self

        // Add pull to refresh
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        eventsTable.refreshControl = refreshControl
    }

    @objc private func fetchData() {
        viewModel.fetchData()
    }

    private func resetSelectedCell() {
        if let selectedIndex = eventsTable.indexPathForSelectedRow {
            eventsTable.deselectRow(at: selectedIndex, animated: true)
        }
    }

	func numberOfSections(in tableView: UITableView) -> Int {
		return viewModel.sections.count
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

        header.backgroundColor = UIColor.primaryBG
		label.text = viewModel.sections[section].title

        let fontWeight = section == 0 ? UIFont.Weight.heavy : UIFont.Weight.regular
        label.font = UIFont.systemFont(ofSize: 38, weight: fontWeight)
        label.bottomAnchor.constraint(greaterThanOrEqualTo: header.bottomAnchor, constant: -10).isActive = true
        label.leftAnchor.constraint(greaterThanOrEqualTo: header.leftAnchor, constant: 15).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false

        return header
    }

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}

	@available(iOS 14, *)
	private func renderCardCell(event: Event, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = eventsTable.dequeueReusableCell(
				withIdentifier: "eventCard",
				for: indexPath
		) as? UITableCellHoster<EventTableCardViewCell> else {
			fatalError("Could not dequeue")
		}
		cell.set(rootView: EventTableCardViewCell(event: event), parentController: self)

		return cell
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let event = viewModel.getEvent(at: indexPath)

		if #available(iOS 14, *), event.isCard {
			//Render cell as card
			return renderCardCell(event: event, cellForRowAt: indexPath)
		}
        guard let cell = eventsTable.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventTableViewCell else {
            fatalError("The dequeued cell is not an instance of EventTableViewCell")
        }
		//Render regular event row cell
		let cellViewModel = EventCellViewModel(event: event)

        cell.month.text = cellViewModel.month
        cell.day.text = cellViewModel.day
        cell.companyName.text = cellViewModel.companyName

        return cell
    }

    // MARK: Navigation

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEvent = viewModel.getEvent(at: indexPath)
		openEvent(event: selectedEvent)
	}

	fileprivate func openEvent(event: Event) {
		let eventDetailViewController = EventDetailViewController.instance(withName: "EventDetailView")
		eventDetailViewController.event = event
		navigationController?.pushViewController(eventDetailViewController, animated: true)
	}
}
