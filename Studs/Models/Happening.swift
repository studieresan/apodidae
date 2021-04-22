//
//  Happening.swift
//  Studs
//
//  Created by Glenn Olsson on 2021-03-30.
//  Copyright © 2021 Studieresan. All rights reserved.
//

import Foundation

class Happening: Decodable, GraphQLMultipleResponse {

	static var rootFieldMultiple: String = "happenings"

	var id: String
	var host: User
	var participants: [User]?
	var location: GeoJSON
	var created: Date
	var title: String
	var emoji: String
	var description: String?
}

///Similar to Happening but with a GraphQL root field to unpack a created query
class CreatedHappening: Happening, GraphQLSingleResponse {
	static var rootField: String = "happeningCreate"
}

///A remove mutation will only return a boolean
class DeleteHappening: Decodable, GraphQLSingleResponse {
	static var rootField: String = "happeningDelete"

	let wasSuccessfull: Bool

	required init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		self.wasSuccessfull = try container.decode(Bool.self)
	}
}

///Used when creating a happening in the backend
class NewHappening {
	var hostId: String
	var participants: [User]
	var location: GeoJSON
	var title: String
	var emoji: String
	var description: String?

	init(
		hostId: String,
		participants: [User],
		location: GeoJSON,
		title: String,
		emoji: String,
		description: String?
	) {
		self.hostId = hostId
		self.participants = participants
		self.location = location
		self.title = title
		self.emoji = emoji
		self.description = description
	}
}
