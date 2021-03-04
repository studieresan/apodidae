//
//  Event.swift
//  Studs
//
//  Created by Michel Tabari on 2018-10-27.
//  Copyright © 2018 Studieresan. All rights reserved.
//

import Foundation
import CoreData

struct Event: Decodable, GraphQLMultipleResponse {
	static var rootField: String = "event"
	static var rootFieldMultiple: String = "events"

    let id: String
	let published: Bool
    let company: Company?
    let location: String?
    let privateDescription: String?
    let publicDescription: String?
    let beforeSurvey: String?
    let afterSurvey: String?
    let date: String?
	let studsYear: Int?
	let pictures: [String]?
	let responsible: User?

	//If event should be rendered as a card in events list
	var isCard: Bool = false

    enum CodingKeys: String, CodingKey {
        case id
		case published
        case company
        case location
        case privateDescription
        case publicDescription
        case beforeSurvey
        case afterSurvey
        case date
		case studsYear
		case pictures
		case responsible
    }
}

extension Event: Comparable {
    static func < (lhs: Event, rhs: Event) -> Bool {
        let lhsDate = lhs.getDate()
        let rhsDate = rhs.getDate()

        return lhsDate < rhsDate
    }

    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }

    func getDate() -> Date {
		guard let date = self.date else {
			return Date(timeIntervalSince1970: 0)
		}
        let dateFormatter = ISO8601DateFormatter()
        // iOS <11 can't parse ISO8601 dates with milliseconds, so we remove them
		let trimmed = date.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        let trimmedDate = dateFormatter.date(from: trimmed)
		return trimmedDate ?? Date(timeIntervalSince1970: 0)
    }
}

let sampleEvent = Event(
	id: "SOME_EVENT_ID",
	published: false,
	company: sampleCompany,
	location: "Osquars backe 21",
	privateDescription: "Kom i tid, annars kan det bli :konsekvenser:",
	publicDescription: "We had a great time visisting this company. Wow!",
	beforeSurvey: nil,
	afterSurvey: nil,
	date: "2021-03-02 17:00",
	studsYear: 2021,
	pictures: nil,
	responsible: nil
)
