//
//  ListSubview.swift
//  Studs
//
//  Created by Glenn Olsson on 2021-03-30.
//  Copyright © 2021 Studieresan. All rights reserved.
//

import Foundation
import UIKit

class ListSubview: UITableViewController, HappeningsSubview {
	var happenings: [Happening] = []

	func onData(_ happenings: [Happening]) {
		self.happenings = happenings

		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}

	override func viewDidLoad() {

	}
}

extension ListSubview {

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.happenings.count
	}

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
	}

	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 0
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "happening-entry") as? HappeningListEntryCell else {
			fatalError("Could not dequeue happenings-entry cell")
		}
		let row = indexPath.row
		let happening = self.happenings[row]

		cell.from(happening: happening)

		if row % 2 == 1 {
			cell.backgroundColor = .primaryBG
		} else {
			cell.backgroundColor = .secondaryBG
		}

		return cell
	}
}

class HappeningListEntryCell: UITableViewCell {

	@IBOutlet var userImage: UIImageView!

	@IBOutlet var happeningTitle: UILabel!
	@IBOutlet var happeningLocation: UILabel!
	@IBOutlet var happeningDescription: UILabel!

	func from(happening: Happening) {
		self.userImage.image = UIImage.roundStudsS.reversedApperance()
		self.userImage.imageFromURL(urlString: happening.host.picture!)
		// Make circular
		self.userImage.layer.cornerRadius = self.userImage.frame.width / 2

		self.happeningTitle.text = happening.title
		self.happeningLocation.text = happening.location.title
		self.happeningDescription.text = happening.description
	}
}
