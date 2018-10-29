//
//  Event.swift
//  Studs
//
//  Created by Michel Tabari on 2018-10-27.
//  Copyright © 2018 Studieresan. All rights reserved.
//

import Foundation

struct Event: Decodable {
    let id: String
    let companyName: String?
    let schedule: String?
    let location: String?
    let privateDescription: String?
    let beforeSurveys: [String]?
    let afterSurveys: [String]?
    let date: Date?

    enum EventCodingKeys: String, CodingKey {
        case id
        case companyName
        case schedule
        case location
        case privateDescription
        case beforeSurveys
        case afterSurveys
        case date
    }
}

extension Event: Comparable {
    static func < (lhs: Event, rhs: Event) -> Bool {
        return lhs.date ?? Date.distantPast < rhs.date ?? Date.distantPast
    }

    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
}
