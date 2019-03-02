//
//  Login.swift
//  Studs
//
//  Created by Willy Liu on 2019-02-23.
//  Copyright © 2019 Studieresan. All rights reserved.
//

import Foundation

struct LoginResponse: Decodable {
    let error: String? // Will be set if email or password is wrong
    let id: String?
    let email: String?
    let token: String?
    let name: String?
}

// Will be set if the email param is not an email
struct LoginError: Decodable {
    let msg: String? // The error message
    let param: String? // indicates which param is invalid
    let value: String? // contains the invalid value
}

struct LoginPayload: Codable {
    let email: String
    let password: String
}
