//
//  UserManager.swift
//  Studs
//
//  Created by Willy Liu on 2019-03-06.
//  Copyright © 2019 Studieresan. All rights reserved.
//

import Foundation
import RxSwift

final class UserManager {

    static private let disposeBag = DisposeBag()

    static func getToken() -> String? {
        return UserDefaults.standard.string(forKey: "token")
    }

    static func setToken(token: String) {
        UserDefaults.standard.set(token, forKey: "token")
    }

    static func clearToken() {
        UserDefaults.standard.removeObject(forKey: "token")
    }

    static func isLoggedIn() -> Bool {
        return UserManager.getToken() != nil
    }

}
