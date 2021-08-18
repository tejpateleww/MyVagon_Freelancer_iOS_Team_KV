//
//  LoginDatum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 18, 2021

import Foundation

struct LoginDatum : Codable {

        let blockStatus : String?
        let city : String?
        let companyName : String?
        let companyPhone : String?
        let country : String?
        let createdAt : String?
        let device : LoginDevice?
        let email : String?
        let emailVerifiedAt : String?
        let emailVerify : String?
        let firstName : String?
        let id : Int?
        let lastName : String?
        let name : String?
        let phone : String?
        let phoneVerify : String?
        let postcode : String?
        let profile : String?
        let selfDes : String?
        let ssn : String?
        let stage : String?
        let state : String?
        let status : Int?
        let token : String?
        let type : String?
        let updatedAt : String?
        let vehicle : LoginVehicle?

        enum CodingKeys: String, CodingKey {
                case blockStatus = "block_status"
                case city = "city"
                case companyName = "company_name"
                case companyPhone = "company_phone"
                case country = "country"
                case createdAt = "created_at"
                case device = "device"
                case email = "email"
                case emailVerifiedAt = "email_verified_at"
                case emailVerify = "email_verify"
                case firstName = "first_name"
                case id = "id"
                case lastName = "last_name"
                case name = "name"
                case phone = "phone"
                case phoneVerify = "phone_verify"
                case postcode = "postcode"
                case profile = "profile"
                case selfDes = "self_des"
                case ssn = "ssn"
                case stage = "stage"
                case state = "state"
                case status = "status"
                case token = "token"
                case type = "type"
                case updatedAt = "updated_at"
                case vehicle = "vehicle"
        }
    
        init(from decoder: Decoder) throws {
                let values = try? decoder.container(keyedBy: CodingKeys.self)
                blockStatus = try values?.decodeIfPresent(String.self, forKey: .blockStatus)
                city = try values?.decodeIfPresent(String.self, forKey: .city)
                companyName = try values?.decodeIfPresent(String.self, forKey: .companyName)
                companyPhone = try values?.decodeIfPresent(String.self, forKey: .companyPhone)
                country = try values?.decodeIfPresent(String.self, forKey: .country)
                createdAt = try values?.decodeIfPresent(String.self, forKey: .createdAt)
                device = try values?.decodeIfPresent(LoginDevice.self, forKey: .device)
                email = try values?.decodeIfPresent(String.self, forKey: .email)
                emailVerifiedAt = try values?.decodeIfPresent(String.self, forKey: .emailVerifiedAt)
                emailVerify = try values?.decodeIfPresent(String.self, forKey: .emailVerify)
                firstName = try values?.decodeIfPresent(String.self, forKey: .firstName)
                id = try values?.decodeIfPresent(Int.self, forKey: .id)
                lastName = try values?.decodeIfPresent(String.self, forKey: .lastName)
                name = try values?.decodeIfPresent(String.self, forKey: .name)
                phone = try values?.decodeIfPresent(String.self, forKey: .phone)
                phoneVerify = try values?.decodeIfPresent(String.self, forKey: .phoneVerify)
                postcode = try values?.decodeIfPresent(String.self, forKey: .postcode)
                profile = try values?.decodeIfPresent(String.self, forKey: .profile)
                selfDes = try values?.decodeIfPresent(String.self, forKey: .selfDes)
                ssn = try values?.decodeIfPresent(String.self, forKey: .ssn)
                stage = try values?.decodeIfPresent(String.self, forKey: .stage)
                state = try values?.decodeIfPresent(String.self, forKey: .state)
                status = try values?.decodeIfPresent(Int.self, forKey: .status)
                token = try values?.decodeIfPresent(String.self, forKey: .token)
                type = try values?.decodeIfPresent(String.self, forKey: .type)
                updatedAt = try values?.decodeIfPresent(String.self, forKey: .updatedAt)
                vehicle = try values?.decodeIfPresent(LoginVehicle.self, forKey: .vehicle)
        }

}
