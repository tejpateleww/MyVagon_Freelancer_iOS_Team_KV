//
//  ApiPaths.swift
//  Virtuwoof Pet
//
//  Created by EWW80 on 01/11/19.
//  Copyright © 2019 EWW80. All rights reserved.
//

import Foundation

var UserDefault = UserDefaults.standard


enum UserDefaultsKey : String {
    case IntroScreenStatus = "IntroScreenStatus"
    case SelectedLanguage = "SelectedLanguage"
    case UserDefaultKeyForRegister = "UserDefaultKeyForRegister"
    case RegisterData = "RegisterData"
    case userProfile = "userProfile"
    case isUserLogin = "isUserLogin"
    case X_API_KEY = "X_API_KEY"
    case DeviceToken = "DeviceToken"
    case LoginUserType = "LoginUserType"
    
}
