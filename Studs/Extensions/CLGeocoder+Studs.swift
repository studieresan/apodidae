//
//  CLGeocoder+Studs.swift
//  Studs
//
//  Created by Glenn Olsson on 2021-04-07.
//  Copyright © 2021 Studieresan. All rights reserved.
//

import Foundation
import CoreLocation

extension CLGeocoder {
	///Get the location name of coordinates. Requires a callback function with a optional name of the location
	func locationNameOf(coords: CLLocationCoordinate2D, callback: @escaping ((String?) -> Void)) {
		let location = CLLocation(latitude: coords.latitude, longitude: coords.longitude)
		self.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
			guard error == nil else {
				print("Error when getting locaiton name: \(error!)")
				return
			}

			guard let placemarks = placemarks else {
				print("Placemarks are nil")
				return
			}

			//Map all locations to their location name (Optional String)
			let placemarksNames: [String?] = placemarks.map({$0.name})

			//Compiler cannot understand that nonNilNames will only contain non-optional Strings (if any)
			let nonNilNames = placemarksNames.filter({$0 != nil})

			callback(nonNilNames.count > 0 ? nonNilNames.first! : nil)
		})
	}
}
