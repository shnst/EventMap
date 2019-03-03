//
//  UserDefaultsManager.swift
//  SFHacks
//
//  Created by Shun Sato on 3/2/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    enum UserDefaultsKeys: String {
        case accessToken = "accessToken"
    }
    
    private init() {}
    
    class func get(_ key: UserDefaultsKeys) -> Any? {
        return UserDefaults.standard.object(forKey: key.rawValue)
    }
    
    class func save(_ key: UserDefaultsKeys, value: Any) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
}
