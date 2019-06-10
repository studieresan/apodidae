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

    static func saveUserData(data: UserData) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(data), forKey: "userdata")
    }

    static func getUserData() -> UserData? {
        if let value = UserDefaults.standard.value(forKey: "userdata") as? Data {
            return try? PropertyListDecoder().decode(UserData.self, from: value)
        }
        return nil
    }

    static func getToken() -> String? {
        return getUserData()?.token
    }

    static func clearUserData() {
        UserDefaults.standard.removeObject(forKey: "userdata")
    }

    static func isLoggedIn() -> Bool {
        return UserManager.getUserData() != nil
    }

}
