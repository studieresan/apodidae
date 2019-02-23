//
//  LoginResponse.swift
//  Studs
//
//  Created by Willy Liu on 2019-02-23.
//  Copyright © 2019 Studieresan. All rights reserved.
//

import Foundation

struct LoginResponse: Decodable {
    let error: String?
    let id: String?
    let email: String?
    let token: String?
    let name: String?
}
