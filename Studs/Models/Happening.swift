//
//  Happening.swift
//  Studs
//
//  Created by Glenn Olsson on 2021-03-30.
//  Copyright © 2021 Studieresan. All rights reserved.
//

import Foundation

struct Happening: Decodable, GraphQLMultipleResponse {
	static var rootFieldMultiple: String = "happenings"

	var id: String
	var host: User
	var participants: [User]
	var location: GeoJSON
	var created: String
	var title: String
	var emoji: String
	var description: String

}
