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
class GeoJSON: Codable {

	let longitude: Double
	let latitude: Double

	let title: String

	var coordinatesList: [Double] {
		return [ //As in RFC specification mentioned below
			self.longitude,
			self.latitude,
		]
	}

	required init(from decoder: Decoder) throws {
		let raw = try GeoJSONRaw(from: decoder)

		let coordinates = raw.geometry.coordinates

		// Long and lat exists and are in this order according to RFC spec https://tools.ietf.org/html/rfc7946
		self.longitude = coordinates[0]
		self.latitude = coordinates[1]

		self.title = raw.properties.name
	}

	func encode(to encoder: Encoder) throws {
		//Assumes type is feature and geometry type is Point
		let geometry = GeoJSONGeometryType(
			type: "Point",
			coordinates: [
				self.longitude,
				self.latitude,
			])

		let prop = GeoJSONPropertiesType(name: self.title)

		let raw = GeoJSONRaw(type: "Feature", geometry: geometry, properties: prop)
		try raw.encode(to: encoder)
	}

	init(coordinates: CLLocationCoordinate2D, title: String) {
		self.longitude = coordinates.longitude
		self.latitude = coordinates.latitude
		self.title = title
	}

	func coordinate() -> CLLocationCoordinate2D {
		return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
	}
}

private class GeoJSONRaw: Codable {
	var type: String
	var geometry: GeoJSONGeometryType
	var properties: GeoJSONPropertiesType

	init(type: String, geometry: GeoJSONGeometryType, properties: GeoJSONPropertiesType) {
		self.type = type
		self.geometry = geometry
		self.properties = properties
	}
}

private class GeoJSONGeometryType: Codable {
	var type: String
	var coordinates: [Double]

	init(type: String, coordinates: [Double]) {
		self.type = type
		self.coordinates = coordinates
	}
}

private class GeoJSONPropertiesType: Codable {
	var name: String

	init(name: String) {
		self.name = name
	}
}
