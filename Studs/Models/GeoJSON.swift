//
//  GeoJSON.swift
//  Studs
//
//  Created by Glenn Olsson on 2021-03-30.
//  Copyright © 2021 Studieresan. All rights reserved.
//

import Foundation
import CoreLocation

//As per defined in API https://github.com/studieresan/overlord/blob/master/API.md#geojsonfeaturetype
class GeoJSON: Decodable {
	var type: String
	var geometry: GeoJSONGeometryType
	var properties: GeoJSONPropertiesType

	// Long and lat are in this order according to RFC spec https://tools.ietf.org/html/rfc7946
	func coordinate() -> CLLocationCoordinate2D {
		//Should always work to get at least these coordinates according to RFC
		let long: Double = self.geometry.coordinates[0]
		let lat: Double = self.geometry.coordinates[1]

		return CLLocationCoordinate2D(latitude: lat, longitude: long)
	}
}

class GeoJSONGeometryType: Decodable {
	var type: String
	var coordinates: [Double]
}

class GeoJSONPropertiesType: Decodable {
	var name: String
}
