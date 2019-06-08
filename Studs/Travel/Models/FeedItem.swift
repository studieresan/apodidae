//
//  FeedItem.swift
//  Studs
//
//  Created by Willy Liu on 2019-06-08.
//  Copyright © 2019 Studieresan. All rights reserved.
//

import Foundation

struct FeedItem {
    var key: String = ""
    var user: String = ""
    var lat: Double = 0.0
    var lng: Double = 0.0
    var message: String = ""
    var timestamp: Int = 0
    var locationName: String = ""
    var includeLocation: Bool = true

    init(user: String, lat: Double, lng: Double, message: String, timestamp: Int, locationName: String, includeLocation: Bool) {
        self.user = user
        self.lat = lat
        self.lng = lng
        self.message = message
        self.timestamp = timestamp
        self.locationName = locationName
        self.includeLocation = includeLocation
    }

    init(user: String, message: String, timestamp: Int) {
        self.user = user
        self.message = message
        self.timestamp = timestamp
        self.includeLocation = false
    }

    init(withDict dict: [String: Any]) {
        self.key = dict["key"] as? String ?? ""
        self.user = dict["user"] as? String ?? ""
        self.lat = dict["lat"] as? Double ?? 0.0
        self.lng = dict["lat"] as? Double ?? 0.0
        self.message = dict["message"] as? String ?? ""
        self.timestamp = dict["timestamp"] as? Int ?? 0
        self.locationName = dict["locationName"] as? String ?? ""
        self.includeLocation = (dict["includeLocation"] != nil)
    }

    func asDict() -> [String: Any] {
        var dictWithoutLocation = [
            "user": user,
            "message": message,
            "timestamp": timestamp,
            "includeLocation": includeLocation,
            ] as [String: Any]

        if self.includeLocation {
            dictWithoutLocation["lat"] = lat
            dictWithoutLocation["lng"] = lng
            dictWithoutLocation["locationName"] = locationName
        }

        return dictWithoutLocation
    }

    func timeFromNow() -> String {
        let now = Date().timeIntervalSince1970
        let minutesAgo = Int(now - TimeInterval(self.timestamp)) / 60

        if minutesAgo == 0 {
            return "Just now"
        }
        if minutesAgo < 60 {
            return "\(minutesAgo)m"
        }
        let hoursAgo = minutesAgo / 60
        return "\(hoursAgo)h"
    }

}
