//
//  EditPersonalInfoReqModel.swift
//  MyVagon
//
//  Created by Harshit K on 15/03/22.
//

import Foundation


class EditPersonalInfoReqModel : Encodable {
    var full_name: String?
    var country_code: String?
    var mobile_number: String?
    var profile_image: String?
    
    enum CodingKeys: String, CodingKey {
        case full_name = "full_name"
        case country_code = "country_code"
        case mobile_number = "mobile_number"
        case profile_image = "profile_image"
    }
}
