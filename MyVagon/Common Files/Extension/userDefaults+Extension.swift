//
//  userDefaults+Extension.swift
//  Qwnched-Customer
//
//  Created by apple on 16/09/20.
//  Copyright © 2020 Hiral's iMac. All rights reserved.
//

import Foundation
extension UserDefaults{
func set<T: Codable>(object: T, forKey: String) throws {
    
    let jsonData = try JSONEncoder().encode(object)
    
    set(jsonData, forKey: forKey)
}


func get<T: Codable>(objectType: T.Type, forKey: String) throws -> T? {
    
    guard let result = value(forKey: forKey) as? Data else {
        return nil
    }
    
    return try JSONDecoder().decode(objectType, from: result)
}

    func setUserData() {
        try? UserDefaults.standard.set(object:  SingletonClass.sharedInstance.UserProfileData, forKey: UserDefaultsKey.userProfile.rawValue)
    }
    
    func getUserData() -> LoginDatum? {
        let objResponse = try? UserDefaults.standard.get(objectType: LoginDatum.self, forKey:  UserDefaultsKey.userProfile.rawValue)
        SingletonClass.sharedInstance.UserProfileData = objResponse
        return objResponse ?? nil
    }
    
    
    func SetRegiterData() {
        try? UserDefaults.standard.set(object:  SingletonClass.sharedInstance.RegisterData, forKey: UserDefaultsKey.RegisterData.rawValue)
    }
    
    func getRegisterData() {
        let objResponse = try? UserDefaults.standard.get(objectType: RegisterSaveDataModel.self, forKey:  UserDefaultsKey.RegisterData.rawValue)
        SingletonClass.sharedInstance.RegisterData = objResponse ?? RegisterSaveDataModel()
       
    }
    
}
