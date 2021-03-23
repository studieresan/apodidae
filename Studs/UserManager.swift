//
//  UserManager.swift
//  Studs
//
//  Created by Willy Liu on 2019-03-06.
//  Copyright © 2019 Studieresan. All rights reserved.
//

import Foundation

final class UserManager {

    // MARK: User data

    static func saveUserData(data: UserData) {
        UserDefaults.studs.set(try? PropertyListEncoder().encode(data), forKey: "userdata")
    }

    static func getUserData() -> UserData? {
        if let value = UserDefaults.studs.value(forKey: "userdata") as? Data {
            return try? PropertyListDecoder().decode(UserData.self, from: value)
        }
        return nil
    }

    static func getToken() -> String? {
        return getUserData()?.token
    }

    static func clearUserData() {
        UserDefaults.studs.removeObject(forKey: "userdata")
    }

    static func isLoggedIn() -> Bool {
        return UserManager.getUserData() != nil
    }
}
