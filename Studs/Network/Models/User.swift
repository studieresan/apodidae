//
//  User.swift
//  Studs
//
//  Created by Glenn Olsson on 2020-12-13.
//  Copyright © 2020 Studieresan. All rights reserved.
//

import Foundation

struct User: Decodable, GraphQLMultipleResponse {
	static var rootField: String = "user"
	static var rootFieldMultiple: String = "users"

	let id: String
	let firstName: String
	let lastName: String
	let studsYear: Int
//	let permissions: [String]?

	//TODO
	//From info obj
//	let role: String
//	let email: String
//	let phone: String
//	let linkedIn: String
//	let github: String
//	let master: String
//	let allergies: String
//	let picture: String
}

//TODO
//let CV...
