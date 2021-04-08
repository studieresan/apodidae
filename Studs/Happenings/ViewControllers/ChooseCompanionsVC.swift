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

	//Users shown. Can be filtered for search
	var shownUsers: [User] = []

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

		self.searchBar.delegate = self

		self.shownUsers = self.allUsers

		self.collectionView.dataSource = self
		self.collectionView.delegate = self
	}
}

extension ChooseCompanionsViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.shownUsers.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "user-cell", for: indexPath) as? CompanionUserCell else {
			fatalError("Could not dequeue user-cell")
		}

		let userIndex = indexPath.row
		let user = self.shownUsers[userIndex]

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

extension ChooseCompanionsViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchText.count == 0 {
			self.shownUsers = self.allUsers
		} else {
			//Filter all users on if their name contains the search text
			self.shownUsers = self.allUsers.filter({ user in
				let userName = user.fullName()
				return userName.contains(searchText)
			})
		}
		self.collectionView.reloadData()
	}
}

extension ChooseCompanionsViewController: UICollectionViewDelegate {

}

class CompanionUserCell: UICollectionViewCell {
	@IBOutlet var userImage: UIImageView!
	@IBOutlet var userNameLabel: UILabel!

}
