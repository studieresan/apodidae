//
//  ProfileVC.swift
//  Studs
//
//  Created by Glenn Olsson on 2020-12-13.
//  Copyright © 2020 Studieresan. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
	override func viewDidLoad() {
		Http.fetchUser().subscribe(onNext: { [weak self] user in
			guard let self = self else { return }
			print(user.firstName, user.lastName, user.picture)
		}, onError: { error in
			print(error)
		})
	}
}
