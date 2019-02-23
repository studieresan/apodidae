//
//  LoginPayload.swift
//  Studs
//
//  Created by Willy Liu on 2019-02-23.
//  Copyright © 2019 Studieresan. All rights reserved.
//

import Foundation

struct LoginPayload: Codable {
    let email: String
    let password: String
}
