//
//  LoginDatum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 4, 2021

import Foundation

struct LoginDatum : Codable {

        let blockStatus : String?
        let city : Int?
        let companyName : String?
        let companyPhone : String?
        let country : Int?
        let createdAt : String?
        let email : String?
        let emailVerifiedAt : String?
        let emailVerify : String?
        let facebookLink : String?
        let firstName : String?
        let id : Int?
        let instagram : String?
        let lastName : String?
        let linkedin : String?
        let name : String?
        let phone : String?
        let phoneVerify : String?
        let postcode : String?
        let profile : String?
        let selfDes : String?
        let ssn : String?
        let stage : String?
        let state : Int?
        let status : Int?
        let token : String?
        let twitterLink : String?
        let type : String?
        let updatedAt : String?

        enum CodingKeys: String, CodingKey {
                case blockStatus = "block_status"
                case city = "city"
                case companyName = "company_name"
                case companyPhone = "company_phone"
                case country = "country"
                case createdAt = "created_at"
                case email = "email"
                case emailVerifiedAt = "email_verified_at"
                case emailVerify = "email_verify"
                case facebookLink = "facebook_link"
                case firstName = "first_name"
                case id = "id"
                case instagram = "instagram"
                case lastName = "last_name"
                case linkedin = "linkedin"
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
                case twitterLink = "twitter_link"
                case type = "type"
                case updatedAt = "updated_at"
        }
    
        init(from decoder: Decoder) throws {
                let values = try? decoder.container(keyedBy: CodingKeys.self)
                blockStatus = try values?.decodeIfPresent(String.self, forKey: .blockStatus)
                city = try values?.decodeIfPresent(Int.self, forKey: .city)
                companyName = try values?.decodeIfPresent(String.self, forKey: .companyName)
                companyPhone = try values?.decodeIfPresent(String.self, forKey: .companyPhone)
                country = try values?.decodeIfPresent(Int.self, forKey: .country)
                createdAt = try values?.decodeIfPresent(String.self, forKey: .createdAt)
                email = try values?.decodeIfPresent(String.self, forKey: .email)
                emailVerifiedAt = try values?.decodeIfPresent(String.self, forKey: .emailVerifiedAt)
                emailVerify = try values?.decodeIfPresent(String.self, forKey: .emailVerify)
                facebookLink = try values?.decodeIfPresent(String.self, forKey: .facebookLink)
                firstName = try values?.decodeIfPresent(String.self, forKey: .firstName)
                id = try values?.decodeIfPresent(Int.self, forKey: .id)
                instagram = try values?.decodeIfPresent(String.self, forKey: .instagram)
                lastName = try values?.decodeIfPresent(String.self, forKey: .lastName)
                linkedin = try values?.decodeIfPresent(String.self, forKey: .linkedin)
                name = try values?.decodeIfPresent(String.self, forKey: .name)
                phone = try values?.decodeIfPresent(String.self, forKey: .phone)
                phoneVerify = try values?.decodeIfPresent(String.self, forKey: .phoneVerify)
                postcode = try values?.decodeIfPresent(String.self, forKey: .postcode)
                profile = try values?.decodeIfPresent(String.self, forKey: .profile)
                selfDes = try values?.decodeIfPresent(String.self, forKey: .selfDes)
                ssn = try values?.decodeIfPresent(String.self, forKey: .ssn)
                stage = try values?.decodeIfPresent(String.self, forKey: .stage)
                state = try values?.decodeIfPresent(Int.self, forKey: .state)
                status = try values?.decodeIfPresent(Int.self, forKey: .status)
                token = try values?.decodeIfPresent(String.self, forKey: .token)
                twitterLink = try values?.decodeIfPresent(String.self, forKey: .twitterLink)
                type = try values?.decodeIfPresent(String.self, forKey: .type)
                updatedAt = try values?.decodeIfPresent(String.self, forKey: .updatedAt)
        }

}
