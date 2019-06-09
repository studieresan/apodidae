//
//  Login.swift
//  Studs
//
//  Created by Willy Liu on 2019-02-23.
//  Copyright © 2019 Studieresan. All rights reserved.
//

import Foundation

struct UserData: Codable {
    let error: String? // Will be set if email or password is wrong
    let id: String?
    let email: String?
    let token: String?
    let name: String?
    let position: String?
    let phone: String?
    let picture: String?

}

struct LoginPayload: Encodable {
    let email: String
    let password: String
}
