//
//  LoginReqModel.swift
//  MyVagon
//
//  Created by Apple on 04/08/21.
//

import Foundation
class LoginReqModel : Encodable {
    var device_name,device_token,device_type,app_version,email,password : String?

    enum CodingKeys: String, CodingKey {
        case device_name = "device_name"
        case device_token = "device_token"
        case device_type = "device_type"
        case app_version = "app_version"
        case email = "email"
        case password = "password"
    }
}
