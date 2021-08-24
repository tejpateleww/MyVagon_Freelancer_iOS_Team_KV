//
//  LoginDatum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 24, 2021

import Foundation

struct LoginDatum : Codable {

        let countryCode : String?
        let email : String?
        let id : Int?
        let mobileNumber : String?
        let name : String?
        let profile : String?
        let token : String?
        let type : String?
        let vehicle : LoginVehicle?

        enum CodingKeys: String, CodingKey {
                case countryCode = "country_code"
                case email = "email"
                case id = "id"
                case mobileNumber = "mobile_number"
                case name = "name"
                case profile = "profile"
                case token = "token"
                case type = "type"
                case vehicle = "vehicle"
        }
    
        init(from decoder: Decoder) throws {
                let values = try? decoder.container(keyedBy: CodingKeys.self)
                countryCode = try values?.decodeIfPresent(String.self, forKey: .countryCode)
                email = try values?.decodeIfPresent(String.self, forKey: .email)
                id = try values?.decodeIfPresent(Int.self, forKey: .id)
                mobileNumber = try values?.decodeIfPresent(String.self, forKey: .mobileNumber)
                name = try values?.decodeIfPresent(String.self, forKey: .name)
                profile = try values?.decodeIfPresent(String.self, forKey: .profile)
                token = try values?.decodeIfPresent(String.self, forKey: .token)
                type = try values?.decodeIfPresent(String.self, forKey: .type)
                vehicle = try values?.decodeIfPresent(LoginVehicle.self, forKey: .vehicle)
        }

}
