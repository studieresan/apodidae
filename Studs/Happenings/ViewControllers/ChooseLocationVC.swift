//
//  ChooseLocationVC.swift
//  Studs
//
//  Created by Glenn Olsson on 2021-04-07.
//  Copyright © 2021 Studieresan. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ChooseLocationViewController: UIViewController {

	@IBOutlet var mapView: MKMapView!
	@IBOutlet var titleField: UITextField!

	@IBAction func onSavePressed(_ sender: Any) {
		self.dismiss(animated: true)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

	}
}
