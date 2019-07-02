//
//  UserDefaultsHelper.swift
//  IW Employee System
//
//  Created by Sagun Raj Lage on 7/2/19.
//  Copyright © 2019 Sagun Raj Lage. All rights reserved.
//

import Foundation


class UserDefaultsHelper {
    
    static func getUserDefaults<T: Codable>(for objType: T.Type, forKey key: String) -> T? {
        let defaults = UserDefaults.standard
        if let savedData = defaults.data(forKey: key){
            let decoder = JSONDecoder()
            if let loadedUserData = try? decoder.decode(objType.self, from: savedData) {
                return loadedUserData
            }
        }
        return nil
    }
    
    static func setUserDefaults<T: Codable>(with obj: T, forKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(obj) {
            let userDefaults = UserDefaults.standard
            userDefaults.set(encoded, forKey: key)
            userDefaults.synchronize()
        }
    }
    
}
