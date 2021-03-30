//
//  MapSubview.swift
//  Studs
//
//  Created by Glenn Olsson on 2021-03-30.
//  Copyright © 2021 Studieresan. All rights reserved.
//

import Foundation
import MapKit

class MapSubview: UIViewController, HappeningsSubview {
	var happenings: [Happening] = []

	func onData(_ happenings: [Happening]) {
		self.happenings = happenings
		self.reloadView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		let view = MKMapView()

		view.delegate = self

		view.mapType = .standard

		let center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 59.347990, longitude: 18.071482)
		let spanSize: CLLocationDistance = 200

		let region = MKCoordinateRegion(center: center, latitudinalMeters: spanSize, longitudinalMeters: spanSize)

		view.setRegion(region, animated: true)

		view.clipsToBounds = true

		self.view = view
	}

	func reloadView() {

	}
}

extension MapSubview: MKMapViewDelegate {

}
