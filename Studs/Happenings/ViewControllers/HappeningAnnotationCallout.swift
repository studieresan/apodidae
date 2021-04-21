//
//  HappeningAnnotationCallout.swift
//  Studs
//
//  Created by Glenn Olsson on 2021-04-21.
//  Copyright © 2021 Studieresan. All rights reserved.
//

import Foundation
import UIKit

class HappeningAnnotationCallout: UIViewController {
	static let identifier = "callout"

	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var emojiLabel: UILabel!
	@IBOutlet var descriptionLabel: UILabel!
	@IBOutlet var companionsCollectionView: UICollectionView!

	var happening: Happening!

	override func viewDidLoad() {
		super.viewDidLoad()

		self.titleLabel.text = happening.title
		self.emojiLabel.text = happening.emoji
		self.descriptionLabel.text = happening.description

		self.companionsCollectionView.dataSource = self

		self.view.backgroundColor = .clear
		self.companionsCollectionView.backgroundColor = .clear

		self.companionsCollectionView.allowsSelection = false
		self.companionsCollectionView.allowsMultipleSelection = false

		//If no companions, hide collection view
		if happening.participants?.count ?? 0 <= 0 {
			self.companionsCollectionView.isHidden = true
			self.companionsCollectionView.heightAnchor.constraint(equalToConstant: 0).isActive = true
		}

		print("Callout view did load \(happening.host.firstName)")
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		self.companionsCollectionView.reloadData()
	}
}

extension HappeningAnnotationCallout: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		print("nr items? \(happening.participants?.count ?? 0)")
		return happening.participants?.count ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView
				.dequeueReusableCell(withReuseIdentifier: HappeningCalloutCompanionCell.identifier, for: indexPath)
				as? HappeningCalloutCompanionCell else {
			fatalError("Could not dequeue HappeningCalloutCompanionCell")
		}

		//Should not happen as if it is nil, 0 should be returned in "numberOfItemsInSection" method
		guard let participants = self.happening.participants else {
			fatalError("No participants")
		}

		let user = participants[indexPath.row]

		cell.image.imageFromURL(urlString: user.picture ?? "")
		cell.nameLabel.text = "\(user.fullName())"

		cell.image.layer.cornerRadius = cell.image.frame.width / 2
		cell.image.layer.borderWidth = 0.5

		cell.contentView.backgroundColor = .clear
		cell.backgroundColor = .clear
		cell.backgroundView?.backgroundColor = .clear

		return cell
	}
}

class HappeningCalloutCompanionCell: UICollectionViewCell {
	static let identifier = "user-cell"

	@IBOutlet var image: UIImageView!
	@IBOutlet var nameLabel: UILabel!

}
