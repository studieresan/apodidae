//
//  Company.swift
//  Studs
//
//  Created by Glenn Olsson on 2020-12-13.
//  Copyright © 2020 Studieresan. All rights reserved.
//

import Foundation

struct Company: Decodable, GraphQLSingleResponse, GraphQLMultipleResponse {
	static var rootFieldMultiple: String = "companies"
	static var rootField: String = "company"

	let id: String
	let name: String
}

let sampleCompany = Company(id: "SOME_COMPANY_ID", name: "Företaget AB")
