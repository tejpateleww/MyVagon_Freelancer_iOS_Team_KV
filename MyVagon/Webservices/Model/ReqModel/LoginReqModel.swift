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
class ForgotPasswordReqModel : Encodable {
    var phone : String?

    enum CodingKeys: String, CodingKey {
        case phone = "phone"
    }
}
class ResetNewPasswordReqModel : Encodable {
    var phone,password : String?

    enum CodingKeys: String, CodingKey {
        case phone = "phone"
        case password = "password"
    }
}
class ChangePasswordReqModel : Encodable {
    var user_id,old_password,new_password : String?

    enum CodingKeys: String, CodingKey {
        case user_id = "user_id"
        case old_password = "old_password"
        case new_password = "new_password"
    }
}
