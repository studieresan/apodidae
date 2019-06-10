//
//  LastKnownLocation.swift
//  Studs
//
//  Created by Willy Liu on 2019-06-11.
//  Copyright © 2019 Studieresan. All rights reserved.
//

import Foundation

struct LastKnownLocation: Codable {
    var user: String = ""
    var lat: Double = 0.0
    var lng: Double = 0.0

    init(fromDict dict: [String: Any]) {
        self.user = dict["user"] as? String ?? ""
        self.lat = dict["lat"] as? Double ?? 0.0
        self.lng = dict["lng"] as? Double ?? 0.0
    }
}
