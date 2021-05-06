//
//  MKMapView+Studs.swift
//  Studs
//
//  Created by Glenn Olsson on 2021-04-07.
//  Copyright © 2021 Studieresan. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {
	/// Center is Medis, sthlm
	static var defaultCenter = CLLocationCoordinate2D(latitude: 59.315278, longitude: 18.072521)
	static var defaultDelta = 0.01

	///Recenter map att default center
	func resetDefaultCenter() {
		let center = MKMapView.defaultCenter
		let delta = MKMapView.defaultDelta
		let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)

		let region = MKCoordinateRegion(center: center, span: span)

		self.setRegion(region, animated: true)
	}
}
