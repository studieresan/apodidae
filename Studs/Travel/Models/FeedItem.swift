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
    var timestamp: Int64 = 0
    var includeLocation: Bool = true

    init(withDict dict: [String: Any]) {
        self.key = dict["key"] as? String ?? ""
        self.user = dict["user"] as? String ?? ""
        self.lat = dict["lat"] as? Double ?? 0.0
        self.lng = dict["lat"] as? Double ?? 0.0
        self.message = dict["message"] as? String ?? ""
        self.timestamp = dict["timestamp"] as? Int64 ?? 0
        self.includeLocation = (dict["includeLocation"] != nil)
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
