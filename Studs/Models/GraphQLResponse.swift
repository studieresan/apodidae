//
//  GraphQLResponse.swift
//  Studs
//
//  Created by Glenn Olsson on 2020-12-14.
//  Copyright © 2020 Studieresan. All rights reserved.
//

import Foundation

///A graphQL response class must define the rootField, i.e. the query field used to fetch it. Only objects
///that can not be fetched as lists should implement this protocol
protocol GraphQLResponse {
	static var rootField: String { get }
}

///Used for objects that can be fetched as group with graphq. Should be implemented by objects that can be
///fetched as a single object and multiple objects
protocol GraphQLMultipleResponse: GraphQLResponse {
	static var rootFieldMultiple: String { get }
}

//Extends all arrays of GraphQL responses to have a rootField
extension Array: GraphQLResponse where Element: GraphQLMultipleResponse {
	static var rootField: String {
		Element.rootFieldMultiple
	}
}
