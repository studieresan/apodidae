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

	let longitude: Double
	let latitude: Double

	required init(from decoder: Decoder) throws {
		let raw = try GeoJSONRaw(from: decoder)

		let coordinates = raw.geometry.coordinates

		// Long and lat exists and are in this order according to RFC spec https://tools.ietf.org/html/rfc7946
		self.longitude = coordinates[0]
		self.latitude = coordinates[1]
	}

	func coordinate() -> CLLocationCoordinate2D {
		return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
	}
}

private class GeoJSONRaw: Decodable {
	var type: String
	var geometry: GeoJSONGeometryType
	var properties: GeoJSONPropertiesType
}

private class GeoJSONGeometryType: Decodable {
	var type: String
	var coordinates: [Double]
}

private class GeoJSONPropertiesType: Decodable {
	var name: String
}
