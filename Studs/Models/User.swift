//
//  User.swift
//  Studs
//
//  Created by Glenn Olsson on 2020-12-13.
//  Copyright © 2020 Studieresan. All rights reserved.
//

import Foundation

private struct RawUserResponse: Decodable {
	static var rootField: String = "user"
	static var rootFieldMultiple: String = "users"

	struct UserInfo: Decodable {
		let permissions: [String]?
		let email: String?
		let phone: String?
		let linkedIn: String?
		let github: String?
		let master: String?
		let allergies: String?
		let picture: String?
	}

	let id: String
	let firstName: String
	let lastName: String
	let studsYear: Int?
	let role: String?
	let info: UserInfo?
}

struct User: Decodable, GraphQLSingleResponse, GraphQLMultipleResponse {
	static var rootField: String = "user"
	static var rootFieldMultiple: String = "users"

	init(from decoder: Decoder) throws {
		let rawResponse = try RawUserResponse(from: decoder)

		id = rawResponse.id
		firstName = rawResponse.firstName
		lastName = rawResponse.lastName
		studsYear = rawResponse.studsYear
		role = rawResponse.role

		permissions = rawResponse.info?.permissions
		email = rawResponse.info?.email
		phone = rawResponse.info?.phone
		linkedIn = rawResponse.info?.linkedIn
		github = rawResponse.info?.github
		master = rawResponse.info?.master
		allergies = rawResponse.info?.allergies
		picture = rawResponse.info?.picture
	}

	let id: String
	let firstName: String
	let lastName: String
	let studsYear: Int?
	let role: String?

	//From info obj
	let permissions: [String]?
	let email: String?
	let phone: String?
	let linkedIn: String?
	let github: String?
	let master: String?
	let allergies: String?
	let picture: String?

	func fullName() -> String {
		return "\(self.firstName) \(self.lastName)"
	}
}

extension User: Hashable {
	func hash(into hasher: inout Hasher) {
		hasher.combine(self.id)
	}
}

//TODO
//let CV...
