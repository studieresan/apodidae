//
//  ChooseCompanionsVC.swift
//  Studs
//
//  Created by Glenn Olsson on 2021-04-07.
//  Copyright © 2021 Studieresan. All rights reserved.
//

import Foundation
import UIKit

class ChooseCompanionsViewController: UIViewController {

	//Set by super-viewcontroller
	var allUsers: [User]!
	var selectedUsers: [User]!
	//Called when view disapears
	var setSelectedUsers: ((_: [User]) -> Void)!

	@IBOutlet var searchBar: UISearchBar!

	@IBOutlet var collectionView: UICollectionView!

	@IBAction func onDonePressed(_ sender: Any) {
		self.dismiss(animated: true)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.setSelectedUsers(self.selectedUsers)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		collectionView.dataSource = self
	}
}

extension ChooseCompanionsViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.allUsers.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "user-cell", for: indexPath) as? CompanionUserCell else {
			fatalError("Could not dequeue user-cell")
		}

		let userIndex = indexPath.row
		let user = self.allUsers[userIndex]

		cell.userImage.imageFromURL(urlString: user.picture ?? "")
		//Make round and with border
		cell.userImage.layer.cornerRadius = cell.userImage.frame.width / 2
		cell.userImage.layer.borderWidth = 0.5

		cell.userNameLabel.text = user.fullName()

		cell.isHighlighted = userIndex % 2 == 0
		cell.userImage.isHighlighted = userIndex % 2 == 0
		cell.isSelected = userIndex % 2 == 0

		cell.isUserInteractionEnabled = true

		return cell
	}
}

class CompanionUserCell: UICollectionViewCell {
	@IBOutlet var userImage: UIImageView!
	@IBOutlet var userNameLabel: UILabel!

}
