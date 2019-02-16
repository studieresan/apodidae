//
//  Event.swift
//  Studs
//
//  Created by Michel Tabari on 2018-10-27.
//  Copyright © 2018 Studieresan. All rights reserved.
//

import Foundation

struct AllEventsResponse: Decodable {
    let data: AllEvents
}

struct AllEvents: Decodable {
    let allEvents: [Event]
}

struct Event: Decodable {
    let id: String
    let companyName: String?
    let schedule: String?
    let location: String?
    let privateDescription: String?
    let publicDescription: String?
    let beforeSurveys: [String]?
    let afterSurveys: [String]?
    let date: String?

    enum EventCodingKeys: String, CodingKey {
        case id
        case companyName
        case schedule
        case location
        case privateDescription
        case publicDescription
        case beforeSurveys
        case afterSurveys
        case date
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
        let dateFormatter = ISO8601DateFormatter()
        // iOS <11 can't parse ISO8601 dates with milliseconds, so we remove them
        let trimmed = self.date!.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        let date = dateFormatter.date(from: trimmed)
        return date
    }
}
