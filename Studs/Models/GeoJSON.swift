//
//  GeoJSON.swift
//  Studs
//
//  Created by Glenn Olsson on 2021-03-30.
//  Copyright © 2021 Studieresan. All rights reserved.
//

import Foundation

//As per defined in API https://github.com/studieresan/overlord/blob/master/API.md#geojsonfeaturetype
class GeoJSON: Decodable {
	var type: String
	var geometry: GeoJSONGeometryType
	var properties: GeoJSONPropertiesType
}

class GeoJSONGeometryType: Decodable {
	var type: String
	var coordinates: [Float]
}

class GeoJSONPropertiesType: Decodable {
	var name: String
}
