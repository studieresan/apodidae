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

	@IBOutlet var searchBar: UISearchBar!

	@IBOutlet var collectionView: UICollectionView!

	@IBAction func onDonePressed(_ sender: Any) {
		self.dismiss(animated: true)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

	}
}
