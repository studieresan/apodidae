//
//  Event.swift
//  Studs
//
//  Created by Michel Tabari on 2018-10-27.
//  Copyright © 2018 Studieresan. All rights reserved.
//

import Foundation

struct EventsResponse: Decodable {
    let data: Events
}

struct Events: Decodable {
    let events: [Event]
}

struct Company: Decodable {
	let id: String
	let name: String
}

struct Event: Decodable {
    let id: String
    let company: Company?
    let schedule: String?
    let location: String?
    let privateDescription: String?
    let publicDescription: String?
    let beforeSurvey: String?
    let afterSurvey: String?
    let date: String?
	let studsYear: Int?
	//TODO: Implement user struct
	//let responsible: User

    enum EventCodingKeys: String, CodingKey {
        case id
        case company
        case schedule
        case location
        case privateDescription
        case publicDescription
        case beforeSurvey
        case afterSurvey
        case date
		case studsYear
    }
}

extension Event: Comparable {
    static func < (lhs: Event, rhs: Event) -> Bool {
        let lhsDate = lhs.getDate()
        let rhsDate = rhs.getDate()

        return lhsDate ?? Date.distantPast < rhsDate ?? Date.distantPast
    }

    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }

    func getDate() -> Date? {
		guard let date = self.date else {
			return Date()
		}
        let dateFormatter = ISO8601DateFormatter()
        // iOS <11 can't parse ISO8601 dates with milliseconds, so we remove them
		let trimmed = date.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        let trimmedDate = dateFormatter.date(from: trimmed)
        return trimmedDate
    }
}
