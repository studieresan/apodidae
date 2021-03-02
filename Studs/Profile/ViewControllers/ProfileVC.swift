//
//  ProfileVC.swift
//  Studs
//
//  Created by Glenn Olsson on 2020-12-13.
//  Copyright © 2020 Studieresan. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ProfileViewController: UIViewController {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!

	let disposeBag = DisposeBag()

	@IBAction func onLogoutTapped(_ sender: Any) {
		confirmLogout()
	}

	func confirmLogout() {
		let dialog = UIAlertController(title: "Logga ut", message: "Är du säker på att du vill logga ut?", preferredStyle: .actionSheet)

		let logoutAction = UIAlertAction(title: "Logga ut", style: .destructive, handler: { (_) -> Void in
			self.logout()
		})

		let cancelAction = UIAlertAction(title: "Avbryt", style: .cancel, handler: nil)

		dialog.run {
			$0.addAction(logoutAction)
			$0.addAction(cancelAction)
		}

		self.present(dialog, animated: true, completion: nil)
	}

	func logout() {
		UserManager.clearUserData()
		DispatchQueue.main.async {
			let studsVC = self.parent?.parent as? StudsViewController
			studsVC?.updateViewControllers()
		}
	}

	func fetchUser() {
		Http.fetchUser().subscribe(onNext: { [weak self] user in
			guard let self = self else { return }

			DispatchQueue.main.async {
				self.nameLabel.text = "\(user.firstName) \(user.lastName)"
			}

			if let imageURL = user.picture {
				DispatchQueue.main.async {
					let radius = self.imageView.layer.frame.width / 2
					self.imageView.layer.cornerRadius = radius
					self.imageView.clipsToBounds = true
				}
				self.imageView.imageFromURL(urlString: imageURL)

			} else {
				DispatchQueue.main.async {
					self.imageView.image = .studsLogo
				}
			}
		}, onError: { error in
			print(error)
		}).disposed(by: disposeBag)
	}

	override func viewDidLoad() {
		fetchUser()

		nameLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
	}
}
