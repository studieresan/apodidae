//
//  HappeningAnnotationCallout.swift
//  Studs
//
//  Created by Glenn Olsson on 2021-04-21.
//  Copyright © 2021 Studieresan. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class HappeningAnnotationCallout: UIViewController {
	static let identifier = "callout"

	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var emojiLabel: UILabel!
	@IBOutlet var descriptionLabel: UILabel!

	@IBOutlet var createdLabel: UILabel!
	@IBOutlet var removeButton: StudsButton!

	@IBOutlet var companionsCollectionView: UICollectionView!

	let maxHeight: CGFloat = 200

	var happening: Happening!

	let disposeBag: DisposeBag = DisposeBag()

	@IBAction func onRemovePressed(_ sender: Any) {
		let alert = UIAlertController(
			title: "Är du säker?",
			message: "Är du säker på att du vill ta bort denna happening? Åtgärden går inte att ångra", preferredStyle: .alert
		)
		alert.addAction(UIAlertAction(title: "OK", style: .default) {_ in
			Http.delete(happening: self.happening).subscribe(onNext: {
				if $0.wasSuccessfull {
					//Create notification that the happenings should update
					NotificationCenter.default.post(.init(name: .HappeningsSetUpdate))
				} else {
					print("Couldn't delete happening??")
				}
			}, onError: {error in
				print("ERROR WITH DELETE, \(error)")
			}).disposed(by: self.disposeBag)
		})
		alert.addAction(UIAlertAction(title: "Avbryt", style: .cancel) {_ in
			//Don't do anything
		})
		self.present(alert, animated: true)
	}

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

		//Set the height of the collection view to be just high and wide enough
		let collectionViewLayout = self.companionsCollectionView.collectionViewLayout
		let collectionContentSize = collectionViewLayout.collectionViewContentSize

		//Let the callout have a resonable max height instead of expanding to the void and beyond!
		let companionCollectionHeight = min(self.maxHeight, collectionContentSize.height)

		self.companionsCollectionView.heightAnchor.constraint(equalToConstant: companionCollectionHeight).isActive = true
		self.companionsCollectionView.widthAnchor.constraint(equalToConstant: collectionContentSize.width).isActive = true

		//Reload the data to force it to update. Got UI bug otherwise where all
		//companions would not show at first, until scroll
		self.companionsCollectionView.reloadData()

		//If the host of the happening is the user, show the remove button
		self.removeButton.isHidden = !happening.host.isSelfUser()

		let formatter = DateFormatter()
		formatter.dateFormat = "dd MMM HH:mm"
		self.createdLabel.text = formatter.string(from: self.happening.created)
	}
}

extension HappeningAnnotationCallout: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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

		//Make images round when the image has been fetched and thus the image view size has been calculated
		//Callback is called on main thread
		cell.image.imageFromURL(urlString: user.picture ?? "") { imageView in
			cell.image.layer.cornerRadius = imageView.frame.width / 2
		}
		cell.nameLabel.text = "\(user.fullName())"

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
